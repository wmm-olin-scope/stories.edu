
siteUrl = 'http://www.thank-a-teacher.org'

setupFacebook = ->
    $.getScript '//connect.facebook.net/en_UK/all.js', ->
        FB.init {appId: '1444954685735176'}

    $('.share-facebook').click ->
        FB.ui
            method: 'feed',
            link: siteUrl,
            caption: 'Thank a teacher!'

setupTwitter = ->
    encoded = encodeURIComponent siteUrl
    twitterUrl = "https://twitter.com/share?url=#{encoded}&via=thankamentor"
    $('.share-twitter')
        .attr 'href', twitterUrl
        .attr 'target', '_blank'

setupGooglePlus = ->
    encoded = encodeURIComponent siteUrl
    googlePlusUrl = "https://plus.google.com/share?url=#{encoded}"
    $('.share-google-plus')
        .attr 'href', googlePlusUrl

setupEmail = ->
    encoded = encodeURIComponent siteUrl
    emailUrl = "mailto:hello@thankateacher.org?Subject=Thank%20a%20teacher%21%20"
    $('.share-email')
        .attr 'href', emailUrl

exports.setup = ->
    setupFacebook()
    setupTwitter()
    setupGooglePlus()
    setupEmail()
    
