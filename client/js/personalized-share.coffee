siteUrl = "http://thank-a-teacher.org"
personalUrl = siteUrl + window.location.pathname
twitterHandle = '@ThankAMentor'

exports.setup = () ->
    teacherName = $('.js-teacher-field').val()
    schoolName = $('.js-school-field.tt-input').val()
    console.log schoolName
    personalized_setupFacebook(teacherName, schoolName)
    personalized_setupTwitter(teacherName, schoolName)
    personalized_setupEmail(teacherName, schoolName)

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

personalized_setupFacebook = (teacherName, schoolName) ->
    FBinit()
    personalized_fb = 
        name: "Thank A Teacher: A Student Project"
        caption: "I just sent a thank you note using Thank-A-Teacher.org"
        link: siteUrl
        picture: "http://i62.tinypic.com/mv3nfl.jpg"

    if schoolName != undefined and teacherName != undefined
        personalized_fb.name = "Thank A Teacher at #{schoolName}"
        personalized_fb.caption = "I just sent a thank you note to #{teacherName} at #{schoolName} using Thank-A-Teacher.org"
    else if schoolName != undefined
        personalized_fb.name = "Thank A Teacher at #{schoolName}"
    else if teacherName != undefined
        personalized_fb.caption = "I just sent a thank you note to #{teacherName} using Thank-A-Teacher.org"

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

personalized_setupTwitter = (teacherName, schoolName) ->
    personalized_tweet = "I just sent a thank you note to one of my past teachers: #{personalUrl}. Send a thank you to a teacher using #{twitterHandle}"
    
    if schoolName != undefined and teacherName != undefined
        personalized_tweet = "I just sent a thank you note to #{teacherName} at #{schoolName}: #{personalUrl}. Send a thank you to a teacher using #{twitterHandle}"
    else if schoolName != undefined
        "I just sent a thank you note to one of my past teachers at #{schoolName}: #{personalUrl}. Send a thank you to a teacher using #{twitterHandle}"
    else if teacherName != undefined
        "I just sent a thank you note to one of my past teachers, #{teacherName}: #{personalUrl}. Send a thank you to a teacher using #{twitterHandle}"

    $('.js-twitter-postcard-text').val(personalized_tweet)
    $('.js-twitter-button').click ->
        personalized_tweet = encodeURIComponent $('.js-twitter-postcard-text').val()
        twitterMessage = "https://twitter.com/intent/tweet?text=#{personalized_tweet}"
        window.open twitterMessage, '_blank'


personalized_setupEmail = (teacherName, schoolName) ->
    personalized_email =
        subject: "Join me in taking a minute to thank a teacher and support this student project"
        body: "I just sent a thank you note to one of my past teachers: #{personalUrl}. Who impacted your life? Show them your appreciation by taking a minute to send them a thank you at #{siteUrl}."
    
    if schoolName != undefined and teacherName != undefined
        personalized_email.subject = "Join me in taking a minute to thank a teacher at #{schoolName} and support this student project"
        personalized_email.body = "I just sent a thank you note to one of my past teachers, #{teacherName}, at #{schoolName}: #{personalUrl}. Who impacted your life? Show them your appreciation by taking a minute to send them a thank you at #{siteUrl}."
    else if schoolName != undefined
        personalized_email.subject = "Join me in taking a minute to thank a teacher at #{schoolName} and support this student project"
    else if teacherName != undefined
        personalized_email.body = "I just sent a thank you note to one of my past teachers, #{teacherName}: #{personalUrl}. Who impacted your life? Show them your appreciation by taking a minute to send them a thank you at #{siteUrl}."


    $('.js-email-postcard-text').val("Subject: #{personalized_email.subject} \n\n #{personalized_email.body}")
    encoded_subject = encodeURIComponent personalized_email.subject
    encoded_body = encodeURIComponent personalized_email.body
    $('.js-email-button').click ->
        emailUrl = "mailto:?Subject=#{encoded_subject}&Body=#{encoded_body}"
        window.location = emailUrl