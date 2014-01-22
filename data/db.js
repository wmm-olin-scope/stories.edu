
var mongoose = require('mongoose')
  , uri = process.env.MONGOLAB_URI || 
          process.env.MONGOHQ_URL || 
          'mongodb://localhost/redoedu';

exports.connect = function() {
    mongoose.connect(uri, function(err, res) {
        if (err) {
            console.log("Couldn't connect to MongoDB:");
            console.log(err);
        } else {
            console.log("Connected to MongoDB!");
        }
    });
};
