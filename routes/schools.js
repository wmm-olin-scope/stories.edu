// Generated by CoffeeScript 1.7.1
(function() {
  var Q, fail, findByCity, findByRegex, findByZip, getCities, getStates, postcard, schools, setupDatabase, state, stateHash, succeed, utils, _i, _len, _ref, _ref1;

  schools = require('../data/schools');

  _ref = utils = require('../lib/utils'), succeed = _ref.succeed, fail = _ref.fail;

  Q = require('q');

  stateHash = {};

  _ref1 = schools.stateList;
  for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
    state = _ref1[_i];
    stateHash[state] = true;
  }

  getStates = function(req, res) {
    return succeed(res, {
      states: schools.stateList
    });
  };

  getCities = function(req, res) {
    state = req.params.state;
    console.log(state);
    if (!(state in stateHash)) {
      return fail(res, 'No such state');
    }
    return Q.ninvoke(schools.State, 'findById', state).then(function(state) {
      return res.json(state.cities);
    })["catch"](function(err) {
      return fail(res, err);
    });
  };

  findByCity = function(req, res) {
    var city, _ref2;
    _ref2 = req.params, state = _ref2.state, city = _ref2.city;
    console.log(state, city);
    if (!(state in stateHash)) {
      return fail(res, 'No such state');
    }
    return schools.findBy({
      state: state,
      city: city
    }).then(function(schools) {
      return res.json(schools);
    })["catch"](function(err) {
      return fail(res, err);
    });
  };

  findByRegex = function(req, res) {
    var name, text;
    text = req.query.text;
    name = new RegExp('.*' + text.toUpperCase() + '.*');
    console.log(text);
    return schools.findBy({
      name: name
    }).then(function(schools) {
      return res.json(schools);
    })["catch"](function(err) {
      return fail(res, err);
    });
  };

  findByZip = function(req, res) {
    var zip;
    zip = req.params.zip;
    return schools.findBy({
      zip: zip
    }).then(function(schools) {
      return res.json(schools);
    })["catch"](function(err) {
      return fail(res, err);
    });
  };

  setupDatabase = function(req, res) {
    return schools.setupDatabase().then(function() {
      return succeed(res, {});
    });
  };

  postcard = function(req, res) {
    return res.render("postcard", {
      title: "Postcard"
    });
  };

  exports.create = function(app) {
    app.get('/schools/setup', setupDatabase);
    app.get('/schools/states', getStates);
    app.get('/schools/cities/:state', getCities);
    app.get('/schools/by-city/:state/:city', findByCity);
    app.get('/schools/by-zip/:zip', findByZip);
    return app.get('/schools/by-name', findByRegex);
  };

}).call(this);
