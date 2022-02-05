/*
    Function:       ADA_Core_fnc_preInitDebug
    Author:         Adanteh
    Description:    Inits local debug system. This is just a big structured text window
*/
#include "macros.hpp"

["debugMessage", {
    _this call FUNC(debugMessage);
}] call cba_fnc_addEventHandler;

[{
    private _messageCount = count GVAR(debugStack);
    if (_messageCount > __MAXMESSAGES) then {
        GVAR(debugStack) = GVAR(debugStack) select [_messageCount - __MAXMESSAGES, _messageCount - 1];
    };

    private _messages = +(GVAR(debugStack));
    private _keepMessages = [];
    private _fullText = "";

    while { count _messages > 0 } do {
        private _entry = _messages deleteAt 0;
        _entry params ["_message", "_timeout"];
        if (_timeout > time) then {
            _fullText = format ["%1<br />%2", _fullText, _message];
            _keepMessages pushBack _entry;
        };

    };

    // -- If there is text to show, show all of it
    disableSerialization;
    private _display = switch (true) do {
        case (!isNil "bis_buldozer_cursor"): { findDisplay -1 };
        case (is3DEN): { findDisplay 313 };
        default { findDisplay 46 };
    };
    private _logging = _display getVariable [QGVAR(debugCtrl), controlNull];
    if (_fullText != "") then {
        if (isNull _logging) then {
            QGVAR(debugText) cutRsc [QGVAR(debugText), "PLAIN"];
            private _logging = (uinamespace Getvariable [QGVAR(debugText), displayNull] displayCtrl 9999);
            _logging ctrlSetPosition [safeZoneX + safeZoneW * 0.04, safeZoneY + (safeZoneH * 0.05), safeZoneW * 0.96, safeZoneH * 0.92];
            _logging ctrlCommit 0;
            _display setVariable [QGVAR(debugCtrl), _logging];
        };
        _logging ctrlSetStructuredText parseText (format ["<t align='left' size='0.45' font='%2' shadow='2' >%1</t>", _fullText, GVAR(dbgFont)]);
    } else {
        _logging ctrlSetStructuredText parseText _fullText;
    };
    GVAR(debugStack) = _keepMessages;

}, 0] call cba_fnc_addPerFrameHandler;
