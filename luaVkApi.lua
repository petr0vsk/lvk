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
function luaVkApi.getAlbums(userId)
  --Params.create().add("owner_id", userId).add("photo_sizes", "1").add("thumb_src", "1"));
  return luaVkApi.invokeApi("photos.getAlbums", {count=countVal})
end

-----------------------
--     Friends       --
-----------------------
function luaVkApi.getFriendIds(userId, orderVal, listId, countVal, offsetVal, 
    fieldsVal, nameCase)
  return luaVkApi.invokeApi("friends.get", {user_id=userId, order=orderVal, list_id=listId, 
      count=countVal, offset=offsetVal, fields=fieldsVal, name_case=nameCase})
end

function luaVkApi.addToFriends(userId, textVal, followVal)
  return luaVkApi.invokeApi("friends.add", {user_id=userId, text=textVal, follow=followVal})
end

function luaVkApi.getOnlineFriends(userId, listId, onlineMobile, sortOrder, countVal, offsetVal)
  return luaVkApi.invokeApi("friends.getOnline", {user_id=userId, list_id=listId,
      online_mobile=onlineMobile, order=sortOrder, count=countVal, offset=offsetVal})
end

function luaVkApi.getMutualFriends(sourceUid, targetUid, targetUids, sortOrder,
    countVal, offsetVal)
  return luaVkApi.invokeApi("friends.getMutual", {source_uid=sourceUid, target_uid=targetUid,
      target_uids=targetUids, order=sortOrder, count=countVal, offset=offsetVal})
end

function luaVkApi.getRecentFriends(countVal)
  return luaVkApi.invokeApi("friends.getRecent", {count=countVal})
end

function luaVkApi.getFriendsRequests(countVal, offsetVal, extended, needMutual, outVal, sortVal,
    suggestedVal)
  return luaVkApi.invokeApi("friends.getRequests", {count=countVal, offset=offsetVal, 
      extended=extendedVal, need_mutual=needMutual, out=outVal, sort=sortVal, suggested=suggestedVal})
end

function luaVkApi.editFriendsList(userId, listIds)
  return luaVkApi.invokeApi("friends.edit", {user_id=userId, list_ids=listIds})
end

function luaVkApi.deleteFriend(userId)
  return luaVkApi.invokeApi("friends.delete", {user_id=userId})
end

function luaVkApi.getFriendsOfFriendsIds(userId, returnSystem)
  return luaVkApi.invokeApi("friends.getLists", {user_id=userId, return_system=returnSystem})
end

function luaVkApi.addFriendList(nameVal, userIds)
  return luaVkApi.invokeApi("friends.addList", {name=nameVal, user_ids=userIds})
end

function luaVkApi.editFriendList(nameVal, listId, userIds, addUserIds, deleteUserIds)
  return luaVkApi.invokeApi("friends.editList", {name=nameVal, list_id=listId, user_ids=userIds,
      add_user_ids=addUserIds, delete_user_ids=deleteUserIds})
end

function luaVkApi.deleteFriendList(listId)
  return luaVkApi.invokeApi("friends.deleteList", {list_id=listId})
end

function luaVkApi.getAppUsers()
  return luaVkApi.invokeApi("friends.getAppUsers")
end

function luaVkApi.getUsersByPhones(phonesVal, fieldsVal)
  return luaVkApi.invokeApi("friends.getByPhones", {phones=phonesVal, fields=fieldsVal})
end

function luaVkApi.deleteAllFriendsRequests()
  return luaVkApi.invokeApi("friends.deleteAllRequests")
end

function luaVkApi.getFriendsSuggestions(filterVal, countVal, offsetVal,fieldsVal, nameCase)
  return luaVkApi.invokeApi("friends.getSuggestions", {filter=filterVal, count=countVal,
      offset=offsetVal, fields=fieldsVal, name_case=nameCase})
end

function luaVkApi.areFriends(userIds, needSign)
  return luaVkApi.invokeApi("friends.areFriends", {user_ids=userIds, need_sign=needSign})
