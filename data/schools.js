// Generated by CoffeeScript 1.6.3
(function() {
  var PrivateSchool, PublicSchool, Q, State, badValues, csv, db, findCitiesAndInsert, fs, generateDB, generateSchools, generateStates, insertSchools, lowQuality, makeSchoolSchema, missing, mongoose, notApplicable, parseSchoolRow, privateCSV, privateFields, privateSchoolSchema, publicCSV, publicFields, publicSchoolSchema, stateList, statesSchema, _,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  csv = require('csv');

  fs = require('fs');

  mongoose = require('mongoose');

  Q = require('q');

  _ = require('underscore');

  notApplicable = '†';

  missing = '–';

  lowQuality = '‡';

  badValues = [notApplicable, missing, lowQuality];

  publicCSV = __dirname + '/raw/public-schools.csv';

  privateCSV = __dirname + '/raw/private-schools.csv';

  publicFields = {
    'School Name': {
      field: 'name',
      type: String
    },
    'State Abbr [Public School] Latest available year': {
      field: 'state',
      type: String
    },
    'County Name [Public School] 2010-11': {
      field: 'county',
      type: String
    },
    'Location Address [Public School] 2010-11': {
      field: 'address',
      type: String
    },
    'Location City [Public School] 2010-11': {
      field: 'city',
      type: String
    },
    'Location ZIP [Public School] 2010-11': {
      field: 'zip',
      type: String
    },
    'Location ZIP4 [Public School] 2010-11': {
      field: 'zip4',
      type: String
    },
    'Mailing Address [Public School] 2010-11': {
      field: 'mailingAddress',
      type: String
    },
    'Mailing City [Public School] 2010-11': {
      field: 'mailingCity',
      type: String
    },
    'Mailing State Abbr [Public School] 2010-11': {
      field: 'mailingState',
      type: String
    },
    'Mailing ZIP [Public School] 2010-11': {
      field: 'mailingZip',
      type: String
    },
    'Mailing ZIP4 [Public School] 2010-11': {
      field: 'mailingZip4',
      type: String
    },
    'Phone Number [Public School] 2010-11': {
      field: 'phone',
      type: String
    },
    'Latitude [Public School] 2010-11': {
      field: 'latitude',
      type: Number
    },
    'Longitude [Public School] 2010-11': {
      field: 'longitude',
      type: Number
    },
    'School Level Code [Public School] 2010-11': {
      field: 'schoolLevel',
      type: String
    },
    'Total Students [Public School] 2010-11': {
      field: 'students',
      type: Number
    },
    'Full-Time Equivalent (FTE) Teachers [Public School] 2010-11': {
      field: 'fteTeachers',
      type: Number
    }
  };

  privateFields = {
    'Private School Name': {
      field: 'name',
      type: String
    },
    'State Abbr [Private School] Latest available year': {
      field: 'state',
      type: String
    },
    'City [Private School] 2009-10': {
      field: 'city',
      type: String
    },
    'ZIP [Private School] 2009-10': {
      field: 'zip',
      type: String
    },
    'ZIP4 [Private School] 2009-10': {
      field: 'zip4',
      type: String
    },
    'Mailing Address [Private School] 2009-10': {
      field: 'mailingAddress',
      type: String
    },
    'Phone Number [Private School] 2009-10': {
      field: 'phone',
      type: String
    },
    'School Level [Private School] 2009-10': {
      field: 'schoolLevel',
      type: String
    },
    'School Type [Private School] 2009-10': {
      field: 'schoolType',
      type: String
    },
    'Total Students (Ungraded & PK-12) [Private School] 2009-10': {
      field: 'students',
      type: Number
    },
    'Full-Time Equivalent (FTE) Teachers [Private School] 2009-10': {
      field: 'fteTeachers',
      type: Number
    }
  };

  generateDB = function() {
    return Q.allSettled([generateSchools(PublicSchool, publicCSV, publicFields), generateSchools(PrivateSchool, privateCSV, privateFields)]).then(generateStates);
  };

  generateSchools = function(model, file, fields) {
    var deferred;
    deferred = Q.defer();
    csv().from.stream(fs.createReadStream(file), {
      columns: true
    }).transform(function(row) {
      return parseSchoolRow(row, fields);
    }).to.array(function(rows) {
      return insertSchools(model, rows).then(function() {
        return deferred.resolve();
      });
    }).on('end', function(count) {
      return console.log("Generated " + count + " school records!");
    }).on('error', function(error) {
      return deferred.reject(error);
    });
    return deferred.promise;
  };

  parseSchoolRow = function(row, fields) {
    var header, info, parsed, value;
    parsed = {};
    for (header in fields) {
      info = fields[header];
      value = row[header];
      if (__indexOf.call(badValues, value) >= 0) {
        value = null;
      } else if (info.type === Number) {
        value = +value;
      } else {
        value = value.trim();
      }
      parsed[info.field] = value;
    }
    return parsed;
  };

  insertSchools = function(model, rows) {
    console.log("Inserting " + rows.length + " " + model.modelName + " schools!");
    return db.batchInsert(model, rows);
  };

  makeSchoolSchema = function(fields) {
    return new mongoose.Schema((function() {
      var header, info, schema;
      schema = {};
      for (header in fields) {
        info = fields[header];
        schema[info.field] = info.type;
      }
      return schema;
    })());
  };

  publicSchoolSchema = makeSchoolSchema(publicFields);

  publicSchoolSchema.index({
    name: 1,
    state: 1,
    city: 1,
    zip: 1
  });

  exports.PublicSchool = PublicSchool = mongoose.model('PublicSchool', publicSchoolSchema);

  privateSchoolSchema = makeSchoolSchema(privateFields);

  privateSchoolSchema.index({
    name: 1,
    state: 1,
    city: 1,
    zip: 1
  });

  exports.PrivateSchool = PrivateSchool = mongoose.model('PrivateSchool', privateSchoolSchema);

  generateStates = function() {
    var promise, state, _fn, _i, _len;
    promise = Q();
    _fn = function(state) {
      return promise = promise.then(function() {
        return findCitiesAndInsert(state);
      });
    };
    for (_i = 0, _len = stateList.length; _i < _len; _i++) {
      state = stateList[_i];
      _fn(state);
    }
    return promise;
  };

  findCitiesAndInsert = function(state) {
    var getCities;
    getCities = function(model) {
      return Q.ninvoke(model.find({
        state: state
      }), 'distinct', 'city');
    };
    return Q.all([getCities(PublicSchool), getCities(PrivateSchool)]).then(function(cities) {
      cities = _.union.apply(_, cities);
      return Q.ninvoke(State, 'create', {
        _id: state,
        cities: cities
      });
    });
  };

  statesSchema = new mongoose.Schema({
    _id: String,
    cities: [String]
  });

  exports.State = State = mongoose.model('State', statesSchema);

  exports.stateList = stateList = ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'AS', 'GU', 'MP', 'PR', 'VI'];

  exports.findBy = function(match, fields) {
    var makeQuery;
    if (fields == null) {
      fields = '_id name state city zip';
    }
    makeQuery = function(model) {
      return Q.ninvoke(model.find(match).select(fields), 'exec');
    };
    return Q.all([makeQuery(PublicSchool), makeQuery(PrivateSchool)]).then(function(schoolSets) {
      return Q(_.flatten(schoolSets));
    });
  };

  if (require.main === module) {
    db = require('./db');
    db.connect().then(function() {
      return console.log('Connected to DB');
    }).then(function() {
      return db.dropModel(PublicSchool);
    }).then(function() {
      return db.dropModel(PrivateSchool);
    }).then(function() {
      return db.dropModel(State);
    }).then(generateDB).then(function() {
      return console.log('Done!');
    })["catch"](function(err) {
      return console.log(err);
    }).fin(function() {
      return process.exit();
    });
  }

}).call(this);
