--LUA Code file for Vanilla WhisperTech
wtState = "enabled"



--Resolver chat / command to toggle on and off
SLASH_WHISPERTECH1 = '/wttoggle'

function SlashCmdList.WHISPERTECH(msg, editbox) 
	if wtState == "enabled" then
		WTMain:UnregisterEvent("CHAT_MSG_WHISPER");
		wtState = "disabled"
		printf("Whipser Tech: Off")
	else
		WTMain:RegisterEvent("CHAT_MSG_WHISPER");
		wtState = "enabled"
		printf("Whisper Tech: On")
	end
end



function WhisperTech_OnLoad()
	WTMain:RegisterEvent("CHAT_MSG_WHISPER");
	--WTMain:Hide();
end

function WhisperTech_Respond()
	--Events are passed like this: self, event, arg1, arg2, ...
	--arg1 = chat message, arg2 = author or sender of message
	--printf(event)
	--printf(arg1)
	--printf(arg2)
	local msg = arg1
	local author = arg2
	if event == "CHAT_MSG_WHISPER" then
		if msg == "wtfollow" then
			TargetByName(author)
			FollowByName(author)
			SendChatMessage("%t, they come for you! (also, I'm on follow)", "WHISPER", "Common", author);
		end
	end
		
end

