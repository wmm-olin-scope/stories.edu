
siteUrl = 'http://www.thank-a-teacher.org'

setupFacebook = ->
    encoded = encodeURIComponent siteUrl
    facebookUrl = "https://www.facebook.com/sharer/sharer.php?u=#{encoded}"
    $('.share-facebook')
        .attr 'href', facebookUrl
        .attr 'target', '_blank'
    $('.share-facebook').click ->
        mixpanel.track 'share',
          network: 'facebook'

setupTwitter = ->
    
    encoded = encodeURIComponent siteUrl
    twitterUrl = "https://twitter.com/share?url=#{encoded}&text=#{message}&via=thankamentor"
    $('.share-twitter')
        .attr 'href', twitterUrl
        .attr 'target', '_blank'
    $('.share-twitter').click ->
        mixpanel.track 'share',
          network: 'twitter'

setupGooglePlus = ->
    encoded = encodeURIComponent siteUrl
    googlePlusUrl = "https://plus.google.com/share?url=#{encoded}"
    $('.share-google-plus')
        .attr 'href', googlePlusUrl
        .attr 'target', '_blank'
    $('.share-google-plus').click ->
        mixpanel.track 'share',
          network: 'googleplus'

setupEmail = ->
    encoded = encodeURIComponent siteUrl
    emailUrl = "mailto:?Subject=Thank%20a%20teacher%21%20&Body=#{message+' Check out: '+siteUrl}"
    $('.share-email')
        .attr 'href', emailUrl
        .attr 'target', '_blank'
    $('.share-email').click ->
        mixpanel.track 'share',
          network: 'email'

setupMakePostcardClick = ->
    $('#saythanks').click ->
        # might need fixing
        mixpanel.track 'click',
          action: 'init'

exports.setup = ->
    setupFacebook()
    setupTwitter()
    setupGooglePlus()
    setupEmail()
    setupMakePostcardClick()
    
