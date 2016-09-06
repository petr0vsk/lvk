local LuaVkApi = {}
local LuaVkApi_mt = {
  __metatable = {},
  __index = LuaVkApi
}

local https = require("ssl.https")
local json = require ("dkjson")

local apiRequest = "https://api.vk.com/method/{METHOD_NAME}" .. "?{PARAMETERS}"
  .. "&access_token={ACCESS_TOKEN}" .. "&v={API_VERSION}"

 
function LuaVkApi:new(token, apiVersion)
    if self ~= LuaVkApi then
        return nil, "First argument must be self"
    end
 
    local o = setmetatable({}, LuaVkApi_mt)
    o._token = token
	o._apiVersion = apiVersion
    return o
end

setmetatable(LuaVkApi, {
  __call = LuaVkApi.new
})

-----------------------
--Common util methods--
-----------------------
function LuaVkApi:invokeApi(method, params)
  -- parse method parameters
  local parameters = ""
  if params ~= nil then
    for key, value in pairs(params) do
      parameters = parameters .. key .. "=" .. value .. "&"
    end
  end

  local reqUrl = string.gsub(apiRequest, "{METHOD_NAME}", method)
  reqUrl = string.gsub(reqUrl, "{ACCESS_TOKEN}", self._token)
  reqUrl = string.gsub(reqUrl, "{API_VERSION}", self._apiVersion)
  reqUrl = string.gsub(reqUrl, "{PARAMETERS}&", parameters)
  return https.request(reqUrl)
end

function LuaVkApi:stringToJSON(jsonString_)
  local jsonString = jsonString_
  return json.decode(jsonString, 1, nil)
end

function LuaVkApi:jsonToString(jsonObject_)
  local jsonObject = jsonObject_
  return json.encode(jsonObject)
end

function LuaVkApi:getStatus(userId, groupId)
  return self:invokeApi("status.get", {user_id=userId, group_id=groupId})
end

return LuaVkApi