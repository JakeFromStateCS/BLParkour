ENT.Base = "base_ai";
ENT.Type = "ai";

ENT.PrintName = "Zambie"
ENT.Author = "Blasphemy ( Original code from Nhordal )";
ENT.Contact = "";
ENT.Information		= "";
ENT.Category		= "SNPCs";

ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.AutomaticFrameAdvance = true;

if( SERVER ) then

	AddCSLuaFile();

	local findInBox = ents.FindInBox;
	local findInSphere = ents.FindInSphere;
	local mRandom = math.random;
	local findByClass = ents.FindByClass;

	function ENT:Initialize()
		self.MaxHealth = 100;
		self.Damage = mRandom( 10, 20 );
		self.FriendlyToPlayer = false;
		self.Alerted = false;
		self.Territorial = false;
		self.Chasing = true;
		self.Flinches = true;
		self.Dead = false;
		self.MeleeAttacking = false;
		self.AlertSounds = {
			"zombies/zombie_alert1.wav",
			"zombies/zombie_alert2.wav",
			"zombies/zombie_alert3.wav"
		};
		self.IdleSounds = {
			"zombies/zombie_voice_idle1.wav",
			"zombies/zombie_voice_idle2.wav",
			"zombies/zombie_voice_idle3.wav",
			"zombies/zombie_voice_idle4.wav",
			"zombies/zombie_voice_idle5.wav",
			"zombies/zombie_voice_idle6.wav",
			"zombies/zombie_voice_idle7.wav"
		};
		self.AttackSounds = {
			"zombies/zo_attack1.wav",
			"zombies/zo_attack1.wav",
			"zombies/zombie_hit.wav",
			"zombies/zombie_pound_door.wav"
		};
		self.AttackMissSounds = {
			"zombies/claw_miss1.wav",
			"zombies/claw_miss2.wav",
			"zombies/claw_miss3.wav",
			"zombies/claw_miss4.wav"
		};
		self.HurtSounds = {
			"zombies/zombie_pain.wav",
			"zombies/zombie_pain1.wav",
			"zombies/zombie_pain2.wav",
			"zombies/zombie_pain3.wav",
			"zombies/zombie_pain4.wav",
			"zombies/zombie_pain5.wav",
			"zombies/zombie_pain6.wav"
		};
		self.DieSounds = {
			"zombies/zombie_die.wav",
			"zombies/zombie_die1.wav",
			"zombies/zombie_die2.wav",
			"zombies/zombie_die3.wav"
		};
		self.Models = {
			"models/nmr_zombie/bateman_infected.mdl",
			"models/nmr_zombie/berny.mdl",
			"models/nmr_zombie/casual_02.mdl",
			"models/nmr_zombie/herby.mdl",
			"models/nmr_zombie/jogger.mdl",
			"models/nmr_zombie/maxx.mdl",
			"models/nmr_zombie/molotov_infected.mdl",
			"models/nmr_zombie/officezom.mdl",
			"models/nmr_zombie/toby.mdl",
			"models/nmr_zombie/wally_infected.mdl"
		};
		local model = self.Models[mRandom( 1, table.maxn( self.Models ) )];
		self:SetModel( model );
		self:SetHullType( HULL_MEDIUM );
		self:SetHullSizeNormal();
		self:SetSolid( SOLID_BBOX );
		self:SetMoveType( MOVETYPE_STEP );
		self:CapabilitiesAdd( CAP_MOVE_GROUND );
		self:SetMaxYawSpeed( 5000 );
		self:SetHealth( self.MaxHealth );
		self.Radius = 1000;
	end;

	function ENT:StopIdleSounds()
		--Stop the idling sounds
		for k,v in ipairs( self.IdleSounds ) do
			self:StopSound( v );
		end;
	end;

	function ENT:StopMelee()
		if( self:Health() < 0 ) then
			return;
		end;
		self.MeleeAttacking = false;
		self:SetSchedule( SCHED_CHASE_ENEMY );
	end;

	function ENT:StartMelee()
		local time = SysTime();
		if( self:Health() < 0 ) then
			return;
		end;
		local attackEnts = findInSphere( self:GetPos() + self:GetForward() * 75, 40 );
		local hit = false;
		if( attackEnts != nil ) then
			for _,ent in pairs( attackEnts ) do
				if( ent:IsNPC() || ent:IsPlayer() and ent:Alive() ) then
					ent:TakeDamage( self.Damage, self );
					if( ent:IsPlayer() ) then
						local viewPunch = Angle( mRandom( -1, 1 ) * self.Damage, mRandom( -1, 1 ) * self.Damage, mRandom( -1, 1 ) * self.Damage );
						ent:ViewPunch( viewPunch );
					end;
					hit = true;
					break;
				end;
			end;
		end;

		local emitSound = "";
		if( hit != false ) then
			emitSound = self.AttackSounds[mRandom( 1, #self.AttackSounds )];
		else
			emitSound = self.AttackMissSounds[mRandom( 1, #self.AttackSounds )];
		end;

		self:StopIdleSounds();
		self:EmitSound( emitSound, 70, mRandom( 70, 110 ) );
		timer.Create( "Zombie_Stop_Melee" .. self:EntIndex(), 0.5, 1, function()
			self:StopMelee();
		end );
		if( SysTime() - time >= 0.001 ) then
			MsgC( Color( 50, 255, 255 ), "GM | Slow Function: " .. tostring( self ) .. ":StartMelee - " .. SysTime() - time .. "\n" );
		end;
	end;

	function ENT:FindEnemies()
		local time = SysTime();
		if( self:GetEnemy() == nil or self:GetEnemy():GetPos():Distance( self:GetPos() ) >= self.Radius ) then
			local radius = self.Radius;
			local alertSounds = self.AlertSounds;
			local pos = self:GetPos();
			local right = self:GetRight();
			local forward = self:GetForward();
			local entTable = findInBox( pos + forward * radius - right * radius, pos - forward * radius + right * radius + Vector( 0, 0, radius ) );
			for k,v in pairs( entTable ) do
				if( v:Disposition( self ) == 1 || v:IsPlayer() ) then
					if( v:IsPlayer() ) then
						self:ResetEnemy();
						self:AddEntityRelationship( v, 1, 10 );
						self:SetEnemy( v );
						self:UpdateEnemyMemory( v, v:GetPos() );
						local emitSound = alertSounds[mRandom( 1, #alertSounds )];
						self:EmitSound( emitSound, 70, mRandom( 90, 120 ) );					
						self.Alerted = true;
						return;
					end;
				end;
			end;
		end;
		if( SysTime() - time >= 0.001 ) then
			MsgC( Color( 50, 255, 255 ), "GM | Slow Function: " .. tostring( self ) .. ":FindEnemies - " .. SysTime() - time .. "\n" );
		end;
	end;

	function ENT:ChaseEnemy()
		
	end;

	function ENT:ResetEnemy()
		self:AddRelationship( "player D_NU 10" );
	end;

	function ENT:SelectSchedule()
		if( self:GetEnemy() != nil ) then
			if( self:GetEnemy():GetPos():Distance( self:GetPos() ) > self.Radius ) then
				self:SetSchedule( SCHED_IDLE_WANDER );
			else
				self:UpdateEnemyMemory( self:GetEnemy(), self:GetEnemy():GetPos() );
				self:SetSchedule( SCHED_CHASE_ENEMY );
				self.Chasing = true;
			end;
		else
			self:SetSchedule( SCHED_IDLE_WANDER );
		end;
	end;

	function ENT:Think()
		local time = SysTime();
		local idleSounds = self.IdleSounds;
		if( mRandom( 1, 50 ) == 1 ) then
			self:StopIdleSounds();
			local emitSound = idleSounds[mRandom( 1, table.maxn( idleSounds ) )];
			self:EmitSound( emitSound, 70, 100 );
		end;

		if( self:GetEnemy() != nil ) then
			if( mRandom( 1, 15 ) == 1 ) then
				if( self:GetPos():Distance( self:GetEnemy():GetPos() ) < 70 ) then
					if( self.MeleeAttacking == false ) then
						self:SetSchedule( SCHED_MELEE_ATTACK1 );
						timer.Create( "Zombie_Melee" .. self:EntIndex(), 0.6, 1, function()
							self:StartMelee();
						end );
						self.MeleeAttacking = true;
					end;
				end;
			end;
		else
			if( mRandom( 1, 10 ) == 1 ) then
				self:FindEnemies();
			end;
		end;
		if( SysTime() - time >= 0.001 ) then
			MsgC( Color( 50, 255, 255 ), "GM | Slow Function: " .. tostring( self ) .. ":Think - " .. SysTime() - time .. "\n" );
		end
	end;

	function ENT:Death()
		self:StopIdleSounds();
		if( mRandom( 1, 4 ) == 1 ) then
			local emitSound = self.DieSounds[mRandom( 1, table.maxn( self.DieSounds ) )];
			self:EmitSound( emitSound, 70, mRandom( 90, 110 ) );
		end;

		local ragdoll = ents.Create( "prop_ragdoll" );
		ragdoll:SetModel( self:GetModel() );
		ragdoll:SetPos( self:GetPos() );
		ragdoll:SetAngles( self:GetAngles() );
		ragdoll:Spawn();
		ragdoll:SetSkin( self:GetSkin() );
		ragdoll:SetColor( self:GetColor() );
		ragdoll:SetMaterial( self:GetMaterial() );
		ragdoll:SetCollisionGroup( COLLISION_GROUP_WEAPON );
		ragdoll:Fire( "FadeAndRemove", "", 60 );
		self:Remove();
	end;

	function ENT:OnTakeDamage( dmgInfo )
		local damage = dmgInfo:GetDamage();
		local attacker = dmgInfo:GetAttacker();
		self:SetHealth( self:Health() - damage );
		if( mRandom( 4 ) == 1 ) then
			self:StopIdleSounds();
			local emitSound = self.HurtSounds[mRandom( 1, table.maxn( self.HurtSounds ) )];
			self:EmitSound( emitSound, 70, mRandom( 70, 110 ) );
		end;
		if( attacker:IsPlayer() ) then
			self:AddEntityRelationship( attacker, 1, 10 );
			self:SetEnemy( attacker );
			self:SetSchedule( SCHED_CHASE_ENEMY );
			self.Chasing = true;
		end;
		local blood = ents.Create( "info_particle_system" );
		blood:SetKeyValue( "effect_name", "blood_impact_red_01" );
		blood:SetPos( dmgInfo:GetDamagePosition() );
		blood:Spawn();
		blood:Activate();
		blood:Fire( "Start", "", 0 );
		blood:Fire( "Kill", "", 0.1 );
		if( self:Health() <= 0 and self.Dead == false ) then
			self.Dead = true;
			self:Death();
		end;
	end;

else

	function ENT:Draw()
		self:DrawModel();
	end;

end;