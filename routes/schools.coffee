
schools = require '../data/schools'
{succeed, fail} = utils = require '../lib/utils'
Q = require 'q'

stateHash = {}
stateHash[state] = true for state in schools.stateList

getStates = (req, res) -> succeed res, {states: schools.stateList}

getCities = (req, res) ->
    {state} = req.params
    console.log state
    return fail res, 'No such state' if state not of stateHash

    # no succeed() for bloodhound
    Q.ninvoke(schools.State, 'findById', state)
    .then((state) -> res.json state.cities)
    .catch((err) -> fail res, err)

findByCity = (req, res) ->
    {state, city} = req.params
    console.log state, city
    return fail res, 'No such state' if state not of stateHash

    # no succeed() for bloodhound
    schools.findBy({state, city}).then((schools) -> res.json schools)
    .catch((err) -> fail res, err)

findByZip = (req, res) ->
    {zip} = req.params
    # no succeed() for bloodhound
    schools.findBy({zip}).then((schools) -> res.json schools) 
    .catch((err) -> fail res, err)

setupDatabase = (req, res) ->
    schools.setupDatabase().then(-> succeed res, {})

postcard = (req, res) ->
    res.render "postcard", {title: "Postcard"}

exports.create = (app) ->
    app.get '/schools/setup', setupDatabase
    app.get '/schools/states', getStates
    app.get '/schools/cities/:state', getCities
    app.get '/schools/by-city/:state/:city', findByCity
    app.get '/schools/by-zip/:zip', findByZip
    app.get '/postcard', postcard