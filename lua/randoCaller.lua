#!/usr/bin/env lua

rando = require("rando")
count = 0


for i=1,100 do
	print("Run #: "..i)
	
	count = count + rando.talkSmack()
	--dofile("rando.lua")
	os.execute("sleep 1")
end	

print("Count out of 100: "..count)