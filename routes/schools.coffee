
schools = require '../data/schools'
{succeed, fail} = utils = require './utils'
Q = require 'q'

stateHash = {}
stateHash[state] = true for state in schools.stateList

getStates = (req, res) -> succeed res, {states: schools.stateList}

getCities = (req, res) ->
    {state} = req.params
    return fail res, 'No such state' if state not of stateHash

    # no succeed() for bloodhound
    Q.ninvoke(schools.State, 'findById', state)
    .then (state) -> 
        res.json state.cities
    .done utils.failOnError(res)...

findByCity = (req, res) ->
    {state, city} = req.params
    return fail res, 'No such state' if state not of stateHash

    # no succeed() for bloodhound
    schools.findBy({state, city})
    .then (schools) ->
        res.json schools
    .done utils.failOnError(res)...

findByState = (req, res) ->
    {state} = req.params
    return fail res, 'No such state' if state not of stateHash

    # no succeed() for bloodhound
    schools.findBy({state})
    .then (schools) ->
        res.json schools
    .done utils.failOnError(res)...

findByRegex = (req, res) ->
    {text} = req.query
    name = new RegExp '.*' + text.toUpperCase() + '.*'

    schools.findBy {name}
    .then (schools) ->
        res.json schools
    .done utils.failOnError(res)...

findByZip = (req, res) ->
    {zip} = req.params
    # no succeed() for bloodhound
    schools.findBy {zip}
    .then (schools) ->
        res.json schools
    .done utils.failOnError(res)...

setupDatabase = (req, res) ->
    schools.setupDatabase().then(-> succeed res, {})

postcard = (req, res) ->
    res.render "postcard", {title: "Postcard"}

exports.create = (app) ->
    #app.get '/schools/setup', setupDatabase
    app.get '/schools/states', getStates
    app.get '/schools/cities/:state', getCities
    app.get '/schools/by-city/:state/:city', findByCity
    app.get '/schools/by-state/:state', findByState
    app.get '/schools/by-zip/:zip', findByZip
    app.get '/schools/by-name', findByRegex
