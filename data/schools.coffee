
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

publicCSV = __dirname + '/raw/public-schools.csv'
privateCSV = __dirname + '/raw/private-schools.csv'

publicFields = 
    'School Name': {field: 'name', type: String}
    'State Abbr [Public School] Latest available year': {field: 'state', type: String}
    'County Name [Public School] 2010-11': {field: 'county', type: String}
    'Location Address [Public School] 2010-11': {field: 'address', type: String}
    'Location City [Public School] 2010-11': {field: 'city', type: String}
    'Location ZIP [Public School] 2010-11': {field: 'zip', type: String}
    'Location ZIP4 [Public School] 2010-11': {field: 'zip4', type: String}
    'Mailing Address [Public School] 2010-11': {field: 'mailingAddress', type: String}
    'Mailing City [Public School] 2010-11': {field: 'mailingCity', type: String}
    'Mailing State Abbr [Public School] 2010-11': {field: 'mailingState', type: String}
    'Mailing ZIP [Public School] 2010-11': {field: 'mailingZip', type: String}
    'Mailing ZIP4 [Public School] 2010-11': {field: 'mailingZip4', type: String}
    'Phone Number [Public School] 2010-11': {field: 'phone', type: String}
    'Latitude [Public School] 2010-11': {field: 'latitude', type: Number}
    'Longitude [Public School] 2010-11': {field: 'longitude', type: Number}
    'School Level Code [Public School] 2010-11': {field: 'schoolLevel', type: String}
    'Total Students [Public School] 2010-11': {field: 'students', type: Number}
    'Full-Time Equivalent (FTE) Teachers [Public School] 2010-11': {field: 'fteTeachers', type: Number}

privateFields = 
    'Private School Name': {field: 'name', type: String}
    'State Abbr [Private School] Latest available year': {field: 'state', type: String}
    'City [Private School] 2009-10': {field: 'city', type: String}
    'ZIP [Private School] 2009-10': {field: 'zip', type: String}
    'ZIP4 [Private School] 2009-10': {field: 'zip4', type: String}
    'Mailing Address [Private School] 2009-10': {field: 'mailingAddress', type: String}
    'Phone Number [Private School] 2009-10': {field: 'phone', type: String}
    'School Level [Private School] 2009-10': {field: 'schoolLevel', type: String}
    'School Type [Private School] 2009-10': {field: 'schoolType', type: String}
    'Total Students (Ungraded & PK-12) [Private School] 2009-10': {field: 'students', type: Number}
    'Full-Time Equivalent (FTE) Teachers [Private School] 2009-10': {field: 'fteTeachers', type: Number}

generateDB = ->
    Q.allSettled([generateSchools(PublicSchool, publicCSV, publicFields),
                  generateSchools(PrivateSchool, privateCSV, privateFields)])
    .then generateStates


generateSchools = (model, file, fields) ->
    deferred = Q.defer()
    csv().from.stream(fs.createReadStream(file), {columns: yes})
         .transform((row) -> parseSchoolRow row, fields)
         .to.array((rows) -> 
            insertSchools(model, rows).then(-> deferred.resolve()))
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

makeSchoolSchema = (fields, schoolType) -> new mongoose.Schema do ->
    schema =
        schoolType:
            type: String
            default: schoolType
    for header, info of fields
        schema[info.field] = info.type
    schema

publicSchoolSchema = makeSchoolSchema publicFields, 'public'
publicSchoolSchema.index
    name: 1
    state: 1
    city: 1
    zip: 1
    mailingAddress: 1
exports.PublicSchool = PublicSchool = mongoose.model 'PublicSchool',
                                                     publicSchoolSchema

privateSchoolSchema = makeSchoolSchema privateFields, 'private'
privateSchoolSchema.index
    name: 1
    state: 1
    city: 1
    zip: 1
    mailingAddress: 1
exports.PrivateSchool = PrivateSchool = mongoose.model 'PrivateSchool', 
                                                       privateSchoolSchema

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
    .then(exports.setupDatabase)
    .fin(-> process.exit())