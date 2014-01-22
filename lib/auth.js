
var passport = require('passport')
  , LocalStrategy = require('passport-local').Strategy
  , User = require('../data/users').User;


function initializeLocal() {
    var options = {
        usernameField: 'email',
        passwordField: 'password'
    };

    passport.use(new LocalStrategy(options, function(email, password, cb) {
        User.findOne({ "email": email }, function (err, user) {
            if (err) return cb(error);
            if (!user) return cb(null, false);

            user.verifyLocalAuth(password, function(err, verified) {
                if (err) return cb(err);
                if (!verified) return cb(null, false);
                cb(null, user);
            });
        });
    }));
}

function initializeSession() {
    passport.serializeUser(function (user, cb) { cb(null, user._id); });
    passport.deserializeUser(function (id, cb) {
        User.findById(id, cb)
    });
}

exports.initialize = function(app) {
    initializeLocal();
    initializeSession();
};

exports.localLogin = passport.authenticate('local');
exports.logout = function(req, res, next) { req.logout(); next(); };