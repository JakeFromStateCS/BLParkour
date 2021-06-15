
MINIGAME = MINIGAME or {};
MINIGAME.Hooks = {};
MINIGAME.Nets = {};


MINIGAME.Name = "Deathmatch";
MINIGAME.Description = "I love throwing bullets at people!";
MINIGAME.Color = Color(231, 76, 60, 255);
MINIGAME.Default = false;
MINIGAME.AllowedGroups = {"*"};
MINIGAME.Teams = {
	["Killer"] = {
		id = 1,
		default = true,
		color = Color(200, 0, 0, 255),
		weapons = {
			--"m9k_m3",
			"weapon_crossbow",
			--"m9k_sticky_grenade",
			"weapon_crowbar",
			"weapon_357",
			"weapon_frag",
			"weapon_shotgun"
			--[["m9k_svt40",
			"m9k_machete",
			"m9k_harpoon",
			"m9k_an94",
			"m9k_damascus",]]--
		},
		allowedGroups = {"*"}
	}
};

MINIGAME.Phys = {
	rebound = 350,
	upward = 60,
	ang = 60,
	dist = 40,
	grav = 300
};

