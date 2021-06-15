
local MINIGAME = MINIGAME;

function MINIGAME:Think()
	local redPlayerCount = #bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Red");
	local bluePlayerCount = #bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Blue");
	
	if( redPlayerCount - bluePlayerCount > 1 ) then
		bwp.minigame:SetTeam( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Red")[redPlayerCount], "Blue", false )
	elseif( bluePlayerCount - redPlayerCount > 1 ) then
		bwp.minigame:SetTeam( bwp.minigame:GetMinigameTeamPlayers(MINIGAME.id, "Blue")[bluePlayerCount], "Red", false )
	end;
end;
		