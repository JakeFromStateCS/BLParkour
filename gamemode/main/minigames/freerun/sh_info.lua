
MINIGAME = MINIGAME or {};
MINIGAME.Hooks = {};
MINIGAME.Nets = {};

MINIGAME.Name = "Free Run";
MINIGAME.Description = "Do what you do, it's free run.";
MINIGAME.Color = Color(155, 89, 182, 255);
MINIGAME.Default = true;
MINIGAME.AllowedGroups = {"*"};
MINIGAME.Teams = {
	["Runner"] = {
		default = true,
		color = Color(155, 89, 182, 255),
		weapons = {
		"weapon_crowbar",
		}
	};
};
