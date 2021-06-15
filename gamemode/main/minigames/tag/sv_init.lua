
local MINIGAME = MINIGAME;
local name = MINIGAME.name;

function MINIGAME:Think()
	local playerCount = table.Count(bwp.minigame:GetMinigamePlayers(MINIGAME.id));
	local playerTable = bwp.minigame:GetMinigamePlayers(MINIGAME.id);
	
	for k,v in pairs( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Tagger") ) do
		local tagger = v;
		for k,v in pairs( ents.FindInSphere( tagger:GetPos(), 80 ) ) do
			if( v:IsPlayer() and v:GetMinigame().name == name and v:Alive() and v != tagger ) then
				if( tagger:Alive() and tagger:GetMinigame().name == name ) then
					v:Kill();
					bwp.minigame:SetTeam( tagger, "Runner", true );
					bwp.minigame:SetTeam( v, "Tagger", true );
					bwp.cinematics:StartLargeNotice( v, "You've been Tagged!" );
					tagger = v;
					for k,v in pairs( playerTable ) do
						bwp.cinematics:StartSmallNotice( v, tagger:Nick().." is now the Tagger!" );
					end;
				end;
			end;
		end;
	end;
	if( table.Count( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Tagger") ) == 0 ) then
		if( playerCount == 0 ) then return end;
		local num = math.random( 1, playerCount );
		bwp.minigame:SetTeam( playerTable[num], "Tagger", true );
		bwp.cinematics:StartLargeNotice( playerTable[num], "You are now the Tagger" );
		print("Set tagger to "..playerTable[num]:Nick());
	end;
end;