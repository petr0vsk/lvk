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

function luaVkApi.searchUsers(queryString, sortVal, offsetVal, countVal, returnedFields,
    cityVal, countryVal, hometownVal, universityCountry, universityVal, universityYear,
    universityFaculty, universityChair, sexVal, statusVal, ageFrom, ageTo, birthDay,
    birthMonth, birthYear, isOnline, hasPhoto, schoolCountry, schoolCity, schoolClass,
    schoolVal, schoolYear, religionVal, interestsVal, companyVal, positionVal, groupId,
    fromList)
  return luaVkApi.invokeApi("users.search", {q=queryString, sort=sortVal, offset=offsetVal,
      count=countVal, fields=returnedFields, city=cityVal, country=countryVal, 
      hometown-hometownVal, university_country=universityCountry, university=universityVal,
      university_year=universityYear, university_faculty=universityFaculty, 
      university_chair=universityChair, sex=sexVal, status=statusVal, age_from=ageFrom,
      age_to=ageTo, birth_day=birthDay, birth_month=birthMonth, birth_year=birthYear,
      online-isOnline, has_photo=hasPhoto, school_country=schoolCountry,
      school_city=schoolCity, school_class=schoolClass, school=schoolVal, 
      school_year=schoolYear, religion=religionVal, interests=interestVal,
      company=complanyVal, position=positionVal, group_id=groupId, from_list=fromList})
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

function luaVkApi.reportUser(userId, typeVal, commentVal)
  return luaVkApi.invokeApi("users.report", {user_id=userId, type=typeVal, comment=commentVal})
end

function luaVkApi.getNearbyUsers(latitudeVal, longitudeVal, accuracyVal, timeoutVal, radiusVal,
    fieldsVal, nameCaseVal)
  return luaVkApi.invokeApi("users.getNearby", {latitude=latitudeVal, longitude=longitudeVal,
      accuracy=accuracyVal, timeout=timeoutVal, radius=radiusVal, fields=fieldsVal,
      name_case=nameCase})
end

-----------------------
--  Authorization    --
-----------------------
function luaVkApi.checkPhone(phoneNumber, userId, clientSecret)
  return luaVkApi.invokeApi("auth.checkPhone", {phone=phoneNumber, client_id=userId,
      client_secret=clientSecret})
end

function luaVkApi.signup(firstName, lastName, clientId, clientSecret, phoneVal,
    passwordVal, testMode, voiceVal, sexVal, sidVal)
  return luaVkApi.invokeApi("auth.signup", {first_name=firstName, last_name=lastName,
      client_id=clientId, client_secret=clientSecret, phone=phoneVal, password=passwordVal,
      test_mode=testMode, voice=voiceVal, sex=sexVal, sid=sidVal})
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
function luaVkApi.createPhotoAlbum(titleVal, groupId, descriptionVal, privacyView,
    privacyComment, uploadByAdminsOnly, commentsDissabled)
  return luaVkApi.invokeApi("photos.createAlbum", {title=titleVal, grop_id=groupId,
      description=descriptionVal, privacy_view=privacyView, privacy_comment=privacyComment,
      upload_by_admins_only=uploadByAdminsOnly, comments_dissabled=commentsDissabled})
end

function luaVkApi.editPhotoAlbum(albumId, titleVal, descriptionVal, ownerId, privacyView,
    privacyComment, uploadByAdminsOnly, commentsDissabled)
  return luaVkApi.invokeApi("photos.editAlbum", {album_id=albumId, title=titleVal,
      description=descriptionVal, owner_id=ownerId, privacy_view=privacyView, 
      privacy_comment=privacyComment, upload_by_admins_only=uploadByAdminsOnly, 
      comments_dissabled=commentsDissabled})
end

function luaVkApi.getPhotoAlbums(ownerId, albumIds, offsetVal, countVal, needSystem,
    needCovers, photoSizes)
  return luaVkApi.invokeApi("photos.getAlbums", {owner_id=ownerId, album_ids=albumIds,
      offset=offsetVal, count=countVal, need_system=needSystem, need_covers=needCovers,
      photo_sizes=photoSizes})
end

function luaVkApi.getPhotos(ownerId, albumId, photoIds, revVal, isExtended, feedType,
    feedVal, photoSizes, offsetVal, countVal)
  return luaVkApi.invokeApi("photos.get", {owner_id=ownerId, album_id=albumId,
      photo_ids=photoIds, rev=revVal, extended=isExtended, feed_type=feedType,
      feed=feedVal, photo_sizes=photoSizes, offset=offsetVal, count=countVal})
