
mongoose = require 'mongoose'
utils = require './utils'
schools = require './schools'
Q = require 'q'

exports.categories = [
    "General", "Student", "Parent", "Educator", "Administrator", "WebAdmin"]

exports.userSchema = userSchema = new mongoose.Schema
    email: String
    localAuthHash: String
    name: utils.makeName()
    category:
        type: String
        default: exports.categories[0]
    joined: Date
    age: Number
    schools: [schools.makeGenericSchool()]
    location:
        coord: 
            lat: Number
            lon: Number
        address: utils.makeAddress()

userSchema.virtual('name.display').get ->
    utils.getDisplayName @name

userSchema.methods.getSchools = ->
    Q.ninvoke this 'populate', 'schools'
    .then (user) -> schools.getSchoolFromGeneric s for s in user.schools

SALT_LENGTH = 10

userSchema.methods.verifyLocalAuth = (password) ->
    if @localAuthHash then Q.ninvoke bcrypt 'compare', @localAuthHash
    else Q.reject 'User does not have local authorization.'

userSchema.methods.createLocalAuth = (password) ->
    Q.reject 'User already has a local password' unless @localAuthHash

    Q.ninvoke bcrypt 'hash', password, SALT_LENGTH
    .then (hash) => 
        @localAuthHash = hash
        Q.ninvoke this 'save'
    .then ([user]) -> Q user

exports.User = mongoose.model 'User', userSchema