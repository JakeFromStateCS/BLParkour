MINIGAME = MINIGAME;
MINIGAME.Name = "Race";
MINIGAME.Lobbies = MINIGAME.Lobbies or {};
MINIGAME.Hooks = MINIGAME.Hooks or {};
MINIGAME.Nets = MINIGAME.Nets or {};
MINIGAME.Config = {};
MINIGAME.Config.StartDelay = 5;
local name = MINIGAME.Name;

local pMeta = FindMetaTable( "Player" );

function pMeta:SetPoint( point )
	self.point = point;
	Base.Modules:NetMessage( self, "SetPoint", point );
end;

function MINIGAME:GetRoute( lobbyID )
	local LOBBY = self.Lobbies[lobbyID];
	if( LOBBY ) then
		local ROUTE = self.Routes[LOBBY.Route];
		if( ROUTE ) then
			return ROUTE;
		end;
	end;
end;



function MINIGAME:GetRoutePoint( routeID, point )
	local ROUTE = self:GetRoute( routeID );
	if( ROUTE ) then
		return ROUTE[point];
	end;
end;



function MINIGAME:GetIdlePlayers( lobbyID )
	local clients = Base.Minigame:GetLobbyPlayers( self.Name, lobbyID );
	local activePlayers = self:GetActivePlayers( lobbyID );
	for k,client in pairs( clients ) do
		if( table.HasValue( activePlayers, client ) ) then
			clients[k] = nil;
		end;
	end;
	return clients;
end;


function MINIGAME:GetActivePlayers( lobbyID )
	local LOBBY = self.Lobbies[lobbyID];
	if( LOBBY ) then
		if( LOBBY.ActivePlayers ) then
			return LOBBY.ActivePlayers;
		end;
	end;
	return {};
end;

function MINIGAME:SetupPlayer( client )
	local lobbyID = client:GetLobbyID();
	local LOBBY = self.Lobbies[lobbyID];
	if( LOBBY ) then
		if( LOBBY.StartDelay == true ) then
			table.insert( LOBBY.ActivePlayers, client );
			Base.Modules:NetMessage( client, "StartLobbyDelay", self.Config.StartDelay - math.ceil( CurTime() - LOBBY.DelayStart ) );
		else
			if( LOBBY.InProgress ) then
				if( LOBBY.IdlePlayers == nil ) then
					LOBBY.IdlePlayers = {};
				end;
				table.insert( LOBBY.IdlePlayers, client );
			end;
		end;
	end;
end;



/*
	function CanStartLobby( lobbyID ):
		Checks if the lobby is active
*/
function MINIGAME:CanStartLobby( lobbyID )
	local LOBBY = self.Lobbies[lobbyID];
	if( LOBBY ) then
		if( !LOBBY.StartDelay and !LOBBY.InProgress ) then
			local clients = Base.Minigame:GetLobbyPlayers( self.Name, lobbyID );
			if( #clients >= 1 ) then
				return true;
			end;
		end;
	end;
	return false;
end;



function MINIGAME:StartLobbyDelay( lobbyID )
	local LOBBY = self.Lobbies[lobbyID];
	if( LOBBY ) then
		if( !LOBBY.StartDelay ) then
			local clients = Base.Minigame:GetLobbyPlayers( self.Name, lobbyID );
			LOBBY.StartDelay = true;
			LOBBY.DelayStart = CurTime();
			LOBBY.ActivePlayers = clients;
			LOBBY.Route = 1;
			Base.Modules:NetMessage( clients, "SyncRoute", LOBBY.Route );
			Base.Modules:NetMessage( clients, "StartLobbyDelay", self.Config.StartDelay );
		end;
	end;
end;



function MINIGAME:StartLobby( lobbyID )
	local LOBBY = self.Lobbies[lobbyID];
	if( LOBBY ) then
		LOBBY.StartDelay = false;
		LOBBY.DelayStart = nil;
		LOBBY.InProgress = true;
		local ROUTE = self:GetRoute( lobbyID );
		local clients = self:GetActivePlayers( lobbyID );
		local count = #clients;
		for k,client in pairs( clients ) do
			client:SetPoint( 1 );
			local pos = ROUTE[1];
			client:SetPos( pos - ( client:GetRight() * count / 2 ) + client:GetRight() * k );
		end;
		Base.Modules:NetMessage( clients, "StartLobbyRace" );
	end;
end;



function MINIGAME:ResetLobby( lobbyID )
	local LOBBY = self.Lobbies[lobbyID];
	if( LOBBY ) then
		if( LOBBY.InProgress ) then

		end;
	end;
end;



function MINIGAME:SyncRoute( client )
	local lobbyID = client:GetLobbyID();
	local LOBBY = self.Lobbies[lobbyID];
	if( LOBBY ) then
		Base.Modules:NetMessage( client, "SyncRoute", LOBBY.Route );
	end;
end;



function MINIGAME:CheckPlayerPos( client )
	local LOBBY = self.Lobbies[client:GetLobbyID()];
	local ROUTE = self.Routes[LOBBY.Route];
	local count = #ROUTE;
	local pointPos = ROUTE[client.point];
	local pos = client:GetPos();
	if( pos:Distance( pointPos ) <= 100 ) then
		if( client.point < count ) then
			client:SetPoint( client.point + 1 );
		elseif( client.point == count ) then

		end;
	end;
end;


/*
	HOOKS:
*/


function MINIGAME.Hooks:PlayerJoinLobby( client, lobbyID )
	--Check if the amount of people in the lobby are over 2
	--If so, set delay on the race for MINIGAME.Config.RaceDelay time
	--Start race after that time
	if( self:CanStartLobby( lobbyID ) ) then
		self:StartLobbyDelay( lobbyID );
	else
		self:SetupPlayer( client );
	end;
end;

function MINIGAME.Hooks:PlayerLeaveLobby( client, minigameID, lobbyID )
	client.point = nil;
end;


function MINIGAME.Hooks:Think()
	for lobbyID, LOBBY in pairs( self.Lobbies ) do
		if( LOBBY.InProgress ) then
			local clients = self:GetActivePlayers( lobbyID );
			for _,client in pairs( clients ) do
				self:CheckPlayerPos( client );
			end;
		elseif( LOBBY.StartDelay ) then
			local time = LOBBY.DelayStart + self.Config.StartDelay;
			if( time < CurTime() ) then
				self:StartLobby( lobbyID );
			end;
		end;
	end;
end;