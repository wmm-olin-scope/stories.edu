
siteUrl = 'http://www.thank-a-teacher.org'

setupFacebook = ->
    encoded = encodeURIComponent siteUrl
    facebookUrl = "https://www.facebook.com/sharer/sharer.php?u=#{encoded}"
    $('.share-facebook')
        .attr 'href', facebookUrl
        .attr 'target', '_blank'

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
        .attr 'target', '_blank'

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
    
