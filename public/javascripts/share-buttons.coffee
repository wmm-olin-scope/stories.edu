
siteUrl = 'http://www.thank-a-teacher.org'

setupFacebook = ->
    $.getScript '//connect.facebook.net/en_UK/all.js', ->
        FB.init {appId: '1444954685735176'}

    $('#share-facebook').click ->
        FB.ui
            method: 'feed',
            link: siteUrl,
            caption: 'Thank a teacher!'

setupTwitter = ->
    $('#share-twitter').attr('href', "https://twitter.com/share?url=#{encodeURIComponent siteUrl}&via=wmmedu")
                       .attr('target', '_blank')

$ ->
    setupFacebook()
    setupTwitter()
    