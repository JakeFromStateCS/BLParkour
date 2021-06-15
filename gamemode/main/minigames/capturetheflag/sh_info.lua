
MINIGAME = MINIGAME or {};
MINIGAME.Hooks = {};
MINIGAME.Nets = {};


MINIGAME.Name = "Capture the flag";
MINIGAME.Description = "Touch my shiny metal balls. Back to the good old days.";
MINIGAME.Color = Color(127, 140, 141);
MINIGAME.AllowedGroups = {"*"};
MINIGAME.Locked = true;
MINIGAME.Teams = {
	["White"] = {
		default = true,
		color = Color(127, 140, 141),
		weapons = {
			"weapon_crowbar",
			"weapon_rpg",
		},
		phys = {
			rebound = 320,
			upward = 100,
			ang = 60,
			dist = 40
		}
	},
	["Black"] = {
		color = Color(52, 73, 94),
		weapons = {
			"weapon_crowbar",
			"weapon_rpg",
		},
		phys = {
			rebound = 320,
			upward = 100,
			ang = 60,
			dist = 40
		}
	}
};
MINIGAME.Phys = {
	rebound = 320,
	upward = 70,
	ang = 60,
	dist = 40,
	grav = 300
};