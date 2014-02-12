
mongoose = require 'mongoose'
_ = require 'underscore'
Q = require 'q'

makeRef = (name) ->
    type: mongoose.Schema.Types.ObjectId
    ref: name

makeAddress = ->
    lines: [String]
    zip: String
    city: String
    state: String

exports.postcardSchema = postcardSchema = new mongoose.Schema
    created: Date
    message: String
    youtubeId: String
    starred: 
        type: Boolean
        default: false
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
            schoolType: String
    author: makeRef 'User'
    views:
        type: Number
        default: 0
        index: yes


postcardSchema.virtual('recipient.name.display').get ->
    name = @recipient.name
    switch
        when not name? then ''
        when name.full then name.full
        when name.first and name.last then "#{name.first} #{name.last}"
        when name.first or name.last then name.first or name.last
        else ''

postcardSchema.methods.registerView = ->
    @views += 1

exports.Postcard = mongoose.model 'Postcard', postcardSchema
