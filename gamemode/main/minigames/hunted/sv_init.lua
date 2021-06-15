MINIGAME = MINIGAME;
MINIGAME.Name = "Hunted";
MINIGAME.Lobbies = MINIGAME.Lobbies;
MINIGAME.Hooks = MINIGAME.Hooks or {};
MINIGAME.Nets = MINIGAME.Nets or {};
local name = MINIGAME.Name;

function MINIGAME.Hooks:PlayerJoinLobby( client, lobbyID )
	local LOBBY = self.Lobbies[lobbyID];

	if( table.Count( LOBBY.players ) == 1 ) then
		client:SetMinigameTeam( "Hunted" );
	end;
end;

function MINIGAME.Hooks:PlayerLeaveLobby( client, minigameID, lobbyID )
	local clients = Base.Minigame:GetLobbyPlayers( minigameID, lobbyID );

	if( table.Count( clients ) == 1 ) then
		local player = table.Random( clients );
		player:SetMinigameTeam( "Hunted" );
		Base.Notify:Add( clients, player:Name() .. " has become the Hunted!" );
	elseif( client:GetTeamID() == "Hunted" ) then
		local player = table.Random( clients );
		player:SetMinigameTeam( "Hunted" );
		Base.Notify:Add( clients, player:Name() .. " has become the Hunted!" );Base.Notify:Add( clients, ent:Name() .. " has become the Hunted!" );
	end;
end;

function MINIGAME.Hooks:PlayerDeath( client )
	if( client:GetTeamID() == "Hunted" ) then
		local lobbyID = client:GetLobbyID();
		local minigameID = client:GetMinigameID();
		local clients = Base.Minigame:GetTeamPlayers( minigameID, lobbyID, "Hunted" );
		if( #clients == 1 ) then
			clients = Base.Minigame:GetLobbyPlayers( minigameID, lobbyID );
			local player = table.Random( clients );

			client:SetMinigameTeam( "Hunter" );
			player:SetMinigameTeam( "Hunted" );
			Base.Notify:Add( clients, player:Name() .. " has become the Hunted!" );
		end;
	end;
end;

--bwp.cinematics:StartSmallNotice( v, hunted:Nick().. " is now the Hunted!" );
function MINIGAME.Hooks:Think()
	for lobbyID, LOBBY in pairs( self.Lobbies ) do
		local clients = Base.Minigame:GetLobbyPlayers( self.Name, lobbyID );
		if( clients ) then
			for _,client in pairs( clients ) do
				local teamID = client:GetTeamID();
				if( teamID == "Hunted" ) then
					if( client:Alive() ) then
						local entTab = ents.FindInSphere( client:GetPos(), 100 );
						for _,ent in pairs( entTab ) do
							if( ent:IsValid() ) then
								if( ent:IsPlayer() ) then
									if( ent:Alive() ) then
										if( ent:GetTeamID() == "Hunter" ) then
											if( table.HasValue( clients, ent ) ) then
												ent:SetMinigameTeam( "Hunted" );
												client:Kill();
												client:SetMinigameTeam( "Hunter" );
												
												Base.Notify:Add( clients, ent:Name() .. " has become the Hunted!" );
											end;
										end;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
		/*
		for client, clientTab in pairs( LOBBY.players ) do
			if( clientTab.team == "Hunted" ) then
				if( clientTab.client:IsValid() ) then
					local entTab = ents.FindInSphere( clientTab.client:GetPos(), 100 );
					for _,ent in pairs( entTab ) do
						if( ent:IsPlayer() ) then
							if( ent:Alive() ) then
								if( ent ~= clientTab.client ) then
									local teamID = ent:GetTeamID();
									if( teamID == "Hunter" ) then
										ent:SetMinigameTeam( "Hunted" );
										clientTab.client:SetMinigameTeam( "Hunter" );
										clientTab.client:Kill();

										local clients = Base.Minigame:GetLobbyPlayers( self.Name, lobbyID );
										PrintTable( clients );
										if( clients ) then
											Base.Notify:Add( clients, ent:Name() .. " has become the Hunted!" );
										end;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
		*/
	end;
end;