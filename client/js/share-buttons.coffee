
siteUrl = 'http://www.thank-a-teacher.org'
message = "We've all been students. Let's take 5 min to thank a teacher who helped us become who we are today."
longer_message = "We've all been students. Let's take 5 min to thank a teacher who helped us become who we are today via http://thank-a-teacher.org"
videoUrl = "http://youtu.be/rArJOGicnHU"

setupFacebook = ->
    encoded = encodeURIComponent videoUrl
    facebookUrl = "https://www.facebook.com/sharer/sharer.php?u=#{encoded}"
    $('.share-facebook')
        .attr 'href', facebookUrl
        .attr 'target', '_blank'
    $('.share-facebook').click ->
            ga 'send', 'social', 'facebook', 'share', #{encoded}

setupTwitter = ->
    
    encoded = encodeURIComponent siteUrl
    twitterUrl = "https://twitter.com/share?url=#{encoded}&text=#{message}&via=thankamentor"
    $('.share-twitter')
        .attr 'href', twitterUrl
        .attr 'target', '_blank'
    $('.share-twitter').click ->
        ga 'send', 'social', 'twitter', 'share', #{encoded}

setupTwitterVideo = ->
    encoded = encodeURIComponent videoUrl
    twitterUrl = "https://twitter.com/share?url=#{encoded}&text=#{message}&via=thankamentor"
    $('.share-twitter-video')
        .attr 'href', twitterUrl
        .attr 'target', '_blank'
    $('.share-twitter-video').click ->
        ga 'send', 'social', 'twitter', 'share', #{encoded}

setupGooglePlus = ->
    encoded = encodeURIComponent videoUrl
    object = {"object": {"content": longer_message}}
    googlePlusUrl = "https://plus.google.com/share?url=#{encoded}"
    $('.share-google-plus')
        .attr 'href', googlePlusUrl
        .attr 'target', '_blank'
    $('.share-google-plus').click ->
        ga 'send', 'social', 'googleplus', 'share', #{encoded}

setupEmail = ->
    encoded = encodeURIComponent siteUrl
    emailUrl = "mailto:?Subject=Thank%20a%20teacher%21%20&Body=#{longer_message+'. Check out the 1 minute video here: '+videoUrl}"
    $('.share-email')
        .attr 'href', emailUrl
        .attr 'target', '_blank'
    $('.share-email').click ->
        ga 'send', 'event', 'button', 'click', 'share', 'email'

setupMakePostcardClick = ->
    $('#saythanks').click ->
        ga 'send', 'event', 'button', 'click', 'postcard', 'init'

exports.setup = ->
    setupFacebook()
    setupTwitter()
    setupTwitterVideo()
    setupGooglePlus()
    setupEmail()
    setupMakePostcardClick()
    
