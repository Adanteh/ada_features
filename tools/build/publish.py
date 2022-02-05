import subprocess
from pathlib import Path

from tools import print

from .armatools import ArmaTools


class Publisher:
    """Pushes an update to workshop"""

    def __init__(self, modname, modid, path: Path):
        bisTools = ArmaTools()
        self.publisher = bisTools.publisher
        self.modid = modid
        self.publish(path)

    def publish(self, path: Path):
        if not path.is_dir():
            print("<error>Couldn't publish. Mod path not valid: {}</error>".format(path))
            return 1

        print("\nPublishing mod on workshop")
        changenotes = path / "CHANGELOG.md"
        retval = subprocess.call(
            [
                self.publisher,
                "update",
                "/id:{}".format(self.modid),
                "/changeNote:{}".format("Fixes everything"),
                "/path:{}".format(path),
                "/nologo",
                "/nosummary",
            ]
        )

        if retval == 0:
            print("<g>Publishing mod finished<g>")
        else:
            print("<error>Publishing mod failed. Error code: {}</error>".format(retval))
        return retval
