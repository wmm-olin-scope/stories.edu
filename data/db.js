// Generated by CoffeeScript 1.7.1
(function() {
  var Q, mongoose, uri;

  mongoose = require('mongoose');

  Q = require('q');

  uri = process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || 'mongodb://localhost/stories';

  exports.connect = function() {
    return Q.ninvoke(mongoose, 'connect', uri);
  };

  exports.dropModel = function(model) {
    var deferred;
    deferred = Q.defer();
    mongoose.connection.db.dropCollection(model.collection.name, function(err) {
      if (err) {
        console.warn(err);
      }
      return deferred.resolve();
    });
    return deferred.promise;
  };

  exports.batchInsert = function(model, docs, batchSize) {
    var batchStart, promise, _fn, _i, _ref;
    if (batchSize == null) {
      batchSize = 2048;
    }
    if (!docs) {
      return Q();
    }
    promise = Q.ninvoke(model, 'create', docs[0]);
    _fn = function(batchStart) {
      return promise = promise.then(function() {
        var batch;
        console.log("Batch start " + batchStart + "/" + docs.length + " for " + model.modelName);
        batch = docs.slice(batchStart, batchStart + batchSize);
        return Q.ninvoke(model.collection, 'insert', batch, {
          w: 1
        });
      });
    };
    for (batchStart = _i = 1, _ref = docs.length; batchSize > 0 ? _i < _ref : _i > _ref; batchStart = _i += batchSize) {
      _fn(batchStart);
    }
    return promise;
  };

}).call(this);
