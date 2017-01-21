package = "LuaVkApi"
version = "0.3.2-1"
source = {
  url = "https://github.com/last-khajiit/luaVkApi",
  tag = "luaVkApi-0.3.2"
}
description = {
  summary = "Lua library for vk.com REST API",
  detailed = [[
luaVkApi is Lua wrapper library for REST API of vk.com. 

Implementation for 5.62 version of API.
]],
  homepage = "https://github.com/last-khajiit/luaVkApi",
  license = "WTFPL2"
}
dependencies = {
  "lua >= 5.2", "dkjson", "luasec"
}
build = {
  type = "builtin",
  modules = {
    LuaVkApi = "LuaVkApi.lua"
  }
}
