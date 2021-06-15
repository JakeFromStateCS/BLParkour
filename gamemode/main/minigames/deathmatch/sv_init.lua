
MINIGAME = MINIGAME or {};
MINIGAME.Hooks = MINIGAME.Hooks or {};
MINIGAME.Nets = MINIGAME.Nets or {};

function MINIGAME.Hooks:Think()
	for lobbyID, LOBBY in pairs( self.Lobbies ) do
		local clients = Base.Minigame:GetLobbyPlayers( self.Name, lobbyID );
		if( clients ) then
			for _,client in pairs( clients ) do
				local weapon = client:GetActiveWeapon();

				if( weapon:IsValid() ) then
					local ammoType = weapon:GetPrimaryAmmoType();
					if( ammoType ) then
						client:SetAmmo( 9999, ammoType );
					end;
				end;
			end;
		end;
	end;
end;