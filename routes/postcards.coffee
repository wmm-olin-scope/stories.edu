
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

    lastName: makeNameCheck 'recipientLastName'
    firstName: makeNameCheck 'recipientFirstName'
    fullName: makeNameCheck 'recipientFullName'

    email: utils.checkBody 'recipientEmail', (email) ->
        utils.check(email).isEmail()
        email

    schoolType: utils.checkBody 'schoolType', (type) ->
        if schoolType not in ['public', 'private', 'other']
            throw "Not a valid school type: #{type}."
        type

    schoolId: utils.checkBody 'schoolId', (id) ->
        if id.length isnt 24 # mongodb object id string length
            throw "Not a valid school id: #{id}"
        id

updatePostcard = (postcard, values, req) ->
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

    postcard.author = req.user if req.user?

postPostCard = (req, res) ->
    [failed, values] = utils.checkAll req, res, checks
    return if failed

    # START WORK HERE!

    Q.ninvoke User, 'findOne', {email: values.email}
    .then (user) ->
        if user?
            if not allowExisting
                return Q.reject
                    message: 'A user already exists with this email.'
        else user = new User()
        updateUser user, values
        Q.ninvoke user, 'save'
    .then ([user]) ->
        if values.password? then user.createLocalAuth values.password
        else Q user
    .then (user) -> Q.ninvoke req, 'login', user
    .then -> succeed res, {user: req.user}
    .catch (err) -> fail res, err
    .done()

exports.create = (app) ->