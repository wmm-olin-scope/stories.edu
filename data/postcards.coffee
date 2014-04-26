
mongoose = require 'mongoose'
utils = require './utils'
Q = require 'q'
{PublicSchool, PrivateSchool} = require './schools'

exports.postcardSchema = postcardSchema = new mongoose.Schema
    created: Date
    name: String
    email: String
    note: String
    youtubeId: String
    starred:
        type: Boolean
        default: false
    teacher: String
    schoolId: String # mongoose.Types.ObjectId?
    schoolType: String
    schoolName: String
    city: String
    state: String
    views:
        type: Number
        default: 0
        index: yes

postcardSchema.methods.getSchool = ->
    if @schoolId
        model = switch @schoolType?.toLowerCase()
            when 'public' then PublicSchool
            when 'private' then PrivateSchool
        return Q.ninvoke model, 'findById', @schoolId if model
    Q
        name: @schoolName
        city: @city
        state: @state
        
postcardSchema.methods.registerView = ->
    @views += 1

postcardSchema.statics.getStarred = (limit=4) ->
    query = @find {starred: yes}
        .limit limit
        .sort '-views'
    Q.ninvoke query, 'exec'

exports.Postcard = mongoose.model 'Postcard', postcardSchema
