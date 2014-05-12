
siteUrl = 'http://www.thank-a-teacher.org'
twitterHandle = '@ThankAMentor'

default_tweet = "Ever wanted to send a thank you note to a past teacher? Take a min to #{twitterHandle} via this student project: #{siteUrl}"
default_email =
    subject: "Take a minute to thank a past teacher and support this student project"
    body: "Ever wanted to send a thank you note to a past teacher? Show them your appreciation by taking a minute to send them a thank you note and support this student project at #{siteUrl}"
default_fb = 
    name: 'Thank A Teacher: A Student Project',
    caption: 'Take a minute to thank a past teacher'
    link: siteUrl
    picture: "http://i62.tinypic.com/mv3nfl.jpg"

FBinit = ->
    window.fbAsyncInit = ->
        FB.init
            appId: "229910487211463"
            status: true
            xfbml: true
        return
    ((d, s, id) ->
        js = undefined
        fjs = d.getElementsByTagName(s)[0]
        return  if d.getElementById(id)
        js = d.createElement(s)
        js.id = id
        js.src = "//connect.facebook.net/en_US/all.js"
        fjs.parentNode.insertBefore js, fjs
        return
    ) document, "script", "facebook-jssdk"

exports.setupButtons = (container) ->
    container = $ container
    default_setupFacebook container
    default_setupTwitter container
    default_setupGooglePlus container
    default_setupEmail container

setupButton = (url, network, button) ->
    button.click ->
        mixpanel.track 'share',
          content: 'site'
          network: {network}
        window.open url, '_blank'

default_setupFacebook = (container) ->
    FBinit()
    $('.js-share-facebook', container).click ->
        FB.ui
            method: "feed"
            name: default_fb.name,
            caption: default_fb.caption
            link: default_fb.link
            picture: default_fb.picture
        , (response) ->
            return

default_setupTwitter = (container) ->
    encoded = encodeURIComponent default_tweet
    twitterUrl = "https://twitter.com/intent/tweet?text=#{encoded}"
    setupButton twitterUrl, 'twitter', $('.js-share-twitter', container)

default_setupGooglePlus = (container) ->
    encoded = encodeURIComponent siteUrl
    googlePlusUrl = "https://plus.google.com/share?url=#{encoded}"
    setupButton googlePlusUrl, 'googleplus', $('.js-share-google-plus', container)

default_setupEmail = (container) ->
    encoded_subject = encodeURIComponent default_email.subject
    encoded_body = encodeURIComponent default_email.body
    emailUrl = "mailto:?Subject=#{encoded_subject}&Body=#{encoded_body}"
    $('.js-share-email', container).click ->
        window.location = emailUrl

