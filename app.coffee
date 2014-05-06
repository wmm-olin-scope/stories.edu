
require('./data/db').connect()

express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'

app = express()
app.set 'port', process.env.PORT or 5001
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.set 'target', process.env.TARGET or 'development'
app.set 'development', app.get('target') is 'development'
app.set 'staticUrl', process.env.STATIC_URL or "localhost:#{app.get 'port'}"

require('newrelic') unless app.get 'development'

middleware = [express.favicon(),
              express.logger('dev'),
              express.bodyParser(),
              express.methodOverride(),
              express.cookieParser('TOP$Secret'),
              express.session({Secret: 'Some Secret'}),
              app.router,
              express.static(path.join __dirname, 'public')]
if app.get 'development'
  middleware.push express.errorHandler()
app.use ware for ware in middleware

routes.create app

http.createServer(app).listen app.get('port'), ->
    console.log "Express server listening on port #{app.get 'port'}"
