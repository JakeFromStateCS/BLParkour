/*
	Unnamed Project
    --By Blasphemy
*/

Base = Base or {};
Base.Name = "Beigelands Parkour";
Base.Author = "Matt.";
Base.FolderName = "BLParkour";--( GAMEMODE and GAMEMODE.FolderName ) or GM.FolderName;

Base.Inventory = Base.Inventory or {};
include( "sh_config.lua" );
include( "sh_main.lua" );


function GM:HUDDrawTargetID()
	--return false;
	self.BaseClass:HUDDrawTargetID();
end;