end

function luaVkApi.getAvailableFriendsForCall(fieldsVal, nameCase)
  return luaVkApi.invokeApi("friends.getAvailableForCall", {fields=fieldsVal, name_case=nameCase})
end

function luaVkApi.searchFriends(userId, query, fieldsVal, nameCase, offsetVal, countCal)
  return luaVkApi.invokeApi("friends.search", {user_id=userId, q=query, fields=fieldsVal,
      name_case=nameCase, offset=offsetVal, count=countVal})
end

-----------------------
--     Widgets       --
-----------------------
function luaVkApi.getCommentsFromWidget(widgetApiId, urlStr, pageId, orderVal,
    fieldsVal, offsetVal, countCal)
  return luaVkApi.invokeApi("widgets.getComments", {widget_api_id=widgetApiId, url=urlStr,
      page_id=pageId, order=orderVal, fields=fieldsVal, offset=offsetVal, count=countVal})
end

function luaVkApi.getPagesWithWidget(widgetApiId, orderVal, periodVal, offsetVal, countCal)
  return luaVkApi.invokeApi("widgets.getPages", {widget_api_id=widgetApiId, order=orderVal,
      page_id=pageId, order=orderVal, period=periodVal, offset=offsetVal, count=countVal})
end

-----------------------
--    Data storage   --
-----------------------
function luaVkApi.getStorageVariable(keyStr, keysStr, userId, globalVal)
  return luaVkApi.invokeApi("storage.get", {key=keyStr, keys=keysStr, user_id=userId,
      global=globalVal})
end

function luaVkApi.setStorageVariable(keyStr, valueStr, userId, globalVal)
  return luaVkApi.invokeApi("storage.set", {key=keyStr, value=valueStr, user_id=userId,
      global=globalVal})
end

function luaVkApi.getVariableKeys(userId, globalVal, offsetVal, countVal)
  return luaVkApi.invokeApi("storage.getKeys", {user_id=userId, global=globalVal,
      offset=offsetVal, count=countVal})
end

-----------------------
--      Status       --
-----------------------
function luaVkApi.getStatus(userId, groupId)
  return luaVkApi.invokeApi("status.get", {user_id=userId, group_id=groupId})
end

function luaVkApi.setStatus(textVal, groupId)
  return luaVkApi.invokeApi("status.set", {text=textVal, group_id=groupId})
end

-----------------------
--    Audio files    --
-----------------------

-----------------------
--       Pages       --
-----------------------

-----------------------
--    Communities    --
-----------------------
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

-----------------------
--      Boards       --
-----------------------

-----------------------
--      Videos       --
-----------------------

-----------------------
--       Notes       --
-----------------------

-----------------------
--      Places       --
-----------------------

-----------------------
--      Account      --
-----------------------

-----------------------
--     Messages      --
-----------------------
function luaVkApi.getPrivateMessages()
  return luaVkApi.invokeApi("messages.get")
end

-----------------------
--      News         --
-----------------------
function luaVkApi.getNewsFeed(countVal) --not all parameters are listed here
  if countVal == nil then
    countVal = "100"
  end
  return luaVkApi.invokeApi("newsfeed.get", {count=countVal})
end

function luaVkApi.searchNews(keyWord, countVal)
  if countVal == nil then
    countVal = "200"
  end
  return luaVkApi.invokeApi("newsfeed.search", {q=keyWord, count=countVal})
end

-----------------------
--      Likes        --
-----------------------
function luaVkApi.putLikerIds(typeVal, ownerId, itemId, pageUrl, filterVal,
    friendsOnly, isExtended, offsetVal, countVal, skipOwn)
  return luaVkApi.invokeApi("likes.getList", {type=typeVal, owner_id=ownerId,
      item_id=itemId, page_url=pageUrl, filter=filterVal, friends_only=friendsOnly,
      extended=isExtended, offset=offsetVal, count=countVal, skip_own=skipOwn})
end

