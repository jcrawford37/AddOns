-- LUA Script file for SwingPro 3/2/2016
SwingProUpdateInterval = 0.04
timeElapsed = 0.00
currentWeaponSpeed = nil
weaponSwingTime = 0.00
enableBarMove = false
SwingBarEnabled = false

----====:::: OnLoad Handler. Setup addon basics

function SwingPro_OnLoad()
	--SetStatusBarColor(r,g,b [,alpha])
	SwingProBarFrame:SetStatusBarColor(0,.55,.95)
	SwingPro:RegisterEvent("PLAYER_REGEN_DISABLED")
	SwingPro:RegisterEvent("PLAYER_REGEN_ENABLED")
	SwingPro:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
	SwingPro:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
	SwingPro:RegisterEvent("COMBAT_TEXT_UPDATE")			-- This might be good in other addon for auras incoming heals
	SwingPro:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
	SwingPro:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
	 
end

----====:::: Lock/Unlock the bar to move it around
function ToggleBarLock()
	if not enableBarMove then
		SwingProBarFrame:SetScript("OnMouseDown", startBarMove);
		SwingProBarFrame:SetScript("OnMouseUp", stopBarMove);
		SwingProBarFrame:SetValue(100);                      -- Set Bar to full (or more than full) for viewing
		--SwingProBarFrame:SetScript("OnUpdate", nil)          -- Unregister OnUpdate so bar doesn't go back to zero while configuring
		SwingProBarFrame:Show();
		enableBarMove = true;
	else
		--SwingProBarFrame:SetScript("OnUpdate", BarFrame_CombatUpdate)
		SwingProBarFrame:SetScript("OnMouseDown", nil);
		SwingProBarFrame:SetScript("OnMouseUp", nil);
		SwingProBarFrame:Hide();
		enableBarMove = false;
	end
end

function SwingBarShow()
	SwingProBarFrame:Show()
end

function SwingBarHide()
	SwingProBarFrame:Hide()
end
----====:::: Functions to move the bar around when it's unlocked.
function startBarMove()
  SwingProBarFrame:StartMoving();
end
function stopBarMove()
  SwingProBarFrame:StopMovingOrSizing(); 
end

function SwingPro_BarUpdater()
	--arg1 is the time from OnUpdate passed in.
	if SwingBarEnabled == false then
		return
	end
	timeElapsed = timeElapsed + arg1
    
	if timeElapsed >= SwingProUpdateInterval then
		--printf("TimeElapsed: "..timeElapsed)
		currentWeaponSpeed = UnitAttackSpeed("player")
   		SwingProBarFrame:SetMinMaxValues(0.00,currentWeaponSpeed)
 		

		if weaponSwingTime <= (currentWeaponSpeed - SwingProUpdateInterval) then
			weaponSwingTime = weaponSwingTime + timeElapsed--timeElapsed
			SwingProBarFrame:SetValue(weaponSwingTime)
			BarText:SetText("")
			--BarText:SetText(weaponSwingTime);
			timeElapsed = 0.00
		end
	end
end

function SwingPro_EvtHandler()
	--printf(unpack(args))

	if event == "PLAYER_REGEN_DISABLED" then		--These means you entered combat
		SwingProBarFrame:Show()
	elseif event == "CHAT_MSG_COMBAT_SELF_HITS" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then		--You took a swing
		if SwingBarEnabled ~= true then
			SwingBarEnabled = true
		end
		--printf("OnEvent: "..string.format("%.2f", weaponSwingTime))
		weaponSwingTime = 0.00
		timeElapsed = 0.00
		SwingProBarFrame:SetValue(0.00)

	elseif event ==  "PLAYER_REGEN_ENABLED" then		--These means you left combat
		SwingProBarFrame:Hide()
		SwingBarEnabled = false
		SwingProBarFrame:SetValue(0.00)
	elseif event == "CHAT_MSG_SPELL_SELF_BUFF" then
		--printf(event)
		--printf("--== "..arg1.." ==--")
		if string.find(arg1, "Wisdom")
			or string.find(arg1, "Seal of Light") then
			--printf("Got mana, doing nothing!")
			return
		else
			--printf("Whoa!!! "..arg1)
			ResetSwingTimer()
			ResumeSwingTimer()
		end

	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		--printf(event)
		--printf("--== "..arg1.." ==--")
		if string.find(arg1, "Earth Shock") ~= nil
			or string.find(arg1, "Flame Shock") ~= nil
			then
			--printf("Got mana, doing nothing!")
			return
		else
			--printf("Whoa!!! "..arg1)
			ResetSwingTimer()
			ResumeSwingTimer()
		end
	end
end

function PauseSwingTimer()
	SwingBarEnabled = false
	BarText:SetText("PAUSED")
	ResetSwingTimer()
end

function ResumeSwingTimer()
	SwingBarEnabled = true
	BarText:SetText("")
end

function ResetSwingTimer()
	weaponSwingTime = 0.00
	timeElapsed = 0.00
	SwingProBarFrame:SetValue(0.00)
end

function printf(guts)
	DEFAULT_CHAT_FRAME:AddMessage(guts);
end


-- CHAT_MSG_SPELL_SELF_BUFF 
-- 	"_HEALEDCRITSELFSELF"
-- 	"_HEALEDSELFSELF" 
-- 	"_HEALEDCRITSELFOTHER"
-- 	"_HEALEDSELFOTHER"

-- CHAT_MSG_SPELL_SELF_DAMAGE

-- These two are for school-less "spells" like Heroic Strike.
-- "_SPELLLOGSELFOTHER"
-- "_SPELLLOGCRITSELFOTHER"

-- These are for regular spells (ie. with Frost damage, etc).
-- "_SPELLLOGSCHOOLSELFOTHER"
-- "_SPELLLOGCRITSCHOOLSELFOTHER"
	
-- elseif event == "CHAT_MSG_SPELL_PARTY_BUFF " then
-- 	printf(event)
-- 	printf("--== "..arg1.." ==--")
-- elseif event == "CHAT_MSG_COMBAT_MISC_INFO" then
-- 	printf(event)
-- 	printf("--== "..arg1.." ==--")
-- elseif event == "AURAADDEDOTHERHELPFUL" then
-- 	printf(event)
-- 	printf("--== "..arg1.." ==--")
-- elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
-- 	printf(event)
-- 	printf("--== "..arg1.." ==--")

-- SwingPro:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF")
-- SwingPro:RegisterEvent("CHAT_MSG_COMBAT_MISC_INFO")
-- SwingPro:RegisterEvent("AURAADDEDOTHERHELPFUL")
-- SwingPro:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")