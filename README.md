lvk v1.0 (ex. luaVkApi)
=========

[![release](https://img.shields.io/badge/release-v1.0-brightgreen.png?style=default)](https://github.com/last-khajiit/lvk/releases/latest) [![Build Status](https://travis-ci.org/last-khajiit/lvk.svg?branch=master)](https://travis-ci.org/last-khajiit/lvk) [![Available through Luarocks https://luarocks.org/modules/lastkhajiit/lvk](https://img.shields.io/badge/luarocks-1.0--1-brightgreen.svg)](https://luarocks.org/modules/lastkhajiit/lvk) [![Join the chat at https://gitter.im/lvk-chat/Lobby](https://badges.gitter.im/lvk-chat/Lobby.svg)](https://gitter.im/lvk-chat/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Lua library for work with [RESTful API](https://vk.com/dev/methods) of [vk.com](https://vk.com). Implementation for 5.62 API version.

Compatible with Lua 5.2 and 5.3.

### Usage
Install lvk using [Luarocks](https://luarocks.org/):
```
luarocks install lvk
```

Add lvk to your code:
```lua
local Lvk = require "lvk"
```

Create instance of the lvk using a constructor and passing there your secret token and version as parameters:
```lua
local secretKey = "ee272c9214611c082d397def7da4368d2baa5d1805aa3dcbb989a2e52bf0cec8c69da547b5d54b524da56"
local api = Lvk:new(secretKey, "5.62")
```

Now you can invoke all REST methods of vk.com, for example:
```lua
print(api:getStatus()) --print current user status

local userId = "201838325"
print(api:getStatus(userId)) --print user status for mentioned user
```

The response is usual string, but you can use _toTable_ method to convert it to Lua table:
```lua
local responce = api:getStatus()
local responceTable = api:toTable(responce) --cast raw responce to Lua table
print(responceTable.response.text)
```

If you want to see version of lvk library and version of vk.com API you can use _getVersion_ and _getVkApiVersion_ methods:
```lua
print(api:getVersion()) --return 1.0 version
print(api:getVkApiVersion()) --return version which you use in lvk constructor
```

### Required Luarocks packages

- [luasec](https://luarocks.org/modules/brunoos/luasec)
- [dkjson](https://luarocks.org/modules/dhkolf/dkjson)


*Feel free to make pull requests!*


---

**Copyright © 2017 Last Khajiit <last.khajiit@gmail.com>**

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the [COPYING](https://raw.githubusercontent.com/last-khajiit/lua-vk-api/master/copying.txt) file for more details.
