-- Author: Souldoubt
-- Date: 11/2/2016
-- Let's talk some Smack. 


function smack_CreateMenuFrames()
--==============  Create the drop down list of supported trigger events ==================================
--========================================================================================================
	-- Create Trigger Event Drop Down frame
	dropDownFrame = CreateFrame("Frame", "SmackTriggerDropDown", SmackTalkMain, "SmackDropdownTemplate")
	dropDownFrame:SetPoint("BOTTOMLEFT", SmackTalkMain, "TOPLEFT", 18, -100)

	-- Create label for Trigger Event drop down
	dropDownLabel = SmackTriggerDropDown:CreateFontString("TriggerFontString", "OVERLAY", "GameFontNormal")
	dropDownLabel:SetText("Trigger Event")
	dropDownLabel:SetPoint("BOTTOMLEFT", SmackTriggerDropDown, "TOPLEFT", 18, 1)

--==============  Create edit box for entering the integer for % to proc the rule ========================
--========================================================================================================
	-- Create Edit box for %Proc
	procEditBox = CreateFrame("EditBox", "SmackProcEditBox" , SmackTalkMain, "Smack_EditBoxTemplate")
	procEditBox:SetWidth(125)
	procEditBox:SetHeight(20)
	procEditBox:SetPoint("TOPLEFT", SmackTalkMain, "TOPLEFT", 40, -120)

	-- Create Label for %Proc Edit Box
	procLabel = SmackProcEditBox:CreateFontString("ProcFontString", "OVERLAY", "GameFontNormal")
	procLabel:SetText("Proc Rate %")
	procLabel:SetPoint("BOTTOMLEFT", SmackProcEditBox, "TOPLEFT", 0, 1)

	-- Create Edit box for String 1 of smack to talk
	smackStr1EditBox = CreateFrame("EditBox", "SmackStringEditBox" , SmackTalkMain, "Smack_EditBoxTemplate")
	smackStr1EditBox:SetWidth(425)
	smackStr1EditBox:SetHeight(20)
	smackStr1EditBox:SetPoint("TOPLEFT", SmackTalkMain, "TOPLEFT", 40, -200)


--============  Create the 3 String entry boxes for each smack rule entry ================================
--========================================================================================================
	-- Create Label for String 1 Edit Box
	strOneLabel = SmackStringEditBox:CreateFontString("strOneFontString", "OVERLAY", "GameFontNormal")
	strOneLabel:SetText("Smack String 1")
	strOneLabel:SetPoint("BOTTOMLEFT", SmackStringEditBox, "TOPLEFT", 0, 1)

	-- Create Edit box for String 2 of smack to talk
	smackStr2EditBox = CreateFrame("EditBox", "SmackString2EditBox" , SmackTalkMain, "Smack_EditBoxTemplate")
	smackStr2EditBox:SetWidth(425)
	smackStr2EditBox:SetHeight(20)
	smackStr2EditBox:SetPoint("TOPLEFT", SmackTalkMain, "TOPLEFT", 40, -240)

	-- Create Label for String 2 Edit Box
	strTwoLabel = SmackString2EditBox:CreateFontString("strOneFontString", "OVERLAY", "GameFontNormal")
	strTwoLabel:SetText("Smack String 2")
	strTwoLabel:SetPoint("BOTTOMLEFT", SmackString2EditBox, "TOPLEFT", 0, 1)

	-- Create Edit box for String 3 of smack to talk
	smackStr3EditBox = CreateFrame("EditBox", "SmackString3EditBox" , SmackTalkMain, "Smack_EditBoxTemplate")
	smackStr3EditBox:SetWidth(425)
	smackStr3EditBox:SetHeight(20)
	smackStr3EditBox:SetPoint("TOPLEFT", SmackTalkMain, "TOPLEFT", 40, -280)

	-- Create Label for String 3 Edit Box
	strThreeLabel = SmackString3EditBox:CreateFontString("strOneFontString", "OVERLAY", "GameFontNormal")
	strThreeLabel:SetText("Smack String 2")
	strThreeLabel:SetPoint("BOTTOMLEFT", SmackString3EditBox, "TOPLEFT", 0, 1)



	--SmackTalkMain:Hide()

end


function smack_dropDownInit()
	if string.find(this:GetName(), "SmackTriggerDropDown") then
		local infoTable = {}
		infoTable.remaining = false


		infoTable.text = "White Hit"
		infoTable.value = 1
		infoTable.func = smackTrigger1_callBack
		UIDropDownMenu_AddButton(infoTable)
		
		infoTable = {}
		infoTable.remaining = false

		infoTable.text = "Spell or Special"
		infoTable.value = 2
		infoTable.func = smackTrigger1_callBack
		UIDropDownMenu_AddButton(infoTable)
	end

end

function smackTrigger1_callBack()
	local dropDownListID = this:GetID()
	UIDropDownMenu_SetSelectedID(SmackTriggerDropDown, dropDownListID)
	printf(dropDownListID)
end
