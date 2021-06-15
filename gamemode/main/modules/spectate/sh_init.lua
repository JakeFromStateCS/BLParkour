MODULE = MODULE or {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Spectate";
MODULE.Spectating = {};
MODULE.Config = {};

function MODULE:GetSpecTarget( client )
	if( self.Spectating[client] ) then
		return self.Spectating[client];
	end;
end;

function MODULE:GetSpectators( client )
	local clients = {};
	for specClient,targClient in pairs( self.Spectating ) do
		if( targClient == client ) then
			if( specClient:IsValid() ) then
				table.insert( clients, specClient );
			else
				self.Spectating[specClient] = nil;
				local clients = self:GetSpectators( specTarg );
				Base.Modules:NetMessage( clients, "StopSpectate", specClient );
			end;
		end;
	end;
	return clients;
end;

if( SERVER ) then

	function MODULE.Hooks:PlayerButtonDown( client, button )
		local clients = self:GetSpectators( client );
		local moves = {
			KEY_W,
			KEY_A,
			KEY_S,
			KEY_D,
			MOUSE_LEFT,
			MOUSE_RIGHT
		}
		if( table.HasValue( moves, button ) ) then
			if( table.Count( clients ) > 0 ) then
				Base.Modules:NetMessage( clients, "ButtonDown", client, button )
			else
				local specTarg = self:GetSpecTarget( client );
				if( specTarg and specTarg ~= client ) then
					if( button ~= MOUSE_LEFT ) then
							local clients = self:GetSpectators( specTarg );
							table.insert( clients, specTarg );
							self.Spectating[client] = nil;
							Base.Modules:NetMessage( clients, "StopSpectate", client, specTarg );
							client:UnSpectate();
					else
						if( client:GetObserverMode() == OBS_MODE_CHASE ) then
							client:SetObserverMode( OBS_MODE_IN_EYE );
						else
							client:SetObserverMode( OBS_MODE_CHASE );
						end;
					end;
				end;
			end;
		end;
	end;

	function MODULE.Hooks:PlayerSay( client, text )
		if( string.sub( string.lower( text ), 1, 5 ) == "/spec" ) then
			local words = string.Split( text, " " );
			local name = words[2];
			if( name ) then
				for _,specTarg in pairs( player.GetAll() ) do
					if( string.match( string.lower( specTarg:Nick() ), string.lower( name ) ) ) then
						self.Spectating[client] = specTarg;
						local clients = self:GetSpectators( specTarg );
						table.insert( clients, specTarg );
						Base.Modules:NetMessage( clients, "StartSpectate", client, specTarg );
						client:SpectateEntity( specTarg );
						client:SetObserverMode( OBS_MODE_CHASE );
						return "";
					end;
				end;
			end;
		end;
	end;

	function MODULE.Hooks:EntityRemoved( client )
		if( client:IsPlayer() ) then
			local clients = self:GetSpectators( specTarg );
			table.insert( clients, specTarg );
			self.Spectating[client] = nil;
			Base.Modules:NetMessage( clients, "StopSpectate", client, specTarg );

			for _,client in pairs( clients ) do
				client:UnSpectate();
			end;
		end;
	end;
else
	MODULE.SpecPanels = {};

	surface.CreateFont( "HUDXHuge_Alpha", {
		size = 40,
		antialias = true,
		weight = 400,
		font = "default"
	} );

	surface.CreateFont( "HUDXHuge_Bold", {
		size = 40,
		antialias = true,
		weight = 1000,
		font = "default"
	} );

	function MODULE.Hooks:Think()
		local count = 0;
		for client,panel in pairs( self.SpecPanels ) do
			local x, y = panel:GetPos();
			local w, h = panel:GetSize();
			if( h < 40 ) then
				h = 50;
			else
				h = h + 10;
			end;

			local yPos = 10 + h * count;
			local xPos = 10;
			if( panel.shouldRemove ) then
				xPos = -panel:GetWide() - 100;
				if( x == xPos ) then
					panel:Remove();
					self.SpecPanels[client] = nil;
				end;
			end;
			panel:SetPos( math.Approach( x, xPos, 6 ), math.Approach( y, yPos, 6 ) );
			count = count + 1;
		end;
	end;

	function MODULE.Hooks:PreDrawViewModel()
		if( self.Spectating[LocalPlayer()] ) then
			return true;
		end;
	end;

	function MODULE.Nets:StartSpectate()
		print( "fas SON" );
		local client = net.ReadEntity();
		local specTarg = net.ReadEntity();
		print( client, specTarg );
		self.Spectating[client] = specTarg;

		if( self.Spectating[LocalPlayer()] ) then
			if( self.Spectating[LocalPlayer()] == specTarg ) then
				local TEAM = client:GetMinigameTeam();
				if( TEAM ) then
					local panel = vgui.Create( "flatUI_Notification" );
					panel:SetText( client:Nick() );
					panel:SetThemeColor( TEAM.color );
					panel:SetPos( 10, 100 );
					self.SpecPanels[client] = panel;
				end;
			end;
		end;
	end;

	function MODULE.Nets:StopSpectate()
		local client = net.ReadEntity();
		local specTarg = net.ReadEntity();


		if( self.Spectating[LocalPlayer()] ) then
			print( "EXISTS1" );
			print( self.Spectating[LocalPlayer()], specTarg  );
			if( self.Spectating[LocalPlayer()] == specTarg ) then
				print( "EXISTS2" );
				if( self.SpecPanels[client] ) then
					print( "EXISTS" );
					self.SpecPanels[client].shouldRemove = true;
				end;
			end;
		end;

		self.Spectating[client] = nil;
	end;

end;
