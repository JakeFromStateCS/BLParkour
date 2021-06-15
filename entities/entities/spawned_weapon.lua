ENT.Base 			= "base_entity"
ENT.Type 			= "anim"
ENT.PrintName			= ""
ENT.Author				= ""
ENT.Contact				= ""
ENT.Purpose				= ""
ENT.Instructions		= ""
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

if( SERVER ) then
	AddCSLuaFile();

	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS);
		self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetSolid(SOLID_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		local phys = self:GetPhysicsObject();

		phys:Wake();
		self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS);
		self.weaponclass = "";
	end;

	function ENT:Use(activator, caller)
		if( activator:IsPlayer() ) then
			local itemTable = {};
			itemTable.model = self:GetModel();
			itemTable.class = self:GetClass();
			itemTable.weaponclass = self.weaponclass;
			BW_Inventory.Functions:StoreItem( activator, itemTable );
			self:Remove();
			local class = self.weaponclass;
			print( self.weaponclass );
			print( class );
			activator:Give(class)
			weapon = activator:GetWeapon(class)

			if self.clip1 then
				weapon:SetClip1(self.clip1)
				weapon:SetClip2(self.clip2 or -1)
			end
			if self.ammo then
				activator:SetAmmo(self.ammo, weapon:GetPrimaryAmmoType())
			end;
		end;
	end;
else
	function ENT:Draw()
		self:DrawModel();
	end;
end;
