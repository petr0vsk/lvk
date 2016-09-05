local https = require("ssl.https")
local json = require ("dkjson")

local luaVkApi = {}

local apiRequest = "https://api.vk.com/method/{METHOD_NAME}" .. "?{PARAMETERS}"
  .. "&access_token={ACCESS_TOKEN}" .. "&v={API_VERSION}"

-----------------------
--Common util methods--
-----------------------
function luaVkApi.invokeApi(method, params)
  -- load properties
  local file = io.open("luaVkApi.properties")
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

function luaVkApi.stringToJSON(jsonString_)
  local jsonString = jsonString_
  return json.decode(jsonString, 1, nil)
end

function luaVkApi.jsonToString(jsonObject_)
  local jsonObject = jsonObject_
  return json.encode(jsonObject)
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
      hometown=hometownVal, university_country=universityCountry, university=universityVal,
      university_year=universityYear, university_faculty=universityFaculty, 
      university_chair=universityChair, sex=sexVal, status=statusVal, age_from=ageFrom,
      age_to=ageTo, birth_day=birthDay, birth_month=birthMonth, birth_year=birthYear,
      online=isOnline, has_photo=hasPhoto, school_country=schoolCountry,
      school_city=schoolCity, school_class=schoolClass, school=schoolVal, 
      school_year=schoolYear, religion=religionVal, interests=interestsVal,
      company=companyVal, position=positionVal, group_id=groupId, from_list=fromList})
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
    fieldsVal, nameCase)
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

function luaVkApi.editComment(ownerId, commentId, messageVal, replyToComment, commentAttachments)
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
  return luaVkApi.invokeApi("photos.saveWallPhoto", {user_id=userId, group_id=groupId,
      photo=photoVal, server=serverVal, hash=hashVal})
end

function luaVkApi.getWallPhotoUploadServer(groupId)
  return luaVkApi.invokeApi("photos.getWallUploadServer", {group_id=groupId})
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

function luaVkApi.saveMarketAlbumPhoto(groupId, photoVal, serverVal, hashVal)
  return luaVkApi.invokeApi("photos.saveMarketAlbumPhoto", {group_id=groupId, photo=photoVal,
      server=serverVal, hash=hashVal})
end

function luaVkApi.saveMarketPhoto(groupId, photoVal, serverVal, hashVal, cropData, cropHash)
  return luaVkApi.invokeApi("photos.saveMarketPhoto", {group_id=groupId, photo=photoVal,
      server=serverVal, hash=hashVal, crop_data=cropData, crop_hash=cropHash})
end

function luaVkApi.getMarketAlbumUploadServer(groupId)
  return luaVkApi.invokeApi("photos.getMarketAlbumUploadServer", {group_id=groupId})
end

function luaVkApi.getMarketUploadServer(groupId, mainPhoto, cropX, cropY, cropWidth)
  return luaVkApi.invokeApi("photos.getMarketUploadServer", {group_id=groupId, main_photo=mainPhoto,
  	crop_x=cropX, crop_y=cropY, crop_width=cropWidth})
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

