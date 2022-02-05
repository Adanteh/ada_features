/*
    Function:       FRL_WindowBreak_fnc_breakWindow
    Author:         N3croo
    Description:    Smashes window you're looking at
		TODO : still possible to "look" through 2 windows of a building and miss it

*/
#include "macros.hpp"

private _player = player;

if !(vehicle _player != _player) exitwith {};
private _posAGL = (eyepos _player) vectorDiff [0, 0, (getTerrainHeightASL _posAGL)];

// -- Detect building
private _buildings = [_player, _posAGL] call FUNC(findBuilding);
if (!isNull cursorTarget && !(cursorTarget in _buildings)) then {_buildings append [cursorTarget]};


private _playerViewDir = eyeDirection _player;
if ( currentweapon _player isEqualTo "" || freelook ) then {_playerViewDir = _player weapondirection (currentweapon _player);};
_playerViewDir set [2, 0];

private _nearest = "";
private _maxDist = 3; //maximun distance it will open doors
private _lastAngle = 30; //maximum angle
private _maxVerticalOffset = 1.5;


// -- Check for closest window
{
	scopeName "buildings";
	private _building = _x;

	for "_i" from 1 to 50 do {

		private _window = format ["Glass_%1", _i];
		private _winDam = _building getHitPointDamage (_window+"_hitpoint");
		private _wPosRel = (_building selectionPosition _window);

		if (_wPosRel isEqualTo [0,0,0] || isNil '_winDam') then { breakTo "buildings" };

		if (_winDam < 1) then {
			private _wPos = _building modeltoWorld _wPosRel;
			private _dist = _wPos distance _posAGL;
			private _verticalOffset = Abs ( (_posAGL select 2) - (_wPos select 2) + 0.5 );	// windows seem to frequently use the top center point as reference
			_wPos set [2,_posAGL select 2];
			// since the windows have the mempoint non central (not to say all over the place),
			// the elevation will be igrnored for the angle

			if ( _dist < _maxDist && _verticalOffset < _maxVerticalOffset ) then {
				private _vecPtD = (_wPos vectorFromTo _posAGL);
				_vecPtD set [2, 0];
				private _dotProd = (_playerViewDir vectorDotProduct vectorNormalized _vecPtD);
				private _angle = acos - _dotProd;

				//systemChat str format ["window: %1 | dst: %2 | angle %3 | vOffset %4",_i,_dist,_angle,_verticalOffset];

				if (_angle < _lastAngle) then {
					_lastAngle = _angle;
					_nearest = _window;
				};

			};

		};

	};

	if (_nearest != "") then {
		_building setHitPointDamage [_nearest + "_hitpoint", 1];

		switch (stance player) do {
			case "STAND" : { player switchmove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon"; };
			case "CROUCH" : { player switchmove "AinvPknlMstpSrasWrflDnon_Putdown_AmovPknlMstpSrasWrflDnon"; };
			case "PRONE" : { player switchmove "AinvPpneMstpSrasWrflDnon_Putdown_AmovPpneMstpSrasWrflDnon"; };
			default { player switchmove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon"; };
		};

		// -- Play sound
		private _soundFile = selectRandom [
			"glass_01.wss",
			"glass_02.wss",
			"glass_03.wss",
			"glass_04.wss",
			"glass_05.wss",
			"glass_06.wss",
			"glass_07.wss",
			"glass_08.wss"
		];
		playSound3D ["A3\Sounds_F\arsenal\sfx\bullet_hits\" + _soundFile, objNull, false, ATLToASL _posAGL, 0.8, 1, 20];
		breakout "buildings";
	};
} foreach _buildings
