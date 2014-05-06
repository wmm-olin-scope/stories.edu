
{Postcard} = require '../data/postcards'
{User} = require '../data/users'
{stateList} = require '../data/schools'
{fail, succeed} = utils = require './utils'
rendering = require './rendering'
_ = require 'underscore'
Q = require 'q'


youtubeIdRegEx = /^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/

checks =
    note: utils.checkBody 'note', (note) ->
        utils.sanitize(note).escape()

    youtubeId: utils.checkBody 'video', (youtubeUrl) ->
        match = youtubeIdRegEx.exec youtubeUrl
        throw 'Not a valid YouTube url' unless match?
        match[1]

    teacher: utils.makeNameCheck 'teacher'
    name: utils.makeNameCheck 'name'
    email: utils.checkBody 'email', (email) ->
        #utils.check(email).isEmail()
        email

    schoolType: utils.checkBody 'schoolType', (schoolType) ->
        if schoolType not in ['public', 'private', 'other']
            throw "Not a valid school type: #{schoolType}."
        schoolType

    schoolId: utils.checkBody 'schoolId', (id) ->
        if id.length isnt 24 # mongodb object id string length
            throw "Not a valid school id: #{id}"
        id

    schoolName: utils.makeNameCheck 'schoolName'
    city: utils.makeNameCheck 'city'
    state: utils.makeNameCheck 'state'

    starred: utils.checkBody 'starred', (starred) ->
        throw "Not a boolean: #{starred}" unless starred in ['true', 'false']
        utils.sanitize(starred).toBoolean(true)

    postcardId: (req) ->
        id = req.params.postcardId
        utils.check(id).len(24)
        id

updatePostcardValues = (postcard, values, req) ->
    postcard.created = Date.now() unless postcard.created?
    
    for field of checks
        continue if field in ['postcardId', 'created']
        postcard[field] = values[field] if values[field]?

    postcard

postPostcard = (req, res) ->
    relevant = _.omit checks, 'postcardId', 'starred'
    [failed, values] = utils.checkAll req, res, relevant
    return if failed

    postcard = updatePostcardValues new Postcard(), values, req

    Q.ninvoke(postcard, 'save')
    .then ([postcard]) ->
        postcard.getSchool()
        .then (school) -> succeed res, {postcard, school}
    .done utils.failOnError(res)...

updatePostcard = (req, res) ->
    relevant = _.omit checks, 'starred'
    [failed, values] = utils.checkAll req, res, checks
    return if failed

    Q.ninvoke(Postcard, 'findById', values.postcardId)
    .then (postcard) ->
        Q.ninvoke updatePostcardValues(postcard, values, req), 'save'
    .then ([postcard]) -> succeed res, {postcard}
    .done utils.failOnError(res)...

getPostcard = (req, res) ->
    {postcardId} = req.params

    Q.ninvoke Postcard, 'findById', postcardId
    .then (postcard) ->
        postcard.registerView()
        Q.ninvoke postcard, 'save'
        .then -> postcard.getSchool()
        .then (school) -> succeed res, {postcard, school}
    .done utils.failOnError(res)...

starPostcard = (req, res) ->
    relevant = _.pick checks, 'postcardId', 'starred'
    [failed, values] = utils.checkBody req, res, relevant
    return if failed

    Q.ninvoke Postcard, 'findByIdAndUpdate', values.postcardId,
        starred: values.starred
    .then (postcard) -> succeed res, {postcard}
    .done utils.failOnError(res)...

POSTCARD_LIMIT = 100

getPostcards = (req, res) ->
    limit = utils.sanitize(req.query.limit).toInt() or 10
    limit = Math.min(POSTCARD_LIMIT, limit)|0

    starred = utils.sanitize(req.query.starred).toBoolean()
    if starred
        Postcard.getStarred limit
        .then (postcards) -> succeed res, {postcards}
        .done utils.failOnError(res)...
    else
        Q.ninvoke Postcard, 'find', {}
        .then (postcards) -> succeed res, {postcards}
        .done utils.failOnError(res)...

exports.create = (app) ->
    app.post '/postcards', postPostcard
    # app.post '/postcards/:postcardId/starred', starPostcard # TODO: auth?
    # app.post '/postcards/:postcardId', updatePostcard
    app.get '/postcards/:postcardId', getPostcard
    app.get '/postcards', getPostcards
