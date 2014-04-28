
siteUrl = 'http://www.thank-a-teacher.org' + window.location.pathname
twitterHandle = '@ThankAMentor'

default_tweet = "Ever wanted to send a thank you note to a past teacher? Take a min to @ThankAMentor via this student project at http://thank-a-teacher.org"
default_email =
    subject: "Join me in taking 2 min to thank a teacher and support this student project"
    body: "We've all been students. Let's take a min to thank a teacher who helped us become who we are today with this student project. Check out http://thank-a-teacher.org"
default_fb = 
    name: 'Thank A Teacher',
    caption: 'Ever wanted to send a thank you note to a past teacher? Check out this student project.'
    link: siteUrl
    picture: "http://i62.tinypic.com/mv3nfl.jpg"

personalized_email =
    subject: "Join me in taking 2 min to thank a teacher and support this student project"
    body1: "I just sent a thank you note to one of my past teachers: " 
    body2: " . Who impacted your life? Show them your appreciation by taking 2 min to send them a thank you at http://thank-a-teacher.org"
personalized_fb = 
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
    personalized_setupFacebook()
    personalized_setupTwitter()
    personalized_setupEmail()

setupButton = (url, network, button) ->
    button.click ->
        mixpanel.track 'share',
          content: 'site'
          network: {network}
        window.open url, '_blank'

default_setupFacebook = (container) ->
    FBinit()
    $('.js-share-facebook').click ->
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
    setupButton twitterUrl, 'twitter', $ '.js-share-twitter', container

default_setupGooglePlus = (container) ->
    encoded = encodeURIComponent siteUrl
    googlePlusUrl = "https://plus.google.com/share?url=#{encoded}"
    setupButton googlePlusUrl, 'googleplus', $ '.js-share-google-plus', container

default_setupEmail = (container) ->
    emailUrl = "mailto:?Subject=#{encodeURIComponent default_email.subject}&Body=#{encodeURIComponent default_email.body}"
    $('.js-share-email').click ->
        window.location = emailUrl

personalized_setupFacebook = () ->
    FBinit()
    $('.js-facebook-button').click ->
        FB.ui
            method: "feed"
            name: personalized_fb.name,
            caption: personalized_fb.caption
            link: 'http://www.thank-a-teacher.org' + window.location.pathname
            picture: personalized_fb.picture
        , (response) ->
            console.log personalized_fb.link
            return

# The window.location.pathname is being loaded before getting to the thank-you route. Fix this.
personalized_setupTwitter = () ->
    personalized_tweet = "I just sent a thank you note to a past teacher: " + 'http://www.thank-a-teacher.org' + window.location.pathname + " . Send a thank you note to a teacher using @ThankaMentor"
    $('.js-twitter-button').val(personalized_tweet)
    $('.js-twitter-button').click ->
        personalized_tweet = $('.js-twitter-postcard-text').val()
        twitterMessage = "https://twitter.com/intent/tweet?text="+personalized_tweet
        window.open twitterMessage, '_blank'


personalized_setupEmail = () ->
    $('.js-email-button').click ->
        emailUrl = "mailto:?Subject=#{encodeURIComponent personalized_email.subject}&Body=" + personalized_email.body1 + 'http://www.thank-a-teacher.org' + window.location.pathname + personalized_email.body2
        window.location = emailUrl

