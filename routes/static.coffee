
{html} = require './rendering'

exports.create = (app) ->
    app.get '/', html 'index'
    app.get '/step2', html 'step2'
    app.get '/step3', html 'step3'
    app.get '/submitted', html 'submitted'
    app.get '/privacy', html 'privacy'
