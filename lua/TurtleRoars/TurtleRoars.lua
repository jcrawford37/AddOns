-- 26 AUG 2021
-- Turtle Wow Functions to listen for /roar emote
-- Handle event and play proper soundfile

--===============================================================================
--==                    Global Variables                                       ==
--===============================================================================
tr_enable = true
use_chat_method = false					--Original addon does a target, target last target
                                        --If this is set to true, it uses a /who method instead
                                        --but prints to the chat window. The target method MAY
                                        --cause issues in combat, the chat method WILL print to chat.

--===============================================================================
--==                    Slash Command Registry                                 ==
--===============================================================================
function TurtleRoars_OnLoad()
	-- Use TR short for turtle roar
	SLASH_TURTLEROAR1 = "/tr"
	local function trSlashCommand(msg, editbox)
		SlashCommandHandler(msg)
	end
	
	-- Register function to slash command
	SlashCmdList["TURTLEROAR"] = SlashCommandHandler

	TurtleRoarsMain:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
	TurtleRoarsMain:RegisterEvent("CHAT_MSG_EMOTE")
    --TurtleRoarsMain:RegisterEvent("CHAT_MSG_SYSTEM")

end

--===============================================================================
--==                    CLI Functions                                          ==
--===============================================================================
function SlashCommandHandler(msg)
    if msg == "disable" then
    	tr_enable = false
    	printf("Disabling /roar Sounds")
    end

    if msg == "enable" then
    	tr_enable = true
    	printf("Enabling /roar Sounds")
    end
    if msg == "target" then
    	use_chat_method = false
    	printf("Turtle Roars: Using Target method")
    elseif msg == "chat" then
        use_chat_method = true
        printf("Turtle Roars: Using Chat method")
    end
end

function TurtlePrintHelp()

end


--===============================================================================
--==                    Event Handling                                         ==
--===============================================================================
function TurtleRoars_OnEvent()
	--event, arg1, arg2 variables passed in by frame
	--arg1 = Text of the emote example: You roar with bestial vigor. So fierce!
	--arg2 = Player Name that emoted. example: Souldoubt
    --printf(event)
	-- if arg1 ~= nil then
	-- 	printf(arg1)
	-- end

	-- if arg2 ~= nil then
	-- 	printf(arg2)
	-- end

	-- if arg3 ~= nil then
	-- 	printf(arg3)
	-- end

	-- Don't handle Events.
	if not tr_enable then
		return
	end


   
    -- CHAT_MSG_TEXT_EMOTE is /roar is custom emote using /e that contains the word roar
	if event == "CHAT_MSG_TEXT_EMOTE" or event=="CHAT_MSG_EMOTE" then
		-- Make sure that was a roar we just heard.
		incoming_emote_str = string.lower(arg1)
	
		if string.find(incoming_emote_str, "roar") ~= nil then
			TargetMethodRoar(arg2)
			--printf("Is Roar was true")
		end
		
	end
    
	if event == "CHAT_MSG_SYSTEM" then
		-- Check if it was a /who return. Seems gross,
		-- but I'm tired and it works
		if string.find(arg1, ": Level") then
			whoReturnVal = string.lower(arg1)
		end
	end
end

-- This function has to target the roarer
-- Figure out Sex/Race to play the right sound file
-- Then targets last target. Could cause issues if heavy roaring
-- during combat.
function TargetMethodRoar(roarer_name)
	TargetByName(roarer_name)
	roar_sex = UnitSex("target")
	roar_race = UnitRace("target")
	TargetLastTarget()
	
	--printf("A "..roar_race.." "..roar_sex.." just let out a roar!")
   
    if roar_sex == 2 then
    	roar_sex = "male"
    else
    	-- Technically Female is 3, and "unknown is 1"
    	-- Let's just scream like a female if we don't know
    	roar_sex = "female"
    end
	   
    roar_race = string.lower(roar_race)
    roar_race = string.gsub(roar_race, "%s+", "")
    local roar_file_name = roar_race.."_"..roar_sex.."_roar.mp3"

    --printf("Roar File: "..roar_file_name)
	PlaySoundFile("Interface\\AddOns\\TurtleRoars\\roar_sounds\\"..roar_file_name)
end

function ChatMethodRoar(roarer_name)

end

--===============================================================================
--==                    Utility Functions                                      ==
--===============================================================================
function printf(guts)
	DEFAULT_CHAT_FRAME:AddMessage(guts);
end