--[[
	What all this module does/should do:

	Store the structure of each module's data table if there is one
	Add data to a specific module's data table
	Base.Data.Stored[modName] = tableStruct;

	Base.Data.Stored[modID][steamID] = {
		wallet = 0,
		bank = 0
	};

]]--

--require( "mysqloo" );
AddCSLuaFile( "sh_von.lua" );
include( "sh_von.lua" );

Base = Base or {};
Base.Data = {};
Base.Data.Hooks = {};
Base.Data.Queue = {};
Base.Data.Stored = {};
Base.Data.Types = {
	["Vector"] = { "x", "y", "z" },
	["Angle"] = { "p", "y", "r" },
	["Table"] = { "r", "g", "b", "a" }
};
Base.Data.Config = {
	mysql = {
		default = false,
		info = {
			host = "beigelands.com",
			username = "fuckingwork",
			password = "fuckingwork",
			database = "Gmod_DarkRP",
			port = 3306
		},
		database = nil;
	},
	defaultRanks = {
		["Owner"] = {
			flags = {
				"*"
			}
		}
	}
};
Base.Data.QueueTimer = CurTime();
Base.Data.KATimer = CurTime()
Base.Data.KADelay = 30;
Base.Data.QueueDelay = 0.25;
Base.Data.Callback = nil;

function Base.Data:OnLoad()
	
end;

function Base.Data:Decode( encodedStr )
	return von.decode( encodedStr );
end;

function Base.Data:Encode( dataTable )
	return von.encode( dataTable );--self:RecursiveEncode( dataTable );
end;

function Base.Data:Connect()
	if( self.Config.mysql.default ) then
		local mysql = self.Config.mysql;
		self.Config.mysql.database = mysqloo.connect( mysql.info.host, mysql.info.username, mysql.info.password, mysql.info.database, mysql.info.port );
		mysql.database.onConnected = function()
			print( "SUCCESS CONNECTING TO DB" );
			if( mysql.database.FirstConnect ) then
	--TODO:
	--			self:Log( some message about first time connecting or something );
			else
	--			self:Log( some message about connecting, info param possibly );
			end;

		end;
		mysql.database.onConnectionFailed = function( query, err )
	--TODO:
	--		self:Log( some message about some bullshit .. tostring( err ), error );
			print( query, err );
		end;
		--TODO:
		-- self:Log( some bullshit about connecting );
		self.Config.mysql.database:connect();
		self.Config.mysql.database:wait();
	end;
end;

function Base.Data:Disconnect()

end;

