
{Postcard} = require '../data/postcards'
{User} = require '../data/users'
{stateList} = require '../data/schools'
auth = require './auth'
{fail, succeed} = utils = require './utils'
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

    recipientLastName: utils.makeNameCheck 'recipientLastName'
    recipientFirstName: utils.makeNameCheck 'recipientFirstName'
    recipientFullName: utils.makeNameCheck 'recipientFullName'
    recipientRole: utils.makeNameCheck 'recipientRole'
    recipientEmail: utils.checkBody 'recipientEmail', (email) ->
        utils.check(email).isEmail()
        email

    anonymous: utils.checkBody 'anonymous', (anon) ->
        throw "Not a boolean: #{anon}" unless anon in ['true', 'false']
        utils.sanitize(anon).toBoolean(true)

    authorLastName: utils.makeNameCheck 'authorLastName'
    authorFirstName: utils.makeNameCheck 'authorFirstName'
    authorFullName: utils.makeNameCheck 'authorFullName'
    authorRole: utils.makeNameCheck 'authorRole'
    authorEmail: utils.checkBody 'authorEmail', (email) ->
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
    postcard.recipient.name.first = values.recipientFirstName if values.recipientFirstName?
    postcard.recipient.name.last = values.recipientLastName if values.recipientLastName?
    postcard.recipient.name.full = values.recipientFullName if values.recipientFullName?
    postcard.recipient.role = values.recipientRole if values.recipientRole?
    postcard.recipient.email = values.recipientEmail if values.recipientEmail?

    postcard.anonymous = values.anonymous if values.anonymous?

    postcard.author = {} unless postcard.author?
    postcard.author.name = {} unless postcard.author.name?
    postcard.author.name.first = values.authorFirstName if values.authorFirstName?
    postcard.author.name.last = values.authorLastName if values.authorLastName?
    postcard.author.name.full = values.authorFullName if values.authorFullName?
    postcard.author.role = values.authorRole if values.authorRole?
    postcard.author.email = values.authorEmail if values.authorEmail?
    postcard.author.user = req.user if not postcard.author.user? and req.user?

    switch values.schoolType
        when 'public'
            postcard.school.public = values.schoolId
        when 'private'
            postcard.school.private = values.schoolId

    postcard

postPostcard = (req, res) ->
    relevant = _.omit checks, 'postcardId', 'starred'
    [failed, values] = utils.checkAll req, res, relevant
    return if failed

    postcard = updatePostcardValues new Postcard(), values, req
    console.log values

    Q.ninvoke(Postcard, 'save')
    .then ([postcard]) -> succeed res, {postcard}
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