end

function luaVkApi.getPhotoAlbumsCount(userId, groupId)
  return luaVkApi.invokeApi("photos.getAlbumsCount", {user_id=userId, group_id=groupId})
end

function luaVkApi.getPhotosById(photosVal, isExtended, photoSizes)
  return luaVkApi.invokeApi("photos.getById", {photos=photosVal, extended=isExtended,
      photo_sizes=photoSizes})
end

function luaVkApi.getPhotoUploadServer(albumId, groupId)
  return luaVkApi.invokeApi("photos.getUploadServer", {album_id=albumId, group_id=groupId})
end

function luaVkApi.getOwnerPhotoUploadServer(ownerId)
  return luaVkApi.invokeApi("photos.getOwnerPhotoUploadServer", {owner_id=ownerId})
end

function luaVkApi.getChatCoverUploadServer(chatId, cropX, cropY, cropWidth)
  return luaVkApi.invokeApi("photos.getChatUploadServer", {chat_id=chatId, crop_x=cropX,
      crop_y=cropY, crop_width=cropWidth})
end

function luaVkApi.saveOwnerPhoto(serverVal, hashVal, photoVal)
  return luaVkApi.invokeApi("photos.saveOwnerPhoto", {server=serverVal, hash=hashVal,
      photo=photoVal})
end 

function luaVkApi.saveWallPhoto(userId, groupId, photoVal, serverVal, hashVal)
  return luaVkApi.invokeApi("photos.saveWallPhoto", {user_id=userId, group_id=grouId,
      photo=photoVal, server=serverVal, hash=hashVal})
end

function luaVkApi.getWallPhotoUploadServer(groupId)
  return luaVkApi.invokeApi("photos.getWallUploadServer", {group_id=grouId})
end

function luaVkApi.getMessagesUploadServer()
  return luaVkApi.invokeApi("photos.getMessagesUploadServer")
end

function luaVkApi.saveMessagesPhoto(photoVal)
  return luaVkApi.invokeApi("photos.saveMessagesPhoto", {photo=photoVal})
end

function luaVkApi.reportPhoto(ownerId, photoId, reasonVal)
  return luaVkApi.invokeApi("photos.report", {owner_id=ownerId, photo_id=photoId,
      reason=reasonVal})
end

function luaVkApi.reportPhotoComment(ownerId, commentId, reasonVal)
  return luaVkApi.invokeApi("photos.reportComment", {owner_id=ownerId, comment_id=commentId,
      reason=reasonVal})
end

function luaVkApi.searchPhotos(query, latitude, longitude, startTime, endTime, sortVal,
    offsetVal, countVal, radiusVal)
  return luaVkApi.invokeApi("photos.search", {q=query, lat=latitude, long=longitude,
      start_time=startTime, end_time=endTime, sort=sortVal, offset=offsetVal,
      count=countVal, radius=radiusVal})
end

function luaVkApi.savePhoto(albumId, groupId, serverVal, photosList, hashVal,
    latitudeVal, longitudeVal, captionVal)
  return luaVkApi.invokeApi("photos.save", {album_id=albumId, group_id=groupId,
  server=serverVal, photos_list=photosList, hash=hashVal, latitude=latitudeVal,
  longitude=longitudeVal, caption=captionVal})
end

function luaVkApi.copyPhoto(ownerId, photoId, accessKey)
  return luaVkApi.invokeApi("photos.copy", {owner_id=ownerId, photo_id=photoId, 
      access_key=accessKey})
end

function luaVkApi.editPhoto(ownerId, photoId, captionVal, latitudeVal, longitudeVal,
    placeStr, foursquareId, deletePlace)
  return luaVkApi.invokeApi("photos.edit", {owner_id=ownerId, photo_id=photoId,
      caption=captionVal, latitude=latitudeVal, longitude=longitudeVal,
      place_str=placeStr, foursquare_id=foursquareId, delete_place=deletePlace})
end

function luaVkApi.movePhoto(ownerId, targetAlbumId, photoId)
  return luaVkApi.invokeApi("photos.move", {owner_id=ownerId, target_album_id=targetAlbumId,
      photo_id=photoId})
end

function luaVkApi.makeCover(ownerId, photoId, albumId)
  return luaVkApi.invokeApi("photos.makeCover", {owner_id=ownerId, photo_id=photoId,
      album_id=albumId})
end

