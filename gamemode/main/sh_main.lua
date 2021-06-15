/*
	Unnamed Project
	--By Blasphemy
*/

Base = Base or {};
Base.FolderName = "BLParkour";--( GAMEMODE and GAMEMODE.FolderName ) or GM.FolderName;
--Base.Modules = Base.Modules or {};
Base.Config = Base.Config or {};

include( "sh_config.lua" );



MsgC( Base.Config.HookColor, "===============================================================\n" );
MsgC( Base.Config.ConsoleColor, "|                        Loading " );
MsgC( Base.Config.HookColor, Base.Name );
MsgC( Base.Config.ConsoleColor, "                       |\n" );
MsgC( Base.Config.HookColor, "===============================================================\n" );

MsgC( Base.Config.ConsoleColor, "\n    Libraries\n" );
MsgC( Base.Config.HookColor, "    ------------------------\n" );


function Base:LoadLibraryNotice( realm, modName )
	local suffix = string.upper( string.sub( realm, 1, 2 ) );
	local color = Base.Config.Colors[suffix];
	--MsgC( Base.Config.ConsoleColor, "[GM-" .. suffix .. "] " );
	--MsgC( color, "[GM-" .. suffix .. "] |" );
	MsgC( Base.Config.ConsoleColor, "    (" );
	MsgC( Base.Config.LibColor, "library" );
	MsgC( Base.Config.ConsoleColor, ") " .. realm ..  modName .. "\n" );
end;

function Base:LoadLibraries()
	local libOnLoads = {};
	local fileTab = {file.Find( Base.FolderName .. "/gamemode/main/libraries/*", "LUA" )};
	for k,v in pairs( fileTab[2] ) do
		for k, fileName in pairs( file.Find( Base.FolderName .. "/gamemode/main/libraries/" .. v .. "/*.lua", "LUA" ) ) do
			if( fileName ) then
				local prefix = string.sub( fileName, 1, 3 );
				local path = Base.FolderName .. "/gamemode/main/libraries/" .. v .. "/" .. fileName;
				if( string.match( prefix, "_" ) ) then
					if( prefix == "sh_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
							include( path );
						else
							include( path );
						end;
						if( Base.Config.Debug ) then
							local proper = string.gsub(" " ..v, "%W%l", string.upper):sub(2);
							if( Base[proper] ) then
								if( Base[proper].OnLoad ) then
									table.insert( libOnLoads, proper );
								end;
							end;
							Base:LoadLibraryNotice( prefix, v );
						end;
					elseif( prefix == "sv_" ) then
						if( SERVER ) then
							include( path );
							if( Base.Config.Debug ) then
								local proper = string.gsub(" " ..v, "%W%l", string.upper):sub(2);
								if( Base[proper] ) then
									if( Base[proper].OnLoad ) then
										table.insert( libOnLoads, proper );
									end;
								end;
								Base:LoadLibraryNotice( prefix, v );
							end;
						end;
					elseif( prefix == "cl_" ) then
						if( SERVER ) then
							AddCSLuaFile( path );
						else
							include( path );
							if( Base.Config.Debug ) then
								local proper = string.gsub(" " ..v, "%W%l", string.upper):sub(2);
								if( Base[proper] ) then
									if( Base[proper].OnLoad ) then
										table.insert( libOnLoads, proper );
									end;
								end;
								Base:LoadLibraryNotice( prefix, v );
							end;
						end;
					end;
				else
					if( Base.Config.Debug ) then
						if( SERVER ) then
							MsgC( Base.Config.ConsoleColor, "[Org-SV] | Skipped File: " .. path .. "\n" );
						else
							MsgC( Base.Config.ConsoleColor, "[GM-CL] | Skipped File: " .. path .. "\n" );
						end;
					end;
				end;
			end;
		end;
	end;
	for k,proper in pairs( libOnLoads ) do
		if( Base[proper] ) then
			if( Base[proper].OnLoad ) then
				RunString( "Base." .. proper .. ":OnLoad()" );
			end;
		end;
	end;
end;

Base:LoadLibraries();
if( CLIENT ) then
end;
