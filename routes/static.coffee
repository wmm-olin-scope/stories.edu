
{html} = require './rendering'

exports.create = (app) ->
    app.get '/', html 'index'
    app.get '/thank-you/[a-zA-Z0-9\\-_]+', html 'index'
    app.get '/privacy', html 'privacy'
    app.get '/about', html 'about'

    if app.get 'development'
        app.get '/debug/step1', html 'debug/step1'
        app.get '/debug/step2', html 'debug/step2'
        app.get '/debug/step3', html 'debug/step3'
