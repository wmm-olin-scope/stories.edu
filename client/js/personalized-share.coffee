siteUrl = "http://thank-a-teacher.org"
personalUrl = siteUrl + window.location.pathname
twitterHandle = '@ThankAMentor'

personalized_email =
    subject: "Join me in taking a minute to thank a teacher and support this student project"
    body: "I just sent a thank you note to one of my past teachers: #{personalUrl}. Who impacted your life? Show them your appreciation by taking a minute to send them a thank you at #{siteUrl}."

personalized_fb = 
    name: 'Thank A Teacher: A Student Project',
    caption: 'I just sent a thank you note to one of my past teachers using Thank-A-Teacher.org'
    link: siteUrl
    picture: "http://i62.tinypic.com/mv3nfl.jpg"

personalized_tweet = "I just sent a thank you note to a past teacher: #{personalUrl}. Send a thank you note to a teacher using #{twitterHandle}"

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
            link: personalUrl
            picture: personalized_fb.picture
        , (response) ->
            console.log personalized_fb.link
            return

personalized_setupTwitter = () ->
    $('.js-twitter-postcard-text').val(personalized_tweet)
    $('.js-twitter-button').click ->
        personalized_tweet = encodeURIComponent $('.js-twitter-postcard-text').val()
        twitterMessage = "https://twitter.com/intent/tweet?text=#{personalized_tweet}"
        window.open twitterMessage, '_blank'


personalized_setupEmail = () ->
    $('.js-email-postcard-text').val("Subject: #{personalized_email.subject} \n\n #{personalized_email.body}")
    encoded_subject = encodeURIComponent personalized_email.subject
    encoded_body = encodeURIComponent personalized_email.body
    $('.js-email-button').click ->
        emailUrl = "mailto:?Subject=#{encoded_subject}&Body=#{encoded_body}"
        window.location = emailUrl