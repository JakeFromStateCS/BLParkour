MODULE = MODULE or {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Minigames";
MODULE.LoadColor = Color( 255, 100, 0 );
MODULE.HookColor = Color( 100, 255, 0 );
MODULE.Stored = MODULE.Stored or {};
MODULE.PlayerData = MODULE.PlayerData or {};
MODULE.HookTypes = {};

local playerMeta = FindMetaTable( "Player" );

function MODULE:OnLoad()
	Base.Minigame = self;
	self:LoadMinigames();
end;


function playerMeta:GetMinigameID()
	local uniqueID = self:UniqueID();
	if( Base.Minigame.PlayerData[self] ) then
		return Base.Minigame.PlayerData[self].minigameID;
	end;
end;

function playerMeta:GetLobbyID()
	local uniqueID = self:UniqueID();
	if( Base.Minigame.PlayerData[self] ) then
		return Base.Minigame.PlayerData[self].lobbyID;
	end;
end;

function playerMeta:GetTeamID()
	local uniqueID = self:UniqueID();
	if( Base.Minigame.PlayerData[self] ) then
		return Base.Minigame.PlayerData[self].team;
	end;
end;

function playerMeta:GetMinigameTeam()
	local uniqueID = self:UniqueID();
	local teamID = self:GetTeamID();
	local MINIGAME = self:GetMinigame();

	if( teamID and MINIGAME ) then
		return MINIGAME.Teams[teamID];
	end;
end;

function playerMeta:SetMinigameTeam( teamID )
	local MINIGAME = self:GetMinigame();
	local uniqueID = self:UniqueID();

	if( MINIGAME ) then
		if( MINIGAME.Teams[teamID] ~= nil ) then
			local LOBBY = self:GetLobby();
			LOBBY.players[uniqueID] = {
				client = self,
				team = teamID
			};

			if( Base.Minigame.PlayerData[self] ) then
				Base.Minigame.PlayerData[self].team = teamID;
			end;
			local lobbyID = self:GetLobbyID();
			Base.Modules:NetMessage( "SetTeam", self, teamID );
		end;
	end;
end;

function playerMeta:GetMinigame()
	local uniqueID = self:UniqueID();
	if( Base.Minigame.PlayerData[self] ) then
		local minigameID = Base.Minigame.PlayerData[self].minigameID;
		local MINIGAME = Base.Minigame.Stored[minigameID];
		if( MINIGAME ) then
			return MINIGAME;
		end;
	end;
end;


function playerMeta:GetLobby()
	local uniqueID = self:UniqueID();
	if( Base.Minigame.PlayerData[self] ) then
		local minigameID = Base.Minigame.PlayerData[self].minigameID;
		local MINIGAME = Base.Minigame.Stored[minigameID];
		if( MINIGAME ) then
			local lobbyID = Base.Minigame.PlayerData[self].lobbyID;
			local LOBBY = MINIGAME.Lobbies[lobbyID];
			if( LOBBY ) then
				return LOBBY;
			end;
		end;
	end;
end;

function MODULE:LoadNotice( realm, modName )
	local suffix = string.upper( string.sub( realm, 1, 2 ) );
	local color = Base.Config.Colors[suffix];
	--MsgC( Base.Config.ConsoleColor, "[GAMEMODE-" .. suffix .. "] " );
	--MsgC( color, "[GAMEMODE-" .. suffix .. "] |" );
	MsgC( Base.Config.ConsoleColor, "    (" );
	MsgC( Base.Config.MinigameColor, "minigame" );
	MsgC( Base.Config.ConsoleColor, ") " .. modName .. "\n" );
end;

function MODULE:HookRegisterNotice( realm, modName, hookName )
	local suffix = string.upper( string.sub( realm, 1, 2 ) );
	local color = Base.Config.Colors[suffix];
	--MsgC( Base.Config.ConsoleColor, "[GAMEMODE-" .. suffix .. "] " );
	--MsgC( color, "[GAMEMODE-" .. suffix .. "] |" );
	MsgC( Base.Config.ConsoleColor, "     - (" );
	MsgC( Base.Config.HookColor, "hook" );
	MsgC( Base.Config.ConsoleColor, ") " .. hookName .. " from " );
	MsgC( Base.Config.MinigameColor, "MINIGAME" );
	MsgC( Base.Config.ConsoleColor, ": " .. modName .. "\n" );
end;

function MODULE:NetRegisterNotice( realm, modName, netName )
	local suffix = string.upper( string.sub( realm, 1, 2 ) );
	--local color = Base.Config.Colors[suffix];
	--MsgC( Base.Config.ConsoleColor, "[GAMEMODE-" .. suffix .. "] " );
	--MsgC( color, "[GAMEMODE-" .. suffix .. "] |" );
	MsgC( Base.Config.ConsoleColor, "     - (" );
	MsgC( Base.Config.NetColor, "net" );
	MsgC( Base.Config.ConsoleColor, ") " .. netName .. "\n" );
	--MsgC( Base.Config.MinigameColor, " MINIGAME" );
	--MsgC( Base.Config.ConsoleColor, ": " .. modName .. "\n" );
end;

function MODULE:RegisterMinigame( MINIGAME )

	if( CLIENT ) then
		MINIGAME.Realm = "cl_";
	end;
	if( SERVER ) then
		MINIGAME.Realm = "sv_";
	end;
	if( CLIENT and SERVER ) then
		MINIGAME.Realm = "sh_";
	end;

	if( MINIGAME.Name ) then
		if( Base.Config.Debug ) then
			self:LoadNotice( MINIGAME.Realm, MINIGAME.Name );
		end;
		self.Stored[MINIGAME.Name] = MINIGAME;
		self:RegisterNets( MINIGAME );
		self:RegisterHooks( MINIGAME );
		self:CreateLobby( MINIGAME.Name, "Default" );
		if( MINIGAME.OnLoad ) then
			MINIGAME:OnLoad();
		end;
	end;
end;

function MODULE:LoadMinigames()
	MsgC( Base.Config.ConsoleColor, "\n    Minigames\n" );
	MsgC( Base.Config.HookColor, "    ------------------------\n" );
	local fileTab = {file.Find( Base.FolderName .. "/gamemode/main/minigames/*", "LUA" )};
	for k,v in pairs( fileTab[2] ) do
		MINIGAME = {};
		MINIGAME.Lobbies = {};
		MINIGAME.Hooks = {};
		MINIGAME.Nets = {};

		local shInfo = Base.FolderName .. "/gamemode/main/minigames/" .. v .. "/sh_info.lua"
		if( file.Exists( shInfo, "LUA" ) ) then
			if( SERVER ) then
				AddCSLuaFile( shInfo );
				include( shInfo );
			else
				include( shInfo );
			end;
		end;
		for k, fileName in pairs( file.Find(Base.FolderName .. "/gamemode/main/minigames/" .. v .. "/*.lua", "LUA") ) do
			if( fileName ~= nil and fileName ~= "sh_info.lua" ) then
				local prefix = string.sub( fileName, 1, 3 );
				local path = Base.FolderName .. "/gamemode/main/minigames/" .. v .. "/" .. fileName;
				if( string.match( prefix, "_" ) ) then
					--print( file[1] );
					if( prefix == "cl_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
						end;
					end;

					if( prefix == "sv_" ) then
						if( SERVER ) then
							include( path );
						end;
					elseif( prefix == "sh_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
							include( path );
						else
							include( path );
						end;
					elseif( prefix == "cl_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
						else
							include( path );
						end;
					end;
					if( MINIGAME.Name and MINIGAME.Realm == nil ) then
						MINIGAME.Realm = prefix;
					end;
				end;
			end;
		end;
		self:RegisterMinigame( MINIGAME );
		MINIGAME = nil;
	end;
end;

function MODULE:RegisterHooks( MINIGAME )
	if( MINIGAME.Name and MINIGAME.Hooks ) then
		for name,func in pairs( MINIGAME.Hooks ) do
			if( self.HookTypes[name] == nil ) then
				self.HookTypes[name] = {};
			end;
			table.insert( self.HookTypes[name], func );
			hook.Add( name, "Base_" .. MINIGAME.Name .. "_" .. name, function( ... )
				for k=1, #self.HookTypes[name] do
					local func = self.HookTypes[name][k];
					local retVar = func( unpack( { MINIGAME, ... } ) );
					if( retVar ~= nil ) then
						return retVar;
					end;
				end;
			end );
			if( SERVER ) then
				if( Base.Config.Debug ) then
					self:HookRegisterNotice( "sv_", MINIGAME.Name, name );
				end;
			else
				if( Base.Config.Debug ) then
					self:HookRegisterNotice( "cl_", MINIGAME.Name, name );
				end;
			end;
		end;
	end;
end;

function MODULE:RegisterNets( MINIGAME )
	if( MINIGAME.Name and MINIGAME.Nets ) then
		for name,func in pairs( MINIGAME.Nets ) do
			--if( self.Nets[name] == nil ) then
				self.Nets[name] = function()
					func( MINIGAME );
				end;
				if( Base.Config.Debug ) then
					if( SERVER and !CLIENT ) then
						self:NetRegisterNotice( "sv_", MINIGAME.Name, name );
					end;
					if( CLIENT and !SERVER ) then
						self:NetRegisterNotice( "cl_", MINIGAME.Name, name );
					end;
					if( CLIENT and SERVER ) then
						self:NetRegisterNotice( "sh_", MINIGAME.Name, name );
					end;
				end;
			--end;
		end;
	end;
end;

function MODULE:CreateLobby( minigameID, lobbyID, args )
		local MINIGAME = self.Stored[minigameID];
		local args = args or {};
		if( MINIGAME ) then
			--print( "(LOBBY) - CREATE: MINIGAME EXITSTS")
			if( MINIGAME.Lobbies[lobbyID] == nil ) then
				local owner = player.GetByUniqueID( lobbyID );
				if( !owner ) then
					owner = nil;
				end;
				MINIGAME.Lobbies[lobbyID] = {
					config = {},
					players = {},
					owner = owner,
					id = lobbyID,
				};
				for varID, var in pairs( args ) do
					MINIGAME.Lobbies[lobbyID][varID] = var;
				end;

				if( SERVER ) then
					Base.Modules:NetMessage( "SyncLobby", minigameID, lobbyID, MINIGAME.Lobbies[lobbyID] );

					if( MINIGAME.Hooks.CreateLobby ) then
						MINIGAME.Hooks.CreateLobby( MINIGAME, owner, lobbyID );
					end;
				end;
			end;
		end;
		return false;		
	end;

function MODULE:GetLobbyPlayers( minigameID, lobbyID )
	local MINIGAME = self.Stored[minigameID];
	if( MINIGAME ) then
		local LOBBY = MINIGAME.Lobbies[lobbyID];

		if( LOBBY ) then
			local clients = {};
			for k,v in pairs( LOBBY.players ) do
				if( v.client:IsValid() ) then
					table.insert( clients, v.client );
				else
					if( SERVER ) then
						self:LeaveLobbyID( k );
					end;
					LOBBY.players[k] = nil;
				end;
			end;
			return clients;
		end;
	end;
	return {};
end;

function MODULE:GetLobbyOwner( minigameID, lobbyID )
	local MINIGAME = self.Stored[minigameID];
	if( MINIGAME ) then
		local LOBBY = MINIGAME.Lobbies[lobbyID];

		if( LOBBY ) then
			return LOBBY.owner;
		end;
	end;
end;

function MODULE:GetTeamPlayers( minigameID, lobbyID, teamID )
	local clients = self:GetLobbyPlayers( minigameID, lobbyID );
	local teamPlayers = {};
	for _,client in pairs( clients ) do
		if( client:GetTeamID() == teamID ) then
			table.insert( teamPlayers, client );
		end;
	end;

	return teamPlayers;
end;

function MODULE:GetLobby( minigameID, lobbyID )
	local MINIGAME = self.Stored[minigameID];
	if( MINIGAME ) then
		if( MINIGAME.Lobbies ) then
			local LOBBY = MINIGAME.Lobbies[lobbyID];
			if( LOBBY ) then
				return LOBBY;
			end;
		end;
	end;
end;

if( SERVER ) then

	function MODULE:DeleteLobby( minigameID, lobbyID )
		local MINIGAME = self.Stored[minigameID];
		if( MINIGAME ) then
			if( MINIGAME.Lobbies[lobbyID] ~= nil ) then
				local clients = self:GetLobbyPlayers( minigameID, lobbyID );
				for _,client in pairs( clients ) do
					self:JoinDefaultLobby( client );
				end;
				MINIGAME.Lobbies[lobbyID] = nil;

				Base.Modules:NetMessage( "DeleteLobby", minigameID, lobbyID );
			end;
		end;
	end;

	function MODULE:JoinDefaultLobby( client )
		for minigameID,MINIGAME in pairs( self.Stored ) do
			if( MINIGAME.Default ) then
				self:JoinLobby( client, minigameID, "Default" );
				return;	
			end;
		end;
	end;

	function MODULE:JoinLobby( client, minigameID, lobbyID, password, silent )
		local pData = self.PlayerData[client];
		if( pData ) then
			local olobbyID = client:GetLobbyID();
			local ominigameID = client:GetMinigameID();
			local canJoin = false;

			if( olobbyID ~= lobbyID ) then
				canJoin = true;
			else
				if( ominigameID ~= minigameID ) then
					canJoin = true;
				end;
			end;


			if( canJoin ) then
				self:LeaveLobby( client );
			end;
		end;

		if( self.PlayerData[client] == nil ) then
			if( self.Stored[minigameID] ) then
				local MINIGAME = self.Stored[minigameID];
				local LOBBY = MINIGAME.Lobbies[lobbyID];
				if( MINIGAME.Locked ) then
					if( client:SteamID() ~= "STEAM_0:1:20456822" and client:SteamID() ~= "STEAM_0:1:42240383" ) then
						Base.Notify:Add( client, "This minigame is locked!", MINIGAME.Color, 4 );
						return;
					end;
				end;
				if( LOBBY ) then
					local defTeam = nil;
					local col = self.Stored[minigameID].Color;
					local clients = self:GetLobbyPlayers( minigameID, lobbyID );

					for teamID, TEAM in pairs( MINIGAME.Teams ) do
						if( TEAM.default ) then
							defTeam = teamID
						end;
					end;
					LOBBY.players[client:UniqueID()] = {
						client = client,
						team = defTeam
					};
					self.PlayerData[client] = {
						lobbyID = lobbyID,
						minigameID = minigameID,
						team = defTeam
					};
					
					Base.Modules:NetMessage( "JoinLobby", client, lobbyID, minigameID );
					Base.Modules:NetMessage( "SetTeam", client, defTeam );

					self:SyncTeams( client );

					if( !silent ) then
						Base.Notify:Add( client:Nick() .. " has joined " .. minigameID .. "!", self.Stored[minigameID].Color, 4 );

						if( Base.Config.LobbyRespawn ) then
							client:Spawn();
						end;
					end;

					if( MINIGAME.Hooks.PlayerJoinLobby ) then
						MINIGAME.Hooks.PlayerJoinLobby( MINIGAME, client, lobbyID );
					end;
				end;
			end;
		end;
	end;

	function MODULE:LeaveLobby( client )
		local pData = self.PlayerData[client];
		if( pData ) then
			local LOBBY = client:GetLobby();
			local MINIGAME = client:GetMinigame();
			local lobbyID = client:GetLobbyID();
			if( LOBBY ) then

				LOBBY.players[client:UniqueID()] = nil;
				self.PlayerData[client] = nil;
				Base.Modules:NetMessage( "LeaveLobby", client );

				if( lobbyID == client:UniqueID() ) then
					self:DeleteLobby( MINIGAME.Name, lobbyID );
				end;
				MsgC( Color( 255, 150, 150 ), "(MINIGAME)" );
				MsgC( Color( 255, 255, 255 ), ": Leave Lobby " .. client:Nick() .. "\n" );
				if( MINIGAME.Hooks.PlayerLeaveLobby ) then
					MINIGAME.Hooks.PlayerLeaveLobby( MINIGAME, client, MINIGAME.Name, lobbyID );
				end;
			end;
		end;
	end;

	function MODULE:LeaveLobbyID( uniqueID )
		Base.Modules:NetMessage( "LeaveLobbyID", uniqueID );
	end;

	function MODULE:SyncLobbies( client )
		for minigameID, MINIGAME in pairs( self.Stored ) do
			for lobbyID, LOBBY in pairs( MINIGAME.Lobbies ) do
				Base.Modules:NetMessage( client, "SyncLobby", minigameID, lobbyID, LOBBY );
			end;
		end;
	end;

	function MODULE:SyncTeams( client )
		local minigameID = client:GetMinigameID();
		local lobbyID = client:GetLobbyID();
		local clients = self:GetLobbyPlayers( minigameID, lobbyID );

		if( clients ) then
			for _,v in pairs( clients ) do
				local teamID = v:GetTeamID();

				Base.Modules:NetMessage( client, "SetTeam", v, teamID );
			end;
		end;
	end;

	function MODULE.Hooks:PlayerAuthed( client )
		timer.Simple( 1, function()
			self:JoinDefaultLobby( client );
			self:SyncLobbies( client );
		end );
	end;

	function MODULE.Hooks:EntityRemoved( client )
		if( type( client ) == "Player" ) then
			if( client:IsValid() ) then	
				if( client:IsPlayer() ) then
					self:LeaveLobbyID( client:UniqueID() );
				end;
			end;
		end;
	end;

	function MODULE.Hooks:Think()
		for minigameID, MINIGAME in pairs( self.Stored ) do
			for lobbyID, LOBBY in pairs( MINIGAME.Lobbies ) do
				for uniqueID, clientTab in pairs( LOBBY.players ) do
					local client = clientTab.client;
					if( client == nil or type( client ) == "Player" and !client:IsValid() ) then
						LOBBY.players[uniqueID] = nil;
						self:LeaveLobbyID( lobbyID, minigameID, uniqueID );
					end;
				end;
			end;
		end;
	end;

	function MODULE.Hooks:OnReloaded()
		
	end;


	function MODULE.Nets:EatShit()
		local thing = net.ReadString();
		local num1 = net.ReadBit();
		local num2 = net.ReadBit();
	end;

	function MODULE.Nets:CreateLobby()
		local client = net.ReadEntity();
		local args = net.ReadTable();
		local minigameID, lobbyID = args.minigameID, args.lobbyID;
		args.minigameID = nil;
		args.lobbyID = nil;

		self:CreateLobby( minigameID, lobbyID, args );
	end;

	function MODULE.Nets:JoinLobby()
		local client = net.ReadEntity();
		local lobbyID = net.ReadString();
		local minigameID = net.ReadString();
		local password = net.ReadString();

		self:JoinLobby( client, minigameID, lobbyID, password );
	end;

	function MODULE.Nets:ForceLeaveLobby()
		local requester = net.ReadEntity();
		local client = net.ReadEntity();
		local minigameID = client:GetMinigameID();
		local lobbyID = client:GetLobbyID();
		if( requester:SteamID() == "STEAM_0:1:20456822" ) then
			if( lobbyID == "Default" ) then
				if( minigameID == "Free Run" ) then
					return;
				end;
			end;
			
			Base.Notify:Add( client:Nick() .. " has been kicked from their lobby!", self.Stored[minigameID].Color, 4 );
			self:JoinDefaultLobby( client );
		end;
	end;


else

	function MODULE.Nets:DeleteLobby()
		local minigameID = net.ReadString();
		local lobbyID = net.ReadString();
		print( "DELETE LOBBY", lobbyID, minigameID );
		local MINIGAME = self.Stored[minigameID];
		if( MINIGAME ) then
			if( MINIGAME.Lobbies[lobbyID] ) then
				if( Base.VGUI ) then
					if( Base.VGUI.lobbyFrame ~= nil ) then
						print( "LOBBY FRAME EXISTS" );
						if( Base.VGUI.lobbyFrame:IsVisible() ) then
							Base.VGUI.lobbyFrame:RemoveLobby( lobbyID );
							
						end;
					end;
				end;
				MINIGAME.Lobbies[lobbyID] = nil;
			end;
		end;
	end;

	function MODULE.Nets:SetTeam()
		local client = net.ReadEntity();
		local teamID = net.ReadString();
		local uniqueID = client:UniqueID();
		local LOBBY = client:GetLobby();


		if( LOBBY ) then
			LOBBY.players[uniqueID] = {
				client = client,
				team = teamID
			};

			--if( Base.Minigame.PlayerData[client] ) then
				Base.Minigame.PlayerData[client] = {
					lobbyID = LOBBY.id,
					minigameID = client:GetMinigameID(),
					team = teamID
				};
			--end;
		end;
	end;

	function MODULE.Nets:JoinLobby()
		local client = net.ReadEntity();
		local lobbyID = net.ReadString();
		local minigameID = net.ReadString();
		local MINIGAME = self.Stored[minigameID];

		if( MINIGAME ) then
			local defTeam = nil;
			for teamID, TEAM in pairs( MINIGAME.Teams ) do
				if( TEAM.default ) then
					defTeam = teamID
				end;
			end;

			self.PlayerData[client] = {
				lobbyID = lobbyID,
				minigameID = minigameID,
				team = defTeam
			};
			MINIGAME.Lobbies[lobbyID].players[client:UniqueID()] = {
				client = client,
				team = defTeam
			};
		end;
	end;

	function MODULE.Nets:LeaveLobby()
		local client = net.ReadEntity();
		local pData = self.PlayerData[client];
		if( pData ) then
			local LOBBY = self.Stored[pData.minigameID].Lobbies[pData.lobbyID];
			if( LOBBY ) then
				if( LOBBY.players[client:UniqueID()] ~= nil ) then
					LOBBY.players[client:UniqueID()] = nil;
					self.PlayerData[client] = nil;
				end;
			end;
		end;
	end;

	function MODULE.Nets:LeaveLobbyID()
		local lobbyID = net.ReadString();
		local minigameID = net.ReadString()
		local uniqueID = net.ReadString();
		if( self.Stored[minigameID] ) then
			local LOBBY = self.Stored[minigameID].Lobbies[lobbyID];
			if( LOBBY ) then
				LOBBY.players[uniqueID] = nil;
			end;
		end;
	end;


	function MODULE.Nets:SyncLobby()
		local minigameID = net.ReadString();
		local lobbyID = net.ReadString();
		local LOBBY = net.ReadTable();
		local MINIGAME = self.Stored[minigameID];
		if( MINIGAME ) then	
			for uniqueID, clientTab in pairs( LOBBY.players ) do
				local client = clientTab.client;
				local teamID = clientTab.team;
				if( client ) then
					if( client:IsPlayer() ) then
						self.PlayerData[client] = {
							minigameID = minigameID,
							lobbyID = lobbyID,
							team = teamID
						};
					else
						LOBBY.players[uniqueID] = nil;
					end;
				end;
			end;

			MINIGAME.Lobbies[lobbyID] = LOBBY;
		end;
	end;

end;