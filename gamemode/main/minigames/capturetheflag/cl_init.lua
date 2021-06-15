
MINIGAME = MINIGAME or {};
MINIGAME.Name = "Capture the flag";
MINIGAME.Lobbies = MINIGAME.Lobbies or {};
MINIGAME.Hooks = MINIGAME.Hooks or {};
MINIGAME.Nets = {};
MINIGAME.Config = {};
MINIGAME.FlagHolders = {};

function MINIGAME:DrawCapBlip( teamID, flagPos )
	local pos = LocalPlayer():GetPos();
	local ang = LocalPlayer():EyeAngles();
	local lpPos = {
		x = pos.x,
		y = pos.y
	};
	local vPos = {
		x = flagPos.x,
		y = flagPos.y
	};

	local dist = math.sqrt( ( lpPos.y - vPos.y )^2 + ( lpPos.x - vPos.x )^2 );
	if( dist > 900 * 2.25 ) then
		return;
	end;
	
	
	local subPos = {
		x = lpPos.x - vPos.x,
		y = lpPos.y - vPos.y
	};
	subPos.x = subPos.x / 20;
	subPos.y = subPos.y / 20;
	
	subPos = Rotate( -ang.y / 60 + 30, subPos.x, subPos.y ); 
	
	surface.SetDrawColor( self.Teams[teamID].color );
	surface.DrawRect( ScrW() - 100 + subPos.x - 7, 100 - subPos.y - 7, 14, 14 );
	surface.SetDrawColor( Color( 255, 255, 255 ) );
	surface.DrawRect( ScrW() - 100 + subPos.x - 5, 100 - subPos.y - 5, 10, 10 );
end;

function MINIGAME:DrawCapInfo( teamID, flagPos )
	local scrPos = flagPos:ToScreen();	
	local TEAM = self.Teams[teamID];	
	surface.SetFont( "HUDXSmall_Alpha" );
	local teamColor = Color( TEAM.color.r, TEAM.color.g, TEAM.color.b );
	local drawColor = Color( TEAM.color.r, TEAM.color.g, TEAM.color.b );
	
	local w, h = surface.GetTextSize( "Flag" );
	
	surface.SetFont( "HUDXTiny_Alpha" );
	local teamW, teamH = surface.GetTextSize( teamID );
	
	
	w = math.Max( w, teamW );
	h = h + teamH;--math.Max( h, teamH );

	scrPos.x = math.Clamp( scrPos.x, w / 2 + 4, ScrW() - w );
	scrPos.y = math.Clamp( scrPos.y, h + 16, ScrH() + 10 ) - 20;

	local dist = math.sqrt( ( ScrW() / 2 - scrPos.x ) ^2 + ( ScrH() / 2 - scrPos.y ) ^2 );
	
	drawColor.a = math.Clamp( 255 - dist, 0, 255 );
	
	surface.SetDrawColor( Color( 255, 255, 255 ) );
	
	if( Base.VGUI ) then
		if( Base.VGUI.Config.colors.background ) then
			surface.SetDrawColor( Base.VGUI.Config.colors.background );
		end;
	end;
	
	surface.DrawRect( scrPos.x - 5 - w / 2, scrPos.y - 2 - h / 2 - 10, w + 10, h );
	
	teamColor.a = 255;
	surface.SetDrawColor( teamColor );
	surface.DrawRect( scrPos.x - 5 - w / 2, scrPos.y - 2 - h / 2 - 10, 4, h );
	surface.DrawRect( scrPos.x - w / 2, scrPos.y - h + teamH + 4, w + 4, 1 );
	
	--draw.RoundedBox( 2, scrPos.x - self.Config.DotSize, scrPos.y - self.Config.DotSize , self.Config.DotSize, self.Config.DotSize + 1, teamColor );
	
	surface.SetFont( "HUDXSmall_Alpha" );
	surface.SetTextColor( Color( 0, 0, 0, teamColor.a ) );
	surface.SetTextPos( scrPos.x - w / 2 + 2, scrPos.y - 5 - ( h - teamH ) / 2 );
	surface.DrawText( "Flag" );
	
	surface.SetTextColor( teamColor );
	surface.SetTextPos( scrPos.x - w / 2 + 2, scrPos.y - 5 - ( h - teamH ) / 2 );
	surface.DrawText( "Flag" );
	
	surface.SetFont( "HUDXTiny_Alpha" );
	surface.SetTextPos( scrPos.x - w / 2 + 2, scrPos.y - h + 5 );
	surface.DrawText( teamID );
end;

function MINIGAME.Nets:FlagHolder()
	local lobbyID = net.ReadString();
	local teamID = net.ReadString();
	local flagTab = net.ReadTable();

	local LOBBY = LocalPlayer():GetLobby();
	if( LOBBY ) then
		LOBBY.FlagHolders[teamID] = flagTab;
	end;
end;

function MINIGAME.Nets:ResetFlags()
	local LOBBY = LocalPlayer():GetLobby();

	if( LOBBY ) then
		if( LOBBY.FlagPositions ) then

		end;
	end;
end;

function MINIGAME.Nets:FlagPos()
	local LOBBY = LocalPlayer():GetLobby();
	if( LOBBY ) then
		local teamID = net.ReadString();
		local flagPos = net.ReadVector();
		if( LOBBY.FlagPositions == nil ) then
			LOBBY.FlagPositions = {};
		end;
		if( LOBBY.FlagHolders == nil ) then
			LOBBY.FlagHolders = {};
		end;

		LOBBY.FlagPositions[teamID] = flagPos;
		LOBBY.FlagHolders[teamID] = nil;
	end;
end;

function MINIGAME.Hooks:HUDPaint()
	local LOBBY = LocalPlayer():GetLobby();
	if( LOBBY ) then
		if( LOBBY.FlagPositions ) then
			for teamID, flagPos in pairs( LOBBY.FlagPositions ) do
				self:DrawCapBlip( teamID, flagPos );
				self:DrawCapInfo( teamID, flagPos );
			end;
		end;
	end;
end;

function MINIGAME.Hooks:PostDrawOpaqueRenderables()
	local LOBBY = LocalPlayer():GetLobby();
	if( LOBBY ) then
		if( LOBBY.FlagPositions ) then
			for teamID, flagPos in pairs( LOBBY.FlagPositions ) do
				local col = self.Teams[teamID].color;
				col = Color( col.r, col.g, col.b, 150 );
				cam.Start3D2D( flagPos, Angle( 0, 0, 180 ), 0.5 );
					surface.SetDrawColor( col );
					surface.DrawRect( -250, -250, 500,  500 );
				cam.End3D2D();
			end;
		end;
	end;
end;