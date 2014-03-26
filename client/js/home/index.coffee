
$ ->
    mixpanel.track 'main page viewed'
    require('../share-buttons').setup()
    require('./seed-carousel').setup()
