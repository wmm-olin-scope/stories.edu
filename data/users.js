
var mongoose = require('mongoose')
  , _ = require('underscore')
  , bcrypt = require('bcrypt');

exports.userCategories = ["General", "Student", "Parent", "Educator", 
                          "Administrator", "WebAdmin"];
exports.schoolGrades = ["Preschool", "Elementary", "Middle", "High", "K-8", 
                        "K-12"];
exports.schoolCategories = ["Public", "Private", "Charter"];
exports.states = ["WA","OR","CA","AK","NV","ID","UT","AZ","HI","MT","WY","CO",
                  "NM","ND","SD","NE","KS","OK","TX","MN","IA","MO","AR","LA",
                  "WI","IL","MS","MI","IN","KY","TN","AL","FL","GA","SC","NC",
                  "OH","WV","VA","PA","NY","VT","ME","NH","MA","RI","CT","NJ",
                  "DE","MD","DC"];
exports.storyTypes = ['Tweet', 'YouTube'];

SALT_LENGTH = 10;

exports.userSchema = new mongoose.Schema({
    email: String,
    localAuthHash: String,
    name: {
        first: String,
        last: String,
        nickname: String
    },
    joinDate: Date,
    age: Number,
    category: {
        type: String,
        "default": exports.userCategories[0]
    },
    location: {
        coords: {
            latitude: Number,
            longitude: Number
        },
        state: String,
        city: String,
        zipcode: String,
        address: [String]
    },
    schools: [{
        name: String,
        state: String,
        city: String,
        grades: String,
        category: String,
        yearJoined: Number,
        yearLeft: Number
    }]
});

exports.userSchema.methods.verifyLocalAuth = function(password, cb) {
    if (this.localAuthHash) bcrypt.compare(password, this.localAuthHash, cb);
    else cb({message: "User does not have a local account."});
};

exports.userSchema.methods.createLocalAuth = function(password, cb) {
    if (this.localAuthHash) {
        return cb({message: "User already has a password"});
    }
    var this_ = this;
    bcrypt.hash(password, SALT_LENGTH, function(err, hash) {
        if (err) return cb(error);
        this_.localAuthHash = hash;
        this_.save(cb);
    });
};

exports.User = mongoose.model('User', exports.userSchema);
