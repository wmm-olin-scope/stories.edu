
siteUrl = 'http://www.thank-a-teacher.org'

default_tweet = "Ever wanted to send a thank you note to a past teacher? Take a min to @ThankAMentor via this student project at http://thank-a-teacher.org"
default_email =
    subject: "Join me in taking 2 min to thank a teacher and support this student project"
    body: "We've all been students. Let's take a min to thank a teacher who helped us become who we are today with this student project. Check out http://thank-a-teacher.org"
default_fb = 
    name: 'Thank A Teacher',
    caption: 'Ever wanted to send a thank you note to a past teacher? Check out this student project.'
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
            console.log "FB opened"
            return

default_setupTwitter = (container) ->
    twitterUrl = "https://twitter.com/intent/tweet?text="+default_tweet
    setupButton twitterUrl, 'twitter', $('.js-share-twitter', container)

default_setupGooglePlus = (container) ->
    encoded = encodeURIComponent siteUrl
    googlePlusUrl = "https://plus.google.com/share?url=#{encoded}"
    setupButton googlePlusUrl, 'googleplus', $('.js-share-google-plus', container)

default_setupEmail = (container) ->
    emailUrl = "mailto:?Subject=#{default_email.subject}&Body=#{default_email.body}"
    $('.js-share-email', container).click ->
        window.location = emailUrl

