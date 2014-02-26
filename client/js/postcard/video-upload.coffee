config =
    # REQUIRED
    # See https://developers.google.com/api-client-library/javascript/features/authentication
    # for instructions on registering for OAuth 2.
    # After generating your OAuth 2 client id, you MUST then visit the "Services" tab of
    # https://code.google.com/apis/console/ find the entry for "YouTube Data API v3"
    # and flip it to "ON".
    OAUTH2_CLIENT_ID: '40051200930.apps.googleusercontent.com'

    # REQUIRED
    # Register at https://code.google.com/apis/youtube/dashboard/gwt/index.html to get your own key.
    DEVELOPER_KEY: '40051200930.apps.googleusercontent.com'

    # If you'd like to enable Google Analytics statistics to your YouTube Direct Lite instance,
    # register for a Google Analytics account and enter your id code below.
    #,GOOGLE_ANALYTICS_ID: 'UA-########-#'

    # Setting any or all of these three fields are optional.
    # If set then the value(s) will be used for new video uploads, and your users won't be prompted for the corresponding fields on the video upload form.
    #VIDEO_TITLE: 'Video Submission'
    #VIDEO_DESCRIPTION: 'This is a video submission.'
    # Make sure that this corresponds to an assignable category!
    # See https://developers.google.com/youtube/2.0/reference#YouTube_Category_List
    VIDEO_CATEGORY: 'Education'

constants =
    CATEGORIES_CACHE_EXPIRATION_MINUTES: 3 * 24 * 60,
    CATEGORIES_CACHE_KEY: 'categories'
    DISPLAY_NAME_CACHE_KEY: 'display_name'
    UPLOADS_LIST_ID_CACHE_KEY: 'uploads_list_id'
    PROFILE_PICTURE_CACHE_KEY: 'profile_picture'
    GENERIC_PROFILE_PICTURE_URL: '//s.ytimg.com/yt/img/no_videos_140-vfl1fDI7-.png'
    OAUTH2_TOKEN_TYPE: 'Bearer'
    OAUTH2_SCOPE: 'https://gdata.youtube.com'
    GDATA_SERVER: 'https://gdata.youtube.com'
    CLIENT_LIB_LOAD_CALLBACK: 'onClientLibReady'
    CLIENT_LIB_URL: 'https://apis.google.com/js/client.js?onload='
    YOUTUBE_API_SERVICE_NAME: 'youtube'
    YOUTUBE_API_VERSION: 'v3'
    PAGE_SIZE: 50
    MAX_ITEMS_TO_RETRIEVE: 200
    FEED_CACHE_MINUTES: 5
    STATE_CACHE_MINUTES: 15
    MAX_KEYWORD_LENGTH: 30
    KEYWORD_UPDATE_XML_TEMPLATE: '<?xml version="1.0"?> <entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007" xmlns:gd="http://schemas.google.com/g/2005" gd:fields="media:group/media:keywords"> <media:group> <media:keywords>{0}</media:keywords> </media:group> </entry>'
    WIDGET_EMBED_CODE: '<iframe width="420" height="500" src="{0}#playlist={1}"></iframe>'
    PLAYLIST_EMBED_CODE: '<iframe width="640" height="360" src="//www.youtube.com/embed/?listType=playlist&list={0}&showinfo=1" frameborder="0" allowfullscreen></iframe>'
    SUBMISSION_RSS_FEED: 'https://gdata.youtube.com/feeds/api/videos?v=2&alt=rss&orderby=published&category=%7Bhttp%3A%2F%2Fgdata.youtube.com%2Fschemas%2F2007%2Fkeywords.cat%7D{0}'
    DEFAULT_KEYWORD: 'ytdl'
    WEBCAM_VIDEO_TITLE: 'Webcam Submission'
    WEBCAM_VIDEO_DESCRIPTION: 'Uploaded via a webcam.'
    REJECTED_VIDEOS_PLAYLIST: 'Rejected YTDL Submissions'
    NO_THUMBNAIL_URL: '//i.ytimg.com/vi/hqdefault.jpg'
    VIDEO_CONTAINER_TEMPLATE: '<li><div class="video-container {additionalClass}"><input type="button" class="submit-video-button" value="Submit Video"><div><span class="video-title">{title}</span><span class="video-duration">({duration})</span></div><div class="video-uploaded">Uploaded on {uploadedDate}</div><div class="thumbnail-container" data-video-id="{videoId}"><img src="{thumbnailUrl}" class="thumbnail-image"><img src="images/play.png" class="play-overlay"></div></div></li>'
    VIDEO_LI_TEMPLATE: '<li><div class="video-container {0}"><input type="button" class="submit-video-button" data-video-id="{1}" data-existing-keywords="{2}" value="Submit Video"><div><span class="video-title">{3}</span><span class="video-duration">({5})</span></div><div class="video-uploaded">Uploaded on {4}</div><div class="thumbnail-container" data-video-id="{1}"><img src="{6}" class="thumbnail-image"><img src="./images/play.png" class="play-overlay"></div></div></li>'
    ADMIN_VIDEO_LI_TEMPLATE: '<li><div class="video-container">{buttonsHtml}<div><span class="video-title">{title}</span><span class="video-duration">({duration})</span></div><div class="video-uploaded">Uploaded on {uploadedDate} by {uploader}</div><div class="thumbnail-container" data-video-id="{videoId}"><img src="{thumbnailUrl}" class="thumbnail-image"><img src="./images/play.png" class="play-overlay"></div></div></li>'
    PLAYLIST_LI_TEMPLATE: '<li data-playlist-name="{playlistName}" data-state="embed-codes" data-playlist-id="{playlistId}">{playlistName}</li>'

