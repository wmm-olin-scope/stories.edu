
mongoose = require 'mongoose'
_ = require 'underscore'


makeRef = (name) ->
    type: mongoose.Schema.Types.ObjectId
    ref: name

makeAddress = ->
    lines: [String]
    zip: String
    city: String
    state: String

exports.postcardSchema = new mongoose.Schema
    created: Date
    message: String
    youtubeId: String
    starred: Boolean
    recipient:
        name:
            full: String
            first: String
            last: String
        email: String
        phone: String
        address: makeAddress()
    school:
        public: makeRef 'PublicSchool'
        private: makeRef 'PrivateSchool'
        other:
            name: String
            address: makeAddress()
            phone: String
            email: String
    author: makeRef 'User'
    views:
        type: Number
        default: 0
        index: yes


###
var mongoose = require('mongoose')
  , _ = require('underscore');

var counter = {type: Number, default: 0};

exports.storySchema = new mongoose.Schema({
    youtubeId: String,
    created: Date,
    added: Date,
    title: {type: String, default: ""},
    description: {type: String, default: ""},
    tags: [String],
    thumbnail: {
        standard: String,
        highQuality: String
    },
    views: {
        type: Number,
        default: 0,
        index: true
    },
    sharedBy: [{ 
        user: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User'
        },
        views: counter
    }],
    sharesByNonUser: counter,
    nonUserShareViews: counter,
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    }
});

exports.storySchema.virtual('timesShared').get(function() {
    return _.reduce(this.sharedBy, function(sum, share) {
        return sum + share.numViews;
    }, this.sharesByNonUser);
});

exports.storySchema.virtual('isShared').get(function() {
    return (this.sharesByNonUser + this.sharedBy.length) > 0;
});

exports.storySchema.methods.findShare = function (user) {
    return _.find(this.sharedBy, function(share) {
        // assuming that shared by has not been populated
        return user._id == share.user;
    });
}

exports.storySchema.methods.isSharedBy = function(user) {
    return null != this.findShare(user);
};

exports.storySchema.methods.registerSharedBy = function(user) {
    if (!this.isSharedBy(user)) {
        this.sharedBy.push({user: user, views: 0});
    }
};

exports.storySchema.methods.registerShareView = function(user) {
    if (!this.isSharedBy(user)) {
        console.log('Missed share registration');
        this.registerSharedBy(user);
    }
    this.findShare(user).views += 1;
}

exports.Story = mongoose.model('Story', exports.storySchema);
###