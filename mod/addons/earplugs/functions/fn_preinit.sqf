/*
    Function:       ADA_Earplugs_fnc_preinit
    Author:         Adanteh
    Description:    Adds settings, vars and keybind for earplugs
*/
#include "macros.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

GVAR(plugged) = false;

_categoryName = format ["%1 - Generic", QUOTE(PREFIX)];
[QGVAR(s_autoEarplugs), "CHECKBOX", ["Auto Earplugs", "Automatically enable earplugs when entering a vehicle"], _categoryName, true, false] call CBA_fnc_addSetting;
[QGVAR(s_dampenLevel), "SLIDER", ["Dampen Level", "How much the sound level should be dampened"], _categoryName, [0, 1, 0.8, 2, true], false] call CBA_fnc_addSetting;
