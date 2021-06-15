MODULE = MODULE or {};
MODULE.Hooks = {};
MODULE.Name = "VGUI";
MODULE.Stored = {};
MODULE.Config = {
	colors = {
		theme = Color( 41, 128, 185 ),
		background = Color( 250, 250, 250 )
	}
};
MODULE.Blur = Material( "pp/blurx" );

function MODULE:OnLoad()
	Base.VGUI = self;
end;

function MODULE:SetThemeColor( col )
	if( col.r and col.g and col.b ) then
		self.Config.colors.theme = col;
	end;
end;

function MODULE:SetBackgroundColor( col )
	if( col.r and col.g and col.b ) then
		self.Config.colors.background = col;
	end;
end;

--[[
	vgui by Matt.
]]--

surface.CreateFont( "flatUI TitleText fine", {
	font = "Roboto",
	size = 22,
} );

surface.CreateFont( "flatUI TitleText tiny", {
	font = "Roboto",
	size = 24,
} );

surface.CreateFont( "flatUI TitleText small", {
	font = "Roboto",
	size = 26,
} );

surface.CreateFont( "flatUI TitleText medium", {
	font = "Roboto",
	size = 28,
} );

surface.CreateFont( "flatUI TitleText large", {
	font = "Roboto",
	size = 32,
} );

surface.CreateFont( "flatUI ControlText", {
	font = "Arial",
	weight = 800,
	size = 16,
} );

surface.CreateFont( "flatUI Icon_Text", {
	font = "CloseCaption_Normal",
	weight = 800,
	size = 30,
} );

surface.CreateFont( "flatUI Icon_Text slim4", {
	font = "Trebuchet",
	weight = 400,
	size = 30
} );


--[[
	Close button.
]]--

local PANEL = {};

function PANEL:Init()
	self.Hovered = false;
	self.TargetAlpha = 0;
	self.Alpha = 0;

	self:SetSize(22, 22);
	self:SetMouseInputEnabled(true);
end;

function PANEL:Paint( w, h )
	if (self.Alpha != self.TargetAlpha) then
		self.Alpha = math.Approach(self.Alpha, self.TargetAlpha, 355 * FrameTime());
	end;
	local col = self:GetParent().BackgroundColor;
	surface.SetDrawColor(Color(100, 100, 100, self.Alpha));
	surface.DrawRect(0, 0, w, h);

	--surface.SetDrawColor( col );
	--surface.DrawRect( 0, 0, w, 4 );
	--surface.DrawRect( 0, 6, w, 4 );
	--surface.DrawRect( 0, 12, w, 4 );
	
	
	surface.SetFont("flatUI Icon_Text slim4");
	surface.SetTextPos(4, -6);
	surface.SetTextColor(self:GetParent().BackgroundColor);--Color(100, 100, 100, 200));
	surface.DrawText("x");
end;

function PANEL:OnCursorEntered()
	self.Hovered = true;
	self.TargetAlpha = 100;
end;

function PANEL:OnCursorExited()
	self.Hovered = false;
	self.TargetAlpha = 0;
end;

function PANEL:OnMousePressed()
	local Parent = self:GetParent();

	if (Parent.Metro) then
		Parent:Close();
		return;
	end;

	Parent:SetVisible(false);
end;

function PANEL:Align()
	local Parent = self:GetParent();
	local ParentWidth, ParentHeight = Parent:GetSize();

	self:SetPos( ParentWidth - ( self:GetWide() + 8 ), 6 );
end;

vgui.Register("flatUI_CloseButton", PANEL, "DPanel");

--[[
	FlatUI Kick from lobby button
	( The little X on their player button );
]]--

local PANEL = {};

function PANEL:Init()
	self.Hovered = false;
	self.TargetAlpha = 0;
	self.Alpha = 0;

	self:SetSize(22, 22);
	self:SetMouseInputEnabled(true);
end;

function PANEL:Paint( w, h )
	if (self.Alpha != self.TargetAlpha) then
		self.Alpha = math.Approach(self.Alpha, self.TargetAlpha, 355 * FrameTime());
	end;
	local col = self:GetParent().BackgroundColor;
	surface.SetDrawColor(Color(100, 100, 100, self.Alpha));
	surface.DrawRect(0, 0, w, h);

	--surface.SetDrawColor( col );
	--surface.DrawRect( 0, 0, w, 4 );
	--surface.DrawRect( 0, 6, w, 4 );
	--surface.DrawRect( 0, 12, w, 4 );
	
	
	surface.SetFont("flatUI Icon_Text slim4");
	surface.SetTextPos(4, -6);
	surface.SetTextColor(self:GetParent().BackgroundColor);--Color(100, 100, 100, 200));
	surface.DrawText("x");
end;

function PANEL:OnCursorEntered()
	self.Hovered = true;
	self.TargetAlpha = 100;
end;

function PANEL:OnCursorExited()
	self.Hovered = false;
	self.TargetAlpha = 0;
end;

function PANEL:OnMousePressed()
	local Parent = self:GetParent();

	if (Parent.Metro) then
		Parent:Close();
		return;
	end;

	Parent:SetVisible(false);
end;

function PANEL:Align()
	local Parent = self:GetParent();
	local ParentWidth, ParentHeight = Parent:GetSize();

	self:SetPos( ParentWidth - ( self:GetWide() + 8 ), 6 );
end;

vgui.Register("flatUI_KickButton", PANEL, "DPanel");


