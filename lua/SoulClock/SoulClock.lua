--=================== Global Variables ==========================================
Clock_UpdateInterval = 20;			--OnUpdate function limiter.
Thorn_UpdateInterval = 5;			--OnUpdate function limiter.
clockCounter = 0;						--Variable to increment with OnUpdate arg1
thornsCounter = 0;
tankMode = 0;
--=========== Soul Clock "OnSomething" Handlers for SoulClock.xml ===============
function SoulClock_OnLoad()
	SoulClock:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
	SetClockString();
	SetXPString();
end

function Clock_OnUpdate()
		clockCounter = clockCounter + arg1
		thornsCounter = thornsCounter + arg1
		
		if clockCounter > Clock_UpdateInterval then
			SetClockString();
			clockCounter = 0;
		end 
		
		if thornsCounter > Thorn_UpdateInterval then
			Check_Thorns();
			CheckRighteousFury();
			thornsCounter = 0;
		end
		
end

function SoulClock_EventHandler()
	if event == "CHAT_MSG_COMBAT_XP_GAIN" then
		SetXPString();
	end
		
end


--==================== Soul Clock functions ==================================
function SetTankMode(tankVal)
	if (tankVal == "true") then
		tankMode = 1
	elseif (tankVal == "false") then
		tankMode = 0
	end
end

function Check_Thorns()
	if not buffed("Thorns") and buffed("Dire Bear Form") then
		--SendChatMessage("Thorns is gone", "WHISPER", "Common", "fibes");
		PrintColor(180,255,0,"Thorns is gone!")
	end
end


function CheckRighteousFury()
	if (tankMode==1) and not buffed("Righteous Fury") and (UnitHealth("player") <= 0)then
		PrintColor(180,255,0,"Righteous Fury is gone!")
	end
end



function SetClockString()
	local hh, mm = GetGameTime();  -- Get hours and minutes from Nostalrius Server
	local am_pm = "AM";
	
	
	if (hh >= 18) or (hh <= 6) then			   -- Set AM or PM string		
		am_pm = "PM";
	end
	
	if (hh <= 6) then			   -- Put the hours into EST
		hh = hh + 6;
	elseif (hh > 18) then		   -- Let's keep it in 12HR format shall we?
		hh = hh - 18;
	else
		hh = hh - 6;
	end
	--==== Set the clock string that displays in the little clock box =====--
	SoulClockClockString:SetText(string.format("%d:%02d %s", hh, mm, am_pm));
end

function SetXPString()
	local currentXP = UnitXP("player")
	local maxXP = UnitXPMax("Player")
	local percentXP = (currentXP / maxXP)*100
	
	SoulClockXPString:SetText(string.format("XP: %.1f %%", percentXP));
end

