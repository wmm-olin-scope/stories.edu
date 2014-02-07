// Generated by CoffeeScript 1.6.3
(function() {
  var home;

  home = function(req, res) {
    return res.render('index', {
      title: 'What Matters Most'
    });
  };

  exports.create = function(app) {
    app.get('/', home);
    require('./prompts').create(app);
    return require('./schools').create(app);
  };

}).call(this);

/*
//@ sourceMappingURL=index.map
*/
