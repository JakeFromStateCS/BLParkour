
MINIGAME = MINIGAME or {};
MINIGAME.Name = "Race";
MINIGAME.Lobbies = MINIGAME.Lobbies;
MINIGAME.Hooks = MINIGAME.Hooks or {};
MINIGAME.Nets = MINIGAME.Nets or {};
MINIGAME.Routes = {
	[1] = {
		Vector( -650, -541, -11136 ),
		Vector( -600, -1041, -11136 ),
		Vector( -535, -1953, -11136 )
	}
};
MINIGAME.Config = {};

function MINIGAME:GetRoute( routeID )
	local ROUTE = self.Routes[routeID];
	if( ROUTE ) then
		return ROUTE;
	end;
end;



function MINIGAME:GetRoutePoint( routeID, point )
	local ROUTE = self:GetRoute( routeID );
	if( ROUTE ) then
		return ROUTE[point];
	end;
end;


function MINIGAME.Hooks:HUDPaint()
	local lobbyID = LocalPlayer():GetLobbyID();
	local LOBBY = self.Lobbies[lobbyID];
	if( LOBBY.InProgress ) then
		local point = LocalPlayer().point;
		if( point ) then
			local pointPos = self:GetRoutePoint( LOBBY.Route, point );
			local scrPos = pointPos:ToScreen();
			surface.SetDrawColor( Color( 255, 150, 150 ) );
			surface.DrawRect( scrPos.x - 5, scrPos.y - 5, 10, 10 );
		end;
	elseif( LOBBY.DelayStart ) then
		surface.SetFont( "flatUI TitleText large" );
		surface.SetTextPos( ScrW() / 2, ScrH() / 2 );
		surface.SetTextColor( Color( 255, 255, 255 ) );
		surface.DrawText( math.ceil( LOBBY.DelayStart - CurTime() ) );
	end;
end;

function MINIGAME.Nets:SetPoint()
	local point = net.ReadFloat();
	print( point );
	LocalPlayer().point = point;
end;

function MINIGAME.Nets:StartLobbyDelay()
	local time = net.ReadFloat();
	local lobbyID = LocalPlayer():GetLobbyID();
	local LOBBY = self.Lobbies[lobbyID];
	if( LOBBY ) then
		LOBBY.DelayStart = CurTime() + time;
	end;
end;

function MINIGAME.Nets:StartLobbyRace()
	local lobbyID = LocalPlayer():GetLobbyID();
	local LOBBY = self.Lobbies[lobbyID];
	PrintTable( LOBBY );
	if( LOBBY ) then
		LOBBY.InProgress = true;
		LOBBY.DelayStart = nil;
	end;
end;

function MINIGAME.Nets:SyncRoute()
	local routeID = net.ReadFloat();
	local ROUTE = self.Routes[routeID];
	if( ROUTE ) then
		local lobbyID = LocalPlayer():GetLobbyID();
		local LOBBY = self.Lobbies[lobbyID];
		if( LOBBY ) then
			LOBBY.Route = routeID;
		end;
	end;
end;