/*
    Function:       ADA_Core_fnc_moduleQueue
    Author:         Adanteh
    Description:    Queues up a function for automatic execution based on the start of it's filename
*/
#include "macros.hpp"

params [["_functionVarName", "", [""]], ["_module", ""]];

if (isNil QGVAR(moduleUsage)) then {
	GVAR(moduleUsage) = true;
	GVAR(autoInitServer) = [];
	GVAR(autoInitClient) = [];
	GVAR(autoInit) = [];
	GVAR(autoInitPre) = [];
	GVAR(autoInitPost) = [];
	GVAR(autoInitHc) = [];

	// -- Get the modules used in this mission -- //
	private _modules = (getArray (missionConfigFile >> QUOTE(PREFIX) >> "ModulesLoaded"));

	// -- Add modules that have 'defaultLoad' entry above 0
	private _modulesDefault = (("getNumber (_x >> 'defaultLoad') > 0" configClasses (configFile >> QUOTE(PREFIX) >> "Modules")) apply { configName _x });
	private _missionModules = (("isNumber (_x >> 'defaultLoad')" configClasses (missionConfigFile >> QUOTE(PREFIX) >> "Modules")));
	{
		// -- Allow setting defaultLoad to 0 in a mission to override our default behavior
		private _enabled = getNumber (_x >> "defaultLoad") > 0;
		if !(_enabled) then {
			_modulesDefault = _modulesDefault - [configName _x];
		} else {
			_modulesDefault pushBack (configName _x);
		}
	} forEach _missionModules;


	_modules append _modulesDefault;
	private _modulesAll =+ _modules;
	private _fnc_addDependencyModule = {
	    private _subModule = _this;
	    private _dependencies = getArray (configFile >> QUOTE(PREFIX) >> "Modules" >> _subModule >> "dependencies");
        _dependencies append (getArray (missionConfigFile >> QUOTE(PREFIX) >> "Modules" >> _subModule >> "dependencies"));

	    {
	        private _i = _modulesAll pushBackUnique (toLower _x);
	        if (_i != -1) then {
				diag_log text format ["[%1] Adding dependency '%2' from '%3", QUOTE(PREFIX), _x, _subModule];
	            _x call _fnc_addDependencyModule;
	        };
	        nil;
	    } count _dependencies;
	};
	{
	    _x call _fnc_addDependencyModule;
	    nil
	} count _modules;


	GVAR(loadedModules) = _modulesAll apply { toLower _x };
    uiNamespace setVariable [QGVAR(loadedModules), GVAR(loadedModules)];
};

if !((toLower _module in GVAR(loadedModules))) exitWith { };

private _functionNameLower = toLower _functionVarName;
// -- Happens on CBA preInit
if (_functionNameLower find "_fnc_preinit" > 0) then {
    GVAR(autoInitPre) pushBackUnique _functionNameLower;
	uiNamespace setVariable [QGVAR(autoInitPre), GVAR(autoInitPre)];
};

// -- All these happen on CBA PostInit technically speaking, but before postInit
if (_functionNameLower find "_fnc_clientinit" > 0) then {
    GVAR(autoInitClient) pushBackUnique _functionNameLower;
	uiNamespace setVariable [QGVAR(autoInitClient), GVAR(autoInitClient)];
};

if (_functionNameLower find "_fnc_serverinit" > 0) then {
    GVAR(autoInitServer) pushBackUnique _functionNameLower;
	uiNamespace setVariable [QGVAR(autoInitServer), GVAR(autoInitServer)];
};

if (_functionNameLower find "_fnc_hcinit" > 0) then {
    GVAR(autoInitHc) pushBackUnique _functionNameLower;
	uiNamespace setVariable [QGVAR(autoInitHc), GVAR(autoInitHc)];
};

if (_functionNameLower find "_fnc_init" > 0) then {
    GVAR(autoInit) pushBackUnique _functionNameLower;
	uiNamespace setVariable [QGVAR(autoInit), GVAR(autoInit)];
};

// -- Happens on CBA postInit
if (_functionNameLower find "_fnc_postinit" > 0) then {
    GVAR(autoInitPost) pushBackUnique _functionNameLower;
	uiNamespace setVariable [QGVAR(autoInitPost), GVAR(autoInitPost)];
};
