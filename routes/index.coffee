
home = (req, res) -> res.render 'postcard/interactive-postcard'

exports.create = (app) ->
    app.get '/', home
    app.get '/privacy', (req, res) -> res.render 'privacy'
    require('./prompts').create app
    require('./schools').create app
    require('./users').create app
    require('./postcards').create app
 