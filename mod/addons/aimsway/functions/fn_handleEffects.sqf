/*
    Function:       ADA_Aimsway_fnc_handleEffects
    Author:         Adanteh
    Description:    Handles the strength of effects
*/
#include "macros.hpp"

private _unit = player;
private _shakePower = 0;

if (cameraView == "GUNNER") then {
    if (vehicle _unit == _unit) then {
        if (GVAR(ticks) > 30) exitWith { };
        GVAR(ticks) = GVAR(ticks) + 1;
    };
}
else
{
    GVAR(ticks) = 1;
};

if (GVAR(ticks) < 30) then {
    _shakePower = switch (stance _unit) do
    {
        case "STAND": { GVAR(s_power) * 3 };
        case "CROUCH": { GVAR(s_power) * 1.25 };
        case "PRONE": { GVAR(s_power) * 2 };
        default { GVAR(s_power) * 4 };
    };

    if (isWeaponRested _unit) then {
        _shakePower = _shakePower * GVAR(s_restedCoef);
    };

    _shakePower = _shakePower / GVAR(ticks);
    _freq = GVAR(s_frequency);
    if (GVAR(s_suppressCoef) > 0) then {
        _suppress = getSuppression _unit;
        if (_suppress > 0) then {
            _freq = _freq + _suppress * GVAR(s_suppressCoef);
        };
    };

    addCamShake [_shakePower * 0.1, 5, _freq * 0.1];
};

