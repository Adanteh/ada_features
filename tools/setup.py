#!/usr/bin/env python3

#######################
#  ADA Setup Script  #
#######################

import ctypes
import os
import subprocess
import sys
import winreg
from pathlib import Path

ROOT_FOLDER = Path(__file__).parents[1]  # type: Path
if str(ROOT_FOLDER) not in sys.path:
    sys.path.insert(0, str(ROOT_FOLDER))

from tools import print  # noqa: E402


######## GLOBALS #########
MAINDIR = "x"
PROJECTDIR = "ada"
##########################
def create_link(link_name, target_element):
    print("Creating link: {} => {}".format(link_name, target_element))
    return subprocess.call(["cmd", "/c", "mklink", "/D", "/J", link_name, target_element])


def main():
    FULLDIR = "{}\\{}".format(MAINDIR, PROJECTDIR)
    print(
        """<y>
  ######################################
  # ObjectPlacement Dev Setup #
  ######################################

  This script will create your ADA dev environment for you.
  This script will create two hard links on your system, both pointing to your ADA project folder:\n</y>"""
    )
    print("[Arma 3]\\{}               => ADA project".format(FULLDIR))
    print("\n")

    try:
        reg = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
        key = winreg.OpenKey(reg, r"SOFTWARE\Wow6432Node\bohemia interactive\arma 3")
        armapath = winreg.EnumValue(key, 1)[1]
    except Exception:
        print("<error>Failed to determine Arma 3 Path.</error>")
        return 1

    from ctypes.wintypes import MAX_PATH

    dll = ctypes.windll.shell32
    buf = ctypes.create_unicode_buffer(MAX_PATH + 1)
    if dll.SHGetSpecialFolderPathW(None, buf, 0x0005, False):

        try:
            # Get the normal user name
            regmission = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
            keymission = winreg.OpenKey(regmission, r"SOFTWARE\bohemia interactive\arma 3")
            armauser = winreg.EnumValue(keymission, 0)[1]
            missionpath = os.path.join(buf.value, "Arma 3 - Other Profiles", armauser, "missions")
        except Exception:
            missionpath = os.path.join(buf.value, "Arma 3", "missions")

    scriptpath = os.path.realpath(__file__)
    projectpath = os.path.join(os.path.dirname(os.path.dirname(scriptpath)), "mod")

    print("<g># Detected Paths:</g>")
    print("  Arma 3 Path:   {}".format(armapath))
    print("  Missions Path: {}".format(missionpath))
    print("  Project Path:  {}".format(projectpath))

    repl = input("\nAre these correct? (y/n): ")
    if repl.lower() != "y":
        return 3

    print("<g>\n# Creating links ...</g>")

    try:
        if not os.path.exists(os.path.join(armapath, MAINDIR)):
            os.mkdir(os.path.join(armapath, MAINDIR))

        create_link(os.path.join(armapath, MAINDIR, PROJECTDIR), projectpath)
        # create_link(os.path.join(armapath, 'serverconfig', 'ADA'), os.path.join(projectpath, 'serverconfig', 'ADA'))
        # create_link(os.path.join(missionpath, 'ADA_Dev'), os.path.join(projectpath, 'missions_dev'))

    except Exception:
        raise
        print("<error>Something went wrong during the link creation. Please finish the setup manually.</error>")
        return 6

    print("<g># Links created successfully.</g>")

    return 0


if __name__ == "__main__":
    exitcode = main()

    if exitcode > 0:
        print("<error>\nSomething went wrong during the setup. Make sure you run this script as administrator.</error>")
    else:
        print("\nSetup successfully completed.")

    input("\nPress enter to exit ...")
    sys.exit(exitcode)
