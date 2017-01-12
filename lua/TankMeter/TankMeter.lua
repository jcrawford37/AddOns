-- Parse some input from combat log and throw it in a window for tank

--==== Global Var initialization ====----
--== A bunch of ints to hold some vars
TotalIncoming = 0
TotalMitigated = 0
TotalAvoided = 0
TotalFullBlocks = 0
TotalBlocks = 0
TotalDodges = 0
TotalParry  = 0
TotalMisses = 0
TotalCrits  = 0
TotalCrushBlow = 0
TotalAvoidPerc = 0.1
TotalBlockPerc = 0.1

--== A bunch of strings for the XML titles
fullBlockString="Full Block: "
anyBlockString="All Blocks: "
dodgeString="Dodges: "
parryString="Parries: "
missString="Misses: "
critString="Crits: "
crushString="Crushes: "
totalIncString="Total Incoming: "
totalAvoidString="Total Avoided: "
percAvoidString="Percent Avoided: "
percBlockString="Percent Blocked: "

-- chat / command to reset stats
SLASH_TANKMETER1 = '/tm'

function SlashCmdList.TANKMETER(msg, editbox) 
	if (msg == "reset") then
		TankMeter_ResetStats()
	elseif (msg == "toggle") then
		if TankMeter:IsVisible() then
			TankMeter:Hide()
		else 
			TankMeter:Show()
		end
	end
end


function TankMeter_ResetStats()
	TotalIncoming = 0
	TotalMitigated = 0
	TotalAvoided = 0
	TotalFullBlocks = 0
	TotalBlocks = 0
	TotalDodges = 0
	TotalParry  = 0
	TotalMisses = 0
	TotalCrits  = 0
	TotalCrushBlow = 0
	TotalAvoidPerc = 0.1
	TotalBlockPerc = 0.1
	TankMeter_UpdateDisplayStrings()
end

--==== OnLoad function. Sets which combat events to register for ====----
function TankMeter_OnLoad()
	--TankMeter:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS") -- You hit something
	--TankMeter:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE") -- You damage something
	--TankMeter:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF") -- Self only buffs (Bloodrage)
	TankMeter:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS") -- Creature hits you
	TankMeter:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
	TankMeter_UpdateDisplayStrings()
	
end

function TankMeter_UpdateDisplayStrings()
	TotalAvoidPerc = (TotalAvoided / TotalIncoming) * 100
	TotalBlockPerc = (TotalBlocks / TotalIncoming) * 100
	TankMeterDodge:SetText(string.format("%s%d", dodgeString, TotalDodges))
	TankMeterParry:SetText(string.format("%s%d", parryString, TotalParry))
	TankMeterMiss:SetText(string.format("%s%d", missString, TotalMisses))
	TankMeterFullBlock:SetText(string.format("%s%d", fullBlockString, TotalFullBlocks))
	TankMeterAnyBlock:SetText(string.format("%s%d", anyBlockString, TotalBlocks))
	TankMeterCrush:SetText(string.format("%s%d", crushString, TotalCrushBlow))
	TankMeterCrit:SetText(string.format("%s%d", critString, TotalCrits))
	TankMeterTotalIncoming:SetText(string.format("%s%d", totalIncString, TotalIncoming))
	TankMeterTotalAvoid:SetText(string.format("%s%d", totalAvoidString, TotalAvoided))
	TankMeterPercentAvoid:SetText(string.format("%s%2.1d", percAvoidString, TotalAvoidPerc).."%")
	TankMeterPercentBlock:SetText(string.format("%s%2.1d", percBlockString, TotalBlockPerc).."%")
end


-- <onEvent> calls this function. Remember vars are passed auto-magically. event and arg1 - argN are just there.
function TankMeter_parseCombat()
	local mitigationType = arg1
	
	if event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then 
		if strfind(mitigationType, " dodge") ~= nil then
			TotalDodges = TotalDodges + 1
			--TankMeterDodge:SetText(string.format("%s%02d", dodgeString, TotalDodges))
			--printf("Dodged!")
			
		elseif strfind(mitigationType, " parry") ~= nil then
			TotalParry = TotalParry + 1
			--TankMeterParry:SetText(string.format("%s%02d", parryString, TotalParry))
			--printf("Parried!")
			
		elseif strfind(mitigationType, " misses") ~= nil then
			TotalMisses = TotalMisses + 1
			--TankMeterMiss:SetText(string.format("%s%02d", missString, TotalMisses))
			--printf("Miss!")
		elseif strfind(mitigationType, " block") ~= nil then
			TotalFullBlocks = TotalFullBlocks + 1
			TotalBlocks = TotalBlocks + 1
			--TankMeterFullBlock:SetText(string.format("%s%02d", fullBlockString, TotalFullBlocks))
			--TankMeterAnyBlock:SetText(string.format("%s%02d", anyBlockString, TotalBlocks))
			--printf("Full Block!")
		end
		
		-- Update Stats for mathing out percentages of total incoming melee vs avoided/mitigated 
		TotalIncoming = TotalIncoming + 1
		TotalAvoided = TotalAvoided + 1
		TankMeter_UpdateDisplayStrings()
		
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" then
		if strfind(mitigationType, " blocked") ~= nil then
			TotalBlocks = TotalBlocks + 1
			TotalMitigated = TotalMitigated + 1	
			TankMeterAnyBlock:SetText(string.format("%s%02d", anyBlockString, TotalBlocks))
			--printf("Blocked!")
			
		elseif strfind(mitigationType, "(crushing)") ~= nil then
			TotalCrushBlow = TotalCrushBlow + 1
			--TankMeterCrush:SetText(string.format("%s%02d", crushString, TotalCrushBlow))
			--printf("Ouch, Crushed!")
		elseif strfind(mitigationType, " crit") ~= nil then
			TotalCrits = TotalCrits + 1
			--TankMeterCrit:SetText(string.format("%s%02d", critString, TotalCrits))
			--printf("Ouch, Got Crit!")
		end
		TotalIncoming = TotalIncoming + 1
		TankMeter_UpdateDisplayStrings()
	end	
end
