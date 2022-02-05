/*
    Function:       ADA_Core_fnc_debugMessage
    Author:         Adanteh
    Description:    Shows a debug message
    Example:        [[_fnc_scriptNameShort, "hi"], "red", 2] call ADA_Core_fnc_debugMessage;
*/
#include "macros.hpp"

params ["_message", ["_color", ""], ["_timeout", 10], ["_logLevel", 30]];

if (isNil QGVAR(dbgLogLevel)) then { call FUNC(clientInitDebug) };

if (GVAR(dbgLogLevel) >= _logLevel) then {

    if !(_message isEqualType "") then {
        if (_message isEqualType []) then {
            _message = _message joinString " ";
        } else {
            _message = str _message;
        };
    };

    if (isNil QGVAR(debugStack)) exitWith { }; // -- UI not available. Exit
    // -- Colorize message
    if (_color != "") then {
        private _color = [_color] call FUNC(colorFromName);
        _message = format ["<t color='%1'>%2</t>", _color, _message];
    };


    // -- The arrow brackets fuck structured text up.
    _message = [_message, "<NULL-group>", "grpNull"] call FUNC(replaceInString);
    _message = [_message, "<NULL-object>", "objNull"] call FUNC(replaceInString);
    _message = [_message, "<no shape>", "shapeNull"] call FUNC(replaceInString);
    diag_log text format ["[%1] Dbg: %2 - %3", QUOTE(PREFIX), _message, diag_tickTime];

    GVAR(debugStack) pushBack [_message, time + _timeout];
};
