/*
    Function:       ADA_Suppress_fnc_preInit
    Author:         Adanteh
    Description:    Inits all the settings
*/
#include "macros.hpp"

private _categoryName = format ["%1 - %2", QUOTE(PREFIX), QUOTE(MODULE)];

[QGVAR(s_enabled), "CHECKBOX", ["Enabled", "Enable suppression system"], _categoryName, true, true, {}, true] call CBA_fnc_addSetting;
[QGVAR(s_blur), "CHECKBOX", ["Use blur", "Adds blur on screen"], _categoryName, true, true, { }, true] call CBA_fnc_addSetting;
[QGVAR(s_vignette), "CHECKBOX", ["Use vignette", "Quick vignette pulse to indicate incoming fire (Think squad)"], _categoryName, true, true, { }, true] call CBA_fnc_addSetting;

// -- Adds our settings
{
	_x params ["_name", "_values", "_description"];
	[_name, "SLIDER", _description, _categoryName, _values, true] call CBA_fnc_addSetting;
} forEach [
	[QGVAR(s_maxSuppression), 	[5, 30, 5, 0], 			["Maximum Suppression", "Max suppression amount. Shake, sway and blur is based on this. Use high values for slow gradual suppression, low values for instant kick"]],
	[QGVAR(s_falloffDist), 		[5, 15, 10, 0], 		["Maximum Suppression", "Max suppression amount. Shake, sway and blur is based on this. Use high values for slow gradual suppression, low values for instant kick"]],
	[QGVAR(s_minDist), 			[0, 50, 10, 1], 		["Minimum shooter distance", "bullets fired from less than this don't suppress (m)"]],
	[QGVAR(s_vignetteFactor), 	[0, 1.5, 0.75, 1, true],["Vignette Strength", "Strength of vignette"]],
	[QGVAR(s_blurFactor), 		[0, 1, 0.5, 1, true], 	["Blur Strength", "Intensity of blur per suppression value"]],
	[QGVAR(s_shakeFactor), 		[0, 1, 0.5, 1, true], 	["Shake Strengh", "Intensity of camera shake per suppresson value"]],
	[QGVAR(s_swayFactor), 		[0, 1, 0.25, 1, true], 	["Sway Strength", "Intensity of camera shake per suppresson value"]],
	[QGVAR(s_timeFactor), 		[0, 20, 5, 0], 			["Suppresion length", "Time added per suppression value before suppression starts fading"]],
	[QGVAR(s_maxTimeToFade), 	[0, 20, 5, 1], 			["Suppression max length", "Max time before suppression starts reducing (A cap on the timeFactor)"]],
	[QGVAR(s_bleed), 			[0, 1, 0.05, 1], 		["Suppression fade speed", "Amount of suppression to reduce per 0.25s"]]
];

[
	QGVAR(openVehicleTypePassthrough), 
	"EDITBOX", 
	["Open Vehicles", "Vehicle types in which suppression should still be applied"], 
	_categoryName,
	'["StaticWeapon", "Motorcycle"]',
	true,
	{
		params ["_value"];
		_value = call compile _value;
		if !(isNil "_value") then { GVAR(s_openVehicleTypes) = _value };
	}
] call CBA_fnc_addSetting;

