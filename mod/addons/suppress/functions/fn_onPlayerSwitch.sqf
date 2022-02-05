/*
    Function:       ADA_Suppress_fnc_onPlayerSwitch
    Author:         Adanteh
    Description:    Add fire eventhandler for all units and vehicles in a loop (Check if this can be done better)
*/
#include "macros.hpp"

params ["_newUnit", "_oldUnit"];

// -- Transfer AI suppression tot his unit
if (alive _oldUnit && (_newUnit != _oldUnit)) then {
	_oldUnit setSuppression (GVAR(amount) / GVAR(s_maxSuppression));
};

// -- Remove event from old unit
_ehHandle = _oldUnit getVariable [QGVAR(suppressed_eh), -1];
if (_ehHandle != -1) then { _oldUnit removeEventHandler ["Suppressed", _ehHandle] };

_ehHandle = _newUnit addEventHandler ["Suppressed", { _this call FUNC(suppressedEH) }];
_newUnit setVariable [QGVAR(suppressed_eh), _ehHandle, false];