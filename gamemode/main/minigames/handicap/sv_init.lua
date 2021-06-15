
local MINIGAME = MINIGAME;
local name = MINIGAME.name;

function MINIGAME:Think()
	local playerCount = table.Count(bwp.minigame:GetMinigamePlayers(MINIGAME.id));
	local playerTable = bwp.minigame:GetMinigamePlayers(MINIGAME.id);
	local lastHunted = null;
	
	for k,v in pairs( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Handicap") ) do
		local hunted = v;
		if( !v:Alive() ) then
			bwp.minigame:SetTeam( hunted, "Handicap", true );
			lastHunted = hunted;
		end;
		for k,v in pairs( ents.FindInSphere( hunted:GetPos(), 80 ) ) do
			if( v:IsPlayer() and v:GetMinigame().name == name and v:Alive() and v != hunted ) then
				if( hunted:Alive() and hunted:GetMinigame().name == name ) then
					hunted:Kill();
					bwp.minigame:SetTeam( hunted, "Hunter", true );
					bwp.minigame:SetTeam( v, "Handicap", true );
					hunted = v;
					hunted.huntedTime = CurTime();
					bwp.cinematics:StartLargeNotice( hunted, "You're now the Handicap!" );
					for k,v in pairs( playerTable ) do
						bwp.cinematics:StartSmallNotice( v, hunted:Nick().. " is now the Handicap!" );
					end;
				end;
			end;
		end;
	end;
	for k,v in pairs( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Hunter") ) do
		v.huntedTime = CurTime();
	end;
	if( table.Count( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Handicap") ) == 0 ) then
		if( playerCount == 0 ) then return end;
		local num = math.random( 1, playerCount );
		if( playerTable[num] != lastHunted ) then
			bwp.minigame:SetTeam( playerTable[num], "Handicap", true );
			bwp.cinematics:StartLargeNotice( playerTable[num], "You're now the Handicap!" );
			playerTable[num].huntedTime = CurTime();
			if( playerCount > 1 ) then
				for k,v in pairs( playerTable ) do
					bwp.cinematics:StartSmallNotice( v, playerTable[num]:Nick().." is now the Handicap!" );
				end;
			end;
		end;
	end;
end;