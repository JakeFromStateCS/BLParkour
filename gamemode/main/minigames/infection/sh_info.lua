
MINIGAME = MINIGAME or {};
MINIGAME.Hooks = {};
MINIGAME.Nets = {};


MINIGAME.Name = "Infection";
MINIGAME.Description = "Y'see, the zombies, they're trying to eat you. Kill them.";
MINIGAME.Color = Color(44, 62, 80, 255);
MINIGAME.AllowedGroups = {"*"};
MINIGAME.Teams = {
	["Survivor"] = {
		default = true,
		color = Color(200, 200, 200, 255),
		weapons = {
			"weapon_smg1"
		}
	},
	
	["Infected"] = {
		color = Color(50, 50, 50, 255),
		weapons = {
		"weapon_crowbar"
	}
	}
};
MINIGAME.Locked = true;