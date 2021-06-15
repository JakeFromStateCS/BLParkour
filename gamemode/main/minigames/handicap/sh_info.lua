
MINIGAME = MINIGAME or {};

MINIGAME.name = "Handicap";
MINIGAME.description = "Catch the guy in the wheelchair.";
MINIGAME.color = Color( 255, 255, 255, 255 );
MINIGAME.allowedGroups = {"*"};
MINIGAME.teams = {
	["Hunter"] = {
		color = Color( 0, 255, 0 ),
		weapons = {
		"weapon_crowbar"
	}
	},
	["Handicap"] = {
		default = true,
		color = Color( 255, 255, 255 ),
		weapons = {
		"weapon_crowbar",
		"weapon_crossbow",
		"weapon_357"
	}
	}
};
