
$ ->
    mixpanel.track 'User arrived at the site'
    require('../share-buttons').setup()
    require('./seed-carousel').setup()

    # Only on mobile
    if not window.matchMedia? or window.matchMedia("screen and (max-width: 768px)").matches
        $('html, body').animate({
            scrollTop: $(".central-container").offset().top
        }, 800);