function luaVkApi.putLike(entityType, ownerId, itemId, accessKey, refStr)
  return luaVkApi.invokeApi("likes.add", {type=entityType, owner_id=ownerId,
      item_id=itemId, access_key=accessKey, ref=refStr})
end

function luaVkApi.deleteLike(entityType, ownerId, itemId)
  return luaVkApi.invokeApi("likes.delete", {type=entityType, owner_id=ownerId,
      item_id=itemId})
end

function luaVkApi.isLiked(userId, entityType, ownerId, itemId)
  return luaVkApi.invokeApi("likes.isLiked", {user_id=userId, type=entityType,
      owner_id=ownerId, item_id=itemId})
end

-----------------------
--      Polls        --
-----------------------
function luaVkApi.getPollById(ownerId, isBoard, pollId)
  return luaVkApi.invokeApi("polls.getById", {owner_id=ownerId, is_board=isBoard, 
      poll_id=pollId})
end

function luaVkApi.addVote(ownerId, pollId, answerId, isBoard)
  return luaVkApi.invokeApi("polls.addVote", {owner_id=ownerId, poll_id=pollId, 
      answer_id=answerId, is_board=isBoard})
end

function luaVkApi.deleteVote(ownerId, pollId, answerId, isBoard)
  return luaVkApi.invokeApi("polls.deleteVote", {owner_id=ownerId, poll_id=pollId, 
      answer_id=answerId, is_board=isBoard})
end

function luaVkApi.getVoters(ownerId, pollId, answerIds, isBoard, friendsOnly, offsetVal,
    countVal, fieldsVal, nameCase)
  return luaVkApi.invokeApi("polls.getVoters", {owner_id=ownerId, poll_id=pollId, 
      answer_ids=answerIds, is_board=isBoard, friends_only=friendsOnly, offset=offsetVal,
      count=countVal, fields=fieldsVal, name_case=nameCase})
end

function luaVkApi.createPoll(questionStr, isAnonymous, ownerId, addAnswers)
  return luaVkApi.invokeApi("polls.create", {question=questionStr, is_anonymous=isAnonymous, 
      owner_id=ownerId, add_answers=addAnswers})
end

function luaVkApi.editPoll(ownerId, pollId, questionStr, addAnswers, editAnswers, 
    deleteAnswers)
  return luaVkApi.invokeApi("polls.edit", {owner_id=ownerId, poll_id=pollId,
      question=questionStr, question=questionStr, add_answers=addAnswers,
      edit_answers=editAnswers, delete_answers=deleteAnswers})
end

-----------------------
--    Documents      --
-----------------------
function luaVkApi.getDocuments(countVal, offsetVal, ownerId)
  return luaVkApi.invokeApi("docs.get", {count=countVal, offset=offsetId, owner_id=ownerId})
end

function luaVkApi.getDocumentsById(docsVal)
  return luaVkApi.invokeApi("docs.getById", {docs=docsVal})
end

function luaVkApi.getUploadServer(groupId)
  return luaVkApi.invokeApi("docs.getUploadServer", {group_id=groupId})
end

function luaVkApi.getWallUploadServer(groupId)
  return luaVkApi.invokeApi("docs.getWallUploadServer", {group_id=groupId})
end

function luaVkApi.saveDoc(docFile, titleVal, tagsVal)
  return luaVkApi.invokeApi("docs.save", {file=docFile, title=titleVal, tags=tagsVal})
end

function luaVkApi.deleteDoc(ownerId, docId)
  return luaVkApi.invokeApi("docs.delete", {owner_id=ownerId, doc_id=docId})
end

function luaVkApi.addDoc(ownerId, docId, accessKey)
  return luaVkApi.invokeApi("docs.add", {owner_id=ownerId, doc_id=docId, access_key=accessKey})
end

-----------------------
--    Favorites      --
-----------------------
function luaVkApi.getBookmarkers(offsetVal, countVal)
  return luaVkApi.invokeApi("fave.getUsers", {offset=offsetVal, count=countVal})
end