function Base.Data:TableExists( tableName )
	if( !self.Config.mysql.default ) then
		return sql.TableExists( tableName );
	else
		local query = "SELECT EXISTS (SELECT * FROM `" .. tableName .. "`);";
		local retVal = self:Query( query );
		if( #retVal == 0 ) then
			return false;
		else
			return true;
		end;
	end;
end;

function Base.Data:Query( string )
	local mysql = self.Config.mysql;
	if( !mysql.default ) then
		sql.Begin();
			local query = sql.query( string );
		sql.Commit();
		if( self.Config.Callback ) then
			self.Config:Callback( query );
		end;
		return query;
	else
		if( mysql.database ~= nil ) then
			local result = mysql.database:query( string );
			local retVal = {};
			if( result ) then
				
				result.onSuccess = function( data )
					--PrintTable( data );
					--retVal = data;
				end;
				result.onError = function( string, err )
					print( "ORGS ERROR | " .. err );
				end;
				result.onData = function( query, data )
					table.insert( retVal, data );
				end;
				result:start();
				result:wait();

				if( self.Config.Callback ) then
					self.Config:Callback( retVal );
				end;
				return retVal;
			end;

		else
			--Try to connect and re-run the query.
			self:Connect();
				-- Add the query to a queue then throw an error
				table.insert( self.Queue, string );
--TODO:
--				self.Log( )
		end;
	end;
end;

function Base.Data:Escape( string )
	if( self.Config.mysql.database ) then
		return self.Config.mysql.database:escape( string );
	else
		return sql.SQLStr( string );
	end;
end;

function Base.Data:SetupData()
	if( Base.Modules ) then
		for modID, MODULE in pairs( Base.Modules.Stored ) do
			if( self.Stored[modID] == nil ) then
				self.Stored[modID] = {};
			end;
		end;
	end;
end;


function Base.Data:AddData( client, modID, key, val )
	if( self.Stored[modID] ) then
		local steamID = client:SteamID();
		if( self.Stored[modID][steamID] ) then
			if( self.Stored[modID][steamID] == nil ) then
				self.Stored[modID][steamID] = {};
			end;
			self.Stored[modID][steamID][key] = val;

			local encode = von.encode( self.Stored[modID][steamID] );
			self:InsertData( steamID, modID, encode );
		end;
	end;
end;

function Base.Data:GetData( client, modID, key )
	if( self.Stored[modID] ) then
		local steamID = client:SteamID();
		if( self.Stored[modID][steamID] ) then
			return self.Stored[modID][steamID][key] or false;
		end;
	end;
end;

function Base.Data:SaveData( client )
	for modID, modData in pairs( self.Stored ) do
		--for steamID, pData in pairs( modData ) do
			
		--end;
		if( modData[client:SteamID()] ) then
			local encode = von.encode( modData[client:SteamID()] );
			if( !self:TableExists( "Base_" .. modID ) ) then
				self:Query( [[
					CREATE TABLE `Base_]] .. modID .. [[` ( 
						`steamID` varchar(255),
						`data` varchar(255)
					);
				]] );
			end;

			self:InsertData( client:SteamID(), modID, encode );
		end;
	end;
end;

function Base.Data:LoadData( client )
	for modID, _ in pairs( self.Stored ) do
		local steamID = client:SteamID();
		local query = self:Query( [[
					SELECT * FROM `Base_]] .. modID .. [[` 
					WHERE `steamID`=']] .. steamID .. [[';
				]] );
		if( query ) then
			local pData = von.decode( query[1] );
			for k,v in pairs( pData ) do
				self:AddData( client, modID, k, v );
			end;
		end;
	end;
end;

function Base.Data:InsertData( steamID, modID, data )
	if( self.Stored[modID] ) then
		self:Query( "INSERT INTO `Base_" .. modID .. "` ( `steamID`, `data` ) VALUES ( '" .. steamID .. "', '" .. data .. "' ) ON DUPLICATE KEY UPDATE `data` = VALUES( '" .. data .. "' );" );
	end;
end;


function Base.Data:KeepAlive()
	if( Base.Data.KATimer < CurTime() ) then
		local db = Base.Data.Config.mysql.database;
		if( db ~= nil ) then
			db:status();
			Base.Data.KATimer = CurTime() + Base.Data.KADelay;
		end;
	end;
end;
--hook.Add( "Think", "Base.Data.KeepAlive", Base.Data.KeepAlive );


function Base.Data:ManageQueue()
	if( Base.Data.QueueTimer < CurTime() ) then
		if( #Base.Data.Queue > 0 ) then
			local result = Base.Data:Query( Base.Data.Queue[1] );
			if( result ~= nil ) then
				table.remove( Base.Data.Queue, 1 );
			end;
			Base.QueueTimer = CurTime() + Base.Data.QueueDelay;
		end;
	end;
	Base.QueueTimer = CurTime() + Base.Data.QueueDelay;
end;
--hook.Add( "Think", "Base.Data.ManageQueue", Base.Data.ManageQueue );

function Base.Data:InitialSetup()
	if( !self:TableExists( "Base_Data" ) ) then
		--self:Query( "CREATE TABLE `Base_Data` ( `uniqueID` varchar(255), `title` varchar(255), `memberStr` varchar(255), `rankStr` varchar(255), `modStr` varchar(255) );" );
		--self:Query( "CREATE TABLE `Base_MemberData` ( `uniqueID` varchar(255), `orgID` varchar(255), `flags` varchar(255), `nick` varchar(255), `rank` varchar(255) );" );
		
	end;
end;