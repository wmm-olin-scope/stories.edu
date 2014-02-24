
{Postcard} = require '../data/postcards'
{User} = require '../data/users'
{stateList} = require '../data/schools'
auth = require '../lib/auth'
{fail, succeed} = utils = require '../lib/utils'
_ = require 'underscore'
Q = require 'q'


youtubeIdRegEx = /^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/

checks =
    message: utils.checkBody 'message', (message) ->
        utils.sanitize(message).escape()

    youtubeId: utils.checkBody 'youtubeUrl', (youtubeUrl) ->
        match = youtubeIdRegEx.exec youtubeUrl
        throw 'Not a valid YouTube url' unless match?
        match[1]

    lastName: utils.makeNameCheck 'recipientLastName'
    firstName: utils.makeNameCheck 'recipientFirstName'
    fullName: utils.makeNameCheck 'recipientFullName'

    email: utils.checkBody 'recipientEmail', (email) ->
        utils.check(email).isEmail()
        email

    schoolType: utils.checkBody 'schoolType', (schoolType) ->
        if schoolType not in ['public', 'private', 'other']
            throw "Not a valid school type: #{schoolType}."
        schoolType

    schoolId: utils.checkBody 'schoolId', (id) ->
        if id.length isnt 24 # mongodb object id string length
            throw "Not a valid school id: #{id}"
        id

    starred: utils.checkBody 'starred', (starred) ->
        throw "Not a boolean: #{starred}" unless starred in ['true', 'false']
        utils.sanitize(starred).toBoolean(true)

    postcardId: (req) ->
        id = req.params.postcardId
        utils.check(id).len(24)
        id

updatePostcardValues = (postcard, values, req) ->
    postcard.message = values.message if values.message?
    postcard.created = Date.now() unless postcard.created?
    postcard.youtubeId = values.youtubeId unless postcard.youtubeId?
    postcard.recipient = {} unless postcard.recipient?
    postcard.recipient.name = {} unless postcard.recipient.name?
    postcard.recipient.name.first = values.firstName if values.firstName?
    postcard.recipient.name.last = values.lastName if values.lastName?
    postcard.recipient.name.full = values.fullName if values.fullName?
    postcard.recipient.email = values.email if values.email?

    switch values.schoolType
        when 'public'
            postcard.school.public = values.schoolId
        when 'private'
            postcard.school.private = values.schoolId

    postcard.author = req.user if not postcard.author? and req.user?
    postcard

postPostcard = (req, res) ->
    relevant = _.omit checks, 'postcardId', 'starred'
    [failed, values] = utils.checkAll req, res, relevant
    return if failed

    postcard = updatePostcardValues new Postcard(), values, req
    Q.ninvoke postcard, 'save'
    .then ([postcard]) -> succeed res, {postcard}
    .done utils.failOnError(res)...

updatePostcard = (req, res) ->
    relevant = _.omit checks, 'starred'
    [failed, values] = utils.checkAll req, res, checks
    return if failed

    Q.ninvoke Postcard, 'findById', values.postcardId
    .then (postcard) ->
        Q.ninvoke updatePostcardValues(postcard, values, req), 'save'
    .then ([postcard]) -> succeed res, {postcard}
    .done utils.failOnError(res)...

getPostcard = (req, res) ->
    relevant = _.pick checks, 'postcardId'
    [failed, values] = utils.checkBody req, res, relevant
    return if failed

    Q.ninvoke Postcard, 'findById', values.postcardId
    .then (postcard) -> succeed res, {postcard}
    .done utils.failOnError(res)...

getMakePostCard = (req, res) ->
    res.render 'postcard/make'

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
        fail res, {message: 'Unsupported query'}



exports.create = (app) ->
    app.get '/make-postcard', getMakePostCard

    app.post '/postcards', postPostcard
    app.post '/postcards/:postcardId/starred', starPostcard # TODO: auth?
    app.post '/postcards/:postcardId', updatePostcard
    app.get '/postcards/:postcardId', getPostcard
    app.get '/postcards', getPostcards