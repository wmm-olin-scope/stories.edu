// Generated by CoffeeScript 1.6.3
var app, auth, express, http, middleware, passport, path, routes, ware, _i, _len;

require('./data/db').connect();

express = require('express');

routes = require('./routes');

auth = require('./lib/auth');

http = require('http');

path = require('path');

passport = require('passport');

app = express();

app.set('port', process.env.PORT || 5000);

app.set('views', __dirname + '/views');

app.set('view engine', 'jade');

auth.initialize(app);

middleware = [
  express.favicon(), express.logger('dev'), express.bodyParser(), express.methodOverride(), express.cookieParser('TOP$Secret'), express.session({
    Secret: 'Some Secret'
  }), passport.initialize(), passport.session(), app.router, express["static"](path.join(__dirname, 'public'))
];

if (app.get('env') === 'development') {
  middleware.push(express.errorHandler());
}

for (_i = 0, _len = middleware.length; _i < _len; _i++) {
  ware = middleware[_i];
  app.use(ware);
}

routes.create(app);

http.createServer(app).listen(app.get('port'), function() {
  return console.log("Express server listening on port " + (app.get('port')));
});
