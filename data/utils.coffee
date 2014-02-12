
mongoose = require 'mongoose'

exports.makeName = ->
    full: String
    first: String
    last: String

exports.makeRef = (model) ->
    type: mongoose.Schema.Types.ObjectId
    ref: model

exports.makeAddress = ->
    lines: [String]
    zip: String
    city: String
    state: String

exports.getDisplayName = (name) ->
    switch
        when not name? then ''
        when name.full then name.full
        when name.first and name.last then "#{name.first} #{name.last}"
        when name.first or name.last then name.first or name.last
        else ''