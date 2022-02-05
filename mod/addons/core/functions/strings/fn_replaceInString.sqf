/*
    Function:       ADA_Core_fnc_replaceInString
    Author:         Adanteh
    Description:    Replaces given teext in string
*/
#include "macros.hpp"

params [["_string", "", [""]], ["_find", "", [""]], ["_replace", "", [""]]];
if (_find == "") exitWith {_string}; // "1" find "" -> 0
private _result = "";
private _offset = count (_find splitString "");

while {_string find _find != -1} do {
    private _index = _string find _find;
    _result = _result + (_string select [0, _index]) + _replace;
    _string = _string select [_index + _offset];
};

_result + _string
