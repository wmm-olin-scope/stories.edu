
csv = require 'csv'
fs = require 'fs'
mongoose = require 'mongoose'

notApplicable = '†'
missing = '–'
lowQuality = '‡'
badValues = [notApplicable, missing, lowQuality]

publicSchoolsCSV = __dirname + '/raw/public-schools.csv'

publicSchoolFieldMap = 
    'School Name': {field: 'schoolName', type: String}
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

generateDB = (done) ->
    csv().from.stream(fs.createReadStream(publicSchoolsCSV), {columns: yes})
         .transform(parsePublicSchoolRow)
         .to.array((rows) -> insertPublicSchools rows, done)
         .on('end', (count) -> 
            console.log "Generated #{count} public school records!")
         .on('error', (error) ->
            console.log error.message)

parsePublicSchoolRow = (row) ->
    parsed = {}
    for header, info of publicSchoolFieldMap
        value = row[header]
        if value is '?' or value in badValues then value = null
        else if info.type is Number then value = +value
        parsed[info.field] = value
    parsed

insertPublicSchools = (rows, done) ->
    console.log "Inserting #{rows.length} public schools!"
    db.batchInsert PublicSchool, rows, done

exports.publicSchoolSchema = publicSchoolSchema = new mongoose.Schema do ->
    schema = {}
    for header, info of publicSchoolFieldMap
        schema[info.field] = info.type
    schema

publicSchoolSchema.index
    schoolName: 1
    state: 1
    city: 1
    zip: 1

exports.PublicSchool = PublicSchool = 
        mongoose.model 'PublicSchool', exports.publicSchoolSchema

if require.main is module
    db = require('./db')
    db.connect ->
        db.dropModel PublicSchool
        generateDB (err) ->
            console.log err if err
            console.log 'Done!'
            process.exit()