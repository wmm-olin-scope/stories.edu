
schools = require '../data/schools'
{succeed, fail} = utils = require '../lib/utils'
Q = require 'Q'

stateHash = {}
stateHash[state] = true for state in schools.stateList

getStates = (req, res) -> succeed res, {states: schools.stateList}

getCities = (req, res) ->
    {state} = req.params
    return fail res, 'No such state' if state not of stateHash

    Q.ninvoke(schools.State, 'findById', state)
    .then((state) -> succeed res, {cities: state.cities})
    .catch((err) -> fail res, err)

findByCity = (req, res) ->
    {state, city} = req.params
    return fail res, 'No such state' if state not of stateHash
    schools.findBy({state, city}).then((schools) -> succeed res, schools)
    .catch((err) -> fail res, err)

findByZip = (req, res) ->
    {zip} = req.params
    schools.findBy({zip}).then((schools) -> succeed res, schools)
    .catch((err) -> fail res, err)

exports.create = (app) ->
    app.get '/schools/states', getStates
    app.get '/schools/cities/:state', getCities
    app.get '/schools/by-city/:state-:city', findByCity
    app.get '/schools/by-zip/:zip', findByZip