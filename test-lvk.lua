local Lvk = require "lvk"

local dummyToken = "ee272c4213611c082d397def7da4368d2baa5d1805aa3dcbb989a2e52bf0cec8c69da547b5d54b524da56"
local api = Lvk:new(dummyToken, "5.62")

print(api:getVersion())
print(api:getVkApiVersion())
