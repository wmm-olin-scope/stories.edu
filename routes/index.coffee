
home = (req, res) -> res.sendfile 'public/html/index.html'

exports.create = (app) ->
    app.get '/', (req, res) -> res.sendfile 'public/html/index.html'
    app.get '/privacy', (req, res) -> res.sendfile 'public/html/privacy.html'
    require('./schools').create app
    require('./users').create app
    require('./postcards').create app
 
