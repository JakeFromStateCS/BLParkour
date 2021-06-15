ENT.Base 			= "base_entity"
ENT.Type 			= "anim"
ENT.PrintName			= "Pain Killers"
ENT.Author				= ""
ENT.Contact				= ""
ENT.Purpose				= ""
ENT.Instructions		= ""
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

if( SERVER ) then
	AddCSLuaFile();

	function ENT:Initialize()
		self:SetModel( "models/w_models/weapons/w_eq_painpills.mdl" );
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:Activate();
		local phys = self:GetPhysicsObject()
		if( phys:IsValid() ) then
			phys:Wake();
		end;
		self.amount = math.random( 10, 25 );
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
		BW_Inventory.Functions:StoreItem( activator, itemTable );
		self:Remove();
	end;

	function ENT:InvUse(activator,caller)
		local health = activator:Health();
		activator:SetHealth( math.Clamp( health + self.amount, 0, 100 ) );
		self:Remove()
		activator:EmitSound("vox/heal.wav", 100, 100)
	end;
else
	function ENT:Draw()
		self:DrawModel();
	end;
end;