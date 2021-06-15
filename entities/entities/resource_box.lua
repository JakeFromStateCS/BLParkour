ENT.Base 			= "base_entity"
ENT.Type 			= "anim"
ENT.PrintName			= "Character"
ENT.Author				= "Blasphemy"
ENT.Contact				= ""
ENT.Purpose				= ""
ENT.Instructions		= ""
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

if( SERVER ) then
	AddCSLuaFile();

	util.AddNetworkString( "resource_box" );

	function ENT:Initialize()
		self:SetModel( "models/Items/item_item_crate.mdl" );
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if( phys:IsValid() ) then
			phys:Wake();
		end;
		self:SetNWInt( "Resources", 1000 );
		self:SetNWInt( "MaxResources", 1000 );
		self:SetUseType( SIMPLE_USE );
		self.BaseFoundation = nil;
		self.LossRate = 0.416;
		self.LastSub = CurTime();
		self.NextToggle = CurTime();
	end;

	function ENT:SetResources( amount )
		self:SetNWInt( "Resources", amount );
		self:SetNWInt( "MaxResources", amount );
	end;

	function ENT:OnTakeDamage(dmg)
		--self:Remove();
	end;

	function ENT:Use( activator, caller )
		net.Start( "resource_box" );
			net.WriteString( "Use" );
			net.WriteEntity( self );
		net.Send( activator );
	end;

	function ENT:Think()
		if( self.BaseFoundation != nil ) then
			if( self:GetNWInt( "Resources" ) > 0 ) then
				if( CurTime() > self.LastSub ) then
					self:SetNWInt( "Resources", self:GetNWInt( "Resources" ) - self.LossRate );
					self.LastSub = CurTime() + 1;
				end;
			end;
		end;
	end;

	function ENT.NetReceive()
		local func = net.ReadString();
		local ent = net.ReadEntity();
		local client = net.ReadEntity();
		ent[func]( ent, client );
	end;
	net.Receive( "resource_box", ENT.NetReceive );

	function ENT.MountToggle( self, client )
		if( CurTime() > self.NextToggle ) then
			if( self.BaseFoundation == nil ) then
				print( "Mounting" );
				self.Mount( self, client );
			else
				print( "Unmounting" );
				self.Unmount( self, client );
			end;
			self.NextToggle = CurTime() + 1;
		end;
	end;

	function ENT.Mount( self, client )
		local trace = {};
		trace.start = self:GetPos();
		trace.endpos = trace.start - self:GetUp() * 5;
		trace.filter = { self };
		trace = util.TraceLine( trace );

		if( trace.Entity:IsValid() ) then
			local ent = trace.Entity;
			if( ent:GetClass() == "base_foundation" ) then
				self:SetPos( ent:GetPos() + ent:GetUp() * 5 );
				self:SetAngles( ent:GetAngles() );
				self.BaseFoundation = ent;
				timer.Simple( 0.1, function()
					self:SetParent( ent );
				end );
				net.Start( "resource_box" );
					net.WriteString( "MountToggle" );
					net.WriteEntity( self );
					net.WriteBit( self.Basefoundation == nil );
				net.Broadcast();
				self:EmitSound( "/buttons/button9.wav" );
			end;
		end;
	end;

	function ENT.Unmount( self, client )
		self:SetParent();
		self:SetPos( self.BaseFoundation:GetPos() + self.BaseFoundation:GetUp() * 5 );
		self:SetAngles( self.BaseFoundation:GetAngles() );
		net.Start( "resource_box" );
			net.WriteString( "MountToggle" );
			net.WriteEntity( self );
			net.WriteBit( self.BaseFoundation == nil );
		net.Broadcast();
		self:EmitSound( "/buttons/button9.wav" );
		self.BaseFoundation = nil;
	end;
	
