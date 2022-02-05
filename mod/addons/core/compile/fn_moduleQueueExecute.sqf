/*
    Function:       ADA_Core_fnc_moduleQueueExecute
    Author:         Adanteh
    Description:    Executes the modules
*/
#include "macros.hpp"

params [["_mode", ""]];

diag_log text format ["[%1] Queue Execute: %2 ('%4') - %3", QUOTE(PREFIX), !isNil QGVAR(moduleUsage), diag_tickTime, _mode];
if (isNil QGVAR(moduleUsage)) exitWith { };

// -- Get namespace (Useful to figure out where vars/functions are actually present)
private _namespace = currentNamespace call {
	if (_this isEqualTo missionNamespace) exitWith { "missionNamespace" };
	if (_this isEqualTo uiNamespace) exitWith { "uiNamespace" };
	if (_this isEqualTo parsingNamespace) exitWith { "parsingNamespace" };
	if (_this isEqualTo profileNamespace) exitWith { "profileNamespace" };
	if (_this isEqualType objNull) exitWith { "objectNamespace" };
	if (_this isEqualType locationNull) exitWith { "locationNamespace" };
	"Unknown Namespace";
};

if (_mode == "preinit") exitWith {
	{
		diag_log text format ["[%1] Executing: %2 - %3", QUOTE(PREFIX), _x, diag_tickTime];
		_x call (missionNamespace getVariable [_x, { true }]);
	} forEach (uiNamespace getVariable QGVAR(autoInitPre));
};

if (_mode == "init") exitWith {
	{
		_x params [["_functions", []], ["_condition", true]];
		if (_condition) then {
			{
				diag_log text format ["[%1] Executing: %2 in '%4' - %3", QUOTE(PREFIX), _x, diag_tickTime, _namespace];
                try { _x call (missionNamespace getVariable [_x, { true }]) } catch { };
			} forEach _functions;
		}
	} forEach [
		[uiNamespace getVariable QGVAR(autoInit), true],
		[uiNamespace getVariable QGVAR(autoInitServer), isServer],
		[uiNamespace getVariable QGVAR(autoInitClient), hasInterface],
		[uiNamespace getVariable QGVAR(autoInitHc), !hasInterface && !isServer]
	];
};

if (_mode == "postinit") exitWith {
	{
		diag_log text format ["[%1] Executing: %2 - %3", QUOTE(PREFIX), _x, diag_tickTime];
		_x call (missionNamespace getVariable [_x, { true }]);
	} forEach (uiNamespace getVariable QGVAR(autoInitPost));
};
