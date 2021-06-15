/*
	Unnamed Project
    --By Blasphemy
*/

GM.StartTime = SysTime();

Base = Base or {};

GM.Name = "Beigelands Parkour";
GM.Author = "Matt.";

Base.Name = "Beigelands Parkour";
Base.Author = "Matt.";
Base.FolderName = "BLParkour";--( GAMEMODE and GAMEMODE.FolderName ) or GM.FolderName;

include( "main/sh_config.lua" );
include( "main/cl_main.lua" );


DeriveGamemode( "base" );