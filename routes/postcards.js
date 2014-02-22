// Generated by CoffeeScript 1.7.1
(function() {
  var Postcard, Q, User, auth, checks, fail, getMakePostCard, getPostcard, postPostcard, stateList, succeed, updatePostcard, updatePostcardValues, utils, youtubeIdRegEx, _, _ref;

  Postcard = require('../data/postcards').Postcard;

  User = require('../data/users').User;

  stateList = require('../data/schools').stateList;

  auth = require('../lib/auth');

  _ref = utils = require('../lib/utils'), fail = _ref.fail, succeed = _ref.succeed;

  _ = require('underscore');

  Q = require('q');

  youtubeIdRegEx = /^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/;

  checks = {
    message: utils.checkBody('message', function(message) {
      return utils.sanitize(message).escape();
    }),
    youtubeId: utils.checkBody('youtubeUrl', function(youtubeUrl) {
      var match;
      match = youtubeIdRegEx.exec(youtubeUrl);
      if (match == null) {
        throw 'Not a valid YouTube url';
      }
      return match[1];
    }),
    lastName: utils.makeNameCheck('recipientLastName'),
    firstName: utils.makeNameCheck('recipientFirstName'),
    fullName: utils.makeNameCheck('recipientFullName'),
    email: utils.checkBody('recipientEmail', function(email) {
      utils.check(email).isEmail();
      return email;
    }),
    schoolType: utils.checkBody('schoolType', function(schoolType) {
      if (schoolType !== 'public' && schoolType !== 'private' && schoolType !== 'other') {
        throw "Not a valid school type: " + schoolType + ".";
      }
      return schoolType;
    }),
    schoolId: utils.checkBody('schoolId', function(id) {
      if (id.length !== 24) {
        throw "Not a valid school id: " + id;
      }
      return id;
    }),
    postcardId: function(req) {
      var id;
      id = req.params.postcardId;
      utils.check(id).len(24);
      return id;
    }
  };

  updatePostcardValues = function(postcard, values, req) {
    if (values.message != null) {
      postcard.message = values.message;
    }
    if (postcard.created == null) {
      postcard.created = Date.now();
    }
    if (postcard.youtubeId == null) {
      postcard.youtubeId = values.youtubeId;
    }
    if (postcard.recipient == null) {
      postcard.recipient = {};
    }
    if (postcard.recipient.name == null) {
      postcard.recipient.name = {};
    }
    if (values.firstName != null) {
      postcard.recipient.name.first = values.firstName;
    }
    if (values.lastName != null) {
      postcard.recipient.name.last = values.lastName;
    }
    if (values.fullName != null) {
      postcard.recipient.name.full = values.fullName;
    }
    if (values.email != null) {
      postcard.recipient.email = values.email;
    }
    switch (values.schoolType) {
      case 'public':
        postcard.school["public"] = values.schoolId;
        break;
      case 'private':
        postcard.school["private"] = values.schoolId;
    }
    if ((postcard.author == null) && (req.user != null)) {
      postcard.author = req.user;
    }
    return postcard;
  };

  postPostcard = function(req, res) {
    var failed, postcard, values, _ref1;
    _ref1 = utils.checkAll(req, res, _.omit(checks, 'postcardId')), failed = _ref1[0], values = _ref1[1];
    if (failed) {
      return;
    }
    postcard = updatePostcardValues(new Postcard(), values, req);
    return Q.ninvoke(postcard, 'save').then(function(_arg) {
      var postcard;
      postcard = _arg[0];
      return succeed(res, {
        postcard: postcard
      });
    })["catch"](function(err) {
      return fail(res, err);
    }).done();
  };

  updatePostcard = function(req, res) {
    var failed, values, _ref1;
    _ref1 = utils.checkAll(req, res, checks), failed = _ref1[0], values = _ref1[1];
    if (failed) {
      return;
    }
    return Q.ninvoke(Postcard, 'findById', values.postcardId).then(function(postcard) {
      return Q.ninvoke(updatePostcardValues(postcard, values, req), 'save');
    }).then(function(_arg) {
      var postcard;
      postcard = _arg[0];
      return succeed(res, {
        postcard: postcard
      });
    })["catch"](function(err) {
      return fail(res, err);
    }).done();
  };

  getPostcard = function(req, res) {
    var failed, values, _ref1;
    _ref1 = utils.checkBody(req, res, _.pick(checks, 'postcardId')), failed = _ref1[0], values = _ref1[1];
    if (failed) {
      return;
    }
    return Q.ninvoke(Postcard, 'findById', values.postcardId).then(function(postcard) {
      return succeed(res, {
        postcard: postcard
      });
    })["catch"](function(err) {
      return fail(res, err);
    }).done();
  };

  getMakePostCard = function(req, res) {
    return res.render('postcard/make');
  };

  exports.create = function(app) {
    app.get('/make-postcard', getMakePostCard);
    app.post('/postcards', postPostcard);
    app.post('/postcards/:postcardId', updatePostcard);
    return app.get('/postcards/:postcardId', getPostcard);
  };

}).call(this);

//# sourceMappingURL=postcards.map
