#!/usr/bin/env lua
local rando = {}


function rando.talkSmack()
	fromThisNum = 1
	toThisNum = 20 --/ inputNum
	
	--print("Date: "..os.date())
	--print("Time: "..os.time())
	
	math.randomseed(os.time())
	rando = math.random(fromThisNum, toThisNum)
	print(rando)

	-- List of smack to talk.
	Smack = {"hi", "hello", "Whatup", "Go Fly a Kyte!", "Derp"}
	
	if rando == 1 then
		--os.execute("sleep 1")
		math.randomseed(os.time()+1)
		randomSmack = math.random(1,5)
		print(Smack[randomSmack])
		return 1
	end
	
	return 0
end

return rando