MODULE = MODULE or {};
MODULE.Name = "Namegen";
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.HookTypes = {};

function MODULE:OnLoad()
	self.Prefixes = {
		"Beige",
		"Blazed",
		"Glazed",
		"Raised",
		"Sage",
		"Enrage",
		"Contage",
		"Bombage",
		"Phage",
		"Swage"
	};
	self.Delay = 2;
	self.NextChange = CurTime();
end;

function MODULE.Hooks:Think()
	if( self.NextChange < CurTime() ) then
		RunConsoleCommand( "hostname", table.Random( self.Prefixes ) .. "lands | Development" );
		self.NextChange = CurTime() + self.Delay;
	end;
end;

