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

	function ENT:Initialize()
		self:SetModel( "models/hunter/plates/plate1x1.mdl" );
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if( phys:IsValid() ) then
			phys:Wake();
		end;
		
	end;

	function ENT:OnTakeDamage(dmg)
		--self:Remove();
	end;
	
else

	function ENT:Initialize()
		self.StatusColor = Color( 200, 50, 50, 150 );
		self.Owner = nil;
		self.Text = {};
		self.Text[1] = {
			color = Color( 255, 255, 255 ),
			text = "Capture Point"
		};
	end;

	function ENT:Think()
		local dist = 20;
		local entTab = ents.FindInBox( self:GetPos() - self:GetForward() * 20 - self:GetRight() * 20 + self:GetUp() * 5, self:GetPos() + self:GetForward() * 20 + self:GetRight() * 20 + self:GetUp() * 5 );
		for _,ent in pairs( entTab ) do
			if( ent:GetClass() == "resource_box" ) then
				self.StatusColor = Color( 50, 200, 50, 150 );
				return;
			end;
		end;
		self.StatusColor = Color( 200, 50, 50, 150 );
	end;

	function ENT:Draw()
		self:DrawModel();

		cam.Start3D2D( self:GetPos(), self:GetAngles(), 0.1 );
			surface.SetDrawColor( self.StatusColor );
			surface.DrawRect( -500, -500, 1000, 1000 );
		cam.End3D2D();

		cam.Start3D2D( self:GetPos() + self:GetUp() * 2, self:GetAngles(), 0.1 );
			surface.SetDrawColor( Color( 50, 50, 50, 150 ) );
			surface.DrawRect( -250, -50, 500, 100 );
		cam.End3D2D();
	end;
end;