function luaVkApi.getLikedPhotos(offsetVal, countVal, photoSizes)
  return luaVkApi.invokeApi("fave.getPhotos", {offset=offsetVal, count=countVal,
      photo_sizes=photoSizes})
end

function luaVkApi.getLikedPosts(offsetVal, countVal, isExtended)
  return luaVkApi.invokeApi("fave.getPosts", {offset=offsetVal, count=countVal,
      extended=isExtended})
end

function luaVkApi.getLikedVideos(offsetVal, countVal, isExtended)
  return luaVkApi.invokeApi("fave.getVideos", {offset=offsetVal, count=countVal,
      extended=isExtended})
end

function luaVkApi.getLikedLinks(offsetVal, countVal)
  return luaVkApi.invokeApi("fave.getLinks", {offset=offsetVal, count=countVal})
end

function luaVkApi.bookmarkUser(userId)
  return luaVkApi.invokeApi("fave.addUser", {user_id=userId})
end

function luaVkApi.removeBookmarkedUser(userId)
  return luaVkApi.invokeApi("fave.removeUser", {user_id=userId})
end

function luaVkApi.bookmarkGroup(groupId)
  return luaVkApi.invokeApi("fave.addGroup", {group_id=groupId})
end

function luaVkApi.removeBookmarkedGroup(userId)
  return luaVkApi.invokeApi("fave.removeGroup", {user_id=userId})
end

function luaVkApi.bookmarkLink(linkStr, textStr)
  return luaVkApi.invokeApi("fave.addLink", {link=linkStr, text=textStr})
end

function luaVkApi.removeBookmarkedLink(linkId)
  return luaVkApi.invokeApi("fave.removeLink", {link_id=linkId})
end

-----------------------
--   Notifications   --
-----------------------
function luaVkApi.getNotifications(countVal, startFrom, filtersVal, startTime, endTime)
  return luaVkApi.invokeApi("notifications.get", {count=countVal, start_from=startFrom,
      filters=filtersVal, start_time=startTime, end_time=endTime})
end

function luaVkApi.markNotificationsAsViewed()
  return luaVkApi.invokeApi("notifications.markAsViewed")
end

-----------------------
--       Stats       --
-----------------------
function luaVkApi.getStatistics(groupId, appId, dateFrom, dateTo)
  return luaVkApi.invokeApi("stats.get", {group_id=groupId, app_id=appId, date_from=dateFrom,
      date_to=dateTo})
end

function luaVkApi.trackVisitor()
  return luaVkApi.invokeApi("stats.trackVisitor")
end

function luaVkApi.trackVisitor(ownerId, postId)
  return luaVkApi.invokeApi("stats.getPostReach", {owner_id=ownerId, post_id=postId})
end

-----------------------
--      Search       --
-----------------------
function luaVkApi.getHint(query, limitVal, filtersVal, searchGlobal)
  return luaVkApi.invokeApi("search.getHints", {q=query, limit=limitVal, filters=filtersVal,
      search_global=searchGlobal})
end

-----------------------
--       Apps        --
-----------------------
function luaVkApi.getAppsCatalog(sortVal, offsetVal, countVal, platformVal, isExtended,
    returnFriends, fieldsVal, nameCase, query, genreId, filterVal)
  return luaVkApi.invokeApi("apps.getCatalog", {sort=sortVal, offset=offsetVal, count=countVal,
      platform=platformVal, extended=isExtended, return_friends=returnFriends, fields=fieldsVal, 
      name_case=nameCase, q=query, genre_id=genreId, filter=filterVal})
end

function luaVkApi.getApp(appId, appIds, platformVal, isExtended, returnFriends, fieldsVal,
    nameCase)
  return luaVkApi.invokeApi("apps.get", {app_id=appId, app_ids=appIds, platform=platformVal,
      extended=isExtended, return_friends=returnFriends, fields=fieldsVal, name_case=nameCase})
end

function luaVkApi.sendAppRequest(userId, textVal, typeVal, nameVal, keyVal, separateVal)
  return luaVkApi.invokeApi("apps.sendRequest", {user_id, text=textVal, type=typeVal, name=nameVal,
      key=keyVal, separate=separateVal})
