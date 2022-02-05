/*
    Function:       ADA_Core_fnc_compile
    Author:         Adanteh
    Description:    Compiles local module function, also see if it needs queing for automagic execution
*/
#include "macros.hpp"

params [["_functionPath", "", [""]], ["_functionVarName", "", [""]], ["_module", ""], ["_allowImport", true], ["_functionName", ""], ["_noHeader", false]];

#define SCRIPTHEADER "\
private _fnc_scriptName = '%1';\
private _fnc_scriptNameShort = '%2';\
scriptName _fnc_scriptName;\
scopeName (_fnc_scriptName + '_Main');\
\
"
//diag_log text format ["[%1] Compiling: %2 - %3", QUOTE(PREFIX), _functionVarName, diag_tickTime];
private _header = format [SCRIPTHEADER, _functionVarName, _functionName];

#ifdef ISDEV

private _cached = false;
private _final = false;
#else

private _cached = isNil {parsingNamespace getVariable _functionVarName};
private _final = true;
#endif

private _funcString = if !(_cached) then {
    if (_noHeader) then {
        preprocessFileLineNumbers _functionPath;
    } else {
        _header + preprocessFileLineNumbers _functionPath;
    };
} else {
    parsingNamespace getVariable _functionVarName
};

private _fncCode = if (_final) then {
    compileFinal _funcString;
} else {
    compile _funcString;
};

{
    if (!_final || { isNil { _x getVariable _functionVarName }}) then {
        _x setVariable [_functionVarName, _fncCode];
    };
    nil
} count [missionNamespace, uiNamespace, parsingNamespace];

// -- Queue for automatic execution based on filenames
[_functionVarName, _module] call (uiNamespace getVariable QFUNC(moduleQueue));

// -- This is used to allow create extra varnames for accessing this function under a different prefix
if (_allowImport) then {
    private _allFunctions = uiNamespace getVariable [QGVAR(compiled), []];
    _allFunctions pushBackUnique (toLower _functionVarName);
    uiNamespace setVariable [QGVAR(compiled), _allFunctions];
};
