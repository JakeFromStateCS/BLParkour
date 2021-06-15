
MINIGAME = MINIGAME or {};
MINIGAME.Hooks = {};
MINIGAME.Nets = {};


MINIGAME.Name = "Hunted";
MINIGAME.Description = "Just run like hell and you should be fine.";
MINIGAME.Color = Color(41, 128, 185, 255);
MINIGAME.AllowedGroups = {"*"};
MINIGAME.Teams = {
	["Hunter"] = {
		default = true,
		color = Color(20, 70, 255),
		weapons = {
			"weapon_crowbar",
		},
		phys = {
			rebound = 320,
			upward = 100,
			ang = 60,
			dist = 40
		}
	},
	["Hunted"] = {
		color = Color(255, 120, 50),
		weapons = {
			"weapon_crowbar"
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
	upward = 100,
	ang = 60,
	dist = 40,
	grav = 300
};
