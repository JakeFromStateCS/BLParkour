
local MINIGAME = MINIGAME;

MINIGAME.name = "Tag";
MINIGAME.description = "You see, the point is that you have to touch 'em.";
MINIGAME.color = Color( 20, 200, 20, 255 );
MINIGAME.allowedGroups = {"*"};
MINIGAME.teams = {
	["Tagger"] = {
		color = Color( 255, 255, 0 ),
		weapons = {
		"weapon_crowbar"
	}
	},
	["Runner"] = {
		default = true,
		color = Color( 20, 200, 20 ),
		weapons = {
		"weapon_crowbar"
	}
	}
};
