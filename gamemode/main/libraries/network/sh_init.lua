Base = Base or {};
Base.Network = Base.Network or {};
Base.Network.Hooks = {};
Base.Network.Config = {};

if( SERVER ) then
	util.AddNetworkString( "Base_OrgSync" );

	function Base.Network:SyncOrg( orgID, client )
		if( Base.Data.Stored[orgID] ~= nil ) then
			net.Start( "Base_OrgSync" );
				net.WriteTable( Base.Data.Stored[orgID] );
			if( client == nil ) then
				net.Broadcast();
			else
				net.Send( client );
			end;
		end;
	end;

else

	function Base.Network:SyncOrg()
		local org = net.ReadTable();

		if( org ) then
			if( org.members[LocalPlayer():UniqueID()] ~= nil ) then
				LocalPlayer().orgID = org.ownerID;
			end;
			Base.Data.Stored[org.ownerID] = org;
		end;
	end;
	net.Receive( "Base_OrgSync", Base.Network.SyncOrg );

end;