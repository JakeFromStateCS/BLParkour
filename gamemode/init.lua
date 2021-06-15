/*
	Unnamed Project
    --By Blasphemy
*/

Base = Base or {};
Base.StartTime = SysTime();

GM.Name = "Beigelands Parkour";
GM.Author = "Matt.";

Base.Name = "Beigelands Parkour";
Base.Author = "Matt.";
Base.FolderName = "BLParkour";--( GAMEMODE and GAMEMODE.FolderName ) or GM.FolderName;

--include( "resources.lua" );

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "main/sh_main.lua" );
AddCSLuaFile( "main/sh_config.lua" );
AddCSLuaFile( "main/cl_main.lua" );

include( "main/sv_main.lua" );


RunConsoleCommand( "mp_falldamage", "1" );
RunConsoleCommand( "sv_gravity", "300" );
RunConsoleCommand( "sbox_godmode", "0" );
RunConsoleCommand( "sbox_noclip", "1" );
RunConsoleCommand( "physgun_limited", "1" );
RunConsoleCommand( "sv_alltalk", "1" );

DeriveGamemode( "base" );

print( SysTime() - Base.StartTime );