function luaVkApi.getFriendsRequests(countVal, offsetVal, extendedVal, needMutual, outVal, sortVal,
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

function luaVkApi.searchFriends(userId, query, fieldsVal, nameCase, offsetVal, countVal)
  return luaVkApi.invokeApi("friends.search", {user_id=userId, q=query, fields=fieldsVal,
      name_case=nameCase, offset=offsetVal, count=countVal})
end

-----------------------
--     Widgets       --
-----------------------
function luaVkApi.getCommentsFromWidget(widgetApiId, urlStr, pageId, orderVal,
    fieldsVal, offsetVal, countVal)
  return luaVkApi.invokeApi("widgets.getComments", {widget_api_id=widgetApiId, url=urlStr,
      page_id=pageId, order=orderVal, fields=fieldsVal, offset=offsetVal, count=countVal})
end

function luaVkApi.getPagesWithWidget(widgetApiId, orderVal, periodVal, offsetVal, countVal)
  return luaVkApi.invokeApi("widgets.getPages", {widget_api_id=widgetApiId, order=orderVal,
      period=periodVal, offset=offsetVal, count=countVal})
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
function luaVkApi.getAudios(ownerId, albumId, audioIds, needUser, offsetVal, countVal)
  return luaVkApi.invokeApi("audio.get", {owner_id=ownerId, album_id=albumId,
      audio_ids=audioIds, need_user=needUser, offset=offsetVal, count=countVal})
end

function luaVkApi.getAudiosById(audioIds)
  return luaVkApi.invokeApi("audio.getById", {audios=audioIds})
end

function luaVkApi.getLyrics(lyricsId)
  return luaVkApi.invokeApi("audio.getLyrics", {lyrics_id=lyricsId})
end

function luaVkApi.searchAudios(query, autoComplete, lyricsVal, performerOnly, sortVal,
    searchOwn, offsetVal, countVal)
  return luaVkApi.invokeApi("audio.search", {q=query, auto_compleate=autoComplete,
      lyrics=lyricsVal, performer_only=performerOnly, sort=sortVal, search_own=searchOwn,
      offset=offsetVal, count=countVal})
end

function luaVkApi.getAudioUploadServer()
  return luaVkApi.invokeApi("audio.getUploadServer")
end

function luaVkApi.saveAudio(serverVal, audioVal, hashVal, artistVal, titleVal)
  return luaVkApi.invokeApi("audio.save", {server=serverVal, audio=audioVal, hash=hashVal,
      artist=artistVal, title=titleVal})
end

function luaVkApi.addAudio(audioId, ownerId, groupId, albumId)
  return luaVkApi.invokeApi("audio.add", {audio_id=audioId, owner_id=ownerId, group_id=groupId,
      album_id=albumId})
end

function luaVkApi.deleteAudio(audioId, ownerId)
  return luaVkApi.invokeApi("audio.delete", {audio_id=audioId, owner_id=ownerId})
end

function luaVkApi.editAudio(ownerId, audioId, artistVal, titleVal, textVal, genreId, noSearch)
  return luaVkApi.invokeApi("audio.edit", {owner_id=ownerId, audio_id=audioId, artist=artistVal,
      title=titleVal, text=textVal, genre_id=genreId, no_search=noSearch})
end

function luaVkApi.reorderAudio(audioId, ownerId, beforeVal, afterVal)
  return luaVkApi.invokeApi("audio.reorder", {audio_id=audioId, owner_id=ownerId, before=beforeVal,
      after=afterVal})
end

function luaVkApi.restoreAudio(audioId, ownerId)
  return luaVkApi.invokeApi("audio.restore", {audio_id=audioId, owner_id=ownerId})
end

function luaVkApi.getAudioAlbums(ownerId, offsetVal, countVal)
  return luaVkApi.invokeApi("audio.getAlbums", {owner_id=ownerId, offset=offsetVal,
      count=countVal})
end

function luaVkApi.addAudioAlbum(groupId, titleVal)
  return luaVkApi.invokeApi("audio.addAlbum", {group_id=groupId, title=titleVal})
end

function luaVkApi.editAudioAlbum(groupId, albumId, titleVal)
  return luaVkApi.invokeApi("audio.editAlbum", {group_id=groupId, album_id=albumId,
      title=titleVal})
end

function luaVkApi.deleteAudioAlbum(groupId, albumId)
  return luaVkApi.invokeApi("audio.deleteAlbum", {group_id=groupId, album_id=albumId})
end

function luaVkApi.moveAudioToAlbum(groupId, albumId, audioIds)
  return luaVkApi.invokeApi("audio.moveToAlbum", {group_id=groupId, album_id=albumId,
      audio_ids=audioIds})
end

function luaVkApi.setAudioBroadcast(audioVal, targetIds)
  return luaVkApi.invokeApi("audio.setBroadcast", {audio=audioVal, target_ids=targetIds})
end

function luaVkApi.getAudioBroadcastList(filterVal, isActive)
  return luaVkApi.invokeApi("audio.getBroadcastList", {filter=filterVal,active=isActive})
end

function luaVkApi.getAudioRecommendations(targetAudio, userId, offsetVal, countVal, isShuffle)
  return luaVkApi.invokeApi("audio.getRecommendations", {target_audio=targetAudio, user_id=userId,
      offset=offsetVal, count=countVal, shuffle=isShuffle})
end

function luaVkApi.getPopularAudios(onlyEng, genreId, offsetVal, countVal)
  return luaVkApi.invokeApi("audio.getPopular", {only_eng=onlyEng, genre_id=genreId,
  	offset=offsetVal, count=countVal})
end

function luaVkApi.getAudiosCount(ownerId)
  return luaVkApi.invokeApi("audio.getCount", {owner_id=ownerId})
end

-----------------------
--       Pages       --
-----------------------
function luaVkApi.getPages(ownerId, pageId, isGlobal, sitePreview, titleVal, needSource,
    needHtml)
  return luaVkApi.invokeApi("pages.get", {owner_id=ownerId, page_id=pageId, global=isGlobal,
      site_preview=sitePreview, title=titleVal, need_source=needSource, need_html=needHtml})
end

function luaVkApi.savePage(textVal, pageId, groupId, userId, titleVal)
  return luaVkApi.invokeApi("pages.save", {text=textVal, page_id=pageId, group_id=groupId,
      user_id=userId, title=titleVal})
end

function luaVkApi.savePageAccess(pageId, groupId, userId, viewVal, editVal)
  return luaVkApi.invokeApi("pages.saveAccess", {page_id=pageId, group_id=groupId, user_id=userId,
      view=viewVal, edit=editVal})
end

function luaVkApi.getPageHistory(pageId, groupId, userId)
  return luaVkApi.invokeApi("pages.getHistory", {page_id=pageId, group_id=groupId, user_id=userId})
end

function luaVkApi.getPageTitles(groupId)
  return luaVkApi.invokeApi("pages.getTitles", {group_id=groupId})
end

function luaVkApi.getPageVersion(versionId, groupId, userId, needHtml)
  return luaVkApi.invokeApi("pages.getVersion", {version_id=versionId, group_id=groupId,
      user_id=userId, need_html=needHtml})
end

function luaVkApi.parseWiki(textVal, groupId)
  return luaVkApi.invokeApi("pages.parseWiki", {text=textVal, group_id=groupId})
end

function luaVkApi.clearPageCache(urlVal)
  return luaVkApi.invokeApi("pages.clearCache", {url=urlVal})
end

-----------------------
--    Communities    --
-----------------------
function luaVkApi.isCommunityMember(groupId, userId, userIds, isExtended)
  return luaVkApi.invokeApi("groups.isMember", {group_id=groupId, user_id=userId,
        user_ids=userIds, extended=isExtended})
end

function luaVkApi.getCommunitiesById(groupIds, groupId, fieldsVal)
  return luaVkApi.invokeApi("groups.getById", {group_ids=groupIds, group_id=groupId,
      fields=fieldsVal})
end

function luaVkApi.getCommunities(userId, isExtended, filterVal, fieldsVal,
    offsetVal, countVal)
  return luaVkApi.invokeApi("groups.get", {user_id=userId, extended=isExtended,
      filter=filterVal, fields=fieldsVal, offset=offsetVal, count=countVal})
end

function luaVkApi.getCommunityMembers(groupId, sortVal, offsetVal, countVal,
    fieldsVal, filterVal)
  return luaVkApi.invokeApi("groups.getMembers", {group_id=groupId, sort=sortVal,
      offset=offsetVal, count=countVal, fields=fieldsVal, filter=filterVal})
end

function luaVkApi.joinCommunity(groupId, notSure)
  return luaVkApi.invokeApi("groups.join", {group_id=groupId, not_sure=notSure})
end

function luaVkApi.leaveCommunity(groupId)
  return luaVkApi.invokeApi("groups.leave", {group_id=groupId})
end

function luaVkApi.searchCommunities(query, typeVal, countryId, cityId, 
    isFuture, sortVal, offsetVal, countVal)
  return luaVkApi.invokeApi("groups.search", {q=query, type=typeVal, country_id=countryId,
      city_id=cityId, future=isFuture, sort=sortVal, offset=offsetVal, count=countVal})
end

function luaVkApi.getCommunitiesInvites(offsetVal, countVal, isExtended)
  return luaVkApi.invokeApi("groups.getInvites", {offset=offsetVal, count=countVal,
      extended=isExtended})
end

function luaVkApi.getInvitedUsers(groupId, offsetVal, countVal, fieldsVal, nameCase)
  return luaVkApi.invokeApi("groups.getInvitedUsers", {group_id=groupId, offset=offsetVal,
      count=countVal, fields=fieldsVal, name_case=nameCase})
end

function luaVkApi.banUserForCommunity(groupId, userId, endDate, reasonVal, commentVal,
    commentVisible)
  return luaVkApi.invokeApi("groups.banUser", {group_id=groupId, user_id=userId, 
    end_date=endDate, reason=reasonVal, comment=commentVal, 
    comment_visible=commentVisible})
end

function luaVkApi.unbanUserForCommunity(groupId, userId)
  return luaVkApi.invokeApi("groups.unbanUser", {group_id=groupId, user_id=userId})
end

function luaVkApi.getBannedUsersForCommunity(groupId, offsetVal, countVal, fieldsVal,
    userId)
  return luaVkApi.invokeApi("groups.getBanned", {group_id=groupId, offset=offsetVal, 
      count=countVal, fields=fieldsVal, user_id=userId})
end

function luaVkApi.createCommunity(titleVal, descriptionVal, typeVal, subtypeVal)
  return luaVkApi.invokeApi("groups.create", {title=titleVal, description=descriptionVal,
      type=typeVal, subtype=subtypeVal})
end

function luaVkApi.editCommunity(groupId, titleVal, descriptionVal, screenName,
    accessVal, websiteVal, subjectVal, emailVal, phoneVal, rssVal, eventStartDate, 
    eventFinishDate, eventGroupId, publicCategory, publicSubcategory, publicDate,
    wallVal, topicsVal, photosVal, videoVal, audioVal, linksVal, eventsVal, placesVal,
    contactsVal, docsVal, wikiVal)
  return luaVkApi.invokeApi("groups.edit", {group_id=groupId, title=titleVal, 
      description=descriptionVal, screen_name=screenName, access=accessVal,
      website=websiteVal, subject=subjectVal, email=emailVal, phone=phoneVal, rss=rssVal,
      event_start_date=eventStartDate, event_finish_date=eventFinishDate,
      event_group_id=eventGroupId, public_category=publicCategory, 
      public_subcategory=publicSubcategory, public_date=publicDate, wall=wallVal,
      topics=topicsVal, photos=photosVal, video=videoVal, audio=audioVal, links=linksVal,
      events=eventsVal, places=placesVal, contacts=contactsVal, docs=docsVal,
      wiki=wikiVal})
end

function luaVkApi.editPlace(groupId, titleVal, adressVal, countryId, cityId, latitudeVal,
    longitudeVal)
  return luaVkApi.invokeApi("groups.editPlace", {group_id=groupId, title=titleVal, 
      adress=adressVal, country_id=countryId, city_id=cityId, latitude=latitudeVal,
      longitude=longitudeVal})
end

function luaVkApi.getCommunitySettings(groupId)
  return luaVkApi.invokeApi("groups.getSettings", {group_id=groupId})
end

function luaVkApi.getCommunityRequests(groupId, offsetVal, countVal, fieldsVal)
  return luaVkApi.invokeApi("groups.getRequests", {group_id=groupId, offset=offsetVal,
      count=countVal, fields=fieldsVal})
end

function luaVkApi.editCommunityManager(groupId, userId, roleVal, isContact, 
    contactPosition, contactPhone, contactEmail)
  return luaVkApi.invokeApi("groups.editManager", {group_id=groupId, user_id=userId,
      role=roleVal, is_contact=isContact, contact_position=contactPosition,
      contact_phone=contactPhone, contact_email=contactEmail})
end

function luaVkApi.inviteToCommunity(groupId, userId)
  return luaVkApi.invokeApi("groups.invite", {group_id=groupId, user_id=userId})
end

function luaVkApi.addCommunityLink(groupId, linkVal, textVal)
  return luaVkApi.invokeApi("groups.addLink", {group_id=groupId, link=linkVal,
      text=textVal})
end

function luaVkApi.deleteCommunityLink(groupId, linkId)
  return luaVkApi.invokeApi("groups.deleteLink", {group_id=groupId, link_id=linkId})
end

function luaVkApi.editCommunityLink(groupId, linkId, textVal)
  return luaVkApi.invokeApi("groups.editLink", {group_id=groupId, link_id=linkId,
      text=textVal})
end

function luaVkApi.reorderCommunityLink(groupId, linkId, afterVal)
  return luaVkApi.invokeApi("groups.reorderLink", {group_id=groupId, link_id=linkId,
      after=afterVal})
end

function luaVkApi.removeUserFromCommunity(groupId, userId)
  return luaVkApi.invokeApi("groups.removeUser", {group_id=groupId, user_id=userId})
end

function luaVkApi.approveUserRequestToCommunity(groupId, userId)
  return luaVkApi.invokeApi("groups.approveRequest", {group_id=groupId, user_id=userId})
end

function luaVkApi.setGroupCallbackSettings(groupId, messageNew, photoNew, audioNew,
	videoNew, wallReplyNew, wallReplyEdit, wallPostNew, boardPostNew, boardPostEdit,
	boardPostRestore, boardPostDelete, photoCommentNew, videoCommentNew, marketCommentNew,
	groupJoin, groupLeave)
  return luaVkApi.invokeApi("groups.setCallbackSettings", {group_id=groupId, message_new=messageNew,
  	photo_new=photoNew, audio_new=audioNew, video_new=videoNew, wall_reply_new=wallReplyNew,
  	wall_reply_edit=wallReplyEdit, wall_post_new=wallPostNew, board_post_new=boardPostNew,
  	board_post_edit=boardPostEdit, board_post_restore=boardPostRestore,
  	board_post_delete=boardPostDelete, photo_comment_new=photoCommentNew,
  	video_comment_new=videoCommentNew, market_comment_new=marketCommentNew, group_join=groupJoin,
  	group_leave=groupLeave})
end

function luaVkApi.setCallbackServerSettings(groupId, secretKey)
  return luaVkApi.invokeApi("groups.setCallbackServerSettings", {group_id=groupId, secret_key=secretKey})
end

function luaVkApi.setCallbackServer(groupId, serverUrl)
  return luaVkApi.invokeApi("groups.setCallbackServer", {group_id=groupId, server_url=serverUrl})
end

function luaVkApi.getCallbackSettings(groupId)
  return luaVkApi.invokeApi("groups.getCallbackSettings", {group_id=groupId})
end

function luaVkApi.getCallbackServerSettings(groupId)
  return luaVkApi.invokeApi("groups.getCallbackServerSettings", {group_id=groupId})
end

function luaVkApi.getCallbackConfirmationCode(groupId)
  return luaVkApi.invokeApi("groups.getCallbackConfirmationCode", {group_id=groupId})
end

function luaVkApi.getCallbackConfirmationCode(groupId)
  return luaVkApi.invokeApi("groups.getCallbackConfirmationCode", {group_id=groupId})
end

function luaVkApi.getGroupCatalogInfo(isExtended, subcategoriesVal)
  return luaVkApi.invokeApi("groups.getCatalogInfo", {extended=isExtended,
  	subcategories=subcategoriesVal})
end

function luaVkApi.getGroupCatalog(categoryId, subcategoryId)
  return luaVkApi.invokeApi("groups.getCatalogInfo", {category_id=categoryId,
  	subcategory_id=subcategoryId})
end

-----------------------
--      Boards       --
-----------------------
function luaVkApi.getBoardTopics(groupId, topicIds, orderVal, offsetVal, countVal, 
    isExtended, previewVal, previewLength)
  return luaVkApi.invokeApi("board.getTopics", {group_id=groupId, topic_ids=topicIds,
      order=orderVal, offset=offsetVal, count=countVal, extended=isExtended,
      preview=previewVal, preview_length=previewLength})
end

function luaVkApi.getBoardComments(groupId, topicId, needLikes, startCommentId, offsetVal,
    countVal, isExtended, sortVal)
  return luaVkApi.invokeApi("board.getComments", {group_id=groupId, topic_id=topicId,
      need_likes=needLikes, start_comment_id=startCommentId, offset=offsetVal, count=countVal,
      extended=isExtended, sort=sortVal})
end

function luaVkApi.addBoardTopic(groupId, titleVal, textVal, fromGroup, attachmentsVal)
  return luaVkApi.invokeApi("board.addTopic", {group_id=groupId, title=titleVal,
      text=textVal, from_group=fromGroup, attachments=attachmentsVal})
end

function luaVkApi.addCommentToBoardTopic(groupId, topicId, textVal, attachmentsVal, fromGroup,
    stickerId)
  return luaVkApi.invokeApi("board.addComment", {group_id=groupId, topic_id=topicId,
      text=textVal, attachments=attachmentsVal, from_group=fromGroup, sticker_id=stickerId})
end

function luaVkApi.deleteBoardTopic(groupId, topicId)
  return luaVkApi.invokeApi("board.deleteTopic", {group_id=groupId, topic_id=topicId})
end

function luaVkApi.editBoardTopic(groupId, topicId, titleVal)
  return luaVkApi.invokeApi("board.editTopic", {group_id=groupId, topic_id=topicId,
      title=titleVal})
end

function luaVkApi.editBoardTopicComment(groupId, topicId, commentId, textVal, attachmentsVal)
  return luaVkApi.invokeApi("board.editComment", {group_id=groupId, topic_id=topicId,
      comment_id=commentId, text=textVal, attachments=attachmentsVal})
end

function luaVkApi.restoreBoardTopicComment(groupId, topicId, commentId)
  return luaVkApi.invokeApi("board.restoreComment", {group_id=groupId, topic_id=topicId,
      comment_id=commentId})
end

function luaVkApi.deleteBoardTopicComment(groupId, topicId, commentId)
  return luaVkApi.invokeApi("board.deleteComment", {group_id=groupId, topic_id=topicId,
      comment_id=commentId})
end

function luaVkApi.openBoardTopic(groupId, topicId)
  return luaVkApi.invokeApi("board.openTopic", {group_id=groupId, topic_id=topicId})
end

function luaVkApi.closeBoardTopic(groupId, topicId)
  return luaVkApi.invokeApi("board.closeTopic", {group_id=groupId, topic_id=topicId})
end

function luaVkApi.fixBoardTopic(groupId, topicId)
  return luaVkApi.invokeApi("board.fixTopic", {group_id=groupId, topic_id=topicId})
end

function luaVkApi.unfixBoardTopic(groupId, topicId)
  return luaVkApi.invokeApi("board.unfixTopic", {group_id=groupId, topic_id=topicId})
end

-----------------------
--      Videos       --
-----------------------
function luaVkApi.getVideosInfo(ownerId, videoIds, albumId, countVal, offsetVal,
    isExtended)
  return luaVkApi.invokeApi("video.get", {owner_id=ownerId, videos=videoIds,
      album_id=albumId, count=countVal, offset=offsetVal, extended=isExtended})
end

function luaVkApi.editVideoInfo(ownerId, videoId, nameVal, descVal, privacyView,
    privacyComment, noComments)
  return luaVkApi.invokeApi("video.edit", {owner_id=ownerId, video_id=videoId,
      name=nameVal, desc=descVal, privacy_view=privacyView, 
      privacy_comment=privacyComment, no_comments=noComments})
end

function luaVkApi.addVideo(targetId, videoId, ownerId)
  return luaVkApi.invokeApi("video.add", {target_id=targetId, owner_id=ownerId,
      video_id=videoId})
end

function luaVkApi.saveVideo(nameVal, descVal, isPrivate, wallPost, linkVal,
    groupId, albumId, privacyView, privacyComment, noComments, isRepeat)
  return luaVkApi.invokeApi("video.save", {name=nameVal, description=descVal,
      is_private=isPrivate, wallpost=wallPost, link=linkVal, group_id=groupId,
      album_id=albumId, privacy_view=privacyView, privacy_comment=privacyComment,
      no_comments=noComments, is_repeat=isRepeat})
end

function luaVkApi.deleteVideo(videoId, ownerId, targetId)
  return luaVkApi.invokeApi("video.delete", {video_id=videoId, owner_id=ownerId,
      target_id=targetId})
end

function luaVkApi.restoreVideo(videoId, ownerId)
  return luaVkApi.invokeApi("video.restore", {video_id=videoId, owner_id=ownerId})
end

function luaVkApi.searchVideos(query, sortVal, isHD, isAdult, filtersVal, searchOwn,
    offsetVal, longerThan, shorterThan, countVal, isExtended)
  return luaVkApi.invokeApi("video.search", {q=query, sort=sortVal, hd=isHD,
      adult=isAdult, filters=filtersVal, search_own=searchOwn, offset=offsetVal,
      longer=longerThan, shorter=shorterThan, count=countVal, extended=isExtended})
end

function luaVkApi.getUserVideos(userId, offsetVal, countVal, isExtended)
  return luaVkApi.invokeApi("video.getUserVideos", {user_id=userId, offset=offsetVal, 
      count=countVal, extended=isExtended})
end

function luaVkApi.getVideoAlbums(ownerId, offsetVal, countVal, isExtended, needSystem)
  return luaVkApi.invokeApi("video.getAlbums", {owner_is=ownerId, offset=offsetVal, 
      count=countVal, extended=isExtended, need_system=needSystem})
end

function luaVkApi.getVideoAlbumById(ownerId, albumId)
  return luaVkApi.invokeApi("video.getAlbumById", {owner_is=ownerId, album_id=albumId})
end

function luaVkApi.addVideoAlbum(groupId, titleVal, privacyVal)
  return luaVkApi.invokeApi("video.addAlbum", {group_iid=groupId, title=titleVal,
      privacy=privacyVal})
end

function luaVkApi.editVideoAlbum(groupId, albumId, titleVal, privacyVal)
  return luaVkApi.invokeApi("video.editAlbum", {group_id=groupId, album_id=albumId, 
      title=titleVal, privacy=privacyVal})
end

function luaVkApi.deleteVideoAlbum(groupId, albumId)
  return luaVkApi.invokeApi("video.deleteAlbum", {group_id=groupId, album_id=albumId})
end

function luaVkApi.reorderVideoAlbums(ownerId, albumId, beforeVal, afterVal)
  return luaVkApi.invokeApi("video.reorderAlbums", {owner_id=ownerId, album_id=albumId,
      before=beforeVal, after=afterVal})
end

function luaVkApi.addVideoToAlbum(targetId, albumId, albumIds, ownerId, videoId)
  return luaVkApi.invokeApi("video.addToAlbum", {target_id=targetId, album_id=albumId,
      album_ids=albumIds, owner_id=ownerId, video_id=videoId})
end

function luaVkApi.removeVideoFromAlbum(targetId, albumId, albumIds, ownerId, videoId)
  return luaVkApi.invokeApi("video.removeFromAlbum", {target_id=targetId, album_id=albumId,
      album_ids=albumIds, owner_id=ownerId, video_id=videoId})
end

function luaVkApi.getAlbumsByVideo(targetId, ownerId, videoId, isExtended)
  return luaVkApi.invokeApi("video.getAlbumsByVideo", {target_id=targetId, owner_id=ownerId, 
      video_id=videoId, extended=isExtended})
end

function luaVkApi.getVideoComments(ownerId, videoId, needLikes, startCommentId, offsetVal,
    countVal, sortVal, isExtended)
  return luaVkApi.invokeApi("video.getComments", {owner_id=ownerId, video_id=videoId, 
      need_likes=needLikes, start_comment_id=startCommentId, offset=offsetVal,
      count=countVal, sort=sortVal, extended=isExtended})
end

function luaVkApi.createVideoComment(ownerId, videoId, messageVal, attachmentsVal,
    fromGroup, replyToComment, stickerId)
  return luaVkApi.invokeApi("video.createComment", {owner_id=ownerId, video_id=videoId, 
      message=messageVal, attachments=attachmentsVal, from_group=fromGroup,
      reply_to_comment=replyToComment, sticker_id=stickerId})
end

function luaVkApi.deleteVideoComment(ownerId, commentId)
  return luaVkApi.invokeApi("video.deleteComment", {owner_id=ownerId, comment_id=commentId})
end

function luaVkApi.restoreVideoComment(ownerId, commentId)
  return luaVkApi.invokeApi("video.restoreComment", {owner_id=ownerId, comment_id=commentId})
end

function luaVkApi.editVideoComment(ownerId, commentId, messageVal, attachmentsVal)
  return luaVkApi.invokeApi("video.editComment", {owner_id=ownerId, comment_id=commentId,
      message=messageVal, attachments=attachmentsVal})
end

function luaVkApi.getVideoTags(ownerId, videoId)
  return luaVkApi.invokeApi("video.getTags", {owner_id=ownerId, video_id=videoId})
end

function luaVkApi.putVideoTag(userId, ownerId, videoId, taggedName)
  return luaVkApi.invokeApi("video.putTag", {user_id=userId, owner_id=ownerId, 
      video_id=videoId, tagged_name=taggedName})
end

function luaVkApi.removeVideoTag(tagId, ownerId, videoId)
  return luaVkApi.invokeApi("video.removeTag", {tag_id=tagId, owner_id=ownerId, 
      video_id=videoId})
end

function luaVkApi.getNewVideoTags(offsetVal, countVal)
  return luaVkApi.invokeApi("video.getNewTags", {offset=offsetVal, count=countVal})
end

function luaVkApi.reportVideo(ownerId, videoId, reasonVal, commentVal, query)
  return luaVkApi.invokeApi("video.report", {owner_id=ownerId, video_id=videoId,
      reason=reasonVal, comment=commentVal, search_query=query})
end

function luaVkApi.reportVideoComment(ownerId, commentId, reasonVal)
  return luaVkApi.invokeApi("video.reportComment", {owner_id=ownerId, comment_id=commentId,
      reason=reasonVal})
end

function luaVkApi.hideVideoCatalogSection(sectionId)
  return luaVkApi.invokeApi("video.hideCatalogSection", {section_id=sectionId})
end

function luaVkApi.getVideoCatalogSection(sectionId, fromVal, countVal, isExtended)
  return luaVkApi.invokeApi("video.getCatalogSection", {section_id=sectionId, from=fromVal,
  	count=countVal, extended=isExtended})
end

function luaVkApi.getVideoCatalog(countVal, itemsCount, fromVal, isExtended, filtersVal,
	isGrouped)
  return luaVkApi.invokeApi("video.getCatalog", {count=countVal, items_count=itemsCount,
  	form=fromVal, extended=isExtended, filters=filtersVal, grouped=isGrouped})
end

function luaVkApi.reorderVideos(ownerId, videoId, targetId, albumId, beforeOwnerId,
	beforeVideoId, afterOwnerId, afterVideoId)
  return luaVkApi.invokeApi("video.reorderVideos", {owner_id=ownerId, video_id=videoId,
  	target_id=targetId, album_id=albumId, before_owner_id=beforeOwnerId,
  	before_video_id=beforeVideoId, after_owner_id=afterOwnerId,
  	after_video_id=afterVideoId})
end

-----------------------
--       Notes       --
-----------------------
function luaVkApi.getNotes(noteIds, userId, offsetVal, countVal, sortVal)
  return luaVkApi.invokeApi("notes.get", {note_ids=noteIds, user_id=userId,
      offset=offsetVal, count=countVal, sort=sortVal})
end

function luaVkApi.getNotesById(noteId, userId, needWiki)
  return luaVkApi.invokeApi("notes.getById", {note_id=noteId, user_id=userId,
      need_wiki=needWiki})
end

function luaVkApi.getFriendsNotes(offsetVal, countVal)
  return luaVkApi.invokeApi("notes.getFriendsNotes", {offset=offsetVal, count=countVal})
end

function luaVkApi.addNote(titleVal, textVal, privacyView, privacyComment)
  return luaVkApi.invokeApi("notes.add", {title=titleVal, text=textVal,
      privacy_view=privacyView, privacy_comment=privacyComment})
end

function luaVkApi.editNote(noteId, titleVal, textVal, privacyView, privacyComment)
  return luaVkApi.invokeApi("notes.edit", {note_id=noteId, title=titleVal, text=textVal,
      privacy_view=privacyView, privacy_comment=privacyComment})
end

function luaVkApi.deleteNote(noteId)
  return luaVkApi.invokeApi("notes.delete", {note_id=noteId})
end

function luaVkApi.getNoteComments(noteId, ownerId, sortVal, offsetVal, countVal)
  return luaVkApi.invokeApi("notes.getComments", {note_id=noteId, owner_id=ownerId,
      sort=sortVal, offset=offsetVal, count=countVal})
end

function luaVkApi.createNoteComment(noteId, ownerId, replyTo, messageVal)
  return luaVkApi.invokeApi("notes.createComment", {note_id=noteId, owner_id=ownerId,
      reply_to=replyTo, message=messageVal})
end

function luaVkApi.editNoteComment(commentId, ownerId, messageVal)
  return luaVkApi.invokeApi("notes.editComment", {comment_id=commentId, owner_id=ownerId,
      message=messageVal})
end

function luaVkApi.deleteNoteComment(commentId, ownerId)
  return luaVkApi.invokeApi("notes.deleteComment", {comment_id=commentId, owner_id=ownerId})
end 

function luaVkApi.restoreNoteComment(commentId, ownerId)
  return luaVkApi.invokeApi("notes.restoreComment", {comment_id=commentId, owner_id=ownerId})
end 

-----------------------
--      Places       --
-----------------------
function luaVkApi.addPlace(typeVal, titleVal, latitudeVal, longitudeVal, countryVal,
    cityVal, adressVal)
  return luaVkApi.invokeApi("places.add", {type=typeVal, title=titleVal, latitude=latitudeVal,
      longitude=longitudeVal, country=countryVal, city=cityVal, addres=adressVal})
end

function luaVkApi.getPlacesById(placesVal)
  return luaVkApi.invokeApi("places.getById", {places=placesVal})
end

function luaVkApi.searchPlaces(query, cityId, latitudeVal, longitudeVal, radiusVal,
    offsetVal, countVal)
  return luaVkApi.invokeApi("places.search", {q=query, city=cityId, latitude=latitudeVal,
      longitude=longitudeVal, radius=radiusVal, offset=offsetVal, count=countVal})
end

function luaVkApi.checkin(placeId, textVal, latitudeVal, longitudeVal, friendsOnly,
    servicesVal)
  return luaVkApi.invokeApi("places.checkin", {place_id=placeId, text=textVal,
      latitude=latitudeVal, longitude=longitudeVal, friends_only=friendsOnly,
      services=servicesVal})
end

function luaVkApi.getCheckins(latitudeVal, longitudeVal, placeVal, userId, offsetVal,
    countVal, timestampVal, friendsOnly, needPlaces)
  return luaVkApi.invokeApi("places.getCheckins", {latitude=latitudeVal, longitude=longitudeVal,
      place=placeVal, user_id=userId, offset=offsetVal, count=countVal,
      timestamp=timestampVal, friends_only=friendsOnly, need_paces=needPlaces})
end

function luaVkApi.getPlacesTypes()
  return luaVkApi.invokeApi("places.getTypes")
end

-----------------------
--      Account      --
-----------------------
function luaVkApi.getUserCounters(fiterVal)
  return luaVkApi.invokeApi("account.getCounters", {filter=fiterVal})
end

function luaVkApi.setAccountNameInMenu(userId, nameVal)
  return luaVkApi.invokeApi("account.setNameInMenu", {user_id=userId, name=nameVal})
end

function luaVkApi.setAccountOnline(voipVal)
  return luaVkApi.invokeApi("account.setOnline", {voip=voipVal})
end

function luaVkApi.setAccountOffline()
  return luaVkApi.invokeApi("account.setOffline")
end

function luaVkApi.lookupAccountContacts(contactsVal, serviceVal, mycontactVal, returnAll,
    fieldsVal)
  return luaVkApi.invokeApi("account.lookupContacts", {contacts=contactsVal, service=serviceVal,
	  mycontact=mycontactVal, return_all=returnAll, fields=fieldsVal})
end

function luaVkApi.registerDevice(tokenVal, deviceModel, deviceYear, deviceId, systemVersion,
    settingsVal, sandboxVal)
  return luaVkApi.invokeApi("account.registerDevice", {token=tokenVal, device_model=deviceModel,
      device_year=deviceYear, device_id=deviceId, system_version=systemVersion, settings=settingsVal,
	  sandbox=sandboxVal})
end

function luaVkApi.unregisterDevice(deviceId, isSandbox)
  return luaVkApi.invokeApi("account.unregisterDevice", {device_id=deviceId, sandbox=isSandbox})
end

function luaVkApi.setSilenceMode(deviceId, timeVal, peerId, soundVal)
  return luaVkApi.invokeApi("account.setSilenceMode", {device_id=deviceId, time=timeVal,
	  peer_id=peerId, sound=soundVal})
end

function luaVkApi.getPushSettings(deviceId)
  return luaVkApi.invokeApi("account.getPushSettings", {device_id=deviceId})
end

function luaVkApi.setPushSettings(deviceId, settingsVal, keyStr, valueStr)
  return luaVkApi.invokeApi("account.setPushSettings", {device_id=deviceId, settings=settingsVal,
	  key=keyStr, value=valueStr})
end

function luaVkApi.getAppPermissions(userId)
  return luaVkApi.invokeApi("account.getAppPermissions", {user_id=userId})
end

function luaVkApi.getActiveOffers(offsetVal, countVal)
  return luaVkApi.invokeApi("account.getActiveOffers", {offset=offsetVal, count=countVal})
end

function luaVkApi.banUser(userId)
  return luaVkApi.invokeApi("account.banUser", {user_id=userId})
end

function luaVkApi.unbanUser(userId)
  return luaVkApi.invokeApi("account.unbanUser", {user_id=userId})
end

function luaVkApi.getBanned(offsetVal, countVal)
  return luaVkApi.invokeApi("account.getBanned", {offset=offsetVal, count=countVal})
end

function luaVkApi.getInfo(fieldsVal)
  return luaVkApi.invokeApi("account.getInfo", {fields=fieldsVal})
end

function luaVkApi.setInfo(nameVal, val)
  return luaVkApi.invokeApi("account.setInfo", {name=nameVal, value=val})
end

function luaVkApi.changePassword(restoreSid, changePasswordHash, oldPassword, newPassword)
  return luaVkApi.invokeApi("account.changePassword", {restore_sid=restoreSid,
	  change_password_hash=changePasswordHash, old_password=oldPassword, new_password=newPassword})
end

function luaVkApi.getProfileInfo()
  return luaVkApi.invokeApi("account.getProfileInfo")
end

function luaVkApi.saveProfileInfo(firstName, lastName, maidenName, screenName, cancelRequestId,
	sexVal, relationVal, relationPartnerId, bdateVal, bdateVisibility, homeTown, countryId,
	cityId, statusVal)
  return luaVkApi.invokeApi("account.saveProfileInfo", {first_name=firstName, last_name=lastName,
	  maiden_name=maidenName, screen_name=screenName, cancel_request_id=cancelRequestId,
	  sex=sexVal, relation=relationVal, relation_partner_id=relationPartnerId, bdate=bdateVal,
	  bdate_visibility=bdateVisibility, home_town=homeTown, counry_id=countryId,
	  city_id=cityId, status=statusVal})
end

-----------------------
--     Messages      --
-----------------------
function luaVkApi.getPrivateMessages(outVal, offsetVal, countVal, timeOffset, filtersVal,
    previewLength, lastMessageId)
  return luaVkApi.invokeApi("messages.get", {out=outVal, offset=offsetVal, count=countVal,
      time_offset=timeOffset, filters=filtersVal, preview_length=previewLength, 
      last_message_id=lastMessageId})
end

function luaVkApi.getDialogs(offsetVal, countVal, startMessageId, previewLength, unreadVal)
  return luaVkApi.invokeApi("messages.getDialogs", {offset=offsetVal, count=countVal,
      start_message_id=startMessageId, preview_length=previewLength, unread=unreadVal})
end

function luaVkApi.getMessagesById(messageIds, previewLength)
  return luaVkApi.invokeApi("messages.getById", {message_ids=messageIds, preview_length=previewLength})
end

function luaVkApi.searchMessages(query, previewLength, offsetVal, countVal)
  return luaVkApi.invokeApi("messages.search", {q=query, preview_length=previewLength,
      offset=offsetVal, count=countVal})
end

function luaVkApi.getMessageHistory(offsetVal, countVal, userId, chatId, peerId, startMessageId,
    revVal)
  return luaVkApi.invokeApi("messages.getHistory", {offset=offsetVal, count=countVal, user_id=userId,
      chat_id=chatId, peer_id=peerId, start_message_id=startMessageId, rev=revVal})
end

function luaVkApi.sendMessage(userId, peerId, domainVal, chatId, userIds, messageStr, randomId,
    latVal, longVal, attachmentVal, forwardMessages, stickerId)
  return luaVkApi.invokeApi("messages.send", {user_id=userId, peer_id=peerId, domain=domainVal,
      chat_id=chatId, user_ids=userIds, message=messageStr, random_id=randomId, lat=latVal,
      long=longVal, attachment=attachmentVal, forward_messages=forwardMessages, sticker_id=stickerId})
end

function luaVkApi.deleteMessages(messageIds)
  return luaVkApi.invokeApi("messages.delete", {message_ids=messageIds})
end

function luaVkApi.deleteDialog(userId, peerId, offsetVal, countVal)
  return luaVkApi.invokeApi("messages.deleteDialog", {user_id=userId, peer_id=peerId, offset=offsetVal,
      count=countVal})
end

function luaVkApi.restoreMessage(messageId)
  return luaVkApi.invokeApi("messages.restore", {message_id=messageId})
end

function luaVkApi.markAsRead(messageIds, peerId, startMessageId)
  return luaVkApi.invokeApi("messages.markAsRead", {message_ids=messageIds, peer_id=peerId,
      start_message_id=startMessageId})
end

function luaVkApi.markAsImportant(messageIds, isImportant)
  return luaVkApi.invokeApi("messages.markAsImportant", {message_ids=messageIds, important=isImportant})
end

function luaVkApi.getLongPollServer(useSSL, needPts)
  return luaVkApi.invokeApi("messages.getLongPollServer", {use_ssl=useSSL, need_pts=needPts})
end

function luaVkApi.getLongPollHistory(tsVal, ptsVal, previewLength, isOnlines, fieldsVal, 
    eventsLimit, msgsLimit, maxMsgId)
  return luaVkApi.invokeApi("messages.getLongPollHistory", {ts=tsVal, pts=ptsVal, 
      preview_length=previewLength, onlines=isOnlines, fields=fieldsVal, events_limit=eventsLimit,
      msgs_limit=msgsLimit, max_msg_id=maxMsgId})
end

function luaVkApi.getChat(chatId, chatIds, fieldsVal, nameCase)
  return luaVkApi.invokeApi("messages.getChat", {chat_id=chatId, chat_ids=chatIds, fields=fieldsVal,
      name_case=nameCase})
end

function luaVkApi.createChat(userIds, titleVal)
  return luaVkApi.invokeApi("messages.createChat", {user_ids=userIds, title=titleVal})
end

function luaVkApi.editChat(chatId, titleVal)
  return luaVkApi.invokeApi("messages.editChat", {chat_id=chatId, title=titleVal})
end

function luaVkApi.getChatUsers(chatId, chatIds, fieldsVal, nameCase)
  return luaVkApi.invokeApi("messages.getChatUsers", {chat_id=chatId, chat_ids=chatIds,
      fields=fieldsVal, name_case=nameCase})
end

function luaVkApi.setActivity(userId, typeVal, peerId)
  return luaVkApi.invokeApi("messages.setActivity", {user_id=userId, type=typeVal,
      peer_id=peerId})
end

function luaVkApi.searchDialogs(query, limitVal, fieldsVal)
  return luaVkApi.invokeApi("messages.searchDialogs", {q=query, limit=limitVal,
      fields=fieldsVal})
end

function luaVkApi.addChatUser(chatId, userId)
  return luaVkApi.invokeApi("messages.addChatUser", {chat_id=chatId, user_id=userId})
end

function luaVkApi.removeChatUser(chatId, userId)
  return luaVkApi.invokeApi("messages.removeChatUser", {chat_id=chatId, user_id=userId})
end

function luaVkApi.getLastActivity(userId)
  return luaVkApi.invokeApi("messages.getLastActivity", {user_id=userId})
end

function luaVkApi.setChatPhoto(fileVal)
  return luaVkApi.invokeApi("messages.setChatPhoto", {file=fileVal})
end

function luaVkApi.deleteChatPhoto(chatId)
  return luaVkApi.invokeApi("messages.deleteChatPhoto", {chat_id=chatId})
end

function luaVkApi.getMessageHistoryAttachments(peerId, mediaType, startFrom,
	countVal, photoSizes, fieldsVal)
  return luaVkApi.invokeApi("messages.getHistoryAttachments", {peer_id=peerId,
  	media_type=mediaType, start_from=startFrom, count=countVal, photo_sizes=photoSizes,
  	fields=fieldsVal})
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
  return luaVkApi.invokeApi("newsfeed.addBan", {user_ids=userIds, group_ids=groupIds})
end 

function luaVkApi.deleteBan(userIds, groupIds)
  return luaVkApi.invokeApi("newsfeed.deleteBan", {user_ids=userIds, group_ids=groupIds})
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
      latitude=latitudeVal, longitude=longitudeVal, start_time=startTime, endTime=endTime, 
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
function luaVkApi.getLikerIds(typeVal, ownerId, itemId, pageUrl, filterVal,
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
      question=questionStr, add_answers=addAnswers, edit_answers=editAnswers,
      delete_answers=deleteAnswers})