--[[
	Menu button.
]]--

local PANEL = {};

function PANEL:Init()
	self.Hovered = false;
	self.TargetAlpha = 0;
	self.Alpha = 0;
	self.Open = false;

	self:SetSize(22, 16);
	self:SetMouseInputEnabled(true);
end;

function PANEL:Paint( w, h )
	if (self.Alpha != self.TargetAlpha) then
		self.Alpha = math.Approach(self.Alpha, self.TargetAlpha, 355 * FrameTime());
	end;
	local col = self:GetParent().BackgroundColor;
	surface.SetDrawColor(Color(100, 100, 100, self.Alpha));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor( col );
	surface.DrawRect( 0, 0, w, 4 );
	surface.DrawRect( 0, 6, w, 4 );
	surface.DrawRect( 0, 12, w, 4 );
	
	
	--surface.SetFont("flatUI ControlText");
	--surface.SetTextPos(7, 2);
	--surface.SetTextColor(self:GetParent().BackgroundColor);--Color(100, 100, 100, 200));
	--surface.DrawText("x");
end;

function PANEL:OnCursorEntered()
	self.Hovered = true;
	self.TargetAlpha = 100;
end;

function PANEL:OnCursorExited()
	self.Hovered = false;
	self.TargetAlpha = 0;
end;

function PANEL:OnMousePressed()
	local Parent = self:GetParent();

	if( Parent.DMenu ~= nil ) then
		Parent.DMenu = nil;
		--return;
	else
		Parent.DMenu = vgui.Create( "DMenu", Parent );
		Parent.DMenu:SetPos( 0, 30 );
		for text, func in pairs( Parent.MenuOptions ) do
			Parent.DMenu:AddOption( text, func );
		end;
		self.Open = true;
		--Parent.DMenu:Open();
		--Parent:AddMenuOption( "Shit", function() print( "hi" ) end );
	end;
	--Parent:SetVisible(false);
end;

function PANEL:Align()
	local Parent = self:GetParent();
	local ParentWidth, ParentHeight = Parent:GetSize();

	self:SetPos( 10, 9 );


end;

vgui.Register("flatUI_MenuButton", PANEL, "DPanel");



--[[
	Base frame.
]]--

local PANEL = {};

function PANEL:Init()
	self.Title = "flatUI frame";
	self.Hovered = false;
	self.ShowCloseButton = true;
	self.ShowMenuButton = true;
	self.MouseDown = false;
	self.BackgroundColor = Base.VGUI.Config.colors.background;
	self.ThemeColor = Base.VGUI.Config.colors.theme;
	self.HighlightColor = Color( math.Clamp( self.ThemeColor.r + 20, 0, 255 ), math.Clamp( self.ThemeColor.g + 20, 0, 255 ), math.Clamp( self.ThemeColor.b + 20, 0, 255 ) );
	self.MenuOptions = {};

	self.Draggable = true;
	self.DragOffset = {
		x = 0,
		y = 0
	};

	self.Closing = false;
	self.DeleteOnClose = false;

	self.FadingToView = false;
	self.TitlePosition = -1000;
	self.TargetTitlePosition = -1000;

	self.MenuButton = vgui.Create( "flatUI_MenuButton", self );
	--self.CloseButton = vgui.Create( "flatUI_CloseButton", self );
	self.DMenu = vgui.Create( "DMenu", self );
	self.Icon = Material( "icon16/color_wheel.png" );
	--self.DMenu:Open();
	--self:AddMenuOption( "Shit", function() print( "hi" ) end );
	--self.DMenu:SetVisible( false );
end;

function PANEL:SetTitle( text )
	self.Title = text;
end;

function PANEL:MenuButtonVisible( bool )
	self.ShowMenuButton = bool;
	if( bool == false ) then
		if( self.MenuButton != nil ) then
			self.MenuButton:Remove();
			self.MenuButton = nil;
		end;
	end;
end;

function PANEL:SetDraggable( bool )
	self.Draggable = false;
end;

function PANEL:SetBackgroundColor( col )
	if( col.r and col.g and col.b ) then
		Base.VGUI.Config.colors.background = col;
		self.BackgroundColor = col;
	end;
end;

function PANEL:SetThemeColor( col )
	if( col.r and col.g and col.b ) then
		Base.VGUI.Config.colors.theme = col;
		self.ThemeColor = col;

		self.HighlightColor = Color( math.Clamp( self.ThemeColor.r + 20, 0, 255 ), math.Clamp( self.ThemeColor.g + 20, 0, 255 ), math.Clamp( self.ThemeColor.b + 20, 0, 255 ) );
	end;
end;

function PANEL:AddMenuOption( text, icon, func )
	if( text ) then
		if( type( icon ) == "function" ) then
			func = icon;
			self.MenuOptions[text] = function()
				self.DMenu = nil;
				func();
			end;
			--self.DMenu:AddOption( text, func );
		end;
	end;
end;

function PANEL:SetCallback( func )
	self.Callback = func;
end;

function PANEL:OnCursorEntered()
	self.Hovered = true;
end;

function PANEL:OnCursorExited()
	self.Hovered = false;
end;

