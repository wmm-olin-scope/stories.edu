
require('./data/db').connect()

express = require 'express'
routes = require './routes'
auth = require './routes/auth'
http = require 'http'
path = require 'path'
passport = require 'passport'

app = express()
app.set 'port', process.env.PORT or 5001
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'

auth.initialize app

middleware = [express.favicon(),
              express.logger('dev'),
              express.bodyParser(),
              express.methodOverride(),
              express.cookieParser('TOP$Secret'),
              express.session({Secret: 'Some Secret'}),
              passport.initialize(),
              passport.session(),
              app.router,
              express.static(path.join __dirname, 'public')]
if app.get('env') is 'development'
  middleware.push express.errorHandler()
app.use ware for ware in middleware

routes.create app

http.createServer(app).listen app.get('port'), ->
    console.log "Express server listening on port #{app.get 'port'}"
