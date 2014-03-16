
$ ->
    mixpanel.track 'User arrived at the site'
    require('../share-buttons').setup()
    require('./seed-carousel').setup()
