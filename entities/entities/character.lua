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
		self:SetModel( "models/XQM/Rails/gumball_1.mdl" );
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if( phys:IsValid() ) then
			phys:Wake();
		end;
		self.LastCollide = CurTime();
	end;

	function ENT:OnTakeDamage(dmg)
		--self:Remove();
	end;

	function ENT:PhysicsCollide( cData, collider )
		if( self.LastCollide == nil ) then
			self.LastCollide = CurTime();
		end;
		if( self.LastCollide < CurTime() ) then
			local cEntity = cData.HitEntity;
			if( cEntity:GetClass() == self:GetClass() ) then
				local cSpeed = cData.Speed;
				for _,client in pairs( player.GetAll() ) do
					if( client.Character == cEntity ) then
						local sSpeed = self:GetVelocity():Length();
						local speedDiff = sSpeed - cSpeed;
						if( client:Alive() and self.Owner:Alive() ) then
							client:SetHealth( client:Health() - speedDiff / 10 );
							self.Owner:SetHealth( self.Owner:Health() - speedDiff / 10 );
							if( cSpeed > sSpeed ) then
								if( client:Health() > 0 ) then
									local aPercent = client:Health() / 100;
									client.Character:SetModelScale( aPercent, 1.0 );
								else
									client:Kill();
									client:Spawn();
								end;
								local physObj = self:GetPhysicsObject();
								if( physObj:IsValid() ) then
									physObj:SetVelocity( ( self:GetPos() - cEntity:GetPos() ) * physObj:GetMass() );
								end;
								return;
							else
								if( self.Owner:Health() > 0 ) then
									local sPercent = self.Owner:Health() / 100;
									self:SetModelScale( sPercent, 1.0 );
								else
									self.Owner:Kill();
									self.Owner:Spawn();
								end;
								return;
							end;
							self.LastCollide = CurTime() + 0.25;
						end;
					end;
				end;
			end;
		end;
	end;
else
	function ENT:Draw()
		self:DrawModel();
	end;
end;