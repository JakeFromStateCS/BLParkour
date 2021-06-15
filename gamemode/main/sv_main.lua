/*
	Unnamed Project
    --By Blasphemy
*/


include( "sh_config.lua" );
include( "sh_main.lua" );

print( "Loaded Shared" );

function GM:PlayerSetModel( client )
	local clientPlayerModel = client:GetInfo("cl_playermodel");
    local playerModel = player_manager.TranslatePlayerModel(clientPlayerModel);
	
	if (!util.IsValidModel(playerModel)) then
		playerModel = "models/kliener.mdl";
	end;
	
	util.PrecacheModel(playerModel);
    client:SetModel(playerModel);
end;

function GM:PlayerSpawn( client )
	--client:StripWeapons();
	hook.Call( "PlayerSetModel", GM, client );
	--self:PlayerLoadout( client );	
end;

function GM:PlayerLoadout( client )
	local TEAM = client:GetMinigameTeam();

	if( TEAM ) then
		for _,v in pairs( TEAM.weapons ) do
			client:Give( v );
		end;
	end;
end;

function GM:PlayerInitialSpawn( client )
	client:SetRunSpeed( Base.Config.RunSpeed );
    client:SetWalkSpeed( Base.Config.WalkSpeed );
    
    self.BaseClass:PlayerInitialSpawn( client );
end;

function GM:AllowPlayerPickup( ply, entity )
	return true;
end;

function GM:EntityRemove( entity )
	self.BaseClass:EntityRemoved( entity );

end;

function GM:CanPlayerSuicide( ply )
	return Base.Config.CanSuicide;
end;

function GM:PlayerSwitchFlashlight( ply, state )
	return false;
end;

print( "Loaded Server" );