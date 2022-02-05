/*
    Function:       ADA_Suppress_fnc_addSuppression
    Author:         Adanteh
    Description:    Adds suppression

    *	0: Amount of suppression to add <SCALAR>
    *	1: The person firing (You can also give the projectile here for things like mortar) <OBJECT>
*/
#include "macros.hpp"

params ["_suppression", "_shooter"];
_suppression = _suppression / ([_shooter] call FUNC(getCover));

// -- Update effects instantly -- //
GVAR(amount) = (GVAR(amount) + _suppression) min GVAR(s_maxSuppression);
if (GVAR(s_blur)) then {
    GVAR(ppBlur) ppEffectEnable true;
    GVAR(ppBlur) ppEffectAdjust [GVAR(amount) / 10 * GVAR(s_blurFactor)];
    GVAR(ppBlur) ppEffectCommit 0.05;
};

// -- Vignette effect. Only based on single bullets
if (GVAR(s_vignette)) then {
    GVAR(vignetteStrength) = GVAR(vignetteStrength) + (_suppression * 0.5) min 1;
    GVAR(vignetteTimeout) = diag_ticktime + 0.4;
    _strength = GVAR(vignetteStrength) * GVAR(s_vignetteFactor);

    GVAR(ppVignette) ppEffectAdjust [
        1, 1, 0, 
        [0, 0, 0, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [1.5 - _strength, 1.5 - _strength, 0, 0, 0, 0.25, 1 - _strength]
    ];
    GVAR(ppVignette) ppEffectCommit 0.07;
};


// -- Time when suppression starts going down again -- //
private _timeValue = _suppression * GVAR(s_timeFactor);

GVAR(downTime) = ((GVAR(downTime) max time) + _timeValue min (time + GVAR(s_maxTimeToFade)));

true;
