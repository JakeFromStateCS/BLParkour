
Base.Cinematics = {};

if (CLIENT) then
	-- The max size is capped at 128, so it's never big enough.
	surface.CreateFont( "BaseCinematicSmall", {
		size = ScreenScale( 12 ),
		weight = 400,
		antialias = true,
		font = "coolvetica"
	} );	
	surface.CreateFont( "BaseCinematicHuge", {
		size = ScreenScale( 48 ),
		weight = 400,
		antialias = true,
		font = "coolvetica"
	} );	

	
	
	Base.Cinematics.umsg = {};
	Base.Cinematics.colorAnimateSpeed = 0.07;
	Base.Cinematics.textAnimateSpeed = 14;
	Base.Cinematics.smallTextInfo = {
		textHeight = draw.GetFontHeight("BaseCinematicSmall"),
		text = "undefined",
		currentHeight = 0,
		slidingIn = false,
		slidingOut = false
	}
	Base.Cinematics.largeTextInfo = {
		textHeight = draw.GetFontHeight("BaseCinematicHuge"),
		text = "undefined",
		positionX = 0,
		alpha = 0
	}
	Base.Cinematics.colorTable = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	};

	function Base.Cinematics:RefreshUpdateRates()
		self.colorAnimateSpeed = 0.5 * FrameTime();
		self.textAnimateSpeed = 350 * FrameTime();
	end;

	function Base.Cinematics:StartGrayscale()
		self.colorTable["$pp_colour_colour"] = 0;
	end;

	-- math.Approach should be used here...
	function Base.Cinematics:HandleCinematics()
		if (self.colorTable["$pp_colour_colour"] < 1) then
			self.colorTable["$pp_colour_colour"] = self.colorTable["$pp_colour_colour"] + self.colorAnimateSpeed;
			DrawColorModify(self.colorTable);
		end;
		
		if (self.largeTextInfo.alpha > 0) then
			draw.DrawText(self.largeTextInfo.text, "BaseCinematicHuge", self.largeTextInfo.positionX, ScrH() / 2 - (self.largeTextInfo.textHeight / 2), Color(255, 255, 255, self.largeTextInfo.alpha), TEXT_ALIGN_LEFT);
			self.largeTextInfo.alpha = self.largeTextInfo.alpha - self.colorAnimateSpeed * 170;
			self.largeTextInfo.positionX = self.largeTextInfo.positionX + self.textAnimateSpeed;
		end;
		
		if (self.smallTextInfo.currentHeight > 0) then
			if (self.smallTextInfo.slidingIn) then
				if (self.smallTextInfo.currentHeight < ScreenScale(14)) then
					self.smallTextInfo.currentHeight = self.smallTextInfo.currentHeight + self.colorAnimateSpeed * 50;
				else
					self.smallTextInfo.slidingIn = false;
					timer.Simple(3, function()
						self.smallTextInfo.slidingOut = true;
					end);
				end;
			elseif (self.smallTextInfo.slidingOut) then
				self.smallTextInfo.currentHeight = self.smallTextInfo.currentHeight - self.colorAnimateSpeed * 50;
			end;
			
			surface.SetDrawColor(0, 0, 0, 255);
			surface.DrawRect(0, 0, ScrW(), self.smallTextInfo.currentHeight);
			surface.DrawRect(0, ScrH() - self.smallTextInfo.currentHeight, ScrW(), self.smallTextInfo.currentHeight);
			draw.DrawText(self.smallTextInfo.text, "BaseCinematicSmall", ScrW() / 2, self.smallTextInfo.currentHeight - (ScreenScale(14) / 2 + (self.smallTextInfo.textHeight / 2)), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER);
		end;
	end;
	
	function Base.Cinematics.umsg:Recieve()
		local noticeID = self:ReadString();
		local text = self:ReadString();
		
		if (noticeID == "large") then
			Base.Cinematics:StartLargeNotice(text);
		elseif (noticeID == "small") then
			Base.Cinematics:StartSmallNotice(text);
		end;
	end;
	usermessage.Hook("Base_umsg_cinematicnotice", Base.Cinematics.umsg.Recieve);
end;

function Base.Cinematics:StartLargeNotice(player, text)
	if (CLIENT) then
		if (type(player) == "string") then
			self.largeTextInfo.text = player;
			self.largeTextInfo.positionX = 0;
			self.largeTextInfo.alpha = 150;
			
			self:StartGrayscale();
		elseif (player == LocalPlayer()) then
			self.largeTextInfo.text = text;
			self.largeTextInfo.positionX = 0;
			self.largeTextInfo.alpha = 150;
			
			self:StartGrayscale();
		end;
	else
		local target;
		
		if (type(player) == "string") then
			text = player;
		else
			target = player;
		end;
		
		umsg.Start("Base_umsg_cinematicnotice", target);
			umsg.String("large");
			umsg.String(text)
		umsg.End();
	end;
end;

function Base.Cinematics:StartSmallNotice(player, text)
	if (CLIENT) then
		if (type(player) == "string") then
			self.smallTextInfo.text = player;
			self.smallTextInfo.slidingIn = true;
			self.smallTextInfo.slidingOut = false;
			self.smallTextInfo.currentHeight = 1;
		elseif (player == LocalPlayer()) then
			self.smallTextInfo.text = player;
			self.smallTextInfo.slidingIn = true;
			self.smallTextInfo.slidingOut = false;
			self.smallTextInfo.currentHeight = 1;
		end;
	else
		local target;
		
		if (type(player) == "string") then
			text = player;
		else
			target = player;
		end;
		
		umsg.Start("Base_umsg_cinematicnotice", target);
			umsg.String("small");
			umsg.String(text)
		umsg.End();
	end;
end;