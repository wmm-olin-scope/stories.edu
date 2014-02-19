
home = (req, res) -> res.render 'index'

exports.create = (app) ->
    app.get '/', home
    require('./prompts').create app
    require('./schools').create app
    require('./users').create app
    require('./postcards').create app
 