end

-----------------------
--    Documents      --
-----------------------
function luaVkApi.getDocuments(countVal, offsetVal, ownerId)
  return luaVkApi.invokeApi("docs.get", {count=countVal, offset=offsetVal, owner_id=ownerId})
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

function luaVkApi.getDocTypes(ownerId)
  return luaVkApi.invokeApi("docs.getTypes", {owner_id=ownerId})
end

function luaVkApi.searchDocs(queryStr, countVal, offsetVal)
  return luaVkApi.invokeApi("docs.search", {q=queryStr, count=countVal, offset=offsetVal})
end

function luaVkApi.editDoc(ownerId, docId, titleVal, tagsVal)
  return luaVkApi.invokeApi("docs.edit", {owner_id=ownerId, doc_id=docId, title=titleVal,
  	tags=tagsVal})
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

function luaVkApi.removeBookmarkedGroup(groupId)
  return luaVkApi.invokeApi("fave.removeGroup", {group_id=groupId})
end

function luaVkApi.bookmarkLink(linkStr, textStr)
  return luaVkApi.invokeApi("fave.addLink", {link=linkStr, text=textStr})
end

function luaVkApi.removeBookmarkedLink(linkId)
  return luaVkApi.invokeApi("fave.removeLink", {link_id=linkId})
