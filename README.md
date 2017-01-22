luaVkApi v0.3.1
=========

[![release](https://img.shields.io/badge/release-v0.3.1-brightgreen.png?style=default)](https://github.com/last-khajiit/lua-vk-api/releases/latest) [![Build Status](https://travis-ci.org/last-khajiit/luaVkApi.svg?branch=master)](https://travis-ci.org/last-khajiit/luaVkApi) [![Available through Luarocks https://luarocks.org/modules/lastkhajiit/luavkapi](https://img.shields.io/badge/luarocks-0.3.1--1-brightgreen.svg)](https://luarocks.org/modules/lastkhajiit/luavkapi) [![Join the chat at https://gitter.im/lua-vk-api/Lobby](https://badges.gitter.im/lua-vk-api/Lobby.svg)](https://gitter.im/lua-vk-api/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Lua wrapper library for [RESTful API](https://vk.com/dev/methods) of [vk.com](https://vk.com). Implementation for 5.62 version of API.

### Usage
Install LuaVkApi using [Luarocks](https://luarocks.org/):
```
luarocks install luavkapi
```

Add LuaVkApi to your code:
```lua
local LuaVkApi = require "LuaVkApi"
```

Create instance using constructor and passing there your secret token and version as parameters:
```lua
local api = LuaVkApi:new("ee272c9214611c082d397def7da4368d2baa5d1805aa3dcbb989a2e52bf0cec8c69da547b5d54b524da56", "5.62")
```

Now you can invoke all VK REST API methods, for example:
```lua
print(api:getStatus().text) --print current user status

local userId = "201838325"
print(api:getStatus(userId).text) --print user status for mentioned user
```
The response is usual table, but you can use _toString_ method for converting it to string:
```lua
local status = api:getStatus(1)
local statusStr = api:toString(status)
print(statusStr) --print {"text":"道德經"}
```

### Required Luarocks packages

- [luasec](https://luarocks.org/modules/brunoos/luasec)



*Feel free to make pull requests!*


---

**Copyright © 2017 Last Khajiit <last.khajiit@gmail.com>**

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the [COPYING](https://raw.githubusercontent.com/last-khajiit/lua-vk-api/master/copying.txt) file for more details.
