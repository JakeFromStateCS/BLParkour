
MINIGAME = MINIGAME or {};

MINIGAME.Name = "Juggernaut";
MINIGAME.Description = "One player is the Juggernaut, other players try to kill him to become him.";
MINIGAME.Color = Color( 243, 156, 18, 255 );
MINIGAME.Default = false;
MINIGAME.AllowedGroups = {"*"};
MINIGAME.Teams = {
	["Killer"] = {
		default = true,
		color = Color( 204, 255, 0, 255 ),
		weapons = { "weapon_357", "weapon_crowbar", "weapon_ar2", "weapon_smg", "weapon_shotgun", "weapon_rpg", "weapon_crossbow" } 
	},
	["Juggernaut"] = {
		color = Color( 39, 229, 255, 255 ),
		weapons = { "weapon_crowbar" }
	}
};
