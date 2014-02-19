
home = (req, res) ->
    res.render 'index',
        title: 'What Matters Most'

exports.create = (app) ->
    app.get '/', home
    require('./prompts').create app
    require('./schools').create app
    require('./users').create app
 