end

function luaVkApi.getLikedMarketItems(countVal, offsetVal, isExtended)
  return luaVkApi.invokeApi("fave.getMarketItems", {offset=offsetVal, count=countVal,
      extended=isExtended})
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
  return luaVkApi.invokeApi("apps.sendRequest", {user_id=userId, text=textVal, type=typeVal,
  	name=nameVal, key=keyVal, separate=separateVal})
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
--      Leads        --
-----------------------
function luaVkApi.completeLead(vkSid, secretVal, commentVal)
  return luaVkApi.invokeApi("leads.complete", {vk_sid=vkSid, secret=secretVal, comment=commentVal})
end

function luaVkApi.startLead(leadId, secretVal, aId, uId, testMode, isForce)
  return luaVkApi.invokeApi("leads.start", {lead_id=leadId, secret=secretVal, aid=aId,
  	uid=uId, test_mode=testMode, force=isForce})
end

function luaVkApi.getLeadStats(leadId, secretVal, dateStart, dateEnd)
  return luaVkApi.invokeApi("leads.getStats", {lead_id=leadId, secret=secretVal, date_start=dateStart,
  	date_end=dateEnd})
end

function luaVkApi.getLeadUsers(offerId, secretVal, offsetVal, countVal, statusVal, isReverse)
  return luaVkApi.invokeApi("leads.getUsers", {offer_id=offerId, secret=secretVal, offset=offsetVal,
  	count=countVal, status=statusVal, reverse=isReverse})
