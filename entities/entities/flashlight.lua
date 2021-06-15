ENT.Base 			= "base_entity"
ENT.Type 			= "anim"
ENT.PrintName			= "Food"
ENT.Author				= ""
ENT.Contact				= ""
ENT.Purpose				= ""
ENT.Instructions		= ""
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

if( SERVER ) then
	AddCSLuaFile();
	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()

		phys:Wake()
		self:SetModel( "models/raviool/flashlight.mdl" );
	end;

	function ENT:OnTakeDamage(dmg)
		--self:Remove();
	end;

	function ENT:Use( activator, caller )
		local itemTable = {};
		itemTable.class = self:GetClass();
		itemTable.model = self:GetModel();
		itemTable.foodmodify = self.foodmodify;
		itemTable.foodvalue = self.foodvalue;
		itemTable.title = self.PrintName;
		print( self.foodmodify );
		BW_Inventory.Functions:StoreItem( activator, itemTable );
		self:Remove();
	end;
else
	function ENT:Draw()
		self:DrawModel();
	end;
end;