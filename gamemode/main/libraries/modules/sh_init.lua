--sh_init.lua
/*
	sh_init.lua
*/

/*
	NOTES:
		I basically decided this was necessary because in previous
		gamemodes I would just loop through the modules table but
		since the modules arent being stored in a table in this gamemode
		this is a nice way of doing it
		its also easier because all the hooks are in one place and accessable as opposed to
		looping through the whole module table which includes functions that arent hooks etc.
		
*/


Base = Base;
Base.Modules = Base.Modules or {};
Base.Modules.Stored = {};
Base.Modules.HookTypes = {};
Base.Modules.Nets = {};
Base.Modules.PostLoads = {};

if( SERVER ) then
	util.AddNetworkString( Base.Name .. "_NetMsg" );
end;

function Base.Modules:OnLoad()
	Base.Modules:LoadModules();
	if( Base.Data ) then
		Base.Data:SetupData();
	end;
end;

function Base.Modules:LoadNotice( realm, modName )
	local suffix = string.upper( string.sub( realm, 1, 2 ) );
	local color = Base.Config.Colors[suffix];
	--MsgC( Base.Config.ConsoleColor, "[GAMEMODE-" .. suffix .. "] " );
	--MsgC( color, "[GM-" .. suffix .. "] |" );
	MsgC( Base.Config.ConsoleColor, "    (" );
	MsgC( Base.Config.ModColor, "module" );
	MsgC( Base.Config.ConsoleColor, ") " .. modName .. "\n" );
end;

function Base.Modules:HookRegisterNotice( realm, modName, hookName )
	local suffix = string.upper( string.sub( realm, 1, 2 ) );
	local color = Base.Config.Colors[suffix];
	--MsgC( Base.Config.ConsoleColor, "[GAMEMODE-" .. suffix .. "] " );
	--MsgC( color, "[GM-" .. suffix .. "] |" );
	MsgC( Base.Config.ConsoleColor, "     - (" );
	MsgC( Base.Config.HookColor, "hook" );
	MsgC( Base.Config.ConsoleColor, ") " .. hookName .. "\n" );--.. " from" );
	--MsgC( Base.Config.ModColor, " MODULE" );
	--MsgC( Base.Config.ConsoleColor, ": " .. modName .. "\n" );
end;

function Base.Modules:NetRegisterNotice( realm, modName, netName )
	local suffix = string.upper( string.sub( realm, 1, 2 ) );
	local color = Base.Config.Colors[suffix];
	--MsgC( Base.Config.ConsoleColor, "[GAMEMODE-" .. suffix .. "] " );
	--MsgC( color, "[GM-" .. suffix .. "] |" );
	MsgC( Base.Config.ConsoleColor, "     - (" );
	MsgC( Base.Config.NetColor, "net" );
	MsgC( Base.Config.ConsoleColor, ") " .. netName .. "\n" );
	--MsgC( Base.Config.ModColor, " MODULE" );
	--MsgC( Base.Config.ConsoleColor, ": " .. modName .. "\n" );
end;

function Base.Modules:RegisterModule( MODULE )
	if( CLIENT ) then
		MODULE.Realm = "cl_";
	end;
	if( SERVER ) then
		MODULE.Realm = "sv_";
	end;
	if( CLIENT and SERVER ) then
		MODULE.Realm = "sh_";
	end;
	
	if( MODULE.Name ) then
		if( Base.Config.Debug ) then
			self:LoadNotice( MODULE.Realm, MODULE.Name );
		end;
		if( MODULE.OnLoad ) then
			MODULE:OnLoad();
		end;
		self.Stored[MODULE.Name] = MODULE;
		self:RegisterHooks( MODULE );
		self:RegisterNets( MODULE );


		if( MODULE.PostLoad ) then
			self.PostLoads[MODULE.Name] = MODULE.PostLoad;
		end;
	end;
end;