end

function luaVkApi.checkLeadUser(leadId, testResult, testMode, autoStart, ageVal, countryVal)
  return luaVkApi.invokeApi("leads.getUsers", {lead_id=leadId, test_result=testResult, test_mode=testMode,
  	auto_start=autoStart, age=ageVal, country=countryVal})
end

function luaVkApi.metricHit(dataVala)
  return luaVkApi.invokeApi("leads.metricHit", {data=dataVala})
end

-----------------------
--      Market       --
-----------------------
function luaVkApi.getMarketItems(ownerId, albumId, countVal, offsetVal, isExtended)
  return luaVkApi.invokeApi("market.get", {owner_id=ownerId, album_id=albumId, count=countVal,
      offset=offsetVal, extended=isExtended})
end

function luaVkApi.getMarketItemsById(itemIds, isExtended)
  return luaVkApi.invokeApi("market.getById", {item_ids=itemIds, extended=isExtended})
end

function luaVkApi.searchMarketItems(ownerId, albumId, query, priceFrom, priceTo, tagsVal,
    sortVal, revVal, offsetVal, countVal, isExtended)
  return luaVkApi.invokeApi("market.search", {owner_id=ownerId, album_id=albumId, 
      q=query, price_from=priceFrom, price_to=priceTo, tags=tagsVal, sort=sortVal,
	  rev=revVal, offset=offsetVal, count=countVal, extended=isExtended})
