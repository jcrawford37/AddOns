-- Parse some input from combat log and throw it in a window for Moon

--==== Global Var initialization ====----
--== A bunch of ints to hold some vars

-- Proc Data
TotalWhiteHits = 0
TotalClearCasts = 0
TotalEdwards = 0
PercClearCasts = 0.1
PercEdwards = 0.1
-- Starfire Data
TotalStarfire = 0
StarfireHit = 0
StarfireCrit = 0
PercStarfireCrit = 0.1

--== A bunch of strings for the XML titles

CCStr =			"Clear Casts: "
edwardStr =		"Focus Procs: "
percCCStr =		"% Clear Cast: "
percEdStr =		"% Focus Proc: "
sfStr =			"Starfire Casts: "
percSfCritStr =	"% Starfire Crit: "

-- chat / command to reset stats
SLASH_MOONMETER1 = '/mm'

function SlashCmdList.MOONMETER(msg, editbox) 
	if (msg == "reset") then
		MoonMeter_ResetStats()
	elseif (msg == "toggle") then
		if MoonMeter:IsVisible() then
			MoonMeter:Hide()
		else 
			MoonMeter:Show()
		end
	end
end

--==== OnLoad function. Sets which combat events to register for ====----
function MoonMeter_OnLoad()
	MoonMeter:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS") -- You hit something
	MoonMeter:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE") -- You damage something
	MoonMeter:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS") -- clear cast, battleshout
	--MoonMeter:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF") -- Self only buffs (Bloodrage)
	MoonMeter_UpdateDisplayStrings()
	
end

function MoonMeter_ResetStats()
	-- Proc Data
	TotalWhiteHits = 0
	TotalClearCasts = 0
	TotalEdwards = 0
	PercClearCasts = 0.1
	PercEdwards = 0.1
	-- Starfire Data
	TotalStarfire = 0
	StarfireHit = 0
	StarfireCrit = 0
	PercStarfireCrit = 0.1
	MoonMeter_UpdateDisplayStrings()
end

function MoonMeter_UpdateDisplayStrings()
	-- Avoid divide by zero
	if TotalWhiteHits ~= 0 then
		PercClearCasts = (TotalClearCasts / TotalWhiteHits) * 100
		PercEdwards = (TotalEdwards / TotalWhiteHits) * 100
	else
		PercClearCasts = 0
		PercEdwards = 0
	end
	-- Avoid divide by zero
	if TotalStarfire ~= 0 then
		PercStarfireCrit = (StarfireCrit / TotalStarfire) * 100
	else
		PercStarfireCrit = 0
	end

	MoonMeterClearCasts:SetText(string.format("%s%d", CCStr, TotalClearCasts))
	MoonMeterEdwards:SetText(string.format("%s%d", edwardStr, TotalEdwards))
	
	MoonMeterPercCC:SetText(string.format("%s%2.1d", percCCStr, PercClearCasts).."%")
	MoonMeterPercEdwards:SetText(string.format("%s%2.1d", percEdStr, PercEdwards).."%")
	
	MoonMeterStarfires:SetText(string.format("%s%d", sfStr, TotalStarfire))
	MoonMeterPercSfCrit:SetText(string.format("%s%2.1d", percSfCritStr, PercStarfireCrit).."%")
end


-- <onEvent> calls this function. Remember vars are passed auto-magically. event and arg1 - argN are just there.
function MoonMeter_parseCombat()
	local action = arg1
	
	if event == "CHAT_MSG_COMBAT_SELF_HITS" then 
		if strfind(action, " hit") ~= nil or strfind(action, " crit") ~= nil then
			TotalWhiteHits = TotalWhiteHits + 1
			--printf("SELF_HITS: White Hit or Crit")
		end
		MoonMeter_UpdateDisplayStrings()
		
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
		--printf("SELF_BUFFS"..action)
		if strfind(action, " Clearcasting") then
			TotalClearCasts = TotalClearCasts + 1
			MoonMeter_UpdateDisplayStrings()
		elseif strfind(action, " Focus") ~= nil then
			TotalEdwards = TotalEdwards + 1
			MoonMeter_UpdateDisplayStrings()
		end
		
	
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		--printf("SELF_DAMAGE:"..action)
		if strfind(action, " Starfire") ~= nil then
			TotalStarfire = TotalStarfire + 1
			if strfind(action, " crits") ~= nil then
				StarfireCrit = StarfireCrit + 1
			end
			MoonMeter_UpdateDisplayStrings()
		end
	end	
	
end

