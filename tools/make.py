#!/usr/bin/env python3

import argparse
import sys
from pathlib import Path

ROOT_FOLDER = Path(__file__).parents[1]  # type: Path
if str(ROOT_FOLDER) not in sys.path:
    sys.path.insert(0, str(ROOT_FOLDER))

from tools import print  # noqa: F403, F401
from tools.build.buildmod import Builder  # noqa: E402
from tools.build.publish import Publisher  # noqa: E402


class DefaultHelpParser(argparse.ArgumentParser):
    def error(self, message):
        from tools import am

        sys.stderr.write(am.parse(f"<error>error: {message}</error>\n"))
        self.print_help()
        sys.exit(2)


def main(argv):
    parser = DefaultHelpParser(description="Builds an arma mod")
    group = parser.add_argument_group("Unique options", "Primary mutually exclusive options")
    exc = group.add_mutually_exclusive_group()
    exc.add_argument("--publish", action="store_true", help="Publish the mod to workshop")
    exc.add_argument("--dev", action="store_true", help="Uses the dev config for release")
    exc.add_argument("--test", action="store_true", help="Only builds a single PBO for a quick test")

    parser.add_argument("mods", nargs="+", help="Which mods to build from make.cfg")
    parser.add_argument("--ci", action="store_true", help="Build from continious integration")

    parser.add_argument("--nobuild", action="store_true", help="Skips the building process")
    parser.add_argument("--zip", action="store_true", help="Zips the release")
    parser.add_argument("--target", help="Target to build, defaults to Current folder", default="")
    parser.add_argument("--cfg", help="Config file to build with", default="")
    args = parser.parse_args()

    if not args.target:
        args.target = ROOT_FOLDER / "release"
    else:
        args.target = Path(args.target).resolve()

    if not args.cfg:
        args.cfg = ROOT_FOLDER / "pyproject.toml"
    else:
        args.cfg = Path(args.cfg).resolve()

    if not args.cfg.exists():
        raise FileNotFoundError(f"Trying to use {args.cfg} for building, but it doesn't exist")

    # Get the directory the make script is in.
    for mod in args.mods:
        message = "{} Build".format(mod)
        if args.dev:
            color = "cyan"
            message += " DEV MODE"
        else:
            color = "red"
        print(
            "<{color}><b>  ##{}##\n"
            "  # {} #\n"
            "  ##{}##\n</b></{color}>".format("#" * len(message), message, "#" * len(message), color=color)
        )

        builder = Builder(mod, args)
        if builder.completed and args.publish:
            modid = builder.cfg.get("modid", 0)
            publisher = Publisher(mod, modid, builder.released_path)

    print("<g>\n# Done</g>")


if __name__ == "__main__":
    sys.exit(main(sys.argv))