end

function luaVkApi.getMarketAlbums(ownerId, offsetVal, countVal)
  return luaVkApi.invokeApi("market.getAlbums", {owner_id=ownerId, offset=offsetVal,
      count=countVal})
end

function luaVkApi.getMarketAlbumsById(ownerId, albumIds)
  return luaVkApi.invokeApi("market.getAlbumById", {owner_id=ownerId, album_ids=albumIds})
end

function luaVkApi.createMarketComment(ownerId, itemId, messageVal, attachmentsVal,
    fromGroup, replyToComment, stickerId, guId)
  return luaVkApi.invokeApi("market.createComment", {owner_id=ownerId, item_id=itemId,
      message=messageVal, attachments=attachmentsVal, from_group=fromGroup,
	  reply_to_comment=replyToComment, sticker_id=stickerId, guid=guId})
end

function luaVkApi.getMarketComments(ownerId, itemId, needLikes, startCommentId,
    offsetVal, countVal, sortVal, isExtended, fieldsVal)
  return luaVkApi.invokeApi("market.getComments", {owner_id=ownerId, item_id=itemId,
      need_likes=needLikes, start_comment_id=startCommentId, offset=offsetVal,
	  count=countVal, sort=sortVal, extended=isExtended, fields=fieldsVal})
end

