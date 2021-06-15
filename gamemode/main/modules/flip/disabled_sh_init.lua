local MODULE = {};
MODULE.Name = "Flip";
//teeheebadcode
//go ahead and use whatever scrap of this you want
ratchet = {}

if( SERVER ) then
    util.AddNetworkString( "Ratchet_flip" );

    hook.Add("PlayerSpawn", "RatchetJumpSpawn", function( ply )
        ply:SetJumpPower( 250 )
        ply.RatchetJump = nil
    end )

    //Reset the variable if the player is on the ground
    hook.Add("OnPlayerHitGround", "RatchetResetJump", function( ply )
        if IsValid( ply ) && ply:IsOnGround() && ply.RatchetJump then
            ply.RatchetJump = nil
        end
    end )

    hook.Add("KeyPress", "RatchetJump", function( ply, data )
        if !ply:KeyPressed( IN_JUMP ) then return end //We only want jump
        
        //Get their velocity for later use...
        local velocity = Vector( ply:GetVelocity().x,
            ply:GetVelocity().y,
            250 )
        
        if !ply.RatchetJump && ply:IsOnGround() then
            ply.RatchetJump = true
            return
        end
        if ply.RatchetJump && !ply:IsOnGround() then
            --ply:SetVelocity( velocity )
            
            //I feel I'm doing this wrong...
            if ply:KeyDown( IN_MOVELEFT ) then
                print( "hi" );
                DoAnimation( ply, "left" )
                
            elseif ply:KeyDown( IN_MOVERIGHT ) then
                DoAnimation( ply, "right" )
                
            elseif ply:KeyDown( IN_BACK ) then
                DoAnimation( ply, "backward" )
                
            else        
                DoAnimation( ply, "forward" )
                
            end
            ply.RatchetJump = nil
        end

    end )

    function DoAnimation(ply, dir)
    if !IsValid( ply ) then return end
        ply:DoAnimationEvent( ACT_HL2MP_IDLE_CROUCH )

        net.Start( "Ratchet_flip" );
            net.WriteEntity( ply );
            net.WriteString( dir );
        net.Broadcast();

    end

else

    /* Speed of the flip */
    ratchet.Speed = 200

        hook.Add( "CalcView", "RachetCalcView", function( client, pos, ang, fov )
            local view = {};
            view.origin = pos;
            view.angles = ang;
            view.fov = fov;

            if client.RatchetDirection == "forward" then
                    //ply:SetRenderAngles( ply:GetRenderAngles() + Angle( ply.RatchetNum, 0, 0 ) )
                view.angles = Angle( client.RatchetNum, ang.y, ang.r )
                
            elseif client.RatchetDirection == "backward" then
                //ply:SetRenderAngles( ply:GetRenderAngles() + Angle( -ply.RatchetNum, 0, 0 ) )
                view.angles = Angle( -client.RatchetNum, ang.y, ang.r )
                
            elseif client.RatchetDirection == "left" then
                //ply:SetRenderAngles( ply:GetRenderAngles() + Angle( 0, 0, -ply.RatchetNum ) )
                view.angles = Angle( ang.p, ang.y, -client.RatchetNum )
                
            elseif client.RatchetDirection == "right" then
                //ply:SetRenderAngles( ply:GetRenderAngles() + Angle( 0, 0, ply.RatchetNum ) )
                view.angles = Angle( ang.p, ang.y, client.RatchetNum ) 
                
            end

            client.RatchetNum = client.RatchetNum + ratchet.Speed * FrameTime();

            if( client.RatchetNum >= 360 ) then
                client.RatchetNum = 0;
                client.RatchetDirection = nil;
            end;

            if( client.RatchetDirection ) then
              --return view;
            end;

        end );

        hook.Add( "PrePlayerDraw", "RatchetDraw", function( ply )
            //for _, ply in pairs( player.GetAll() ) do
                if !IsValid( ply ) || !ply.RatchetDirection then return end
                    //ratchet.ply:SetAnimation( ACT_CROUCH )
                    //ratchet.ply:DoAnimationEvent( ACT_HL2MP_IDLE_CROUCH )
                    
                /* Change the position of the player so it doesn't look like they are flipping at their feet */
                //print( math.sin( ply.RatchetNum / 115 ) * 50 )
                //ply:SetPos( ply:GetPos() + Vector( 0, 0, 50) )
                local angle = Angle( 0, 0, 0)
                
                
                /* Check what direction we are flipping, and set the angle accordingly */
                if ply.RatchetDirection == "forward" then
                    //ply:SetRenderAngles( ply:GetRenderAngles() + Angle( ply.RatchetNum, 0, 0 ) )
                    angle = ply:GetRenderAngles() + Angle( ply.RatchetNum, 0, 0 )
                    
                elseif ply.RatchetDirection == "backward" then
                    //ply:SetRenderAngles( ply:GetRenderAngles() + Angle( -ply.RatchetNum, 0, 0 ) )
                    angle = ply:GetRenderAngles() + Angle( -ply.RatchetNum, 0, 0 )
                    
                elseif ply.RatchetDirection == "left" then
                    //ply:SetRenderAngles( ply:GetRenderAngles() + Angle( 0, 0, -ply.RatchetNum ) )
                    angle = ply:GetRenderAngles() + Angle( 0, 0, -ply.RatchetNum )
                    
                elseif ply.RatchetDirection == "right" then
                    //ply:SetRenderAngles( ply:GetRenderAngles() + Angle( 0, 0, ply.RatchetNum ) )
                    angle = ply:GetRenderAngles() + Angle( 0, 0, ply.RatchetNum ) 
                    
                end
                
                //Draw player angle
                ply:SetRenderAngles( angle )            
                ply:SetupBones()
                
                //Draw proper weapon angle
                local Weapon = ply:GetActiveWeapon()
                if IsValid( Weapon ) then 
                    Weapon:SetRenderAngles( angle )
                    Weapon:SetupBones() 
                end
                
                /* Continue with the loop */
                ply.RatchetNum = ply.RatchetNum + (ratchet.Speed * FrameTime())
                print( ply:GetName()..": "..tostring(ply.RatchetNum) )
                
                if ply.RatchetNum >= 360 then 
                /* They finished the loop, let's not leave these silly vars on them */
                    ply.RatchetNum = 0
                    ply.RatchetDirection = nil
                    
                    //ply:SetPos( ply:GetPos() + Vector( 0, 0, 0) )
                    //ply:SetRenderOrigin( Vector( 0, 0, 0 ) ) //BACK TO NORMAL
                end
                    
            //end   
            
        end )
        
        
        
        
        net.Receive("Ratchet_flip", function( )
            print( "gg" );
            local ply = net.ReadEntity()
            local dir = net.ReadString()
            
            if IsValid( ply ) then      
                
                ply.RatchetNum = 0
                ply.RatchetDirection = dir
                
                timer.Simple( 360 / ratchet.Speed, function()
                    ply.RatchetDirection = nil;
                end )
                Msg(tostring(ply).." is doing a "..dir.." flip!\n")

            end
            //ply:DoAnimationEvent( ACT_GET_DOWN_CROUCH )
        
        end )
    
end