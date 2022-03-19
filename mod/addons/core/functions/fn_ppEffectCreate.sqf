/*
    Function:       ADA_Main_fnc_ppEffectCreate
    Author:         Adanteh
    Description:    Creates a ppEffect
*/
#include "macros.hpp"

params ["_name", "_priority", "_effect", ["_commitSpeed", 0.1]];
if !(toLower _name in [
    "radialblur",
    "chromaberration",
    "wetdistortion",
    "colorcorrections",
    "dynamicblur",
    "filmgrain",
    "colorinversion"
]) exitWith {
    [[_fnc_scriptNameShort, "Unknown effect type:", _name], "red", 5, 0] call FUNC(debugMessage);
    -1
};

// -- Make sure effect is actually created (If created with a priority that already exist it won't be created otherwise)
private "_handle";
while {
    _handle = ppEffectCreate [_name, _priority];
    _handle < 0
} do {
    _priority = _priority + 1;
};

_handle ppEffectEnable true;
_handle ppEffectForceInNVG true;
if !(isNil "_effect") then {
    _handle ppEffectAdjust _effect;
    _handle ppEffectCommit _commitSpeed;
};
_handle;
