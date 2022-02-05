/*
    Function:       ADA_Suppress_fnc_clientInit
    Author:         Adanteh
    Description:    Creates effects and eventhandlers
*/
#include "macros.hpp"

if !(GVAR(s_enabled)) exitWith { };

GVAR(amount) = 0;
GVAR(downTime) = 0;

//  -- Add suppression and EH and take care of transfering suppression when switching
["unit", { _this call FUNC(onPlayerSwitch) }] call CBA_fnc_addPlayerEventHandler;

// -- This is not compatible with other mods unfortunately
setCamShakeParams [0.025, 0.5, 0.5, 0.8, true];
enableCamShake true;

GVAR(ppVignette) = -1;
GVAR(ppBlur) = -1;


if (GVAR(s_vignette)) then {
    GVAR(ppVignette) = ["colorCorrections", 2501] call CFUNC(ppEffectCreate);
    GVAR(vignetteTimeout) = 0;
    GVAR(vignetteStrength) = 0;
};

if (GVAR(s_blur)) then {
    GVAR(ppBlur) = ["dynamicBlur", 416, [0], 0.3] call CFUNC(ppEffectCreate);
};


// -- Handles the effects -- //
[{ _this call FUNC(handleEffects) }, __c_effectinterval] call CBA_fnc_addPerFrameHandler;