webcam =
    init: () ->
        if not YT? or not YT.UploadWidget?
            window.onYouTubeIframeAPIReady = () ->
                webcam.loadUploadWidget()
            $.getScript('//www.youtube.com/iframe_api')
        else
            webcam.loadUploadWidget()

    loadUploadWidget: () ->
        new YT.UploadWidget('webcam-widget',
            webcamOnly: true
            events:
                onApiReady: (event) ->
                    event.target.setVideoTitle(config.VIDEO_TITLE or constants.WEBCAM_VIDEO_TITLE)
                    event.target.setVideoDescription(config.VIDEO_DESCRIPTION or constants.WEBCAM_VIDEO_DESCRIPTION)
                    # event.target.setVideoKeywords([utils.generateKeywordFromPlaylistId(globals.hashParams.playlist)])

                onUploadSuccess: (event) ->
                    console.log("Webcam submission success!")
                    console.log(event)
                    $('#youtube_id').val(event.data.videoId)
                    window.VIDRECORDER.close()

                    # utils.addVideoToPlaylist("Pending", event.data.videoId)

                onStateChange: (event) ->
                    if event.data.state == YT.UploadWidgetState.ERROR
                        console.error("Webcam submission error!")
        )

utils =
    itemsInResponse: (response) ->
        return ('items' in response and response.items.length > 0)

    # addVideoToPlaylist: (playlistId, videoId) ->
    #     console.log("Trying to add video to playlist!")
    #     console.log(videoId)
    #     console.log(playlistId)

    #     lscache.remove(constants.GDATA_SERVER + '/feeds/api/users/default/playlists')
    #     lscache.remove(playlistId)

    #     request = gapi.client.youtube.playlistItems.insert(
    #             part: 'snippet'
    #             resource:
    #                 snippet:
    #                     playlistId: playlistId
    #                     resourceId:
    #                         kind: 'youtube#video'
    #                         videoId: videoId
    #                     position: 0
    #     )

    #     request.execute((response) ->
    #         if 'error' in response
    #             console.log(response.error)
    #             console.error('Could not add video playlist. ')
    #         else
    #             console.log('Success adding video to playlist!')
    #     )

auth =
    initAuth: () ->
        window[constants.CLIENT_LIB_LOAD_CALLBACK] = () ->
            gapi.auth.init(() ->
                if lscache.get(constants.DISPLAY_NAME_CACHE_KEY) # FIXME
                    window.setTimeout(() ->
                        gapi.auth.authorize(
                            client_id: config.OAUTH2_CLIENT_ID
                            scope: [constants.OAUTH2_SCOPE]
                            immediate: true
                        , auth.onAuthResult)
                    , 1)
                    console.log('auth script launched')
                else
                    console.log('requesting YT login')
                    # gapi.auth.authorize({
                    #     client_id: config.OAUTH2_CLIENT_ID
                    #     scope: [constants.OAUTH2_SCOPE]
                    #     immediate: false}
                    #     , auth.onAuthResult
                    # )
            )
        $.getScript(constants.CLIENT_LIB_URL + constants.CLIENT_LIB_LOAD_CALLBACK)

    onAuthResult: (authResult) ->
        if authResult
            console.log('Got auth result', authResult)
            gapi.client.load(constants.YOUTUBE_API_SERVICE_NAME, constants.YOUTUBE_API_VERSION, auth.onYouTubeClientLoad)
        else
            console.log('Auth failed')
            lscache.flush() # FIXME
            # utils.redirect('login')

    onYouTubeClientLoad: () ->
        #   var nextState = globals.hashParams.state || '';
        #   if (nextState == 'login') {
        #     nextState = '';
        #   }
        console.log('Youtube client loaded!')
        if lscache.get(constants.DISPLAY_NAME_CACHE_KEY) # FIXME
            # utils.redirect(nextState);
        else
            request = gapi.client[constants.YOUTUBE_API_SERVICE_NAME].channels.list(
                mine: true
                part: 'snippet,contentDetails,status'
            )
            request.execute( (response) ->
                if utils.itemsInResponse(response) # FIXME
                    if response.items[0].status.isLinked
                        lscache.set(constants.UPLOADS_LIST_ID_CACHE_KEY, response.items[0].contentDetails.relatedPlaylists.uploads)
                        lscache.set(constants.DISPLAY_NAME_CACHE_KEY, response.items[0].snippet.title)
                        lscache.set(constants.PROFILE_PICTURE_CACHE_KEY, response.items[0].snippet.thumbnails.default.url)
                        # utils.redirect(nextState)
                    else
                        console.error('Your account cannot upload videos. Please visit <a target="_blank" href="https://www.youtube.com/signin?next=/create_channel">https://www.youtube.com/signin?next=/create_channel</a> to add a YouTube channel to your account, and try again.')
                else
                    console.log(response)
                    console.error("Unable to retrieve channel info.")
            )

does_meet_requirements = ->
    if not $.support.cors
        console.error("Browser not supported!")
        return false
    else
        return true


exports.setup = ->
    if not config.OAUTH2_CLIENT_ID or not config.DEVELOPER_KEY
        console.log("NOT CONFIGURED!")
    else
        console.log("Configured!")
        if does_meet_requirements
            auth.initAuth()
            webcam.init()
