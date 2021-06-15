MODULE = MODULE or {};
MODULE.Name = "Walljump";
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.HookTypes = {};
MODULE.Phys = {
	rebound = 320,
	upward = 100,
	ang = 60,
	dist = 40
};
MODULE.WalljumpDelay = 0.1;

function MODULE:OnLoad()

end;

if( SERVER ) then

	function MODULE:MoveKeysDown( client )
		local moveKeys = {
			IN_MOVERIGHT,
			IN_MOVELEFT,
			IN_FORWARD,
			IN_BACK,
			--IN_JUMP
		};

		local keys = {};
		for k,v in pairs( moveKeys ) do
			if( client:KeyDown( v ) ) then
				table.insert( keys, v );
			end;
		end;
		return keys;
	end;

	function MODULE:TraceLine( client, dir )
		local trace = {};
		trace.start = client:GetPos();
		trace.endpos = client:GetPos() + ( dir * self.Phys.dist );
		trace.filter = client;
		trace = util.TraceLine( trace );

		return trace;
	end;

	function MODULE:HandleVelocity( client, dir )
		local phys = {
			rebound = self.Phys.rebound,
			upward = self.Phys.upward,
		};
		local MINIGAME = client:GetMinigame();
		local lobbyID = client:GetLobbyID();
		local team = client:GetMinigameTeam();
		if( MINIGAME ) then
			if( MINIGAME.Phys ) then
				for var, val in pairs( MINIGAME.Phys ) do
					if( phys[var] and val ~= phys[var] ) then
						phys[var] = val;
					end;
				end;
			end;
		end;

		local vel = client:GetVelocity() - dir * phys.rebound;
		vel.z = client:GetVelocity().z +phys.upward;

		client:SetVelocity( -client:GetVelocity() + vel );
		self:WallJumpSound( client );
	end;

	function MODULE:WallJumpSound( client )
		client:EmitSound("/physics/concrete/rock_impact_hard" .. math.random(1, 6) .. ".wav", math.Rand(90, 110), math.Rand(60, 80))--EmitSound( "npc/footsteps/hardboot_generic"..math.random(1, 6)..".wav" );
	end;

	function MODULE:HandleWallJump( client, key )
		local keys = {
			[IN_MOVERIGHT] = -client:GetRight(),
			[IN_MOVELEFT] = client:GetRight(),
			--[IN_FORWARD] = -client:GetForward(),
			--[IN_BACK] = client:GetForward(),
			[IN_JUMP] = -client:GetUp()
		};

		if( keys[key] ) then

			if( client:KeyDown( IN_MOVERIGHT ) ) then
				local trace = self:TraceLine( client, keys[IN_MOVERIGHT] );

				if( trace.Fraction < 1 ) then

					--if( trace.HitTexture ~= "METAL/METALFENCE003A" ) then
						self:HandleVelocity( client, keys[IN_MOVERIGHT] );
					--end;
				elseif( trace.Entity ) then
					if( trace.Entity:IsPlayer() ) then
						self:HandleVelocity( client, keys[IN_MOVERIGHT] );
						trace.Entity:SetVelocity( -keys[IN_MOVERIGHT] );
					end;
				end;
			end;

			if( client:KeyDown( IN_MOVELEFT ) ) then
				local trace = self:TraceLine( client, keys[IN_MOVELEFT] );

				if( trace.Fraction < 1 ) then

					--if( trace.HitTexture ~= "METAL/METALFENCE003A" ) then
						self:HandleVelocity( client, keys[IN_MOVELEFT] );
					--end;
				end;
			end;

			if( client:KeyDown( IN_FORWARD ) ) then
				local trace = self:TraceLine( client, -client:GetForward() );

				if( trace.Fraction < 1 ) then

					--if( trace.HitTexture ~= "METAL/METALFENCE003A" ) then
						self:HandleVelocity( client, -client:GetForward() );
					--end;
				end;
			end;

			if( client:KeyDown( IN_BACK ) ) then
				local trace = self:TraceLine( client, client:GetForward() );

				if( trace.Fraction < 1 ) then

					--if( trace.HitTexture ~= "METAL/METALFENCE003A" ) then
						self:HandleVelocity( client, client:GetForward() );
					--end;
				end;
			end;
			
			/*
			
			local keysDown = self:MoveKeysDown( client );
			local jumped = false;
			for _,keyDown in pairs( keysDown ) do
				if( keys[keyDown] ) then
					local trace = self:TraceLine( client, keys[keyDown] );
					if( trace.Fraction < 1 ) then
						self:HandleVelocity( client, keys[keyDown] );
						jumped = true;
					elseif( trace.Entity ) then
						if( trace.Entity:IsPlayer() ) then
							trace.Entity:SetVelocity( -keys[keyDown] * self.Phys.rebound );
						end;
					end;
				end;
			end;

			if( key ~= IN_JUMP ) then
				client.WalljumpTimer = CurTime() + self.WalljumpDelay;
				if( jumped ) then
					self:WallJumpSound( client );
				end;
			end;
			*/
		end;
	end;

	function MODULE:HandleRunSpeed( client )
		if( type( client ) == "Player" ) then
			local vel = client:GetVelocity():Length();

			--if( client:WaterLevel() > 0 or client:GetMoveType() == MOVETYPE_LADDER ) then
				--player.lastRunSpeed = Base.Config.RunSpeed;
			if( !client.lastRunSpeed or !client:Alive() ) then
				client.lastRunSpeed = Base.Config.RunSpeed;
			elseif( !client:OnGround() ) then
				if( vel <= 250 ) then
					client.lastRunSpeed = Base.Config.RunSpeed;
				end;
			elseif( !self:MoveKeysDown( client ) ) then
				client.lastRunSpeed = math.Clamp( vel, Base.Config.RunSpeed, Base.Config.RunSpeed );
			end;
			client.lastRunSpeed = math.Approach( client.lastRunSpeed, Base.Config.RunSpeed, 5 );
			client:SetWalkSpeed( client.lastRunSpeed );
			client:SetRunSpeed( client.lastRunSpeed );
		end;
	end;

	function MODULE:HandleWallSlide( client )
		if( type( client ) == "Player" ) then
			if( client:KeyDown( IN_ATTACK2 ) ) then
				local eyeTrace = client:GetEyeTrace();
				if( eyeTrace.HitPos:Distance( client:EyePos() ) <=  self.Phys.dist ) then
					local LOBBY = client:GetLobby();
					local aimVec = client:GetAimVector();
					local vel = client:GetVelocity();
					if( LOBBY ) then
						if( LOBBY.name ) then
							if( LOBBY.name == "GG Scrub" ) then
								aimVec.z = -10;

								client:SetLocalVelocity( client:GetVelocity() - Vector( 0, 0, aimVec.z ) );
								return;
							end;
						end;
					end;
					vel.z = vel.z / 1.2;

					client:SetLocalVelocity( vel );
				end;
			end;
		end;
	end;

	function MODULE.Hooks:KeyPress( client, key )
		if( !client:KeyDown( IN_JUMP ) ) then
			return;
		end;

		if( client.WalljumpTimer ~= nil ) then
			if( client.WalljumpTimer > CurTime() ) then
				return;
			end;
		end;

		local skyTrace = client:GetEyeTrace().HitSky;
		--print( trace.HitPos );
		--if( !trace.Hit ) then
			--return;
		--end;
		--local trace = 
		--if( trace.HitPos:Distance( trace.StartPos ) < self.Phys.dist ) then
			--if( trace.HitTexture ~= "METAL/METALFENCE003A" ) then
				self:HandleWallJump( client, key );
			--end;
		--end;
	end;


	function MODULE.Hooks:GetFallDamage(player, speed)
		local playerHealth = player:Health();
		local punchDirection = math.random(-1, 1);
		local newSpeed = speed - 580;
		local damageAmount = newSpeed * (25/ (1024 - 580));
		local punchAmount = math.Clamp(damageAmount, 1, 120);
		
		player:ViewPunch(Angle(punchAmount * 0.8, punchDirection * punchAmount * 0.3, punchDirection * punchAmount * 0.3));
		
		if (damageAmount >= playerHealth) then
			player:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav");
			player.lastRunSpeed = 10;
		elseif (damageAmount > 55) then
			player:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav");
			player.lastRunSpeed = 10;
		elseif (damageAmount > 20) then
			player:EmitSound("physics/body/body_medium_impact_hard1.wav");
			player.lastRunSpeed = 10;
		else
			player:EmitSound("npc/fast_zombie/foot"..math.random(1, 4)..".wav");
			return false;
		end;
		
		local _lookangle = player:GetUp() - player:GetAimVector()
		local _lookingdown = false
		if (_lookangle.z > 1.7) then _lookingdown = true end
		if (_lookingdown == true and player:KeyDown(IN_DUCK)) then
			umsg.Start("bwp_roll", player);
			umsg.End();
			damageAmount = damageAmount*0.70;
		end;
		
		player:TakeDamage(damageAmount, game.GetWorld(), game.GetWorld());
		return false;
	end;

	function MODULE.Hooks:Think()
		for _, client in pairs( player.GetAll() ) do
			self:HandleRunSpeed( client );
			self:HandleWallSlide( client );
		end;
	end;

else
	MODULE.FootHistory = {};

	function MODULE.Hooks:PlayerFootstep( client, pos, foot, sound, volume, filter )
		if( self.FootHistory[client] == nil ) then
			self.FootHistory[client] = {};
		end;

		local footStep = {
			pos = pos,
			color = HSVToColor( math.cos( CurTime() ) * 359, 1, 1 )
		};

		table.insert( self.FootHistory[client], footStep );

		if( #self.FootHistory[client] >= 10 ) then
			table.remove( self.FootHistory[client], 1 );
		end;
	end;

	function MODULE.Hooks:PostDrawOpaqueRenderables()
		for _,client in pairs( player.GetAll() ) do
			if( self.FootHistory[client] ) then
				for _,footStep in pairs( self.FootHistory[client] ) do
					local ang = client:GetAngles();
					cam.Start3D2D( footStep.pos, Angle( 0, ang.y + 90, 0 ), 1 );
						surface.SetDrawColor( footStep.color );
						surface.DrawRect( 0, 0, 5, 10 );
					cam.End3D2D();
				end;
			end;
		end;
	end;

end;