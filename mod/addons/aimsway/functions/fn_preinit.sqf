/*
    Function:       ADA_Aimsway_fnc_preInit
    Author:         Adanteh
    Description:    Inits all the settings
*/
#include "macros.hpp"

private _categoryName = format ["%1 - %2", QUOTE(PREFIX), QUOTE(MODULE)];
[QGVAR(s_enabled), "CHECKBOX", ["Enabled", "Disables scope align + aimsway"], _categoryName, true, true] call CBA_fnc_addSetting;

// -- Adds our settings
{
	_x params ["_name", "_values", "_description"];
	[_name, "SLIDER", _description, _categoryName, _values, true] call CBA_fnc_addSetting;
} forEach [
	[QGVAR(s_frequency), 	[0, 4, 2, 2], 	 ["Frequency", ""]],
	[QGVAR(s_power), 		[0, 4, 0.5, 2],  ["Strength", ""]],
	[QGVAR(s_maxTicks), 	[0, 100, 30, 0], ["Ticks", "Higher means it takes longer for scope to settle"]],
	[QGVAR(s_restedCoef), 	[0, 4, 0.5, 2],  ["Rested Multiplier", ""]],
	[QGVAR(s_suppressCoef),	[0, 4, 0, 2], 	 ["Suppression Multiplier", ""]]
];
