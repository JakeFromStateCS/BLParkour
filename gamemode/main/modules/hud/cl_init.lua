MODULE = MODULE or {};
MODULE.Hooks = {};
MODULE.Name = "HUD";
MODULE.Stored = {};
MODULE.Config = {};
MODULE.Config.DotSize = 11;
MODULE.Config.RadarSize = 900;
MODULE.Config.RadarPos = {
	x = ScrW() - MODULE.Config.RadarSize,
	y = MODULE.Config.RadarSize
};

surface.CreateFont( "HUDXSmall_Alpha", {
	size = 20,
	antialias = true,
	weight = 400,
	font = "default"
} );

surface.CreateFont( "HUDXTiny_Alpha", {
	size = 16,
	antialias = true,
	weight = 400,
	font = "default"
} );


function Rotate( ang, x1, y1 )
	local x, y = x1, y1;
	local c = math.cos( ang );
	local s = math.sin( ang );
	x = c * x1 - s * y1;
	y = s * x1 + c * y1;
	return {
		x = x,
		y = y
	};
	
end;

function MODULE:OnLoad()

end;

function MODULE:CanWalljump()
	local pos = {
		[IN_MOVERIGHT] = LocalPlayer():GetRight() * 40,
		[IN_MOVELEFT] = LocalPlayer():GetRight() * -40,
		[IN_FORWARD] = LocalPlayer():GetForward() * 40
	};
end;

function MODULE:DrawPos()
	local backgroundColor = Base.VGUI.Config.colors.background;
	local themeColor = Base.VGUI.Config.colors.theme;
	local pos = LocalPlayer():GetPos();
		--surface.SetDrawColor( themeColor );
		--surface.DrawOutlinedRect( ScrW() - 200, 1, 200, 200 );
	surface.SetTextColor( Color( 255, 255, 255 ) );
	surface.SetFont( "HUDXTiny_Alpha" );
	surface.SetTextPos( ScrW() - 200, 205 );
	surface.DrawText( math.Round( pos.x ) .. ", " .. math.Round( pos.y ) .. ", " .. math.Round( pos.z ) );
end;

function MODULE:DrawInfo( client )
	local scrPos = client:EyePos():ToScreen();
	local teamID = client:GetTeamID();
	local lobbyID = client:GetLobbyID();
	local TEAM = client:GetMinigameTeam();
	if( TEAM ) then
		
		surface.SetFont( "HUDXSmall_Alpha" );
		local teamColor = Color( TEAM.color.r, TEAM.color.g, TEAM.color.b );
		local drawColor = Color( TEAM.color.r, TEAM.color.g, TEAM.color.b );
		
		local w, h = surface.GetTextSize( client:Nick() );
		
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
		surface.DrawText( client:Nick() );
		
		surface.SetTextColor( teamColor );
		surface.SetTextPos( scrPos.x - w / 2 + 2, scrPos.y - 5 - ( h - teamH ) / 2 );
		surface.DrawText( client:Nick() );
		
		surface.SetFont( "HUDXTiny_Alpha" );
		surface.SetTextPos( scrPos.x - w / 2 + 2, scrPos.y - h + 5 );
		surface.DrawText( teamID );
		
		drawColor.a = 255;
	end;
end;

function MODULE:DrawRadarBlip( client )
	local pos = LocalPlayer():GetPos();
	local ang = LocalPlayer():EyeAngles();
	local TEAM = client:GetMinigameTeam();
	if( TEAM ) then
		local lpPos = {
			x = pos.x,
			y = pos.y
		};
		pos = client:GetPos();
		local vPos = {
			x = pos.x,
			y = pos.y
		};

		local dist = math.sqrt( ( lpPos.y - vPos.y )^2 + ( lpPos.x - vPos.x )^2 );
		if( dist > self.Config.RadarSize * 2.25 ) then
			return;
		end;
		
		local subPos = {
			x = lpPos.x - vPos.x,
			y = lpPos.y - vPos.y
		};
		subPos.x = subPos.x / 20;
		subPos.y = subPos.y / 20;
		
		subPos = Rotate( -ang.y / 60 + 30, subPos.x, subPos.y ); 
		
		surface.SetDrawColor( TEAM.color );
		surface.DrawRect( ScrW() - 100 + subPos.x - 3, 100 - subPos.y - 3, 6, 6 );
	end;