function luaVkApi.deleteMarketComment(ownerId, commentId)
  return luaVkApi.invokeApi("market.deleteComment", {owner_id=ownerId, 
      comment_id=commentId})
end

function luaVkApi.restoreMarketComment(ownerId, commentId)
  return luaVkApi.invokeApi("market.restoreComment", {owner_id=ownerId, 
      comment_id=commentId})
end

function luaVkApi.editMarketComment(ownerId, commentId, messageVal, attachmentsVal)
  return luaVkApi.invokeApi("market.editComment", {owner_id=ownerId, 
      comment_id=commentId, message=messageVal, attachments=attachmentsVal})
end

function luaVkApi.reportMarketComment(ownerId, commentId, reasonVal)
  return luaVkApi.invokeApi("market.reportComment", {owner_id=ownerId, 
      comment_id=commentId, reason=reasonVal})
end

function luaVkApi.getMarketCategories(countVal, offsetVal)
  return luaVkApi.invokeApi("market.getCategories", {count=countVal, offset=offsetVal})
end

function luaVkApi.reportMarketItem(ownerId, itemId, reasonVal)
  return luaVkApi.invokeApi("market.report", {owner_id=ownerId, item_id=itemId,
      reason=reasonVal})
end

function luaVkApi.addMarketItem(ownerId, nameVal, descriptionVal, categoryId,
    priceVal, isDeleted, mainPhotoId, photoIds)
  return luaVkApi.invokeApi("market.add", {owner_id=ownerId, name=nameVal,
      description=descriptionVal, category_id=categoryId, price=priceVal,
	  deleted=isDeleted, main_photo_id=mainPhotoId, photo_ids=photoIds})
