siteUrl = "http://thank-a-teacher.org" + window.location.pathname
personalized_email =
    subject: "Join me in taking 2 min to thank a teacher and support this student project"
    body: "I just sent a thank you note to one of my past teachers: #{siteUrl}. Who impacted your life? Show them your appreciation by taking 2 min to send them a thank you at http://thank-a-teacher.org"

personalized_fb = 
    name: 'Thank A Teacher',
    caption: 'Ever wanted to send a thank you note to a past teacher? Check out this student project.'
    link: siteUrl
    picture: "http://i62.tinypic.com/mv3nfl.jpg"
personalized_tweet = "I just sent a thank you note to a past teacher: #{siteUrl}. Send a thank you note to a teacher using @ThankaMentor"

exports.setup = (id) ->
    personalized_setupFacebook()
    personalized_setupTwitter()
    personalized_setupEmail()

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

personalized_setupFacebook = () ->
    FBinit()
    $('.js-facebook-button').click ->
        FB.ui
            method: "feed"
            name: personalized_fb.name,
            caption: personalized_fb.caption
            link: siteUrl
            picture: personalized_fb.picture
        , (response) ->
            console.log personalized_fb.link
            return

personalized_setupTwitter = () ->
    $('.js-twitter-postcard-text').val(personalized_tweet)
    $('.js-twitter-button').click ->
        personalized_tweet = $('.js-twitter-postcard-text').val()
        twitterMessage = "https://twitter.com/intent/tweet?text="+personalized_tweet
        window.open twitterMessage, '_blank'


personalized_setupEmail = () ->
    $('.js-email-postcard-text').val("Subject: #{personalized_email.subject} \n\n #{personalized_email.body}")
    $('.js-email-button').click ->
        emailUrl = "mailto:?Subject=#{personalized_email.subject}&Body=#{personalized_email.body}"
        window.location = emailUrl