lua-vk-api
=========

[![Join the chat at https://gitter.im/lua-vk-api/Lobby](https://badges.gitter.im/lua-vk-api/Lobby.svg)](https://gitter.im/lua-vk-api/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
Lua wrapper-functions for [REST API methods](https://vk.com/dev/methods) of [vk.com](https://vk.com). Implementation for 5.40 version of API.

### Usage

Set up your *accessToken* in *luaVkApi.properties*, for instance:
```
accessToken=ee272c9214611c082d397def7da4368d2baa5d1805aa3dcbb989a2e52bf0cec8c69da547b5d54b524da56
```
and add luaVkApi to your code:
```lua
local luaVkApi = require "luaVkApi";
```

Now you can invoke all VK REST API methods, for examplpe:
```lua
print(luaVkApi.getStatus()) --print current user status

local userId = "201838325"
print(luaVkApi.getStatus(userId)) --print user status for mentioned user
```
Response is usual string, but you can use _stringToJSON_ method for comverting to table:
```lua
statusStr = luaVkApi.getStatus()
status = luaVkApi.stringToJSON(statusStr)
print(status.response.text)
```

### Required packages

- ssl.https: https://github.com/brunoos/luasec/blob/master/src/https.lua
- dkjson: https://github.com/LuaDist/dkjson

*Feel free to make pull requests!*


---

**Copyright © 2016 Last Khajiit <last.khajiit@gmail.com>**

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the [COPYING](https://raw.githubusercontent.com/last-khajiit/lua-vk-api/master/copying.txt) file for more details.
