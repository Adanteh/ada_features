/*
    Function:       ADA_Suppress_fnc_suppressedEH
    Author:         Adanteh
    Description:    Fired EH for suppression system
*/
#include "macros.hpp"
params ["_unit", "_distance", "_shooter", ""];

_vehicle = vehicle _unit;
if ((_vehicle == _unit) || { isTurnedOut _unit } || {(({_vehicle isKindOf _x} findIf GVAR(s_openVehicleTypes)) >= -1)}) then {
    private _shooterRange = _shooter distance _unit;
    if (_shooterRange > GVAR(s_minDist)) then {
        [linearConversion [GVAR(s_falloffDist), 0.5, _distance, 0, 1, true], _shooter] call FUNC(addSuppression);
    };
};

true
