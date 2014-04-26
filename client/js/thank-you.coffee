currentUrl = 'http://localhost:5001'
siteUrl = 'http://thank-a-teacher.org'
twitterHandle = '@ThankAMentor'
emailSubject = 'Join me in taking 2 min to thank a teacher and support this student project'
emailText = "We've all been students. Let's take a min to thank a teacher who helped us become who we are today via @ThankAMentor. Check out http://thank-a-teacher.org"
message = "We've all been students. Let's take a min to thank a teacher who helped us become who we are today via " + twitterHandle + " "

email =
    subject: 'Thank a teacher'
    body: "#{message}\n\nCheck out #{siteUrl}"

FBinit =  ->
    window.fbAsyncInit = ->
        FB.init
            appId: "229910487211463"
            status: true
            xfbml: true

    fjs = document.getElementsByTagName('script')[0]
    return if document.getElementById 'facebook-jssdk'
    
    js = document.createElement 'script'
    js.id = 'facebook-jssdk'
    js.source = '//connect.facebook.net/en_US/all.js'
    fjs.parentNode.insertBefore js, fjs

setupButton = (url, network, button) ->
    button.click ->
        console.log 'setting up button...'
        mixpanel.track 'share',
          content: 'note'
          network: {network}
        window.open url, '_blank'

setupFacebook = () ->
    $('.js-facebook-button').click ->
        FB.ui
            method: "feed"
            name: 'Thank A Teacher',
            caption: 'Ever wanted to send a thank you note to a past teacher? Check out this student project.'
            link: 'https://thank-a-teacher.org'
            picture: "http://i62.tinypic.com/mv3nfl.jpg"
        , (response) ->
            console.log "FB opened"
            return

setupTwitter = () ->
    encoded = encodeURIComponent siteUrl
    twitterUrl = "https://twitter.com/share?text=#{message}"
    setupButton twitterUrl, 'twitter', $ '.js-twitter-button'

setupEmail = () ->
    $('.js-email-button').click ->
        window.location = "mailto:?subject="+emailSubject+"&body="+emailText

setupButtons = () ->
    FBinit()
    setupFacebook()
    setupTwitter()
    setupEmail()
    return


getPostcardId = ->
    url = window.location.pathname
    index = url.lastIndexOf? '/'
    return unless index >= 0

    idString = url[index+1...]
    if idString.length >= 24
        idString[...24]
    else
        null

getPostcard = (postcardId, done) ->
    $.get "/postcards/#{postcardId}"
    .done (result) ->
        if result.success then done null, result
        else done result.error
    .fail (error) -> done error

showError = (error) ->
    console.error error
    window.open '/404', '_self'

$ ->
    postcardId = getPostcardId()
    return showError 'We couldn\'t find this thank you note.' unless postcardId

    setupButtons()

    getPostcard postcardId, (error, result) ->
        return showError (error.message or error) if error
        require('./postcard.coffee').run result