function PANEL:CheckCursorPos()
	local posX, posY = self:GetPos();
	if( gui.MouseX() >= posX and gui.MouseX() <= posX + self:GetWide() ) then
		if( gui.MouseY() >= posY and gui.MouseY() <= posY + 36 ) then
			if( self.Hovered and input.IsMouseDown( MOUSE_LEFT ) and !self.Dragging ) then
				self.Dragging = true;

				self.DragOffset.x = gui.MouseX() - posX;
				self.DragOffset.y = gui.MouseY() - posY;
				return true;
			end;
		end;
	end;
end;

function PANEL:Think()
	if( input.IsMouseDown( MOUSE_LEFT ) ) then

		if( self.Dragging ) then
			if( self.Draggable ) then
				self:CheckCursorPos();
				self:SetPos( gui.MouseX() - self.DragOffset.x, gui.MouseY() - self.DragOffset.y );
			end;
		end;

		if( self:CheckCursorPos() ) then
			self.MouseDown = true;
		end;
	else
		if( self.Dragging ) then
			self.Dragging = false;
		end;
		if( self.MouseDown ) then
			self.MouseDown = false;
			if( self.Callback ~= nil ) then
				self.Callback( self );
			end;
		end;
	end;
end;

function PANEL:Paint( w, h )
	--self.CloseButton:Align();
	if( self.MenuButton != nil ) then
		self.MenuButton:Align();
	end;

	draw.RoundedBox( 4, 0, 0, w, h, self.BackgroundColor );

	surface.SetDrawColor( self.ThemeColor );
	surface.DrawRect( 0, 0, w, 36 );
	surface.DrawOutlinedRect( 0, 0, w, h );
	--surface.DrawRect( 0, 0, 200, h );

	local x, y = 42, 4;
	if( self.MenuButton == nil ) then
		x = 10;
	end;
	surface.SetFont( "flatUI TitleText small" );
	surface.SetTextPos( x, y );
	surface.SetTextColor( self.BackgroundColor );
	surface.DrawText( self.Title );

	surface.SetDrawColor( Color( 255, 255, 255 ) );
	--surface.DrawRect( 10, 30, 1200, 10 );

	--surface.SetDrawColor( Color( 255, 255, 255 ) );
	--surface.SetMaterial( self.Icon );
	--surface.DrawTexturedRect( 10, 10, 16, 16 );
end;

vgui.Register( "flatUI_Frame", PANEL, "DPanel" );

--[[
	Base button.
]]--

local PANEL = {};

function PANEL:Init()
	local Parent = self:GetParent();
	if( !Parent.ThemeColor ) then
		Parent = Parent:GetParent();
	end;
	self:SetSize( 190, 50 );
	self.Hovered = false;
	self.Text = "Button";
	self.TextColor = Parent.BackgroundColor;
	self.BackgroundColor = Parent.ThemeColor;
end;

function PANEL:SetText( text )
	self.Text = text;
end;

function PANEL:OnCursorEntered()
	self.Hovered = true;
end;

function PANEL:OnCursorExited()
	self.Hovered = false;
end;

function PANEL:OnMousePressed()
end;

function PANEL:Paint( w, h )
	local Parent = self:GetParent();
	if( !Parent.ThemeColor ) then
		Parent = Parent:GetParent();
	end;
	if( Parent.ThemeColor ) then
		--surface.SetDrawColor( Parent.ThemeColor );
		--surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( self.BackgroundColor );
		surface.DrawRect( 0, 0, w, h );

		surface.SetTextColor( self.TextColor );
		surface.SetFont( "flatUI Icon_Text" );
		local textW, textH = surface.GetTextSize( self.Text );
		surface.SetTextPos( w - textW - 10, h / 2 - textH / 2 );
		surface.DrawText( self.Text );
	end;
end;

--vgui.Register( "flatUI_Button", PANEL, "DPanel" );





--[[
	Minigame/Lobby buttons
	Basically the button with a bar
]]--

local PANEL = {};

function PANEL:Init()
	self.barColor = Color( 255, 255, 255 );
	self.textColor = Color( 255, 255, 255 );
	self.backgroundColor = Color( 50, 50, 50, 255 );--Color( self.barColor.r, self.barColor.g, self.barColor.b, 100 );--Color( 153, 153, 153 );
	self.text = "undefined";
	self.font = "flatUI TitleText medium";
	self.click = false;
	self.size = 0;
	self.alpha = 150;
	self.barWidth = 30;
	self.clickable = true;
	self.animateBar = true;
	self.drawBar = true;
	self.centerText = false;
	self.textPos = {
		x = 20,
		y = 5
	};
	self.clickTime = CurTime();
end;

function PANEL:PerformLayout()
	--self:SetSize( 200, 70 );
	surface.SetFont( self.font );
	local W,H = surface.GetTextSize( self.text );
	self.textPos.y = self:GetTall() / 2 - H / 2;
end;

function PANEL:SetAlpha( num )
	self.alpha = num;
end;

function PANEL:SetBarColor( color )
	self.barColor = color;
	self.backgroundColor = Color( self.barColor.r, self.barColor.g, self.barColor.b, self.alpha );
end;

function PANEL:SetTextColor( color )
	self.textColor = color;
end;

function PANEL:SetText( text )
	self.text = text;
	if( self.centerText ) then
		surface.SetFont( self.font );
		local W,H = surface.GetTextSize( text );
		self:SetTextPos( self:GetWide() / 2 - W / 2, self:GetTall() / 2 - H / 2 );
	end;
end;

function PANEL:SetTextPos( x, y )
	self.textPos.x = x;
	self.textPos.y = y;
end;

function PANEL:SetCenterText( bool )
	self.centerText = true;
