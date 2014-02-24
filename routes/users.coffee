
{User} = users = require '../data/users'
{stateList} = require '../data/schools'
auth = require './auth'
{fail, succeed} = utils = require './utils'
_ = require 'underscore'
Q = require 'q'

checks =
    email: utils.checkBody 'email', (email) ->
        utils.check(email).isEmail()
        email

    password: utils.checkBody 'password', (password) ->
        utils.check password
            len: 'Please enter a password that is 6 to 32 characters long.'
        .len 6, 32
        password

    lastName: utils.makeNameCheck 'lastName'
    firstName: utils.makeNameCheck 'firstName'
    fullName: utils.makeNameCheck 'fullName'

    age: utils.checkBody 'age', (age) ->
        utils.check age, 'Please enter a valid age (in years).'
            .isInt().min(1).max(110)
        age|0

    category: utils.checkBody 'category', (cat) ->
        return users.categories[0] unless cat?
        if cat not in users.categories
            throw {message: "Not a valid category: #{cat}"}
        cat

    lat: utils.checkBody 'lat', (lat) ->
        utils.check lat, 'Invalid latitude.'
            .isFloat().min(-90).max(90)
        +lat

    lon: utils.checkBody 'lon', (lon) ->
        utils.check lon, 'Invalid longitude.'
            .isFloat().min(-180).max(180)
        +lon

    state: utils.checkBody 'state', (state) ->
        if state not in stateList
            throw "Not a valid state code: #{state}"
        state

    city: utils.checkBody 'city', (city) ->
        utils.check city, 'Please enter a valid city name.'
            .len 2, 18
        utils.sanitize(city).escape()

    zip: utils.checkBody 'zip', (zipcode) ->
        utils.check zipcode, 'Please enter a valid US ZIP code.'
            .regex /^\d{5}(?:[-\s]\d{4})?$/

    address: utils.checkBody 'address', (address) ->
        address = [address] if _.isString address
        if 1 <= address.length <= 4
            throw {message: 'Address must be 1 to 4 lines long.'}
        _.map address, (line) ->
            utils.check(line).len(1, 128)
            utils.sanitize(line).escape()

assertHasEmail = (values, res) ->
    if not values.email?
        fail res, {message: 'You must provide a valid email.'}
        false
    else true

assertHasPassword = (values, res) ->
    if not values.password?
        fail res, {message: 'You must provide a valid password.'}
        false
    else true

updateUser = (user, values) ->
    user.email = values.email
    user.joined = Date.now() unless user.joined?
    user.name = {} unless user.name?
    user.name.first = values.firstName if values.firstName?
    user.name.last = values.lastName if values.lastName?
    user.name.full = values.fullName if values.fullName?
    user.category = values.category if values.category?
    user.age = values.age if values.age?
    user.schools = [] unless user.schools?
    user.location = {} unless user.location?
    user.location.coord = {lat: values.lat, lon: values.lon} if values.lat?
    user.location.address = {} unless user.location.address?
    user.location.address.lines = values.address if values.address?
    user.location.address.city = values.city if values.city?
    user.location.address.state = values.state if values.state?
    user.location.address.zip = values.zip if values.zip?
    user

makePostUser = (allowExisting, checkRequiredFields) -> (req, res) ->
    [failed, values] = utils.checkAll req, res, checks
    return if failed or not checkRequiredFields values, res

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

postEmailUser = makePostUser yes, assertHasEmail

postLocalUser = makePostUser no, (values, res) ->
    assertHasEmail(values, res) and assertHasPassword(values, res)

postLocalLogin = (req, res) -> succeed res, {user: req.user}

putLocalLogout = (req, es) -> succeed res

exports.create = (app) ->
    app.post '/login/local', auth.localLogin, postLocalLogin
    app.put '/logout', auth.logout, putLocalLogout
    app.post '/user/email', postEmailUser
    app.post '/user/local', postLocalUser
