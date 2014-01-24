
users = require './users'
stories = require './stories'
prompts = require './prompts'

home = (req, res) ->
    res.render 'index',
        title: 'What Matters Most'

webcam = (req, res) -> res.render 'webcam'

exports.create = (app) ->
    app.get '/', home
    app.get '/webcam', webcam
    users.create app
    stories.create app
    prompts.create app
