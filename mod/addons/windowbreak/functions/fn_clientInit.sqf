/*
    Function:       FRL_WindowBreak_fnc_clientInit
    Author:         N3croo
    Description:    Adds keybind for window breaking
*/
#include "macros.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

// -- Bind to weapon resting by default
_defaultKey = actionKeys "deployWeaponAuto";
_keyBind = if (_defaultKey isEqualTo []) then { DIK_T } else { _defaultKey select 0 };

[
	QUOTE(PREFIX),
	"WindowBreak",
	["Break Window", "Destroy window that's in front of you"],
	{ _this call FUNC(breakWindow); false },
	{ false },
	[_keyBind, [false, false, false]]
] call CBA_fnc_addKeybind;
