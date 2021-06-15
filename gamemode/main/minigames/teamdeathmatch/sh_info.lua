
local MINIGAME = MINIGAME;

MINIGAME.name = "Team Deathmatch";
MINIGAME.description = "Like Deathmatch.. but with teams.";
MINIGAME.color = Color(20, 70, 255, 255);
MINIGAME.allowedGroups = {"*"};
MINIGAME.teams = {
	["Blue"] = {
		default = true,
		color = Color(20, 70, 255, 255),
		weapons = {
			"weapon_shotgun",
			"weapon_crossbow",
			"weapon_frag",
			"weapon_mp5",
			"weapon_357",
			"weapon_crowbar"
		}
	},
	["Red"] = {
		color = Color(200, 0, 0, 255),
		weapons = {
			"weapon_shotgun",
			"weapon_crossbow",
			"weapon_frag",
			"weapon_mp5",
			"weapon_357",
			"weapon_crowbar"
		}
	}
};