function luaVkApi.reorderPhotoAlbums(ownerId, albumId, beforeVal, afterVal)
  return luaVkApi.invokeApi("photos.reorderAlbums", {owner_id=ownerId, album_id=albumId,
      before=beforeVal, after=afterVal})
end

function luaVkApi.reorderPhotos(ownerId, photoId, beforeVal, afterVal)
  return luaVkApi.invokeApi("photos.reorderPhotos", {owner_id=ownerId, photo_id=photoId,
      before=beforeVal, after=afterVal})
end

function luaVkApi.getAllPhotos(ownerId, isExtended, offsetVal, countVal, photoSizes,
    noServiceAlbums, needHidden, skipHidden)
  return luaVkApi.invokeApi("photos.getAll", {owner_id=ownerId, extended=isExtended,
      offset=offsetVal, count=countVal, photo_sizes=photoSizes, no_service_albums=noServiceAlbums,
      need_hidden=needHidden, skip_hidden=skipHidden})
end

function luaVkApi.getUserPhotos(userId, offsetVal, countVal, isExtended, sortVal)
  return luaVkApi.invokeApi("photos.getUserPhotos", {user_id=userId, offset=offsetVal,
      count=countVal, extended=isExtended, sort=sortVal})
end

function luaVkApi.deletePhotoAlbum(albumId, groupId)
  return luaVkApi.invokeApi("photos.deleteAlbum", {album_id=albumId, group_id=groupId})
end

function luaVkApi.deletePhoto(ownerId, photoId)
  return luaVkApi.invokeApi("photos.delete", {owner_id=ownerId, photo_id=photoId})
end

function luaVkApi.restorePhoto(ownerId, photoId)
  return luaVkApi.invokeApi("photos.restore", {owner_id=ownerId, photo_id=photoId})
end

function luaVkApi.confirmPhotoTag(ownerId, photoId, tagId)
  return luaVkApi.invokeApi("photos.confirmTag", {owner_id=ownerId, photo_id=photoId,
      tag_id=tagId})
end

function luaVkApi.getNewPhotoTags(offsetVal, countVal)
  return luaVkApi.invokeApi("photos.getNewTags", {offset=offsetVal, count=countVal})
end

function luaVkApi.removePhotoTag(ownerId, photoId, tagId)
  return luaVkApi.invokeApi("photos.removeTag", {owner_id=ownerId, photo_id=photoId,
      tag_id=tagId})
end

function luaVkApi.putPhotoTag(ownerId, photoId, userId, x_, y_, x2_, y2_)
  return luaVkApi.invokeApi("photos.putTag", {owner_id=ownerId, photo_id=photoId,
      user_id=userId, x=x_, y=y_, x2=x2_, y2=y2_})
end

function luaVkApi.gePhotoTags(ownerId, photoId, accessKey)
  return luaVkApi.invokeApi("photos.getTags", {owner_id=ownerId, photo_id=photoId,
      access_key=accessKey})
end

function luaVkApi.gePhotoComments(ownerId, photoId, needLikes, startCommentId, offsetVal,
    countVal, sortVal, accessKey, isExtended, fieldsVal)
  return luaVkApi.invokeApi("photos.getComments", {owner_id=ownerId, photo_id=photoId,
      need_likes=needLikes, start_comment_id=startCommentId, offset=offsetVal,
      count=countVal, sort=sortVal, access_key=accessKey, extended=isExtended,
      fields=fieldsVal})
end

function luaVkApi.getAllPhotoComments(ownerId, albumId, needLikes, offsetVal, countVal)
  return luaVkApi.invokeApi("photos.getAllComments", {owner_id=ownerId, album_id=albumId,
      need_likes=needLikes, offset=offsetVal, count=countVal})
end

function luaVkApi.createPhotoComment(ownerId, photoId, messageStr, attachmentsVal, fromGroup,
    replyToComment, stickerId, accessKey, guidVal)
  return luaVkApi.invokeApi("photos.createComment", {owner_id=ownerId, photo_id=photoId,
      message=messageStr, attachments=attachmentsVal, from_group=fromGroup,
      reply_to_comment=replyToComment, sticker_id=stickerId, access_key=accessKey,
      guid=guidVal})
end

function luaVkApi.deletePhotoComment(ownerId, commentId)
  return luaVkApi.invokeApi("photos.deleteComment", {owner_id=ownerId, comment_id=commentId})
end