end

function luaVkApi.deleteAppRequests()
  return luaVkApi.invokeApi("apps.deleteAppRequests")
end

function luaVkApi.getFriendsList(isExtended, countVal, offsetVal, typeVal, fieldsVal)
  return luaVkApi.invokeApi("apps.getFriendsList", {extended=isExtended, count=countVal, 
      offset=offsetVal, type=typeVal, fields=fieldsVal})
end

function luaVkApi.getLeaderboard(typeVal, globalVal, isExtended)
  return luaVkApi.invokeApi("apps.getLeaderboard", {type=typeVal, global=globalVal, 
      extended=isExtended})
end

function luaVkApi.getScore(userId)
  return luaVkApi.invokeApi("apps.getScore", {user_id=userId})
end

-----------------------
--     Service       --
-----------------------
function luaVkApi.checkLink(urlStr)
  return luaVkApi.invokeApi("utils.checkLink", {url=urlStr})
end

function luaVkApi.resolveScreenName(screenNsme)
  return luaVkApi.invokeApi("utils.resolveScreenName", {screen_name=screenNsme})
end

function luaVkApi.getServerTime()
  return luaVkApi.invokeApi("utils.getServerTime")
end

-----------------------
--     VK data       --
-----------------------
function luaVkApi.getCountries(needAll, codeStr, offsetVal, countVal)
  return luaVkApi.invokeApi("database.getCountries", {need_all=needAll, code=codeStr,
      offset=offsetVal, count=countVal})
end

function luaVkApi.getRegions(countryId, query, offsetVal, countVal)
  return luaVkApi.invokeApi("database.getRegions", {country_id=countryId, q=query,
      offset=offsetVal, count=countVal})
end

function luaVkApi.getStreetsById(streetIds)
  return luaVkApi.invokeApi("database.getStreetsById", {street_ids=streetIds})
end

function luaVkApi.getCountriesById(countryIds)
  return luaVkApi.invokeApi("database.getCountriesById", {country_ids=countryIds})
end

function luaVkApi.getCities(countryId, regionId, query, needAll, offsetVal, countVal)
  return luaVkApi.invokeApi("database.getCities", {country_id=countryId, region_id=regionId,
      q=query, need_all=needAll, offset=offsetVal, count=countVal})
end

function luaVkApi.getCitiesById(cityIds)
  return luaVkApi.invokeApi("database.getCitiesById", {city_ids=cityIds})
end

function luaVkApi.getUniversities(query, countryId, cityId, offsetVal, countVal)
  return luaVkApi.invokeApi("database.getUniversities", {q=query, country_id=countryId, 
      city_id=cityId, offset=offsetVal, count=countVal})
end

function luaVkApi.getSchools(query, cityId, offsetVal, countVal)
  return luaVkApi.invokeApi("database.getSchools", {q=query, city_id=cityId, offset=offsetVal,
      count=countVal})
end

function luaVkApi.getSchoolClasses(countryId)
  return luaVkApi.invokeApi("database.getSchoolClasses", {country_id=countryId})
end

function luaVkApi.getFaculties(universityId, offsetVal, countVal)
  return luaVkApi.invokeApi("database.getFaculties", {university_id=universityId, offset=offsetVal,
      count=countVal})
end

function luaVkApi.getChairs(facultyId, offsetVal, countVal)
  return luaVkApi.invokeApi("database.getChairs", {faculty_id=facultyId, offset=offsetVal,
      count=countVal})
end

-----------------------
--      Gifts        --
-----------------------
function luaVkApi.getGifts(userId, countVal, offsetVal)
  return luaVkApi.invokeApi("gifts.get", {user_id=userId, count=countVal, offset=offsetVal})
end

-----------------------
--      Other        --
-----------------------
function luaVkApi.executeCode(codeStr)
  return luaVkApi.invokeApi("execute", {code=codeStr})
end



return luaVkApi
