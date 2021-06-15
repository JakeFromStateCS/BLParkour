--sh_init.lua
Base = Base or {};
Base.Player = {};
local meta = FindMetaTable( "Player" );

function meta:GetOrg()
	if( self.org ~= nil ) then
		return Base.Data.Stored[self.org];
	end;
end;

function meta:GetOrgID()
	if( self.org ~= nil ) then
		return self.org;
	end;
end;

function meta:HasOrgFlag( flag )
	if( self.org ~= nil ) then
		if( self.org.flags[flag] ) then
			return true;
		end;
	end;
end;