function luaVkApi.restorePhotoComment(ownerId, commentId)
  return luaVkApi.invokeApi("photos.restoreComment", {owner_id=ownerId, comment_id=commentId})
end

function luaVkApi.editPhotoComment(ownerId, commentId, messageVal, attachmentsVal)
  return luaVkApi.invokeApi("photos.editComment", {owner_id=ownerId, comment_id=commentId,
      message=messageVal, attachments=attachmentsVal})
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
function luaVkApi.getNewsFeed(filtersVal, returnBanned, startTime, endTime, maxPhotos,
    sourceIds, startFrom, countVal, fieldsVal)
  return luaVkApi.invokeApi("newsfeed.get", {filters=filtersVal, return_banned=returnBanned, 
      start_time=startTime, end_time=endTime, max_photos=maxPhotos, source_ids=sourceIds, 
      start_from=startFrom, count=countVal, fields=fieldsVal})
end

function luaVkApi.getRecommendedNews(startTime, endTime, maxPhotos, startFrom, countVal,
    fieldsVal)
  return luaVkApi.invokeApi("newsfeed.getRecommended", {start_time=startTime, end_time=endTime,
      max_photos=maxPhotos, start_from=startFrom, count=countVal, fields=fieldsVal})
end

function luaVkApi.getNewsComments(countVal, filtersVal, repostsVal, startTime, endTime, 
    lastCommentsCount, startFrom, fieldsVal)
  return luaVkApi.invokeApi("newsfeed.getComments", {count=countVal, filters=filtersVal,
      reposts=repostsVal, start_time=startTime, end_time=endTime,
      last_comments_count=lastCommentsCount, start_from=startFrom, fields=fieldsVal})
end

function luaVkApi.getUserMentions(ownerId, startTime, endTime, offsetVal, countVal)
  return luaVkApi.invokeApi("newsfeed.getMentions", {owner_id=ownerId, start_time=startTime,
      end_time=endTime, offset=offsetVal, count=countVal})
end

function luaVkApi.getBanned(isExtended, fieldsVal, nameCase)
  return luaVkApi.invokeApi("newsfeed.getBanned", {extended=isExtended, fields=fieldsVal,
      name_case=nameCase})
end

function luaVkApi.addBan(userIds, groupIds)
  return luaVkApi.invokeApi("newsfeed.addBan", {user_ids=userIds, group_ids=userIds})
end 

function luaVkApi.deleteBan(userIds, groupIds)
  return luaVkApi.invokeApi("newsfeed.deleteBan", {user_ids=userIds, group_ids=userIds})
end 

function luaVkApi.ignoreItem(typeVal, ownerId, itemId)
  return luaVkApi.invokeApi("newsfeed.ignoreItem", {type=typeVal, ownner_id=ownerId,
      item_id=itemId})
end 

function luaVkApi.unignoreItem(typeVal, ownerId, itemId)
  return luaVkApi.invokeApi("newsfeed.unignoreItem", {type=typeVal, ownner_id=ownerId,
      item_id=itemId})
end 

function luaVkApi.searchNews(keyWord, isExtended, countVal, latitudeVal, longitudeVal,
    startTime, endTime, startFrom, fieldsVal)
  return luaVkApi.invokeApi("newsfeed.search", {q=keyWord, extended=isExtended, count=countVal,
      latitude-latitudeVal, longitude=longitudeVal, start_time=startTime, endTime=endTime, 
      start_from=startFrom, fields=fieldsVal})
end

function luaVkApi.getLists(listIds, isExtended)
  return luaVkApi.invokeApi("newsfeed.getLists", {list_ids=listIds, extended=isExtended})
end

function luaVkApi.saveList(listId, titleVal, sourceIds, noReposts)
  return luaVkApi.invokeApi("newsfeed.saveList", {list_id=listId, title=titleVal, 
  source_ids=sourceIds, no_reposts=noReposts})
end 

function luaVkApi.deleteList(listId)
  return luaVkApi.invokeApi("newsfeed.deleteList", {list_id=listId})
end

function luaVkApi.unsubscribe(typeVal, ownerId, itemId)
  return luaVkApi.invokeApi("newsfeed.unsubscribe", {type=typeVal, owner_id=ownerId,
      item_id=itemId})
end

function luaVkApi.getSuggestedSources(offsetVal, countVal, shuffleVal, fieldsVal)
  return luaVkApi.invokeApi("newsfeed.getSuggestedSources", {offset=offsetVal, count=countVal,
      shuffle=shuffleVal, fieldsVal})
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
