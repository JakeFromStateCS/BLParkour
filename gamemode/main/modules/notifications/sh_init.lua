MODULE = MODULE or {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Stored = {};
MODULE.Name = "Notifications";

function MODULE:OnLoad()
	Base.Notify = self;
end;

if( SERVER ) then
	function MODULE:Add( ... )
		local clients = {};
		local args = { ... };
		if( type( args[1] ) == "Player" ) then
			clients = args[1];
			table.remove( args, 1 );
		elseif( type( args[1] ) == "table" ) then
			if( args[1].r == nil ) then
				for k,v in pairs( args[1] ) do
					if( type( v ) == "Player" ) then
						clients[#clients + 1] = v;
					end;
				end;

				table.remove( args, 1 );
			else
				clients = player.GetAll();
			end;
		elseif( type( args[1] ) == "Entity" ) then
			if( args[1]:IsValid() ) then
				local text = "";

				for k,v in pairs( args ) do
					if( type( v ) == "string" ) then
						text = text .. v;
					end;
				end;

				Msg( "(BLParkour) " .. text .. "\n" );

				return;
			end;
		else
			clients = player.GetAll();
		end;

		
		Base.Modules:NetMessage( clients, "AddNotification", args );

	end;

	function MODULE:BroadcastNotification( client, text, color, time )

	end;
else
	MODULE.Config = {
		offset = {
			x = ScrW() - 20,
			y = ScrH() - 70
		}
	};

	function MODULE:Add( text )
		local panel = vgui.Create( "flatUI_Notification" );
		panel:SetText( text );
		table.insert( self.Stored, panel );
		return self.Stored[#self.Stored];
	end;

	function MODULE.Nets:AddNotification()
		--print( net.ReadData() );
		local args = net.ReadTable();
		--local col = net.ReadTable();
		--local time = net.ReadBit();
		local panel = self:Add( args[1] );
		if( args[2] ) then
			panel:SetThemeColor( args[2] );
		end;
		panel:MoveToBack();
	end;

	function MODULE.Hooks:Think()
		for index,panel in pairs( self.Stored ) do
			if( CurTime() > panel.RemoveTime ) then
				panel:Remove();
				table.remove( self.Stored, index );
			else
				local x, y = panel:GetPos();
				local w, h = panel:GetSize();
				if( h < 40 ) then
					h = 50;
				else
					h = h + 10;
				end;

				local yPos = self.Config.offset.y - h * index;

				panel:SetPos( self.Config.offset.x - panel:GetWide(), math.Approach( y, yPos, 6 ) );
			end;
		end;
	end;

	local PANEL = {};

	function PANEL:Init()
		self.BackgroundColor = ( Base.VGUI ~= nil and Base.VGUI.Config.colors.background ) or Color( 255, 255, 255 );
		self.ThemeColor = ( Base.VGUI ~= nil and Base.VGUI.Config.colors.theme ) or Color( 255, 255, 255 );
		self.MinHeight = 30;
		self.Text = "Undefined";
		self.Font = "flatUI TitleText tiny";
		self.Icon = Material( "icon16/information.png" );
		self.RemoveTime = CurTime() + 5;
		self.Index = 0;
		surface.SetFont( self.Font );
		local W, H = surface.GetTextSize( self.Text );
		if( H < self.MinHeight ) then
			H = self.MinHeight;
		end;
		self:SetSize( W + 10, H );

		self:SetPos( Base.Notify.Config.offset.x - self:GetWide(), Base.Notify.Config.offset.y );
	end;

	function PANEL:SetLifeTime( len )
		self.RemoveTime = CurTime() + len;
	end;

	function PANEL:SetColor( col )
		self.BackgroundColor = col;
	end;

	function PANEL:SetThemeColor( col )
		self.ThemeColor = col;
	end;

	function PANEL:SetIcon( iconPath )
		local icon = Material( iconPath );
		if( icon ) then
			self.Icon = icon;
		end;
	end;

	function PANEL:SetText( text )
		if( text ~= "" ) then
			self.Text = text;
			surface.SetFont( self.Font );
			local W, H = surface.GetTextSize( self.Text );
			if( H < self.MinHeight ) then
				H = self.MinHeight;
			end;
			self:SetSize( W + 14, H );
		end;
	end;

	function PANEL:SetIndex( num )
		self.Index = num;
	end;

	function PANEL:Paint( w, h )
		surface.SetDrawColor( self.BackgroundColor );
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( self.ThemeColor );
		surface.DrawRect( 0, 0, 4, h );
		--surface.DrawRect( 0, 0, w, 2 );
		--surface.DrawRect( 0, 0, 2, h );
		--surface.DrawRect( 0, h - 2, w, 2 );
		--surface.DrawRect( w - 2, 0, 2, h );

		surface.SetFont( self.Font );
		local textW, textH = surface.GetTextSize( self.Text );

		surface.SetTextPos( 7, h / 2 - textH / 2 );
		surface.SetTextColor( Color( 0, 0, 0 ) );
		surface.DrawText( self.Text );
	end;

	function PANEL:Think()
		
	end;

	vgui.Register( "flatUI_Notification", PANEL, "DPanel" );

end;