
MINIGAME = MINIGAME or {};
MINIGAME.Hooks = {};
MINIGAME.Nets = {};


MINIGAME.Name = "Race";
MINIGAME.Description = "Just run like hell and you should be fine.";
MINIGAME.Color = Color(41, 128, 185, 255);
MINIGAME.AllowedGroups = {"*"};
MINIGAME.Teams = {
	["Racer"] = {
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
	}
};
MINIGAME.Routes = {
	[1] = {
		Vector( -650, -541, -11136 ),
		Vector( -600, -1041, -11136 ),
		Vector( -535, -1953, -11136 )
	}
};

