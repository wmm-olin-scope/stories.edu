
{html} = require './rendering'

exports.create = (app) ->
    app.get '/', html 'index'
    app.get '/step2', html 'step2'
    app.get '/step3', html 'step3'
    app.get '/submitted', html 'submitted'
    app.get '/privacy', html 'privacy'
    app.get '/about', html 'about'
    app.get '/unsubscribe', html 'unsubscribe'

    if app.get 'development'
        app.get '/debug/step1', html 'debug/step1'
        app.get '/debug/step2', html 'debug/step2'
        app.get '/debug/step3', html 'debug/step3'
