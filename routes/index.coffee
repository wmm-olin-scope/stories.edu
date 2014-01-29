
prompts = require './prompts'

home = (req, res) ->
    res.render 'index',
        title: 'What Matters Most'

exports.create = (app) ->
    app.get '/', home
    prompts.create app
