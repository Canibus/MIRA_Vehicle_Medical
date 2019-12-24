#include "function_macros.hpp"
params["_player", "_target", "_params"];
_params params["_unit"];

_actions = [];

_stitchWounds = _unit call FUNC(getStitchableWounds);
_needsStitch = GVAR(TrackStitchableWounds) && count _stitchWounds > 0;
if (_needsStitch) then {
	LOG(format["'%1' has stitchable wounds", _unit]);
	_action = ["MIRA_Stitch", format["Stitch (%1)", count _stitchWounds] , QUOTE(ICON_PATH(stitch)), {
			params ["_player", "_target", "_parameters"];
			_parameters params ["_unit"];
			[_unit] call ace_medical_menu_fnc_openMenu;
		}, {true}, {}, [_unit]] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], _unit];
};

_needsBandage = GVAR(TrackNeedsBandage) && _unit call FUNC(needsBandage);
if(_needsBandage) then {
	_requiredBandages = 0;
	_openWounds = _unit call FUNC(getOpenWounds);
	{
		_x params ["", "_bodyPartN", "_amountOf", "_bleeding"];
		if (_amountOf > 0) then {
			_requiredBandages = _requiredBandages + 1;
		};
	} forEach _openWounds;
	LOG(format["'%1' has unbandadged wounds", _unit]);
	_action = ["MIRA_Bandage", format["Bandage (%1)", (_requiredBandages - (count _stitchWounds))] , QUOTE(ICON_PATH(bandage)), {
			params ["_player", "_target", "_parameters"];
			_parameters params ["_unit"];
			[_unit] call ace_medical_menu_fnc_openMenu;
		}, {true}, {}, [_unit]] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], _unit];
};

_hasLowBP = GVAR(TrackLowBP) && _unit call FUNC(hasLowBP);
if(_hasLowBP) then {
	LOG(format["'%1' has low BP", _unit]);
	_bp = [_player, _unit] call FUNC(displayBP);
	_action = ["MIRA_LowBP", format["Blood Pressure (%1)", _bp] , QUOTE(ICON_PATH(bp_low)), {
			params ["_player", "_target", "_parameters"];
			_parameters params ["_unit"];
			[_unit] call ace_medical_menu_fnc_openMenu;
		}, {true}, {}, [_unit]] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], _unit];
};

_hasLowHR = GVAR(TrackLowHR) && _unit call FUNC(hasLowHR);
if(_hasLowHR) then {
	LOG(format["'%1' has low HR", _unit]);
	_hr = [_player, _unit] call FUNC(displayHR);
	_action = ["MIRA_LowHR", format["Heart Rate (%1)", _hr], QUOTE(ICON_PATH(hr_low)), {
			params ["_player", "_target", "_parameters"];
			_parameters params ["_unit"];
			[_unit] call ace_medical_menu_fnc_openMenu;
		}, {true}, {}, [_unit]] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], _unit];
};

_actions