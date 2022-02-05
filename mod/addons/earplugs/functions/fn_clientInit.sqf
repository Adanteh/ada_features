/*
    Function:       ADA_Earplugs_fnc_clientInit
    Author:         Adanteh
    Description:    Adds settings, vars and keybind for earplugs
*/
#include "macros.hpp"

["vehicle", { _this call FUNC(onVehicleChanged) }] call CBA_fnc_addPlayerEventHandler;

[
	QUOTE(PREFIX),
	"EarplugToggle",
	["Earplugs", "Toggles the earplugs"],
	{  },
	{ [!GVAR(plugged)] call FUNC(toggleEarplugs) },
	[DIK_F1, [false, false, false]]
] call CBA_fnc_addKeybind;
