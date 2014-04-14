
rendering = require './rendering'

exports.create = (app) ->
    rendering.setup app

    app.get '/', rendering.html 'index'
    app.get '/privacy', rendering.html 'privacy'

    require('./schools').create app
    require('./postcards').create app
 
