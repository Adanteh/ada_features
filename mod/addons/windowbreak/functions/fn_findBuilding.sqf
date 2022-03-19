/*
    Function:       ADA_WindowBreak_fnc_findBuilding
    Author:         N3croo
    Description:    find building the player is inside or is looking at
    Example:        [player, getpos player] call ADA_WindowBreak_fnc_findBuilding
*/
#include "macros.hpp"

params ["_unit", "_posAGL"];
_posAGL = _posAGL vectorAdd [0, 0, getTerrainHeightASL _posAGL];

private _buildings = [];

{
    private _endPos = (_posAGL vectorAdd _x);
    private _intersectedObjs = lineIntersectsWith [_posAGL, _endPos, objNull, objNull, true];
    if ({_x iskindOf "Building"} count _intersectedObjs > 0) exitWith {
        _buildings = _intersectedObjs;
    };
} foreach [[0,0,-3], [0,0,3], ((eyeDirection _unit) vectormultiply 20)];

_buildings;
