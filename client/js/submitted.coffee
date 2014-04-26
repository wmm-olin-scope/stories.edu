currentUrl = 'http://localhost:5001'
siteUrl = 'http://thank-a-teacher.org'
twitterHandle = '@ThankAMentor'
emailSubject = 'Join me in taking 2 min to thank a teacher and support this student project'
emailText = "We've all been students. Let's take a min to thank a teacher who helped us become who we are today via @ThankAMentor. Check out http://thank-a-teacher.org"
message = "We've all been students. Let's take a min to thank a teacher who helped us become who we are today via " + twitterHandle + " "

email =
    subject: 'Thank a teacher'
    body: "#{message}\n\nCheck out #{siteUrl}"

FBinit = () ->
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

setupButton = (url, network, button) ->
    button.click ->
        console.log 'setting up button...'
        mixpanel.track 'share', {network}
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

$ ->
    setupButtons()