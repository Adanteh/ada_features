/*
    Function:       ADA_Aimsway_fnc_clientInit
    Author:         Adanteh
    Description:    Inits system, setups EHs
*/
#include "macros.hpp"

if !(GVAR(s_enabled)) exitWith { };

// -- Handles the effects -- //
[{ _this call FUNC(handleEffects) }, 0.25] call CBA_fnc_addPerFrameHandler;
