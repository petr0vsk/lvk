lua-vk-api
=========

Lua library for vk.com REST API

---

## Description

Lua wrapper-functions for [REST API methods](https://vk.com/dev/methods) of [vk.com](https://vk.com). Implementation for 5.40 version of API.

## Usage

Set up your *accessToken* in *luaVkApi.properties*, for instance:
```
accessToken=ee272c9214611c082d397def7da4368d2baa5d1805aa3dcbb989a2e52bf0cec8c69da547b5d54b524da56
```
and add luaVkApi to your code:
```lua
local luaVkApi = require "luaVkApi";

print(luaVkApi.getStatus()) --print current user status

local userId = "201838325"
print(luaVkApi.getStatus(userId)) --print user status for mentioned user
```

## Required packages

- ssl.https: https://github.com/brunoos/luasec/blob/master/src/https.lua
