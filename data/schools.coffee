
csv = require 'csv'
fs = require 'fs'
mongoose = require 'mongoose'

notApplicable = '†'
missing = '–'
lowQuality = '‡'
badValues = [notApplicable, missing, lowQuality]

publicSchoolsCSV = __dirname + '/raw/public-schools.csv'
privateSchoolsCSV = __dirname + '/raw/private-schools.csv'

publicSchoolFieldMap = 
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

privateSchoolFieldMap = 
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

generateDB = (done) ->
    generate PublicSchool, publicSchoolsCSV, publicSchoolFieldMap, (err) ->
        return console.log err if err
        generate PrivateSchool, privateSchoolsCSV, privateSchoolFieldMap, done

generate = (model, file, map, done) ->
    csv().from.stream(fs.createReadStream(file), {columns: yes})
         .transform((row) -> parseSchoolRow row, map)
         .to.array((rows) -> insertSchools model, rows, done)
         .on('end', (count) -> 
            console.log "Generated #{count} school records!")
         .on('error', (error) ->
            console.log error.message)

parseSchoolRow = (row, map) ->
    parsed = {}
    for header, info of map
        value = row[header]
        if value in badValues then value = null
        else if info.type is Number then value = +value
        parsed[info.field] = value
    parsed

insertSchools = (model, rows, done) ->
    console.log "Inserting #{rows.length} schools!"
    db.batchInsert model, rows, done

makeSchema = (fieldMap) -> new mongoose.Schema do ->
    schema = {}
    for header, info of fieldMap
        schema[info.field] = info.type
    schema

exports.publicSchoolSchema = makeSchema publicSchoolFieldMap
exports.publicSchoolSchema.index
    name: 1
    state: 1
    city: 1
    zip: 1

exports.PublicSchool = PublicSchool = 
        mongoose.model 'PublicSchool', exports.publicSchoolSchema

exports.privateSchoolSchema = makeSchema privateSchoolFieldMap
exports.privateSchoolSchema.index
    name: 1
    state: 1
    city: 1
    zip: 1

exports.PrivateSchool = PrivateSchool = 
        mongoose.model 'PrivateSchool', exports.privateSchoolSchema

if require.main is module
    db = require('./db')
    db.connect ->
        db.dropModel PublicSchool
        db.dropModel PrivateSchool

        generateDB (err) ->
            console.log err if err
            console.log 'Done!'
            process.exit()