else

	surface.CreateFont( "Title_Arial_40_Scanlines2", {
		font = "Arial",
		size = 40,
		weight = 400,
		antialias = true,
		scanlines = 2
	} );

	surface.CreateFont( "Title_Arial_35", {
		font = "Arial",
		size = 35,
		weight = 400,
		antialias = true
	} );

	surface.CreateFont( "Title_Arial_35_300", {
		font = "Arial",
		size = 35,
		weight = 300,
		antialias = true
	} );

	surface.CreateFont( "Title_Arial_30_300", {
		font = "Arial",
		size = 30,
		weight = 300,
		antialias = true
	} );

	function ENT:Initialize()
		self.DrawColor = Color( 200, 50, 50, 150 );
		self.Buttons = {};

		self:AddButton( 0, 175, 110, 35, "Mount", Color( 0, 0, 0 ), Color( 255, 50, 50 ), function()
			net.Start( "resource_box" );
				net.WriteString( "MountToggle" );
				net.WriteEntity( self );
				net.WriteEntity( LocalPlayer() );
			net.SendToServer();
		end );

		self.LastClick = CurTime();

		--self:AddButton( 0, 40, 110, 35, "Murder", Color( 0, 0, 0 ), Color( 50, 255, 50 ), function()
		--	local ply = table.Random( player.GetAll() ):Nick()
		--	RunConsoleCommand( "ulx", "slay",  ply );
		--end );

		
	end;

	function ENT.NetReceive()
		local func = net.ReadString();
		local ent = net.ReadEntity();

		if( func == "Use" ) then
			ent:CheckCursor( ent, true );
		end;
		if( func == "MountToggle" ) then
			local status = net.ReadBit();
			local statuses = {
				[1] = { 
					text = "Unmount",
					color = Color( 50, 255, 50 )
				},
				[0] = {
					text = "Mount",
					color = Color( 255, 50, 50 )
				}
			};

			for index,button in pairs( ent.Buttons ) do
				if( string.match( string.lower( button.text ), "mount" ) ) then
					print( status );
					button.text = statuses[status].text;
					button.textColor = statuses[status].color
				end;
			end;
		end;
	end;
	net.Receive( "resource_box", ENT.NetReceive );

	function ENT:AddButton( x, y, w, h, text, color, textColor, clickFunc )
		if( self.Buttons == nil ) then
			self.Buttons = {};
		end;

		local buttonTab = {
			x = x,
			y = y,
			w = w,
			h = h,
			text = text,
			color = color,
			textColor = textColor,
			clickFunc = clickFunc
		};

		table.insert( self.Buttons, buttonTab );
	end;

	function ENT:CheckCursor( ent, clicked )
		if( ent == self ) then
			local offSet = self:GetForward() * 17 + self:GetUp() * 23 + self:GetRight() * 13;
			local worldCursor = self:WorldToLocal( LocalPlayer():GetEyeTrace().HitPos - offSet );
			worldCursor.z = -worldCursor.z
			-- Figure out the offset of the drawing position from the normal position in vector form
			-- So figure out what the vector offset would be for 0,0 of the drawing position
			-- Get the position of my cursor on the entity, use that with the offset to figure out
			-- Where the cursor position is relative to the 0,0 of the drawing
			--worldCursor = worldCursor;
			--worldCursor = worldCursor - newCursor * 10;
			local cursorPos = {
				["x"] = worldCursor.y * 10,
				["y"] = worldCursor.z * 10
			};

			for index,button in pairs( self.Buttons ) do
				if( cursorPos.x > button.x and cursorPos.x < button.x + button.w ) then
					if( cursorPos.y > button.y ) then
						if( cursorPos.y < button.y + button.h ) then
							if( clicked ) then
								if( CurTime() > self.LastClick ) then
									button.clickFunc();
									self.LastClick = CurTime() + 0.1;
								end;
							end;
							return { index = index, button = button };
						end;
					end;
				end;
			end;
		end;
	end;

	function ENT:DrawCursor()
		if( LocalPlayer():GetEyeTrace().Entity == self ) then
			local offSet = self:GetForward() * 17 + self:GetUp() * 23 + self:GetRight() * 13;
			local worldCursor = self:WorldToLocal( LocalPlayer():GetEyeTrace().HitPos - offSet );
			worldCursor.z = -worldCursor.z
			-- Figure out the offset of the drawing position from the normal position in vector form
			-- So figure out what the vector offset would be for 0,0 of the drawing position
			-- Get the position of my cursor on the entity, use that with the offset to figure out
			-- Where the cursor position is relative to the 0,0 of the drawing
			--worldCursor = worldCursor;
			--worldCursor = worldCursor - newCursor * 10;
			local cursorPos = {
				["x"] = worldCursor.y * 10,
				["y"] = worldCursor.z * 10
			};

			surface.SetDrawColor( Color( 255, 255, 255 ) );
			surface.DrawRect( cursorPos.x - 5, cursorPos.y - 5, 10, 10 );
		end;
	end;

	function ENT:DrawButtons()
		for index,button in pairs( self.Buttons ) do
			local buttonHover = self:CheckCursor( self, false );
			local buttonColor = button.color;
			if( buttonHover != nil and index == buttonHover.index ) then
				buttonColor = Color( button.color.r + 30, button.color.g + 30, button.color.b + 30 );
			end;
			surface.SetDrawColor( button.textColor );
			surface.DrawOutlinedRect( button.x, button.y, button.w, button.h );
			surface.SetDrawColor( buttonColor );
			surface.DrawRect( button.x + 1, button.y + 1, button.w - 2, button.h - 2 );
			surface.SetFont( "Title_Arial_30_300" );
			local W, H = surface.GetTextSize( button.text );
			draw.SimpleText( button.text, "Title_Arial_30_300", button.x + 5, button.y + 2, button.textColor );
		
		end;
	end;

	function ENT:Draw()
		self:DrawModel();

		local drawAngle = self:GetAngles();
		drawAngle:RotateAroundAxis( self:GetForward(), 90 );
		drawAngle:RotateAroundAxis( self:GetUp(), 90 );
		cam.Start3D2D( self:GetPos() + self:GetForward() * 17 + self:GetUp() * 23 + self:GetRight() * 13, drawAngle, 0.1 );
			surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
			surface.DrawRect( 0, 0, 240, 210 );

			surface.SetFont( "Title_Arial_40_Scanlines2" );
			local W, H = surface.GetTextSize( "Resource Box" );
			draw.SimpleText( "Resource Box", "Title_Arial_40_Scanlines2", 10, 0, Color( 255, 255, 255 ) );
		

			surface.SetDrawColor( Color( 255, 50, 50 ) );
			surface.DrawOutlinedRect( 0, 105 - 25, 240, 50 );
			surface.SetDrawColor( Color( 50, 255, 50 ) );
			surface.DrawRect( 5, 110 - 25, math.Clamp( ( 240 / self:GetNWInt( "MaxResources" ) * self:GetNWInt( "Resources" ) ) - 10, 0, 100000 ), 40 );

			self:DrawButtons();
			self:DrawCursor();	
		cam.End3D2D();
	end;

end;