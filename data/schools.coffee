
csv = require 'csv'
fs = require 'fs'
mongoose = require 'mongoose'
Q = require 'q'
_ = require 'underscore'
db = require './db'
utils = require './utils'

notApplicable = '†'
missing = '–'
lowQuality = '‡'
badValues = [notApplicable, missing, lowQuality]

publicCSV = __dirname + '/thank-a-teacher.publicschools.csv'
privateCSV = __dirname + '/thank-a-teacher.privateschools.csv'

publicSchoolSchema = new mongoose.Schema
    schoolType:
        type: String
        default: 'public'
    address: String
    city: String
    county: String
    email: String
    fteTeachers: Number
    latitude: Number
    longitude: Number
    mailingAddress: String
    mailingCity: String
    mailingState: String
    mailingZip: String
    name: String
    phone: String
    principal: String
    schoolLevel: String
    state: String
    students: Number
    zip: String
    zip4: String
publicSchoolSchema.index {state: 1}
publicSchoolSchema.index {state: 1, city: 1}

exports.PublicSchool = PublicSchool = mongoose.model 'PublicSchool',
                                                     publicSchoolSchema

privateSchoolSchema = new mongoose.Schema
    schoolType:
        type: String
        default: 'private'
    city: String
    email: String
    fteTeachers: Number
    mailingAddress: String
    name: String
    phone: String
    principal: String
    schoolLevel: String
    privateSchoolType: String
    state: String
    students: Number
    zip: String
    zip4: String
privateSchoolSchema.index {state: 1}
privateSchoolSchema.index {state: 1, city: 1}

exports.PrivateSchool = PrivateSchool = mongoose.model 'PrivateSchool',
                                                       privateSchoolSchema

generateDB = ->
    generateSchools PublicSchool, publicCSV
    .then -> generateSchools PrivateSchool, privateCSV
    .catch (error) ->
        console.error 'Could not parse schools csv'
        console.log error
        console.log error.stack
    .then generateStates

generateSchools = (model, file) ->
    fields = {}
    model.schema.eachPath (field, type) ->
        return if field in ['schoolType', '_id', '__v']
        fields[field] = {field, type}

    deferred = Q.defer()
    csv().from.stream(fs.createReadStream(file), {columns: yes})
         .transform((row) -> parseSchoolRow row, fields)
         .to.array((rows) ->
             insertSchools model, rows
             .then -> deferred.resolve())
         .on('end', (count) ->
             console.log "Generated #{count} school records!")
         .on('error', (error) -> deferred.reject error)
    deferred.promise
    

parseSchoolRow = (row, fields) ->
    parsed = {}
    for header, info of fields
        value = row[header]
        if value in badValues then value = null
        else if info.type is Number then value = +value
        else value = value.trim()

        # fix zipcodes stripped of leading 0's
        if info.field is 'zip' and value?.length < 5
            value = ('0' for x in [0...5-value.length]).join('') + value

        parsed[info.field] = value
    parsed

insertSchools = (model, rows) ->
    console.log "Inserting #{rows.length} #{model.modelName} schools!"
    db.batchInsert model, rows

generateStates = ->
    promise = Q()
    for state in stateList
        do (state) ->
            promise = promise.then -> findCitiesAndInsert state
    promise

findCitiesAndInsert = (state) ->
    getCities = (model) ->
        Q.ninvoke model.find({state}), 'distinct', 'city'

    Q.all([getCities(PublicSchool), getCities(PrivateSchool)])
    .then (cities) ->
        cities = _.union(cities...)
        Q.ninvoke State, 'create', {_id: state, cities}

statesSchema = new mongoose.Schema
    _id: String
    cities: [String]
exports.State = State = mongoose.model 'State', statesSchema

exports.stateList = stateList = [
    'AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL',
    'IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE',
    'NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD',
    'TN','TX','UT','VT','VA','WA','WV','WI','WY','AS','GU','MP','PR','VI']

findByFields = '_id name state city zip mailingAddress schoolType'
exports.findBy = (match, fields=findByFields) ->
    makeQuery = (model) ->
        Q.ninvoke model.find(match).select(fields), 'exec'
    Q.all([makeQuery(PublicSchool), makeQuery(PrivateSchool)])
    .then((schoolSets) -> Q _.flatten schoolSets)

exports.setupDatabase = ->
    Q().then(-> db.dropModel PublicSchool)
    .then(-> db.dropModel PrivateSchool)
    .then(-> db.dropModel State)
    .then(generateDB)
    .then(-> console.log 'Done!')
    .catch((err) -> console.log err)

exports.makeGenericSchool = ->
    public: utils.makeRef 'PublicSchool'
    private: utils.makeRef 'PrivateSchool'
    other:
        name: String
        address: utils.makeAddress()
        phone: String
        email: String
        schoolType: String

exports.getSchoolFromGeneric = (generic) ->
    return null unless generic?
    switch
        when generic.public then generic.public
        when generic.private then generic.private
        when generic.other then generic.other
        else null

exports.getName = (generic) ->
    exports.getSchoolFromGeneric(generic)?.name

exports.getAddress = (generic) ->
    return null unless generic?
    switch
        when generic.public
            school = generic.public
            lines: [school.name, school.mailingAddress or school.address]
            zip: school.mailingZip or school.zip
            city: school.mailingCity or school.city
            state: school.mailingState or school.state
        when generic.private
            school = generic.public
            lines: [school.name, school.address]
            zip: school.zip
            city: school.city
            state: school.state
        when generic.other then generic.other.address
        else null

if require.main is module
    db.connect()
    .then exports.setupDatabase
    .fin -> process.exit()