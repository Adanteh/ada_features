/*
    Function:       ADA_Suppress_fnc_handleEffects
    Author:         Adanteh
    Description:    Handles the strength of effects
*/
#include "macros.hpp"

if (GVAR(amount) > 0) then {


    GVAR(ppBlur) ppEffectEnable true;
    GVAR(ppVignette) ppEffectEnable true;

    // -- How long and intense to shake camera -- //
    private _suppression = GVAR(amount) * GVAR(s_shakeFactor) / 5;
    addCamShake [_suppression, 3, _suppression];

    // -- Add extra sway factor, to compensate for extra precision from resting / different stances
    private _swayFactor = (getAnimAimPrecision PLAYER);
    if (isWeaponRested PLAYER) then {
        _swayFactor = _swayFactor / 0.4;
    } else {
        if (isWeaponDeployed PLAYER) then {
            _swayFactor = _swayFactor / 0.25;
        };
    };
    PLAYER setCustomAimCoef (GVAR(amount) * (GVAR(s_swayFactor)) * _swayFactor);

    if (GVAR(downTime) < time) then { // -- Lower suppression -- //
        GVAR(amount) = GVAR(amount) - GVAR(s_bleed);

        // -- Blur effect
        if (GVAR(s_blur)) then {
            GVAR(ppBlur) ppEffectAdjust [(GVAR(amount) / 10 * GVAR(s_blurFactor))];
            GVAR(ppBlur) ppEffectCommit __c_effectinterval;
        };

        if (GVAR(amount) <= 0) then {
            PLAYER setCustomAimCoef 1;
            GVAR(amount) = 0;
            GVAR(ppBlur) ppEffectEnable false;
        };
    };

    // -- Disable the vignette75
    if (GVAR(s_vignette)) then {
        if (diag_tickTime > GVAR(vignetteTimeout)) then {
            GVAR(ppVignette) ppEffectAdjust [
                1, 1, 0, 
                [0, 0, 0, 1],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [3, 3, 0, 0, 0, 0, 3]
            ];
            GVAR(ppVignette) ppEffectCommit 2;
            GVAR(vignetteStrength) = 0;
        };
    };
};
