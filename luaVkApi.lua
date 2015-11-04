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

-----------------------
--      Users        --
-----------------------
function luaVkApi.getUsersInfo(userIds, returnedFields, nameCase)
  return luaVkApi.invokeApi("users.get", {user_ids=userIds, fields=returnedFields,
      name_case=nameCase})
end

 --not all parameters are listed here
function luaVkApi.searchUsers(queryString, sortVal, offsetVal, countVal, returnedFields)
  return luaVkApi.invokeApi("users.search", {q=queryString, sort=sortVal, offset=offsetVal,
      count=countVal, fields=returnedFields})
end

function luaVkApi.isAppUser(userId)
  return luaVkApi.invokeApi("users.isAppUser", {user_id=userId})
end

function luaVkApi.getSubscriptions(userId, extendedVal, offsetVal, countVal, fieldsVal)
  return luaVkApi.invokeApi("users.getSubscriptions", {user_id=userId, extended=extendedVal,
      offset=offsetVal, count=countVal, fields=fieldsVal})
end

function luaVkApi.getFollowers(userId, nameCase, offsetVal, countVal, fieldsVal)
  return luaVkApi.invokeApi("users.getFollowers", {user_id=userId, name_case=nameCase,
      offset=offsetVal, count=countVal, fields=fieldsVal})
end

-----------------------
--  Authorization    --
-----------------------
function luaVkApi.checkPhone(phoneNumber, userId, clientSecret)
  return luaVkApi.invokeApi("auth.checkPhone", {phone=phoneNumber, client_id=userId,
      client_secret=clientSecret})
end

function luaVkApi.signup() --!!!not all parameters are listed here
  return luaVkApi.invokeApi("auth.signup", {})
end

function luaVkApi.confirm(userId, clientSecret, phoneNumber, codeVal, passwordVal,
    testMode, introVal)
  return luaVkApi.invokeApi("auth.confirm", {client_id=userId, client_secret=clientSecret,
      phone=phoneNumber, code=codeVal, password=passwordVal, test_mode=testMode,
      intro=introVal})
end

function luaVkApi.restore(phoneNumber)
  return luaVkApi.invokeApi("auth.restore", {phone=phoneNumber})
end

-----------------------
--       Wall        --
-----------------------
function luaVkApi.getWallPosts(ownerId, domainVal, offsetVal, countVal, filterVal,
    isExtended, fieldsVal)
  return luaVkApi.invokeApi("wall.get", {owner_id=ownerId, domain=domainVal,
      offset=offsetVal, count=countVal, filter=filterVal, extended=isExtended,
      fields=fieldsVal})
end

function luaVkApi.searchWallPosts(ownerId, domainVal, queryStr, offsetVal, countVal,
    ownersOnly, filterVal, isExtended, fieldsVal)
  return luaVkApi.invokeApi("wall.search", {owner_id=ownerId, domain=domainVal,
      query=queryStr, offset=offsetVal, count=countVal, owners_only=ownersOnly,
      filter=filterVal, extended=isExtended, fields=fieldsVal})
end

function luaVkApi.getWallById(postIds, isExtended, copyHistoryDepth, fieldsVal)
  return luaVkApi.invokeApi("wall.getById", {posts=postIds, extended=isExtended,
      copy_history_depth=copyHistoryDepth, fields=fieldsVal})
end

function luaVkApi.post(ownerId, friendsOnly, fromGroup, messageVal, postAttachments,
    servicesList, isSigned, publishDate, latitude, longitude, placeId, postId)
  return luaVkApi.invokeApi("wall.post", {owner_id=ownerId, friends_only=friendsOnly,
      from_group=fromGroup, message=messageVal, attachments=postAttachments,
      services=servicesList, signed=isSigned, publish_date=publishDate, lat=latitude,
      long=longitude, place_id=placeId, post_id=postId})
end

function luaVkApi.doRepost(objectId, messageStr, groupId, refVal)
  return luaVkApi.invokeApi("wall.repost", {object=objectId, message=messageStr,
      group_id=groupId, ref=refVal})
end

function luaVkApi.getReposts(ownerId, postId, offsetVal, countVal)
  return luaVkApi.invokeApi("wall.getReposts", {owner_id=ownerId, post_id=postId,
      offset=offsetVal, count=countVal})
end

function luaVkApi.editPost(ownerId, postId, friendsOnly, messageVal, postAttachments,
    servicesList, isSigned, publishDate, latitude, longitude, placeId)
  return luaVkApi.invokeApi("wall.edit", {owner_id=ownerId, post_id=postId, 
      friends_only=friendsOnly, message=messageVal, attachments=postAttachments,
      services=servicesList, signed=isSigned, publish_date=publishDate, lat=latitude,
      long=longitude, place_id=placeId})
end

function luaVkApi.deletePost(ownerId, postId)
  return luaVkApi.invokeApi("wall.delete", {owner_id=ownerId, post_id=postId})
end

function luaVkApi.restorePost(ownerId, postId)
  return luaVkApi.invokeApi("wall.restore", {owner_id=ownerId, post_id=postId})
end

function luaVkApi.pinPost(ownerId, postId)
  return luaVkApi.invokeApi("wall.pin", {owner_id=ownerId, post_id=postId})
end

function luaVkApi.unpinPost(ownerId, postId)
  return luaVkApi.invokeApi("wall.unpin", {owner_id=ownerId, post_id=postId})
end

function luaVkApi.getComments(ownerId, postId, needLikes, startCommentId, offsetVal,
    countVal, sortVal, previewLength, isExtened)
  return luaVkApi.invokeApi("wall.getComments", {owner_id=ownerId, post_id=postId, 
      need_likes=needLikes, start_comment_id=startCommentId, offset=offsetVal,
      count=countVal, sort=sortVal, preview_length=previewLength, extended=isExtened})
end

function luaVkApi.addComment(ownerId, postId, fromGroup, textVal, replyToComment,
    commentAttachments, stickerId, refVal)
  return luaVkApi.invokeApi("wall.addComment", {owner_id=ownerId, post_id=postId, 
      from_group=fromGroup, text=textVal, reply_to_comment=replyToComment,
      attachments=commentAttachments, sticker_id=stickerId, ref=refVal})
end

function luaVkApi.editComment(ownerId, commentId, messageVal, commentAttachments)
  return luaVkApi.invokeApi("wall.editComment", {owner_id=ownerId, comment_id=commentId, 
      message=messageVal, reply_to_comment=replyToComment, attachments=commentAttachments})
end

function luaVkApi.deleteComment(ownerId, commentId)
  return luaVkApi.invokeApi("wall.deleteComment", {owner_id=ownerId, comment_id=commentId})
end

function luaVkApi.restoreComment(ownerId, commentId)
  return luaVkApi.invokeApi("wall.restoreComment", {owner_id=ownerId, comment_id=commentId})
end

function luaVkApi.reportPost(ownerId, postId, reasonVal)
  return luaVkApi.invokeApi("wall.reportPost", {owner_id=ownerId, post_id=postId,
      reason=reasonVal})
end

function luaVkApi.reportComment(ownerId, commentId, reasonVal)
  return luaVkApi.invokeApi("wall.reportComment", {owner_id=ownerId, comment_id=commentId,
      reason=reasonVal})
end

-----------------------
--     Photos        --
-----------------------











function luaVkApi.getNewsFeed(countVal) --not all parameters are listed here
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
		if (userIds.length() > 0)
			userIds = JSONUtils.removeDuplicateIds(userIds);
		return userIds.toString();
	}
]]

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