end

function luaVkApi.editMarketItem(ownerId, itemId, nameVal, descriptionVal, categoryId,
    priceVal, isDeleted, mainPhotoId, photoIds)
  return luaVkApi.invokeApi("market.edit", {owner_id=ownerId, item_id=itemId, 
	  name=nameVal, description=descriptionVal, category_id=categoryId, price=priceVal,
	  deleted=isDeleted, main_photo_id=mainPhotoId, photo_ids=photoIds})
end

function luaVkApi.deleteMarketItem(ownerId, itemId)
  return luaVkApi.invokeApi("market.delete", {owner_id=ownerId, item_id=itemId})
end

function luaVkApi.restoreMarketItem(ownerId, itemId)
  return luaVkApi.invokeApi("market.restore", {owner_id=ownerId, item_id=itemId})
end

function luaVkApi.reorderMarketItems(ownerId, albumId, itemId, beforeVal, afterVal)
  return luaVkApi.invokeApi("market.reorderItems", {owner_id=ownerId, album_id=albumId,
      item_id=itemId, before=beforeVal, after=afterVal})
end

function luaVkApi.reorderMarketAlbums(ownerId, albumId, beforeVal, afterVal)
  return luaVkApi.invokeApi("market.reorderAlbums", {owner_id=ownerId, album_id=albumId,
      before=beforeVal, after=afterVal})
end

function luaVkApi.addMarketAlbum(ownerId, titleVal, photoId, mainAlbum)
  return luaVkApi.invokeApi("market.addAlbum", {owner_id=ownerId, title=titleVal,
      photo_id=photoId, main_album=mainAlbum})
end

function luaVkApi.editMarketAlbum(ownerId, albumId, titleVal, photoId, mainAlbum)
  return luaVkApi.invokeApi("market.editAlbum", {owner_id=ownerId, album_id=albumId,
      title=titleVal, photo_id=photoId, main_album=mainAlbum})
end

function luaVkApi.deleteMarketAlbum(ownerId, albumId)
  return luaVkApi.invokeApi("market.deleteAlbum", {owner_id=ownerId, album_id=albumId})
end

function luaVkApi.removeFromMarketAlbum(ownerId, itemId, albumIds)
  return luaVkApi.invokeApi("market.removeFromAlbum", {owner_id=ownerId, item_id=itemId,
      album_ids=albumIds})
end

function luaVkApi.addToMarketAlbum(ownerId, itemId, albumIds)
  return luaVkApi.invokeApi("market.addToAlbum", {owner_id=ownerId, item_id=itemId,
      album_ids=albumIds})
end

-----------------------
--      Other        --
-----------------------
function luaVkApi.executeCode(codeStr)
  return luaVkApi.invokeApi("execute", {code=codeStr})
end



return luaVkApi
