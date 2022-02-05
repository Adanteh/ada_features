import os
import winreg
from configparser import ConfigParser
from pathlib import Path
from io import StringIO


class ArmaTools:
    def __init__(self):
        reg = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
        try:
            k = winreg.OpenKey(reg, r"Software\bohemia interactive\arma 3 tools")
            self.tools_path = winreg.QueryValueEx(k, "path")[0]
            winreg.CloseKey(k)
        except Exception:
            raise Exception("BadTools", "Arma 3 Tools are not installed correctly or the P: drive needs to be created.")

        self.addonbuilder = os.path.join(self.tools_path, "AddonBuilder", "AddonBuilder.exe")
        self.dssignfile = os.path.join(self.tools_path, "DSSignFile", "DSSignFile.exe")
        self.dscreatekey = os.path.join(self.tools_path, "DSSignFile", "DSCreateKey.exe")
        self.cfgconvert = os.path.join(self.tools_path, "CfgConvert", "CfgConvert.exe")
        self.publisher = os.path.join(self.tools_path, "Publisher", "PublisherCmd.exe")
        self.imagetopaa = os.path.join(self.tools_path, "ImageToPAA", "ImageToPAA.exe")
        self.binarize = os.path.join(self.tools_path, "Binarize", "binarize_x64.exe")
        self.workdrive = Path(self.find_workdrive(self.tools_path))

        for entry in (self.addonbuilder, self.dssignfile, self.dscreatekey, self.cfgconvert):
            if not os.path.isfile(entry):
                raise Exception(
                    "BadTools", "Arma 3 Tools are not installed correctly or the P: drive needs to be created."
                )

        if not self.workdrive.is_dir():
            raise Exception("BadTools", "Workdrive not configured. Open Arma 3 Tools and go to Preferences->Options")

    def find_workdrive(self, toolspath):
        """Finds the actual position of workdrive."""
        config = ConfigParser()
        with open(os.path.join(toolspath, "settings.ini"), "r") as inputfile:
            inputfile = StringIO("[top]\n" + inputfile.read())
            config.readfp(inputfile)
            tempath = config["P_Drive"]["P_DrivePath"]
            return tempath.replace('"', "")