function Base.Modules:LoadModules()
	MsgC( Base.Config.ConsoleColor, "\n    Modules\n" );
	MsgC( Base.Config.HookColor, "    ------------------------\n" );
	local fileTab = {file.Find( Base.FolderName .. "/gamemode/main/modules/*", "LUA" )};
	for k,v in pairs( fileTab[2] ) do
		for k, file in pairs( {file.Find(Base.FolderName .. "/gamemode/main/modules/" .. v .. "/*.lua", "LUA")} ) do
			if( file[1] ~= nil ) then
				local prefix = string.sub( file[1], 1, 3 );
				local path = Base.FolderName .. "/gamemode/main/modules/" .. v .. "/" .. file[1];
				if( string.match( prefix, "_" ) ) then
					MODULE = {};
					MODULE.Hooks = {};
					MODULE.Nets = {};
					MODULE.Realm = prefix;
					if( prefix == "cl_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
						else
							include( path );
						end;
					elseif( prefix == "sh_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
							include( path );
						else
							include( path );
						end;
					elseif( prefix == "sv_" ) then
						if( SERVER ) then
							include( path );
						end;
					
					end;

					self:RegisterModule( MODULE );
					MODULE = nil;
				end;
			end;
		end;
	end;
	for modName, func in pairs( self.PostLoads ) do
		print( "postLoad", modName );
		func( self.Stored[modName] );
	end;
end;

function Base.Modules:RegisterHooks( MODULE )
	if( MODULE.Name and MODULE.Hooks ) then
		for name,func in pairs( MODULE.Hooks ) do
			if( Base.Modules.HookTypes[name] == nil or !Base.Modules.HookTypes[name] ) then
				Base.Modules.HookTypes[name] = {};
			end;
			Base.Modules.HookTypes[name][MODULE.Name] = func;
			--table.insert( Base.Modules.HookTypes[name], func );
			hook.Add( name, "Base_" .. name, function( ... )
				if( Base.Modules.HookTypes[name] == nil and !self.Reloading ) then
					print( name );
					hook.Remove( name, "Base_" .. name );
					return;
				end;
				if( Base.Modules.HookTypes[name] ~= nil ) then
					for modName, func in pairs( Base.Modules.HookTypes[name] ) do
						local retVar = func( unpack( { Base.Modules.Stored[modName], ... } ) );
						if( retVar ~= nil ) then
							return retVar;
						end;
					end;
				end;
			end );
			if( Base.Config.Debug ) then
				if( SERVER ) then
					Base.Modules:HookRegisterNotice( "sv_", MODULE.Name, name );
				else
					Base.Modules:HookRegisterNotice( "cl_", MODULE.Name, name );
				end;
			end;
		end;
	end;
end;

function Base.Modules:DisableHook( modName, hookType )
	local MODULE = Base.Modules.Stored[modName];
	if( MODULE ) then
		if( MODULE.Hooks ) then
			if( MODULE.Hooks[hookType] ) then
				if( Base.Modules.HookTypes[hookType][modName] ~= nil ) then
					Base.Modules.HookTypes[hookType][modName] = nil;
				end
				hook.Remove( hookType, "Base_" .. hookType );
			end;
		end;
	end;
end;

function Base.Modules:DisableHooks( modName )
	local MODULE = Base.Modules.Stored[modName];
	if( MODULE ) then
		if( MODULE.Hooks ) then
			for name, func in pairs( MODULE.Hooks ) do
				self:DisableHook( modName, name );
			end;
		end;
	end;
end;

function Base.Modules:RegisterNets( MODULE )
	if( MODULE.Name and MODULE.Nets ) then
		for name,func in pairs( MODULE.Nets ) do
			if( Base.Modules.Nets[name] == nil ) then
				if( Base.Config.Debug ) then
					if( SERVER ) then
						self:NetRegisterNotice( "sv_", MODULE.Name, name );
					else
						self:NetRegisterNotice( "cl_", MODULE.Name, name );
					end;
					Base.Modules.Nets[name] = { ["module"] = MODULE.Name, ["func"] = func };
				end;
			end;
		end;
	end;
end;

function Base.Modules:NetMessage( client, netMsg, ... )
	local tab = { ... }
	local clients = {};
	if( type( client ) == "string" ) then
		table.insert( tab, 1, netMsg );
		netMsg = client;
		client = nil;
		clients = player.GetAll();
	elseif( type( client ) == "table" ) then
		for k,v in pairs( client ) do
			if( type( v ) == "Player" ) then
				table.insert( clients, v );
			end;
		end;
	elseif( type( client ) == "Player" ) then
		clients = client;
	end;

	MsgC( Color( 255, 150, 150 ), "     - (netmsg)" );
	MsgC( Color( 255, 255, 255 ), ": Starting Message " ..  netMsg .. "\n" );
	local types = {
		["Number"] = "Float",
		["NextBot"] = "Entity",
		["Player"] = "Entity",
		["NPC"] = "Entity",
		["Table"] = "Table"
	}
	net.Start( Base.Name .. "_NetMsg" );
		net.WriteString( netMsg );
		for k,v in pairs( tab ) do
			local typeName = type( v ):gsub("^%l", string.upper);
			print( typeName );
			if( types[typeName] ) then
				typeName = types[typeName];
			end;
			local func = net["Write" .. typeName];
			if( func ) then
				func( v );
			end;
		end;
	if( CLIENT ) then
			--net.WriteEntity( LocalPlayer() );
		net.SendToServer();
	else
		net.Send( clients );
	end;
end;

function Base.Modules.NetReceive()
	local netMsg = net.ReadString();
	if( netMsg ) then
		if( SERVER ) then
		else
		end;
		local netTab = Base.Modules.Nets[netMsg];
		if( netTab ) then
			MsgC( Color( 255, 150, 150 ), "(NET)" );
			MsgC( Color( 255, 255, 255 ), ": Receiving Message " ..  netMsg .. "\n" );
			local MODULE = Base.Modules.Stored[netTab.module];
			netTab.func( MODULE );
		end;
	end;
end;
net.Receive( Base.Name .. "_NetMsg", Base.Modules.NetReceive );