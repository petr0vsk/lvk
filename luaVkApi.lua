local https = require("ssl.https")

local luaVkApi = {}

local authUrl = "https://oauth.vk.com/authorize" .. "?client_id={APP_ID}"
		.. "&scope={PERMISSIONS}" .. "&redirect_uri={REDIRECT_URI}" 
		.. "&display={DISPLAY}" .. "&v={API_VERSION}" .. "&response_type=token"
local apiRequest = "https://api.vk.com/method/{METHOD_NAME}" .. "?{PARAMETERS}"
		.. "&access_token={ACCESS_TOKEN}" .. "&v={API_VERSION}"

function luaVkApi.invokeApi(method, params)
	-- load properties
	file = io.open("luaVkApi.properties")
	local properties = {}
	for line in file:lines() do
		for key, value in string.gmatch(line, "(.-)=(.-)$") do 
			properties[key] = value 
		end
	end	
	
	-- parse method parameters
	local parameters = ""	
	if params ~= nil then
		for key, value in pairs(params) do
			parameters = parameters .. key .. "=" .. value .. "&"
		end
	end
	
	local reqUrl = string.gsub(apiRequest, "{METHOD_NAME}", method)
	reqUrl = string.gsub(reqUrl, "{ACCESS_TOKEN}", properties.accessToken)
	reqUrl = string.gsub(reqUrl, "{API_VERSION}", properties.apiVersion)
	reqUrl = string.gsub(reqUrl, "{PARAMETERS}&", parameters)		
	return https.request(reqUrl)
end

function luaVkApi.getNewsFeed(countVal)
	if countVal == nil then 
		countVal = "100"
	end
	return luaVkApi.invokeApi("newsfeed.get", {count=countVal})
end

function luaVkApi.getAlbums(userId)
	--Params.create().add("owner_id", userId).add("photo_sizes", "1").add("thumb_src", "1"));
	return luaVkApi.invokeApi("photos.getAlbums", {count=countVal})
end

function luaVkApi.getStatus(userId)
	return luaVkApi.invokeApi("status.get", {user_id=userId})
end

function luaVkApi.getFriendIds(userId)
	return luaVkApi.invokeApi("friends.get", {user_id=userId})
end

function luaVkApi.addToFriends(userId)
	return luaVkApi.invokeApi("friends.add", {user_id=userId})
end

function luaVkApi.getWallPosts(ownerId, countVal)
	if countVal == nil then 
		countVal = "100"
	end
	return luaVkApi.invokeApi("wall.get", {owner_id=ownerId, count=countVal})
end

function luaVkApi.searchNews(keyWord, countVal)
	if countVal == nil then 
		countVal = "200"
	end
	return luaVkApi.invokeApi("newsfeed.search", {q=keyWord, count=countVal})
end

function luaVkApi.getFriendsOfFriendsIds()
	return ""
end
--[[
public String getFriendsOfFriendsIds() {
		JSONArray userIds = new JSONArray();
		try {
			String myFriendIdResponse = invokeApi("friends.get",
					Params.create().add("user_id", propertyManager.getProp(Properties.CURRENT_USER_ID)));
			JSONArray friendIds = new JSONObject(myFriendIdResponse).getJSONObject("response").getJSONArray("items");
			for (int i = 0; i < friendIds.length(); i++) {
				Thread.sleep(Integer.parseInt(
						propertyManager.getProp(Properties.REQUESTS_DELAY, propertyManager.DEFAULT_REQUESTS_DELAY)));
				String friendIdResponse = invokeApi("friends.get",
						Params.create().add("user_id", friendIds.get(i).toString()));
				if (friendIdResponse.contains("response") && friendIdResponse.contains("items")) {
					JSONArray friendOfFriendIds = new JSONObject(friendIdResponse).getJSONObject("response")
							.getJSONArray("items");
					userIds = JSONUtils.concatArray(userIds, friendOfFriendIds);
				}
			}
		} catch (IOException e) {
			Logger.error(e);
		} catch (JSONException e) {
			Logger.error(e);
		} catch (InterruptedException e) {
			Logger.error(e);
		}
		if (userIds.length() > 0)
			userIds = JSONUtils.removeDuplicateIds(userIds);

		return userIds.toString();
	}
]]

function luaVkApi.doRepost(objectId)
	return luaVkApi.invokeApi("wall.repost", {object=objectId})
end

function luaVkApi.putLike(itemId, entityType)
	return luaVkApi.invokeApi("likes.add", {item_id=itemId, type=entityType})
end

function luaVkApi.joinCommunity(groupId)
	return luaVkApi.invokeApi("groups.join", {group_id=groupId})
end

function luaVkApi.searchCommunities(searchWord, countVal)
	if countVal == nil then 
		countVal = "1000"
	end
	return luaVkApi.invokeApi("groups.search", {q=searchWord, count=countVal})
end

function luaVkApi.getCommunityById(groupId)
	return luaVkApi.invokeApi("groups.getById", {group_id=groupId})
end

function luaVkApi.getUserCommunities(userId, countVal)
	if countVal == nil then 
		countVal = "1000"
	end
	return luaVkApi.invokeApi("groups.get", {user_id=groupId, count=countVal})
end

function luaVkApi.getPrivateMessages()
	return luaVkApi.invokeApi("messages.get")
end

return luaVkApi