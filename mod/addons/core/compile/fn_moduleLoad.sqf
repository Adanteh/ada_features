/*
    Function:       ADA_Core_fnc_moduleLoad
    Author:         Adanteh
    Description:    Loads in a module
    Example:        ["project"] call ADA_Core_fnc_moduleLoad;
*/
#include "macros.hpp"

params [["_moduleName", "preinit"], ["_global", false]];

private _fnc_moduleWalk = {
    params ["_moduleName", "_modulePath", "_subModulePaths", "_config"];
    private _submodules = configProperties [_config, "isClass _x", true];
    if (count _submodules == 0) then {
    	private _functionName = configName _config;
	    private _functionNameFull = toLower format ["%1_%2_fnc_%3", QUOTE(PREFIX), _moduleName, _functionName];
	    private _functionPath = if (count _subModulePaths > 0) then {
	        format ["%1\%2\fn_%3.sqf", _modulePath, (_subModulePaths joinString "\"), _functionName];
	    } else {
	        format ["%1\fn_%2.sqf", _modulePath, _functionName];
	    };

        private _allowImport = (getNumber (_config >> "noImport")) == 0;
        // -- Specific setup, only if the config value is specifiec in this class specifically use it, otherwise use a parent (IF IT EXISTS)
        private _noHeader = if ("noheader" in (configProperties [_config, "true", false] apply { toLower configName _x })) then {
            (getNumber (_config >> "noHeader")) > 0;
        } else {
            if (!isNil "_noHeaderModule") then { _noHeaderModule } else { false };
        };

        [_functionPath, _functionNameFull, _moduleName, _allowImport, _functionName, _noHeader] call (uiNamespace getVariable QFUNC(compile));
        if (_global) then {
            publicVariable _functionNameFull;
        };
    } else {
       	private _subModulePaths = +_subModulePaths;
        private "_noHeaderModule"; // -- Some specific private usage to let it for downward only
        if ("noheader" in (configProperties [_config, "true", false] apply { toLower configName _x })) then {
            _noHeaderModule = (getNumber (_config >> "noHeader")) > 0;
        };
	    if (isText (_config >> "path")) then {
	        _modulePath = getText (_config >> "path");
	        _subModulePaths = [];
	    } else {
        	_subModulePaths pushBack (configName _config);
	    };
	    {
	        [_moduleName, _modulePath, _subModulePaths, _x] call _fnc_moduleWalk;
	        nil
	    } count _submodules;
    };
};

private _modules = [];
// -- If this is preinit or prestart (No param given for that, because BIS) compile everything
if (toLower _moduleName in ["preinit", "init", ""]) then {

    _modules = (configProperties [configFile >> QUOTE(PREFIX) >> "Modules", "isClass _x", true]);
    _modules append (configProperties [missionConfigFile >> QUOTE(PREFIX) >> "Modules", "isClass _x", true]);

} else {

    private _moduleSplit = _moduleName splitString "/";
    if (count _moduleSplit == 1) then {
        _moduleSplit = [QUOTE(PREFIX), _moduleSplit select 0];
    };

    private _modName = toLower (_moduleSplit select 0);
    private _moduleName = toLower (_moduleSplit select 1);
    _modules = [];
    if (isClass (configFile >> _modName >> "Modules" >> _moduleName)) then {
        _modules pushBack (configFile >> _modName >> "Modules" >> _moduleName);
    };

    if (isClass (missionConfigFile >> _modName >> "Modules" >> _moduleName)) then {
        _modules pushBack (missionConfigFile >> _modName >> "Modules" >> _moduleName);
    };
};

{
    private _moduleCfg = _x;
    private _moduleName = configName _x;
    private _modulePath = getText (_moduleCfg >> "path");
    if (_modulePath == "") then { _modulePath = format ["%1\%2\functions", QUOTE(BASEPATH), _moduleName] };
    {
        [_moduleName, _modulePath, [], _x] call _fnc_moduleWalk;
        nil
    } count (configProperties [_moduleCfg, "isClass _x", true]);
} forEach _modules;

"Recompiled succesfully";
