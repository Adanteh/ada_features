/*
    Function:       ADA_Suppress_fnc_getCover
    Author:         Adanteh
    Description:    Gets a cover modifier for player
*/
#include "macros.hpp"

params ["_shooter"];

private _shooterPos = AGLToASL (_shooter modelToWorld (_shooter selectionPosition "Pilot"));
private _coverModifier = 1;

{
    if (count _x > 0) then {  _coverModifier = _coverModifier + 1.5 };
    nil;
} count [
    (lineIntersectsSurfaces [AGLtoASL (PLAYER modelToWorld ((PLAYER selectionPosition "Neck") vectorAdd [0, 0.35, 0.5])), _shooterPos, _shooter, objNull, true, 1, "IFIRE", "NONE"]), // -- Head
    (lineIntersectsSurfaces [AGLtoASL (PLAYER modelToWorld ((PLAYER selectionPosition "LeftShoulder") vectorAdd [-0.5, 0, 0])), _shooterPos, _shooter, objNull, true, 1, "IFIRE", "NONE"]), // -- Left Shoulder
    (lineIntersectsSurfaces [AGLtoASL (PLAYER modelToWorld ((PLAYER selectionPosition "RightShoulder") vectorAdd [0.5, 0, 0])), _shooterPos, _shooter, objNull, true, 1, "IFIRE", "NONE"]) // -- Right shoulder
];

_coverModifier;
