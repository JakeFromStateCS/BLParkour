
local MINIGAME = MINIGAME;

MINIGAME.name = "Training";
MINIGAME.description = "A gamemode to just dick around in with friends.";
MINIGAME.color = Color(120, 0, 250, 255);
MINIGAME.default = false;
MINIGAME.allowedGroups = {"*"};
MINIGAME.teams = {
	["Brotherman"] = {
		default = true,
		color = Color(120, 0, 250, 255),
		weapons = {
		"weapon_crowbar"
	}
	}
};
