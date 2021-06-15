AddCSLuaFile()


ENT.Base             = "base_nextbot"
ENT.Spawnable        = true


function ENT:Initialize()
    self:SetModel( "models/police.mdl" );
    self.MaxReach = 60;
end

function ENT:EnemyInRange()
    return self.Enemy:EyePos():Distance( self:EyePos() ) <= self.MaxReach;
end;

function ENT:MeleeAttack( ent, dmg )
    print( "Melee" );
    self.loco:FaceTowards( ent:EyePos() );
    self:StartActivity( Base.Config.AttackAnim );
    coroutine.wait(0.45);
    --coroutine.wait( 0.15 );
    if( self:EnemyInRange() ) then
        print( "Damage" );
        local dmgInfo = DamageInfo();
        dmgInfo:SetDamagePosition( self:GetPos() + Vector( 0, 0, 50 ) );
        dmgInfo:SetDamage( dmg );
        dmgInfo:SetDamageType( DMG_CLUB );
        dmgInfo:SetAttacker( self.Owner );
        ent:TakeDamageInfo( dmgInfo );
        coroutine.wait( 0.5 );
        self:StartActivity( ACT_RUN );
        self.Attack = false;
        self.Enemy = nil;
        self.MoveTo = nil;
        Base.Modules:NetMessage( "ActDone", self.Owner );
        hook.Call( "PlayerAttack", GAMEMODE, self.Owner, ent, dmgInfo );
    end;
end;


function ENT:BehaveAct()
end

function ENT:BehaviorUpdate( tick )
    self.loco:FaceTowards( self.MoveTo );
    local ok, message = coroutine.resume( self.BehaveThread )
    if ( ok == false ) then


        self.BehaveThread = nil
        Msg( self, "error: ", message, "\n" );


    end
end;

function ENT:Stop()
    coroutine.yield();
end;


function ENT:RunBehaviour()
    while ( true ) do
        if( self.Move and self.MoveTo ) then
            self:StartActivity( ACT_RUN )
            self.loco:SetDesiredSpeed( 250 );
            self.Move = nil;
            self:MoveToVec( self.MoveTo, 10 );
            self.MoveTo = nil;
            --self:StartActivity( ACT_IDLE );
        elseif( self.Attack and self.Enemy ) then
            self:MoveToPos( self.Enemy:GetPos(), self.MaxReach - 10 );
            if( self:EnemyInRange() ) then
                self:MeleeAttack( self.Enemy, 100 );
            end;
        else
            self:StartActivity( ACT_IDLE );
        end;
        coroutine.yield()
    end
end


function ENT:MoveToVec( gpos, reach, options )
    print( "Move" )
    local options = options or {}
    local updrate = options.updaterate or 0.3
    
    local pp = gpos;
    local np = self:GetPos()
    local dir = ( np - pp )
    dir:Normalize()
    local pos = pp + dir * reach
    
    local path = Path( "Follow" )
    path:SetMinLookAheadDistance( options.lookahead or 300 )
    path:SetGoalTolerance( options.tolerance or 20 )
    path:Compute( self, pos )
    self.updt = CurTime()

    if ( !path:IsValid() ) then print( "hesaf" ) return "failed" end

--
    while ( path:IsValid() ) do
        if( self.MoveTo or self.Enemy ) then
            if( self.Enemy ) then
                print( "I HAVE AN ENEMY SIR" );
                print( self.Enemy );
                self.MoveTo = self.Enemy:GetPos();
                reach = self.MaxReach - 10;
            end;
            pp = self.MoveTo;
            np = self:GetPos()
            dir = ( pp - np )
            dir:Normalize()
            pos = pp + dir * reach

            if( np:Distance( pp ) > reach * 1.5 ) then
                path:Compute( self, pos );
            elseif( np:Distance( pp ) > reach * 1.1 ) then
                self.loco:SetDesiredSpeed( 100 );
            else
                self.MoveTo = nil;
                self.Move = nil;
                return "ok";
            end;
            --path:Update( self, pos );
            --return "ok";
        end;

        --path:Draw()
        path:Update( self );

        if ( self.loco:IsStuck() ) then
            self:HandleStuck();
            return "stuck"
        end

        if ( options.maxage ) then
            if ( path:GetAge() > options.maxage ) then return "timeout" end
        end

        if ( options.repath ) then
            if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
        end

        coroutine.yield()
    end

    return "ok"
end

function ENT:MoveToPos( pos )
    if( self.Move ) then
        self.NewMove = true;
    end;
    self.MoveTo = pos;
    self.Move = true;
    --self.NewMove = true;
end;

function ENT:AttackEnt( ent )
    if( ent:IsValid() ) then
        self.MoveTo = nil;
        self.Move = false;
        self.Attack = true;
        self.Enemy = ent;
    end;
end;


-- List the NPC as spawnable
list.Set( "NPC", "npc_tf2_ghost",     {    Name = "TF2 Ghost", 
                                        Class = "npc_tf2_ghost",
                                        Category = "TF2"    
                                    })