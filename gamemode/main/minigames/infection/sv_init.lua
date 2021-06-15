
local MINIGAME = MINIGAME;
local name = MINIGAME.name;

function MINIGAME:Think()
	local playerCount = table.Count(bwp.minigame:GetMinigamePlayers(MINIGAME.id));
	local playerTable = bwp.minigame:GetMinigamePlayers(MINIGAME.id);
	
	for k,v in pairs( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Infected") ) do
		local ply = v;
		for k,v in pairs( ents.FindInSphere( ply:GetPos(), 80 ) ) do
			if( v:IsPlayer() and v:GetMinigame().name == name and v:Alive() and v != ply and v:MinigameTeam() != ply:MinigameTeam() ) then
				if( ply:Alive() ) then
					bwp.minigame:SetTeam( v, "Infected", true );
					local tempPlayer = v;
					bwp.cinematics:StartLargeNotice( v, "You've been Infected!" );
					for k,v in pairs( playerTable ) do
						bwp.cinematics:StartSmallNotice( v, tempPlayer:Nick().." has been Infected!" );
					end;
					v.maxSpeed = MAXSPEED*1.30;
					bwp.player:SetMaxHealth( v, 200 );
				end;
			end;
		end;
	end;
	if( table.Count( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Infected") ) == 0 ) then
		if( playerCount == 0 ) then return end;
		local num = math.random( 1, playerCount );
		print("Set infected to "..playerTable[num]:Nick());
		bwp.minigame:SetTeam( playerTable[num], "Infected", true );
		bwp.cinematics:StartLargeNotice( playerTable[num], "You are now the Alpha Infected." );
			for k,v in pairs( playerTable ) do
				bwp.cinematics:StartSmallNotice( v, playerTable[num]:Nick().." is the Alpha Zombie!" );
			end
		bwp.player:SetMaxHealth( playerTable[num], 300 );
		playerTable[num].maxSpeed = MAXSPEED*1.30;
	end;
	if( table.Count( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Infected") ) == playerCount and playerCount > 1 ) then
		for k,v in pairs( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Infected") ) do
			bwp.minigame:SetTeam( v, "Survivor", false );
			v.maxSpeed = MAXSPEED;
			bwp.player:SetMaxHealth( v, 100 );
		end;
	end;
end;