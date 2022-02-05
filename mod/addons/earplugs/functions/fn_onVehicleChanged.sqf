/*
    Function:       ADA_Earplugs_fnc_onVehicleChanged
    Author:         Adanteh
    Description:    Adds settings, vars and keybind for earplugs
*/
#include "macros.hpp"

if !(GVAR(s_autoEarplugs)) exitWith { false };
params ["", "_vehicle"];

if (_vehicle isKindOf "CaManBase") exitWith {
	[false] call FUNC(toggleEarplugs);
};

private _isVehicle = call {
	if (_vehicle isKindOf "Car") exitWith { true };
	if (_vehicle isKindOf "Tank") exitWith { true };
	if (_vehicle isKindOf "Air") exitWith { true };
	if (_vehicle isKindOf "Motorcycle") exitWith { true };
	if (_vehicle isKindOf "Ship") exitWith { true };
	false;
};

if (_isVehicle) then {
	[true] call FUNC(toggleEarplugs);
};