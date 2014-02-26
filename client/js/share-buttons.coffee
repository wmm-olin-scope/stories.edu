
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
    encoded = encodeURIComponent siteUrl
    twitterUrl = "https://twitter.com/share?url=#{encoded}&via=wmmedu"
    $('#share-twitter')
        .attr 'href', twitterUrl
        .attr 'target', '_blank'

exports.setup = ->
    setupFacebook()
    setupTwitter()
    