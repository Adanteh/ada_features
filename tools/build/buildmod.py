import shutil
import subprocess
import os
from os import chdir
from pathlib import Path
from typing import Generator

import toml
from tools import print
from tools.build.armatools import ArmaTools

TOOLS = ArmaTools()
FOLDER = (Path(__file__).parent).resolve()
ROOT_FOLDER = (Path(__file__).parents[2]).resolve()


def mod_time(path: Path):
    if not path.is_dir():
        return os.path.getmtime(str(path))
    maxi = os.path.getmtime(str(path))
    if path.is_dir():
        for file in path.iterdir():
            maxi = max(mod_time(file), maxi)
    return maxi


def check_for_changes(module: Path, prefix: str):
    """Checks if there are any more recent files in the folder than the timestamp of our PBO"""
    pbo = (module.parent / f"{prefix}{module.name}").with_suffix(".pbo")
    if not pbo.is_file():
        return True
    return mod_time(module) > mod_time(pbo)


class Builder:
    cfg: dict

    def __init__(self, name: str, args):
        self.name = name
        self.args = args

        self.made = 0
        self.failed = 0
        self.skipped = 0
        self.completed = False

        self.read_cfg(self.args.cfg)
        if self.cfg.get("sign", True):
            self.privatekey = self.create_signing_key()
        else:
            self.privatekey = None

        source = ROOT_FOLDER / (self.cfg.get("source", "mod"))
        target = self.prepare_folders(source)
        self.released_path = target.parent

        try:
            self.build_mod(source, target)
            self.copy_important_files(source, target.parent)
            if self.args.zip:
                self.zip_mod(target)
            self.completed = True
        except Exception as e:
            print(f"<error>{e}</error>")
        finally:
            self.wrapup()

    def read_cfg(self, path: Path):
        config = toml.load(path)["arma"][self.name]
        if self.args.dev:
            config = config["dev"]
        self.cfg = config
        self.prefix = self.cfg.get("pbo_prefix", "")

    def create_signing_key(self) -> Path:
        """Creates .bisign key"""
        keypath = ROOT_FOLDER / self.cfg.get("keypath", "")
        keyfile = keypath / f"{self.name}.biprivatekey"

        if not keyfile.exists():
            print("<y>Requested key does not exist.</y>")
            print(f"Key Path: {keyfile}")

            current = Path.cwd()
            keypath.mkdir(parents=True, exist_ok=True)
            chdir(keypath)
            ret = subprocess.call([TOOLS.dscreatekey, keyfile.stem])

            chdir(current)
            if ret == 0:
                print(f"<g>Created key: {keyfile}</g>")
            else:
                print(f"<error>Failed to create key: {keyfile}</error")
                raise
        else:
            print(f"<y>Using key {keyfile}</y>".format())

        return keyfile

    def prepare_folders(self, source: Path) -> Path:
        """Prepares the required folders for our release
        
        Args:
            source (Path): Where we want to build the mod from
        
        Returns:
            Path: The addons folder that we want to put our build PBOs in
        """
        if self.args.dev:  # For dev builds build in the source folder
            buildfolder = source.resolve()
        else:
            buildfolder = (self.args.target / (self.cfg.get("name", f"@{self.name}"))).resolve()  # type: Path

        if not self.args.nobuild:
            if self.cfg.get("purge", False):
                if buildfolder.is_dir():
                    shutil.rmtree(buildfolder, ignore_errors=True)

        addons = buildfolder / "addons"  # type: Path
        addons.mkdir(0o755, True, exist_ok=True)

        if self.privatekey:
            keysfolder = buildfolder / "keys"  # type: Path
            keysfolder.mkdir(0o755, True, exist_ok=True)
            shutil.copy(self.privatekey.with_suffix(".bikey"), keysfolder)
        return addons

    def build_mod(self, source: Path, target: Path):
        if self.args.nobuild:
            print("<c>Skipping build for {}due to --nobuild</c>".format(self.name))
            return 0

        # self.copy_important_files(str(self.path), self.releasepath)
        for module in self.module_iterator(source):
            self.build_pbo(module.stem, module, target)

    def module_iterator(self, source: Path) -> Generator[Path, None, None]:
        module: Path
        addons = source / "addons"
        changed_only = self.cfg.get("changed_only", False)
        for module in (x for x in addons.iterdir() if x.is_dir()):
            if not (module / "config.cpp").is_file():
                continue

            if (module / "$NOPACK$").is_file():
                self.skipped += 1
                continue

            if changed_only and not check_for_changes(module, self.prefix):
                self.skipped += 1
                continue

            yield module

            if self.args.test:
                print("<c>Ending after first pbo due to --test arg</c>")
                break

    def build_args(self, name: str, module: Path):

        # Detect LICENSE.MD and if so, copy it to the addons folder and later format into same name as the PBO
        if (module / "LICENSE.md").is_file():
            do_add_license = True
            print("LICENSE file found in module, will copy.")
        else:
            do_add_license = False

        # Detect $NOBIN$ and do not binarize if found.
        do_binarize = False
        if self.cfg.get("binarize", True):
            if not (module / "$NOBIN$").is_file():
                do_binarize = True

        # Detect $NOBIN$ and do not binarize if found.
        do_sign = False
        if self.cfg.get("sign", True):
            if not (module / "$NOSIGN$").is_file():
                do_sign = True

        # Detect $PBOPREFIX$ and, if not found use our config setting
        temp = TOOLS.workdrive / "temp"
        temp_path = "-temp=" + str(temp / self.prefix)
        if (module / "$PBOPREFIX$").is_file():
            do_prefix = True
            with (module / "$PBOPREFIX$").open(mode="r") as fp:
                prefix_path = fp.readlines()[0]
            temp_path = "-temp=" + str(temp / prefix_path)
        else:
            baseprefix = self.cfg.get("baseprefix", "")
            if baseprefix:
                prefix_path = "{}\\{}".format(baseprefix, name)
                temp_path = "-temp=" + str((temp / prefix_path).parent)
                do_prefix = True
            else:
                do_prefix = False

        p_module = str(Path("P:/") / prefix_path)

        return (do_add_license, do_binarize, do_sign, do_prefix, prefix_path, temp_path, p_module)

    def build_pbo(self, name: str, module: Path, target: Path):
        """Builds a PBO from a folder"""

        print()
        print("<c>Making {} - {}</c>".format(self.name, name + "-" * max(1, (60 - len(name)))))
        do_add_license, do_binarize, do_sign, do_prefix, prefix_path, temp_path, p_module = self.build_args(
            name, module
        )

        # Call AddonBuilder
        chdir(TOOLS.workdrive)
        name_path = "-name=" + self.name
        include_path = f"-include={FOLDER / 'include.txt'}"
        exclude_path = f"-exclude={FOLDER / 'exclude.lst'}"
        # p_module = Path("P:/") / (str(module))[2:]

        cmd = [TOOLS.addonbuilder, str(module), str(target), temp_path, "-clear", include_path]
        if not do_binarize:
            print("<c>Skipping binarizing for this PBO, uses $NOBIN$ file or setting in pyproject.toml</c>")
            cmd.append("-packonly")
        # else:
            # cmd.append("-binarize=" + TOOLS.binarize)

        if do_sign:
            cmd.append(f"-sign={self.privatekey}")
            print(f"<c>Signing with: {self.privatekey.name}</c>")
        else:
            print("<c>Skipping signature for this PBO, uses $NOSIGN$ file or setting in pyproject.toml</c>")

        if do_prefix:
            cmd.append("-prefix=" + prefix_path)
            print("<c>Building with prefix: {}</c>".format(prefix_path))

        # If there is a license file in the folder, copy it next to the PBO with a similar name
        try:
            output = subprocess.check_output(cmd)

        except subprocess.CalledProcessError as e:
            print(e.output)
            print(f"<error>Failed creating pbo for {module}</error>")
            raise

        if do_add_license:
            try:
                license_filename = "{}{}_LICENSE.md".format(self.prefix, name)
                file_src = module / "LICENSE.md"
                file_dst = module / license_filename
                print(f"<c>Copying license file: {file_dst}</c>")
                shutil.copyfile(file_src, file_dst)

            except Exception:
                print("<error>Could not copy license file.</error>")
                raise
        # Prettyprefix rename the PBO if requested.
        if self.prefix:
            self.pretty_name(name, target)
        self.made += 1

    def pretty_name(self, name: str, target: Path):
        """Adds prefix to PBO name and renames to the .bisign to have same name"""
        pbo_pretty = target / f"{self.prefix}{name}.pbo"  # type: Path
        pbo = target / f"{name}.pbo"  # type: Path

        try:
            if pbo_pretty.is_file():
                pbo_pretty.unlink()
            pbo.rename(pbo_pretty)

            if self.cfg.get("sign", True):
                SUFFIX = f".pbo.{self.privatekey.stem}.bisign"

                pbo.with_suffix(SUFFIX).rename(pbo_pretty.with_suffix(SUFFIX))

        except Exception:
            print("<error>Could not rename built PBO with prefix.</error>")
            raise

    def copy_important_files(self, source: Path, target: Path):
        """Copies over all DLLs, plus important files listed in the pyproject.toml"""

        files = self.cfg.get("copy_files", [])
        if not files:
            return

        print()
        print(f"<yellow>Searching for important files in {source}</yellow>")

        for file in files:
            # Renamed copy
            if isinstance(file, (tuple, list)):
                sourcename, targetname = file
            else:
                sourcename = targetname = file

            sourcefile = source / sourcename
            targetfile = target / targetname
            if sourcefile.is_dir():
                print(f"Copying folder => {sourcefile}")
                shutil.copytree(sourcefile, targetfile)
            elif sourcefile.is_file():
                print(f"Copying file => {sourcefile}")
                shutil.copyfile(sourcefile, targetfile)
            else:
                print(f"<error>Missing important file => {sourcefile}</error>")

        for file in source.glob("*.dll"):
            print(f"Copying DLL => {file}")
            shutil.copyfile(file, target)

    def zip_mod(self, target: Path):
        """Target is the addons folder"""
        released = target.parent
        name = released.name
        print()
        print(f"<c>Making archive {released.name}.zip</c>")
        shutil.make_archive(str(released), "zip", released.parent, released.name)

    def wrapup(self):
        print()
        print(f"Made {self.made}")
        print(f"Skipped {self.skipped}")
        if self.failed:
            print(f"<error>Failed to make {self.failed}</error>")
        else:
            print(f"Failed to make {self.failed}")
