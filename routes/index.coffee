
rendering = require './rendering'

exports.create = (app) ->
    require('./rendering').setup app

    require('./static').create app
    require('./schools').create app
    require('./postcards').create app
 