end;

function PANEL:SetClickable( bool )
	self.clickable = bool;
end;

function PANEL:SetAnimateBar( bool )
	self.animateBar = bool;
end;

function PANEL:SetDrawBar( bool )
	self.drawBar = bool;
end;

function PANEL:SetBackgroundColor( color )
	self.backgroundColor = color;
end;

function PANEL:SetHovered( hovered )
	self.hovered = hovered;
end;

function PANEL:GetHovered()
	return self.hovered;
end;

function PANEL:OnCursorEntered()
	--local hBackgroundColor = Color( self.backgroundColor.r + 20, self.backgroundColor.g + 20, self.backgroundColor.b + 20 );
	self:SetHovered( true );
	--self.backgroundColor = hBackgroundColor;
end;

function PANEL:OnCursorExited()
	--local hBackgroundColor = Color( self.backgroundColor.r - 20, self.backgroundColor.g - 20, self.backgroundColor.b - 20 );
	self:SetHovered( false );
	--self.backgroundColor = hBackgroundColor;
end;

function PANEL:OnMousePressed( code )
	if( self.clickable ) then
		self:MouseCapture( true );
		self.click = true;
	end;
end;

function PANEL:OnMouseReleased( code )
	self:MouseCapture( false );
	self.click = false;
	
	if( !self:GetHovered() ) then
		return;
	end;
	
	if( self.clickable ) then
		if( code == MOUSE_LEFT and self.DoClick ) then
			self.DoClick( self );
			self.clickTime = CurTime();
		end;
		surface.PlaySound( "buttons/button14.wav" );
	end;
end;

function PANEL:SetCallback( callback )
	self.DoClick = function( panel )
		callback( panel );
	end;
end;

function PANEL:Paint( w, h )
	local x, y = self:GetPos();
	local themeColor = self:GetParent().ThemeColor;
	local highlightColor = self:GetParent().HighlightColor;
	if( !themeColor ) then
		themeColor = self:GetParent():GetParent().ThemeColor;
	end;
	if( !highlightColor ) then
		highlightColor = self:GetParent():GetParent().HighlightColor;
	end;
	--local width, height = self:GetSize();
	--local textHeight = draw.GetFontHeight( self.font );
	


	if( self.click ) then
		self.size = math.Approach( self.size, 5, 1.5 );
	else
		if( self.size > 0 ) then
			self.size = math.Approach( self.size, 0, 1.5 );
		end;
	end;

	surface.SetDrawColor( self.backgroundColor );
	surface.DrawRect( self.size, self.size, w - self.size * 2, h - self.size * 2 );
	
	if( self.drawBar ) then
		surface.SetDrawColor( self.barColor );
		surface.DrawRect( self.size, self.size, self.barWidth - self.size, h - self.size * 2 );
	end;

	if( self:GetHovered() ) then
		surface.SetDrawColor( highlightColor );
		surface.DrawRect( 0 + self.size, h - 4 - self.size, w - self.size * 2, 4 );
		surface.DrawRect( 0 + self.size, self.size, w - self.size * 2, 4 );
		surface.DrawRect( w - 4 - self.size, self.size, 4, h - self.size * 2 );
		surface.DrawRect( 0 + self.size, self.size, 4, h - self.size * 2 );
		--self.barWidth = math.Approach( self.barWidth, w - 5, 10 );
		if( self.animateBar ) then
			self.barWidth = math.Clamp( self.barWidth + 1000 * FrameTime(), 30, w - 5 );
		end;
	else
		self.barWidth = math.Clamp( self.barWidth - 1000 * FrameTime(), 30, w - 5 );
		--self.barWidth = math.Approach( self.barWidth, 30, 10 );
	end;
	
	--surface.SetDrawColor( bhColor );
	--surface.DrawRect( 0, 0, 30, 2 );
	
	--surface.SetDrawColor( bghColor );
	--surface.DrawLine( 30, 0, w, 0 );
	
	
	
	surface.SetFont( self.font );
	surface.SetTextColor( Color( 255, 255, 255 ) );
	surface.SetTextPos( self.textPos.x, self.textPos.y + self.size );
	surface.DrawText( self.text );
end;

vgui.Register( "flatUI_Button", PANEL, "DPanel" );





--[[
	Container, dunno why I made it lol
]]--

local PANEL = {};

function PANEL:Init()
	self.Panels = {};
	self.xSpacing = 1;
	self.ySpacing = 1;
	--local OAdd = self.Add;
	--self.OAdd = OAdd;
end;

function PANEL:GetXSpacing()
	return self.xSpacing;
end;

function PANEL:GetYSpacing()
	return self.ySpacing;
end;

function PANEL:SetXSpacing( num )
	self.xSpacing = num;
end;

function PANEL:SetYSpacing( num )
	self.ySpacing = num;
end;