end;

function MODULE:DrawRadarFrame()
	if( Base.VGUI ~= nil ) then
		local backgroundColor = Base.VGUI.Config.colors.background;
		local themeColor = Base.VGUI.Config.colors.theme;

		surface.SetDrawColor( themeColor );
		surface.DrawOutlinedRect( ScrW() - 200, 1, 200, 200 );
	end;
end;

function MODULE:DrawCrosshair()
	if( Base.VGUI ~= nil ) then
		local backgroundColor = Base.VGUI.Config.colors.background;
		local themeColor = Base.VGUI.Config.colors.theme;
		local TEAM = LocalPlayer():GetMinigameTeam();

		surface.SetDrawColor( themeColor );
		surface.DrawCircle( ScrW() / 2, ScrH() / 2, 4, TEAM.color );
	end;
end;

function MODULE:DrawAng()
	local trace = {};
	trace.start = EyePos();
	trace.endpos = trace.start + LocalPlayer():GetForward() * 40;
	trace.filter = LocalPlayer();
	trace = util.TraceLine( trace );
	local norm = trace.HitNormal;
	local hitPos = trace.HitPos
	if( hitPos ) then
		local dist = math.ceil( hitPos:Distance( EyePos() ) )
		if( 22 - dist >= 0 and 22 - dist <= 3 ) then
			local TEAM = LocalPlayer():GetMinigameTeam();
			if( TEAM ) then
				cam.Start3D2D( trace.HitPos + norm, norm:Angle() + Angle( 90, 0, 0 ), 1 );
					surface.SetDrawColor( TEAM.color );
					surface.DrawRect( -2, -2, 4, 4 );
				cam.End3D2D();
			end;
		end;
	end;	
end;

function MODULE:DrawAngle()
	local trace = {};
	trace.start = EyePos();
	trace.endpos = trace.start + LocalPlayer():GetForward() * 40;
	trace.filter = LocalPlayer();
	trace = util.TraceLine( trace );
	
	if( trace.HitPos ) then
		local dist = math.ceil( trace.HitPos:Distance( EyePos() ) )
		if( 22 - dist >= 0 ) then
			local pos1 = EyePos();
			local pos2 = trace.HitPos;
			local hitNormal = trace.HitNormal;
			hitNormal = pos2 + hitNormal * dist / 2;
			pos1 = pos1:ToScreen();
			pos2 = pos2:ToScreen();
			hitNormal = hitNormal:ToScreen();
			surface.SetDrawColor( 255, 255, 255 );
			surface.DrawRect( hitNormal.x, hitNormal.y, 10, 10 );
			surface.DrawRect( pos2.x, pos2.y, 10, 10 );
			surface.DrawLine( pos2.x, pos2.y, hitNormal.x, hitNormal.y );
		end;
	end;	
end;

function MODULE.Hooks:HUDPaint()
	if( Base.VGUI ~= nil ) then
		if( Base.VGUI.Menu == nil ) then
			if( Base.Minigame ~= nil ) then
				local lobbyID = LocalPlayer():GetLobbyID();
				local minigameID = LocalPlayer():GetMinigameID();

				if( lobbyID ) then
					local clients = Base.Minigame:GetLobbyPlayers( minigameID, lobbyID );
					if( minigameID == "Free Run" and lobbyID == "Default" ) then
						clients = player.GetAll();
					end;
					if( clients ) then
						for _,client in pairs( clients ) do
							if( client:IsValid() ) then
								if( client ~= LocalPlayer() ) then
									self:DrawInfo( client );
								end;
								self:DrawRadarBlip( client );
							end;
						end;
					end;
					self:DrawRadarFrame();
					self:DrawPos();
					self:DrawCrosshair();
					self:DrawAngle();
				end;
			end;
		end;
	end;
end;

function MODULE.Hooks:PostDrawOpaqueRenderables()
	self:DrawAng();
end;

Base.Modules:RegisterModule( MODULE );