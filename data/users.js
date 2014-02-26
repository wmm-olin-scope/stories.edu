// Generated by CoffeeScript 1.7.1
(function() {
  var Q, SALT_LENGTH, mongoose, schools, userSchema, utils;

  mongoose = require('mongoose');

  utils = require('./utils');

  schools = require('./schools');

  Q = require('q');

  exports.categories = ["General", "Student", "Parent", "Educator", "Administrator", "WebAdmin"];

  exports.userSchema = userSchema = new mongoose.Schema({
    email: String,
    localAuthHash: String,
    name: utils.makeName(),
    category: {
      type: String,
      "default": exports.categories[0]
    },
    joined: Date,
    age: Number,
    schools: [schools.makeGenericSchool()],
    location: {
      coord: {
        lat: Number,
        lon: Number
      },
      address: utils.makeAddress()
    }
  });

  userSchema.virtual('name.display').get(function() {
    return utils.getDisplayName(this.name);
  });

  userSchema.methods.getSchools = function() {
    return Q.ninvoke(this('populate', 'schools')).then(function(user) {
      var s, _i, _len, _ref, _results;
      _ref = user.schools;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        s = _ref[_i];
        _results.push(schools.getSchoolFromGeneric(s));
      }
      return _results;
    });
  };

  SALT_LENGTH = 10;

  userSchema.methods.verifyLocalAuth = function(password) {
    if (this.localAuthHash) {
      return Q.ninvoke(bcrypt('compare', this.localAuthHash));
    } else {
      return Q.reject('User does not have local authorization.');
    }
  };

  userSchema.methods.createLocalAuth = function(password) {
    if (!this.localAuthHash) {
      Q.reject('User already has a local password');
    }
    return Q.ninvoke(bcrypt('hash', password, SALT_LENGTH)).then((function(_this) {
      return function(hash) {
        _this.localAuthHash = hash;
        return Q.ninvoke(_this('save'));
      };
    })(this)).then(function(_arg) {
      var user;
      user = _arg[0];
      return Q(user);
    });
  };

  exports.User = mongoose.model('User', userSchema);

}).call(this);
