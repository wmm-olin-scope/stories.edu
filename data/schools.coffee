
csv = require 'csv'
fs = require 'fs'
mongoose = require 'mongoose'
Q = require 'q'
_ = require 'underscore'

notApplicable = '†'
missing = '–'
lowQuality = '‡'
badValues = [notApplicable, missing, lowQuality]

publicSchoolsCSV = __dirname + '/raw/public-schools.csv'
privateSchoolsCSV = __dirname + '/raw/private-schools.csv'

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
    generateSchools(PublicSchool, publicSchoolsCSV, publicFields)
    .fail((err) -> console.log err)
    .then(-> generateSchools(PrivateSchool, privateSchoolsCSV, privateFields))
    #.then(generateStates)


generateSchools = (model, file, fields) ->
    deferred = Q.defer()
    csv().from.stream(fs.createReadStream(file), {columns: yes})
         .transform((row) -> parseSchoolRow row, fields)
         .to.array((rows) -> 
            insertSchools(model, rows).then deferred.resolve())
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
        parsed[info.field] = value
    parsed

insertSchools = (model, rows) ->
    console.log "Inserting #{rows.length} #{model.modelName} schools!"
    db.batchInsert model, rows

makeSchoolSchema = (fields) -> new mongoose.Schema do ->
    schema = {}
    for header, info of fields
        schema[info.field] = info.type
    schema

publicSchoolSchema = makeSchoolSchema publicFields
publicSchoolSchema.index
    name: 1
    state: 1
    city: 1
    zip: 1
exports.PublicSchool = PublicSchool = mongoose.model 'PublicSchool',
                                                     publicSchoolSchema

privateSchoolSchema = makeSchoolSchema privateFields
privateSchoolSchema.index
    name: 1
    state: 1
    city: 1
    zip: 1
exports.PrivateSchool = PrivateSchool = mongoose.model 'PrivateSchool', 
                                                       privateSchoolSchema

generateStates = ->
    grouping = PublicSchool.aggregate().group({_id: '$state'})
    states = Q.ninvoke grouping, 'exec'
    states.then((states) -> 
        (findCitiesAndInsert state for state in states).reduce Q.when, Q())

findCitiesAndInsert = (state) ->
    console.log state, state._id
    name = state._id
    getCities = (model) -> 
        Q.ninvoke model.aggregate()
                       .group({_id: '$city'})
                       .match({state: name}),
                       'exec'

    Q.all([getCities(PublicSchool), getCities(PrivateSchool)])
    .then((cities) ->
        console.log cities
        cities = _.union(cities...)
        Q.ninvoke State, 'create', {_id: name, cities})

statesSchema = new mongoose.Schema
    _id: String
    cities: [String]
exports.State = State = mongoose.model 'State', statesSchema


if require.main is module
    db = require('./db')
    db.connect()
        .then(-> console.log 'Connected to DB')
        .then(-> db.dropModel PublicSchool)
        .then(-> db.dropModel PrivateSchool)
        .then(-> db.dropModel State)
        .then(generateDB)
        #.then(generateStates)
        .then(-> console.log 'Done!')
        .catch((err) -> console.log err)
        .fin(-> process.exit())