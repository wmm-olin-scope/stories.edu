
mongoose = require 'mongoose'
utils = require './utils'
Q = require 'q'

exports.postcardSchema = postcardSchema = new mongoose.Schema
    created: Date
    message: String
    youtubeId: String
    starred: 
        type: Boolean
        default: false
    recipient:
        name: utils.makeName()
        email: String
    school:
        public: utils.makeRef 'PublicSchool'
        private: utils.makeRef 'PrivateSchool'
    author: utils.makeRef 'User'
    views:
        type: Number
        default: 0
        index: yes


postcardSchema.virtual('recipient.name.display').get ->
    utils.getDisplayName @recipient.name

postcardSchema.methods.registerView = ->
    @views += 1

postcardSchema.statics.getStarred = (limit=4) ->
    query = @find {starred: yes}
        .limit limit
        .sort '-views'
    Q.ninvoke query, 'exec'

exports.Postcard = mongoose.model 'Postcard', postcardSchema