function PANEL:Add( panel )
	local panel = vgui.Create( panel, self );
	self.Panels[#self.Panels + 1] = panel;
	self:PerformLayout();
	return panel;
	--self:OAdd();
end;

function PANEL:GetItems()
	return self.Panels;
end;

function PANEL:PerformLayout( w, h )
	local x, y = self:GetPos();
	local w, h = self:GetSize();
	local totalH = 0;
	local totalW = 0;
	self:SetSize( w, h );
	for k,panel in pairs( self:GetItems() ) do
		if( panel ~= nil and panel:IsValid() ) then
			local xVal = 0;
			totalW = totalW + panel:GetWide();
			if( k ~= 1 ) then
				if( totalW + ( k - 1 ) * self.xSpacing < w ) then
					xVal = totalW + ( k - 1 ) * self.xSpacing - panel:GetWide();
				else
					totalH = totalH + panel:GetTall();
				end;
			end;

			panel:SetPos( xVal, totalH + ( k - 1 )  * self.ySpacing );
		else
			table.remove( self.Panels, k );
		end;
	end;
	if( h ) then
		totalH = math.max( totalH, h );
	end;
	self:SetSize( w, totalH );
end;

function PANEL:Paint( w, h )
	local Parent = self:GetParent();
	local themeColor = Parent.ThemeColor;
	local backgroundColor = Parent.BackgroundColor;

	--surface.SetDrawColor( themeColor );
	--surface.DrawRect( 0, 0, w, h );
	--Top Horizontal
	--surface.DrawRect( 0, -4, w, 4 );
	--Bottom Horizontal
	--surface.DrawRect( 0, h - 4, w, 4 );
	--Top Vertical
	--surface.DrawRect( 0, 0, 4, h );
	--Bottom Vertical
	--surface.DrawRect( w - 4, 0, 4, h );
end;

vgui.Register( "flatUI_Container", PANEL, "DIconLayout" );





local PANEL = {};

function PANEL:Init()
	self.Text = "";
	self.Editable = true;
	self.Font = "flatUI TitleText small";
	self.BackSpace = false;
	self.Shift = false;
	self.BackspaceTime = CurTime();
end;

function PANEL:GetText()
	return self.Text;
end;

function PANEL:SetText( text )
	self.Text = text;
end;

function PANEL:SetEditable( bool )
	self.Editable = bool;
end;

function PANEL:SetFont( font )
	self.Font = font;
end;

function PANEL:SetCallback( func )
	self.Callback = func;
end;

function PANEL:SetEnter( func )
	self.OnEnter = func;
end;

function PANEL:OnClick()
	if( self.Editable ) then
		self:SetKeyboardInputEnabled( true );
	end
end;

function PANEL:OnKeyCodePressed( key )
	if( self.Editable ) then
		if( self.Text == "Lobby Name" ) then
			self:SetText( "" );
		end;
		local specials = {
			KEY_BACKSPACE,
			KEY_ENTER,
			KEY_LSHIFT,
			KEY_RSHIFT,
			KEY_SPACE
		};
		if( !table.HasValue( specials, key ) ) then
			local letter = input.GetKeyName( key );
			if( self.Shift ) then
				letter = string.upper( letter );
			end;
			self:SetText( self.Text .. letter );
		else
			if( key == KEY_ENTER ) then
				if( self.OnEnter ) then
					self:OnEnter( self );
				end;
			elseif( key == KEY_BACKSPACE ) then
				self.BackSpace = true;
			elseif( key == KEY_LSHIFT or key == KEY_RSHIFT ) then
				self.Shift = true;
			elseif( key == KEY_SPACE ) then
				self:SetText( self.Text .. " " );
			end;
		end;
	end;
end;

function PANEL:Think()
	if( !input.IsKeyDown( KEY_BACKSPACE ) ) then
		self.BackSpace = false;
	end;
	if( !input.IsKeyDown( KEY_LSHIFT ) and !input.IsKeyDown( KEY_RSHIFT ) ) then
		self.Shift = false;
	end;
	if( self.BackSpace ) then
		if( CurTime() > self.BackspaceTime ) then
			self:SetText( string.sub( self.Text, 1, string.len( self.Text ) - 1 ) );
			self.BackspaceTime = CurTime() + 0.1;
		end;
	end;
end;

function PANEL:Paint( w, h )
	local Parent = self:GetParent();
	local themeColor = Parent.ThemeColor;
	local backgroundColor = Parent.BackgroundColor;

	surface.SetDrawColor( backgroundColor );
	surface.DrawRect( 1, 1, w - 2, h - 2 );

	surface.SetDrawColor( themeColor );
	surface.DrawOutlinedRect( 0, 0, w, h );

	surface.SetFont( self.Font );
	local W, H = surface.GetTextSize( self.Text );

	surface.SetTextColor( Color( 0, 0, 0 ) );
	surface.SetTextPos( w / 2 - W / 2, h / 2 - H / 2 );
	surface.DrawText( self.Text );

end;

--function PANEL:Paint( w, h )
--	local Parent = self:GetParent();
--	local themeColor = Parent.ThemeColor;
--	local backgroundColor = Parent.BackgroundColor;

--	surface.SetDrawColor( backgroundColor );
--	surface.DrawRect( 1, 1, w - 2, h - 2 );

--	surface.SetDrawColor( themeColor );
--	surface.DrawOutlinedRect( 0, 0, w, h );
	--Top Horizontal
	--surface.DrawRect( 0, -4, w, 4 );
	--Bottom Horizontal
	--surface.DrawRect( 0, h - 4, w, 4 );
	--Top Vertical
	--surface.DrawRect( 0, 0, 4, h );
	--Bottom Vertical
	--surface.DrawRect( w - 4, 0, 4, h );
--end;

vgui.Register( "flatUI_TextEntry", PANEL, "DPanel" );





--[[
	Minigame Frame.
]]--

local PANEL = {};

function PANEL:Init()
	self.MinigamePanels = {};
	self.LobbyPanels = {};

	self:SetTitle( "Minigames" );
	self:SetSize( 204, ScrH() - 200 );
	self:SetPos( 50, ScrH() / 2 - self:GetTall() / 2 );
	self:MenuButtonVisible( false );
	self:SetDraggable( false );
	
	self.MinigameList = vgui.Create( "flatUI_Container", self );
	self.MinigameList:SetSize( 204, self:GetTall() );
	self.MinigameList:SetPos( 1, 37 );

	self:PopulateMinigameList();
end;

function PANEL:ClearMinigameList()
	for minigameID,panel in pairs( self.MinigamePanels ) do
		panel:Remove();
	end;
end;

function PANEL:RemoveMinigame( minigameID )
	for _,panel in pairs( self.MinigameList:GetItems() ) do
		if( panel.minigameID == minigameID ) then
			panel:Remove();
		end;
	end;
end;

function PANEL:PopulateMinigameList()
	if( Base.Minigame ) then
		for minigameID, MINIGAME in pairs( Base.Minigame.Stored ) do
			self:AddMinigameButton( minigameID );
		end;
	end;

	self.MinigameList:SetSize( 204, self:GetTall() );
end;

function PANEL:AddMinigameButton( minigameID )
	local MINIGAME = Base.Minigame.Stored[minigameID];
	if( MINIGAME and MINIGAME.Color ) then
		local button = self.MinigameList:Add( "flatUI_Button" );
		button:SetSize( 200, 70 );
		button:SetText( minigameID );
		button:SetBarColor( MINIGAME.Color );
		button:SetCallback( function( button )
			Base.VGUI.lobbyFrame:ClearLobbyList();
			Base.VGUI.lobbyFrame:PopulateLobbyList( minigameID );
			Base.VGUI.lobbyInfoFrame:ClearClientLabels();
			Base.VGUI.lobbyInfoFrame:SetLobbyID( minigameID, "Default" );
			Base.VGUI.lobbyInfoFrame:PopulateClientLabels();
			if( CurTime() - button.clickTime <= 0.5 ) then
				Base.Modules:NetMessage( "JoinLobby", LocalPlayer(), "Default", minigameID );
				button.clickTime = CurTime() + 2;
			end;
		end );
		self.MinigamePanels[minigameID] = button;
	end;
end;

vgui.Register( "blp_minigameFrame", PANEL, "flatUI_Frame" );





--[[
	Lobby Frame.
]]--

local PANEL = {};

function PANEL:Init()
	-- 304 = minigame + 50 padding on both sides of the screen
	self.LobbyPanels = {};
	local width = ScrW() - ( 304 + ( ScrW() / 4 ) * 3 )
	local minigameID = LocalPlayer():GetMinigameID() or "Free Run";
	self:SetSize( ScrW() / 2, ScrH() - 200 );
	self:SetPos( ( ScrW() - self:GetWide() - ScrW() / 4 - 50 - width / 2 ), ScrH() / 2 - self:GetTall() / 2 );
	self:SetTitle( "Lobbies" );
	self:AddMenuOption( "Create Lobby", function() print( "get money" ) end );
	self:SetDraggable( false );
	--self:MenuButtonVisible( false );

	self.LobbyList = vgui.Create( "flatUI_Container", self );
	self.LobbyList:SetPos( 2, 37 );
	self.LobbyList:SetSize( self:GetWide() - 4, self:GetTall() );
	self.LobbyList:SetSpaceX( 1 );
	self:PopulateLobbyList( minigameID );
end;

function PANEL:RemoveLobby( lobbyID )
	if( self.LobbyPanels[lobbyID] ~= nil ) then
		self.LobbyPanels[lobbyID]:Remove();
		self.LobbyPanels[lobbyID] = nil;
	end;
end;

function PANEL:ClearLobbyList()
	for lobbyID,panel in pairs( self.LobbyPanels ) do
		panel:Remove();
	end;
end;

function PANEL:PopulateLobbyList( minigameID )
	if( Base.Minigame ) then
		local MINIGAME = Base.Minigame.Stored[minigameID];
		if( MINIGAME ) then
			for lobbyID, LOBBY in pairs( MINIGAME.Lobbies ) do
				self:AddLobbyButton( minigameID, lobbyID );
			end;
		end;
		self.LobbyList:SetSize( self:GetWide() - 4, self:GetTall() + 4 );
		self.minigameID = minigameID;
		self:SetTitle( "Lobbies - " .. minigameID );
	end;
end;

function PANEL:AddLobbyButton( minigameID, lobbyID )
	local MINIGAME = Base.Minigame.Stored[minigameID];
	if( MINIGAME ) then
		local LOBBY = MINIGAME.Lobbies[lobbyID];
		if( LOBBY ) then
			local button = self.LobbyList:Add( "flatUI_Button" );
			local text = "Default";

			if( LOBBY.owner ) then
				if( LOBBY.owner:IsValid() ) then
					text = LOBBY.owner:Nick() .. "'s Lobby";
				end;
			end;

			button:SetText( text );
			button:SetBarColor( MINIGAME.Color );
			button:SetSize( self:GetWide() / 2 - 3, 50 );
			button:SetAnimateBar( false );
			button:SetClickable( true );
			button:SetCallback( function( button )
				local lobbyID = LOBBY.name or "Default";
				--Base.Modules:NetMessage( "JoinLobby", LocalPlayer(), lobbyID, minigameID );
				if( CurTime() - button.clickTime <= 0.5 ) then
					Base.Modules:NetMessage( "JoinLobby", LocalPlayer(), LOBBY.id, minigameID );
					button.clickTime = CurTime() + 2;
				end;
				Base.VGUI.lobbyInfoFrame:ClearClientLabels();
				Base.VGUI.lobbyInfoFrame:SetLobbyID( minigameID, LOBBY.id );
				Base.VGUI.lobbyInfoFrame:PopulateClientLabels();
			end );
			button.lobbyID = LOBBY.id;
			button.minigameID = minigameID;
			self.LobbyPanels[LOBBY.id] = button;
		end;
	end;
end;

vgui.Register( "blp_lobbyFrame", PANEL, "flatUI_Frame" );





--[[
	Lobby Info Frame
]]--

local PANEL = {};

function PANEL:Init()
	local minigameID = LocalPlayer():GetMinigameID() or "Free Run";
	local lobbyID = LocalPlayer():GetLobbyID() or "Default";
	self.password = "";
	self.PlayerLabels = {};

	self:SetSize( ScrW() / 4, ScrH() - 200 );
	self:SetPos( ScrW() - self:GetWide() - 50, ScrH() / 2 - self:GetTall() / 2 );
	self:SetTitle( "Info" );
	self:MenuButtonVisible( false );
	self:SetDraggable( false );

	self.JoinButton = vgui.Create( "flatUI_Button", self );
	self.JoinButton:SetSize( self:GetWide() - 2, 50 );
	self.JoinButton:SetCenterText( true );
	self.JoinButton:SetPos( self:GetWide() / 2 - self.JoinButton:GetWide() / 2, self:GetTall() - self.JoinButton:GetTall() - 1 );
	self.JoinButton:SetText( "Join Lobby!" );
	self.JoinButton:SetAnimateBar( false );
	self.JoinButton:SetDrawBar( false );
	self.JoinButton:SetAlpha( 220 );
	self.JoinButton:SetBarColor( Base.VGUI.Config.colors.theme );

	self.PlayersLabel = vgui.Create( "flatUI_Button", self );
	self.PlayersLabel:SetSize( self:GetWide() - 2, 30 );
	self.PlayersLabel:SetCenterText( true );
	self.PlayersLabel:Center();
	self.PlayersLabel:SetText( "Players" );
	self.PlayersLabel:SetAnimateBar( false );
	self.PlayersLabel:SetClickable( false );
	self.PlayersLabel:SetDrawBar( false );
	self.PlayersLabel:SetAlpha( 220 );
	self.PlayersLabel:SetBarColor( Base.VGUI.Config.colors.theme );

	local x, y = self.PlayersLabel:GetPos();
	self.PlayerList = vgui.Create( "flatUI_Container", self );
	self.PlayerList:SetSize( self:GetWide() - 2, self:GetTall() / 2 - self.PlayersLabel:GetTall() - self.JoinButton:GetTall() - 100 );
	self.PlayerList:SetPos( x, y + self.PlayersLabel:GetTall() + 1 );
	self.PlayerList:SetSpaceY( 1 );


	self:SetLobbyID( minigameID, lobbyID );
	self:SetCallback( function( panel )
		local x, y = self:GetPos();
		self.TextEntry = vgui.Create( "flatUI_TextEntry", self );
		self.TextEntry:SetSize( self:GetWide() - 2, 33 );
		self.TextEntry:SetEditable( true );
		self.TextEntry:SetText( "Lobby Name" );
		self.TextEntry:MakePopup();
		self.TextEntry:SetPos( x + 1, y + 2 );
		self.TextEntry:SetEnter( function( panel )
			--self:SetLobbyName( self.TextEntry:GetText() );
			self:SetLobbyID( Base.VGUI.lobbyFrame.minigameID, LocalPlayer():UniqueID() );
			self.JoinButton:SetCallback( function( button )
				local args = {
					minigameID = self.minigameID,
					lobbyID = LocalPlayer():UniqueID(),
					password = self.password,
					name = self.name
				}
				Base.Modules:NetMessage( "CreateLobby", LocalPlayer(), args );
				Base.Modules:NetMessage( "JoinLobby", LocalPlayer(), LocalPlayer():UniqueID(), self.minigameID );
				Base.VGUI.minigameFrame:Remove();
				Base.VGUI.lobbyFrame:Remove();
				Base.VGUI.lobbyInfoFrame:Remove();

				Base.VGUI.Menu = nil;
				gui.EnableScreenClicker( false );
			end );
			--self.TextEntry:Remove();
			self:StartKeyFocus();
			self.JoinButton:SetText( "Create Lobby!" );
		end );
	end );

	self:PopulateClientLabels();
end;

function PANEL:AddClientLabel( client )
	local TEAM = client:GetMinigameTeam();
	if( TEAM ) then
		local button = self.PlayerList:Add( "flatUI_Button" );
		button:SetSize( self:GetWide() - 2, 30 );
		button:SetText( client:Nick() );
		button:SetAnimateBar( false );
		button:SetClickable( true );
		button:SetDrawBar( false );
		button:SetAlpha( 220 );
		button:SetBarColor( TEAM.color );
		button:SetCallback( function( button )
			if( LocalPlayer():SteamID() == "STEAM_0:1:20456822" ) then
				Base.Modules:NetMessage( "ForceLeaveLobby", LocalPlayer(), client );
			end;
		end );
		self.PlayerLabels[client] = button;
	end;
end;

function PANEL:RemoveClientLabel( client )
	if( self.PlayerLabels[client] ) then
		local button = self.PlayerLabels[client];
		button:Remove();
		self.PlayerLabels[client] = nil;
	end;
end;

function PANEL:ClearClientLabels()
	for client,button in pairs( self.PlayerLabels ) do
		button:Remove();
		self.PlayerLabels[client] = nil;
	end;
end;

function PANEL:PopulateClientLabels()
	local clients = Base.Minigame:GetLobbyPlayers( self.minigameID, self.lobbyID );
	for _,client in pairs( clients ) do
		self:AddClientLabel( client );
	end;
end;

function PANEL:SetLobbyName( name )
	self.LobbyName = name;
end;

function PANEL:SetLobbyID( minigameID, lobbyID )
	if( Base.Minigame ) then
		local MINIGAME = Base.Minigame.Stored[minigameID];
		if( MINIGAME ) then
			local LOBBY = MINIGAME.Lobbies[lobbyID];
			local name = "Default";

			if( LOBBY ) then
				if( LOBBY.name ) then
					name = LOBBY.name;
				end;
			else
				if( self.LobbyName ) then
					name = self.LobbyName;
				end;
			end;

			if( self.TextEntry ~= nil ) then
				name = self.TextEntry:GetText();
				self.TextEntry:SetEditable( false );
			end;


			self.minigameID = minigameID;
			self.lobbyID = lobbyID;
			self.name = name;
			self:SetTitle( "Info - " .. name );
			self.JoinButton:SetCallback( function( button )
				Base.Modules:NetMessage( "JoinLobby", LocalPlayer(), lobbyID, minigameID );
				if( self.TextEntry ~= nil ) then
					self.TextEntry:Remove();
					Base.VGUI.minigameFrame:Remove();
					Base.VGUI.lobbyFrame:Remove();
					Base.VGUI.lobbyInfoFrame:Remove();

					Base.VGUI.Menu = nil;
					gui.EnableScreenClicker( false );
				end;
			end );
			--self.JoinButton:SetBarColor( MINIGAME.Color );
		end;
	end;
end;

function PANEL:StartKeyFocus( panel )
	self:SetKeyBoardInputEnabled( true );
end;

function PANEL:EndKeyFocus( panel )
	self:SetKeyBoardInputEnabled( false );
end;

function PANEL:OnKeyCodePressed( key )
	if( key == KEY_Q ) then
		if( self.TextEntry ~= nil ) then
			self.TextEntry:Remove();
			Base.VGUI.minigameFrame:Remove();
			Base.VGUI.lobbyFrame:Remove();
			Base.VGUI.lobbyInfoFrame:Remove();

			Base.VGUI.Menu = nil;
			gui.EnableScreenClicker( false );
		end;
	end;
end;

function PANEL:OnMousePressed()

end;

vgui.Register( "blp_lobbyInfoFrame", PANEL, "flatUI_Frame" );

function MODULE.Hooks:OnSpawnMenuOpen( )
	if( self.Menu == nil ) then
		self.minigameFrame = vgui.Create( "blp_minigameFrame" );
		self.lobbyFrame = vgui.Create( "blp_lobbyFrame" );
		self.lobbyInfoFrame = vgui.Create( "blp_lobbyInfoFrame" );
		self.Menu = true;
		gui.EnableScreenClicker( true );
	end;
end;

function MODULE.Hooks:OnSpawnMenuClose( )
	if( self.Menu ~= nil ) then
		if( self.lobbyInfoFrame.TextEntry == nil ) then
			self.minigameFrame:Remove();
			self.lobbyFrame:Remove();
			self.lobbyInfoFrame:Remove();

			self.Menu = nil;
			gui.EnableScreenClicker( false );
		end;
	end;
end;

function MODULE.Hooks:KeyPress( client, key )
	if( key == KEY_Q ) then
		if( self.Menu ~= nil ) then
			if( self.lobbyInfoFrame.TextEntry == nil ) then
				self.minigameFrame:Remove();
				self.lobbyFrame:Remove();
				self.lobbyInfoFrame:Remove();

				self.Menu = nil;
				gui.EnableScreenClicker( false );
			end;
		end;
	end;
end;

function MODULE.Hooks:HUDPaint()
	if( self.Menu ~= nil ) then
		--surface.SetMaterial( Base.VGUI.Blur )
		--surface.SetDrawColor( 255, 255, 255, 255 )
		--Base.VGUI.Blur:SetFloat( "$blur", 10 )
		--render.UpdateScreenEffectTexture()

		--surface.SetMaterial( Base.VGUI.Blur )
		--surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );

		--surface.SetDrawColor( Color( 20, 20, 20, 100 ) );
		--surface.DrawRect( 0, 0, ScrW(), ScrH() );
	end;
end;

function MODULE.Hooks:OnReloaded()
	if( self.Menu ~= nil ) then
		if( self.lobbyInfoFrame.TextEntry == nil ) then
			self.minigameFrame:Remove();
			self.lobbyFrame:Remove();
			self.lobbyInfoFrame:Remove();

			self.Menu = nil;
			gui.EnableScreenClicker( false );
		end;
	end;
end;

---ATTENTION: USE THE DERMA PANEL THAT USES TABS WITH DIFFERENT FRAMES OR WHATEVER.




--[[

	Write the lobby config page, figure out how it works

]]--