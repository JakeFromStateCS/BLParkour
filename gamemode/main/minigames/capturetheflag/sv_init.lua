MINIGAME = MINIGAME or {};
MINIGAME.Name = "Capture the flag";
MINIGAME.Lobbies = MINIGAME.Lobbies;
MINIGAME.Hooks = MINIGAME.Hooks or {};
MINIGAME.Nets = MINIGAME.Nets;
MINIGAME.Config = {};
MINIGAME.Config.FlagPositions = {
	["gm_bigcity"] =  {
		{
			Vector( -9230, 1154, -11135 ),
			Vector( 9217, 10261, -10895 )
		}
	}
}

function MINIGAME:SetFlagHolder( client )
	local lobbyID = client:GetLobbyID();
	local teamID = client:GetTeamID();
	local clients = Base.Minigame:GetLobbyPlayers( lobbyID );

	if( clients ) then
		local team = teamID;
		for teamID,TEAM in pairs( self.Teams ) do
			if( teamID != team ) then
				team = teamID;
				break;
			end;
		end;
		Base.Modules:NetMessage( clients, "FlagHolder", client, teamID );
	end;
end;

function MINIGAME:ResetFlags( lobbyID )
	local clients = Base.Minigame:GetLobbyPlayers( lobbyID );
	if( clients ) then
		local LOBBY = Base.Minigame:GetLobby( self.Name, lobbyID );
		local map = game.GetMap();
		local flagPositions = self.Config.FlagPositions[map];
		if( flagPositions )  then
			local count = 1;
			for teamID, TEAM in pairs( self.Teams ) do

				if( LOBBY.FlagPositions == nil ) then
					LOBBY.FlagPositions = {};
				end;
				if( LOBBY.FlagHolders == nil ) then
					LOBBY.FlagHolders = {};
				end;

				LOBBY.FlagPositions[teamID] = flagPositions[1][count];
				LOBBY.FlagHolders[teamID] = {
					client = nil,
					capTime = CurTime()
				};
				Base.Modules:NetMessage( clients, "FlagPos", teamID, flagPositions[1][count] );
				

				count = count + 1;
			end;
		end;
	end;
end;

function MINIGAME:SyncFlags( clients, lobbyID )
	local LOBBY = Base.Minigame:GetLobby( self.Name, lobbyID );
	if( LOBBY ) then
		if( LOBBY.FlagPositions ) then
			for teamID, flagPos in pairs( LOBBY.FlagPositions ) do
				Base.Modules:NetMessage( clients, "FlagPos", teamID, flagPos );
			end;
		end;
	end;
end;

function MINIGAME:SyncFlagHolders( clients, lobbyID )
	local LOBBY = Base.Minigame:GetLobby( self.Name, lobbyID );
	if( LOBBY ) then
		if( LOBBY.FlagHolders ) then
			for teamID, flagTab in pairs( LOBBY.FlagHolders ) do
				Base.Modules:NetMessage( clients, "FlagHolder", lobbyID, teamID, flagTab );
			end;
		end;
	end;
end;

function MINIGAME:HandleSpawn( client, lobbyID )
	local teamID = client:GetTeamID();
	local LOBBY = self.Lobbies[lobbyID];

	if( LOBBY.FlagPositions ) then
		if( LOBBY.FlagPositions[teamID] ) then
			local pos = LOBBY.FlagPositions[teamID];
			if( pos ) then
				local spawnPos = Vector( pos.x + math.random( -500, 500 ), pos.y + math.random( -500, 500 ), pos.z );
				client:SetPos( spawnPos );
			end;
		end;
	end;
end;

function MINIGAME:SetTeam( client, lobbyID )
	if( table.Count( self.Lobbies[lobbyID].players ) > 1 ) then
		local count = 100;
		local lowest = "White";
		for teamID, TEAM in pairs( self.Teams ) do
			print( teamID );
			local playerCount = #Base.Minigame:GetTeamPlayers( self.Name, lobbyID, teamID );
			print( playerCount );

			if( playerCount <= count ) then
				count = playerCount + 1;
				lowest = teamID;
			end;
		end;

		client:SetMinigameTeam( lowest );
	--else
		--Ghetto rig the reset flags in here because lol why not
		--self:ResetFlags( lobbyID );
	end;
end;

function MINIGAME.Hooks:PlayerJoinLobby( client, lobbyID )
	self:SetTeam( client, lobbyID );
	self:SyncFlags( client, lobbyID );
	self:SyncFlagHolders( client, lobbyID );
	self:HandleSpawn( client, lobbyID );
end;

function MINIGAME.Hooks:CreateLobby( client, lobbyID )
	self:ResetFlags( lobbyID );
end;

function MINIGAME.Hooks:PlayerLeaveLobby( client, minigameID, lobbyID )
	--local clients = Base.Minigame:GetLobbyPlayers( minigameID, lobbyID );
end;

function MINIGAME.Hooks:PlayerDeath( client )
	
end;

--bwp.cinematics:StartSmallNotice( v, hunted:Nick().. " is now the Hunted!" );
function MINIGAME.Hooks:Think()
	
end;

