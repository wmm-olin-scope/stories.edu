
siteUrl = 'http://www.thank-a-teacher.org'
twitterHandle = 'thankamentor'
message = '''We've all been students. Let's take a min to thank a teacher 
             who helped us become who we are today.'''
email =
    subject: 'Thank a teacher'
    body: "#{message}\n\nCheck out #{siteUrl}"

exports.setupButtons = (container) ->
    container = $ container
    setupFacebook container
    setupTwitter container
    setupGooglePlus container
    setupEmail container

setupButton = (url, network, button) ->
    button.click ->
        mixpanel.track 'share',
          content: 'site'
          network: {network}
        window.open url, '_blank'

setupFacebook = (container) ->
    encoded = encodeURIComponent siteUrl
    facebookUrl = "https://www.facebook.com/sharer/sharer.php?u=#{encoded}"
    setupButton facebookUrl, 'facebook', $ '.js-share-facebook', container

setupTwitter = (container) ->
    encoded = encodeURIComponent siteUrl
    twitterUrl = "https://twitter.com/share?url=#{encoded}&text=#{message}&via=#{twitterHandle}"
    setupButton twitterUrl, 'twitter', $ '.js-share-twitter', container

setupGooglePlus = (container) ->
    encoded = encodeURIComponent siteUrl
    googlePlusUrl = "https://plus.google.com/share?url=#{encoded}"
    setupButton googlePlusUrl, 'googleplus', $ '.js-share-google-plus', container

setupEmail = (container) ->
    emailUrl = "mailto:?Subject=#{encodeURIComponent email.subject}
                       &Body=#{encodeURIComponent email.body}"
    setupButton emailUrl, 'email', $ '.js-share-email', container

