/*
    Function:       ADA_Earplugs_fnc_toggleEarplugs
    Author:         Adanteh
    Description:    Toggles the earplug
*/
#include "macros.hpp"
params [["_plug", false]];

if (_plug) then {
    ["showNotification", ["Put in Earplugs", "ok"]] call cba_fnc_localEvent;
    0.3 fadeSound (1 - GVAR(dampenLevel));
} else {
    ["showNotification", ["Took out earplugs", "ok"]] call cba_fnc_localEvent;
    0.3 fadeSound 1;
};

GVAR(plugged) = _plug;