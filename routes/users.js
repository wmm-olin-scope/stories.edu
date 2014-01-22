
var users = require('../data/users')
  , auth = require('../lib/auth')
  , utils = require('../lib/utils')
  , _ = require('underscore');

checkEmail = utils.checkBody("email", function (email) {
    utils.check(email).isEmail();
    return email;
});

checkPassword = utils.checkBody("password", function (password) {
    utils.check(password, {
        len: 'Please enter a password that is 6 to 32 characters long.',
        regex: 'Your password must contain at least one lowercase letter, ' +
               'one uppercase letter, and one number.'
    }).len(6, 32).is(/[a-z]/).is(/[A-Z]/).is(/[0-9]/);
    return password;
});

checkFirstName = utils.checkBody("firstName", function (name) {
    utils.check(name).len(1, 32);
    return utils.sanitize(name).escape();
});
checkLastName = utils.checkBody("lastName", function (name) {
    utils.check(name).len(1, 32);
    return utils.sanitize(name).escape();
});
checkNickname = utils.checkBody("nickname", function (name) {
    utils.check(name).len(1, 32);
    return utils.sanitize(name).escape();
});

checkAge = utils.checkBody("age", function (age) {
    utils.check(age, 'Please enter a valid age (in years).')
         .isInt().min(1).max(110);
    return age|0;
});

checkCategory = utils.checkBody("category", function (cat) {
    if (!_.contains(users.userCategories, cat)) {
        throw {message: "Not a valid category: " + cat};
    }
    return cat;
}, users.userCategories[0]);

checkLatitude = utils.checkBody("latitude", function (lat) {
    utils.check(lat, 'Invalid latitude.').isFloat().min(-90).max(90);
    return +lat;
});

checkLongitude = utils.checkBody("longitude", function (lon) {
    utils.check(lon, 'Invalid longitude.').isFloat().min(-180).max(180);
    return +lon;
});

checkState = utils.checkBody("state", function (state) {
    if (!_.contains(users.states, state)) {
        throw {message: "Not a valid state code: " + state};
    }
    return state;
});

checkCity = utils.checkBody("city", function (city) {
    utils.check(city, 'Please enter a valid city name.').len(2,18);
    return utils.sanitize(city).escape();
});

checkZipcode = utils.checkBody("zipcode", function (zipcode) {
    utils.check(zipcode, 'Please enter a valid US zipcode.')
         .regex(/^\d{5}(?:[-\s]\d{4})?$/);
    return zipcode;
});

checkAddress = utils.checkBody("address", function (address) {
    if (typeof address == "string") {
        address = [address];
    }
    if (address.length < 1 || address.length > 3) {
        throw {message: "Address must be 1 to 3 lines long."};
    }
    return _.map(address, function (line) {
        utils.check(line).len(1, 128);
        return utils.sanitize(line).escape();
    });
});

function putLocalUser(req, res) {
    var check = utils.checkAll(req, res, {
        email: checkEmail,
        password: checkPassword,
        firstName: checkFirstName,
        lastName: checkLastName,
        nickname: checkNickname,
        age: checkAge,
        category: checkCategory,
        latitude: checkLatitude,
        longitude: checkLongitude,
        state: checkState,
        city: checkCity,
        zipcode: checkZipcode,
        address: checkAddress
    });
    if (check[0]) return;
    var values = check[1];

    if (!values.email) return utils.fail(res, {
        message: "You must provide a valid email."
    });
    if (!values.password) return utils.fail(res, {
        message: "You must provide a strong password of at least 6 " +
                 "characters."
    });

    users.User.findOne({email: values.email}, function(err, story) {
        if (story) return utils.fail(res, {
            message: "A user already exists with this email."
        });

        var user = new users.User({
            email: values.email,
            age: values.age,
            joinDate: Date.now()
        });

        if (values.category) user.category = values.category;

        if (values.firstName || values.lastName || values.nickname) {
            user.name = {
                first: values.firstName,
                last: values.lastName,
                nickname: values.nickname
            };
        }

        if ((values.latitude != null && values.longitude != null) ||
                values.state || values.city || values.zipcode || 
                values.address) {
            user.location = {
                state: values.state,
                city: values.city,
                zipcode: values.zipcode,
                address: values.address
            };
            if (values.latitude != null) {
                user.location.coords = {
                    latitude: values.latitude,
                    longitude: values.longitude
                };
            }
        }

        user.save(function (err) {
            if (err) utils.fail(res, err);
            else user.createLocalAuth(values.password, function (err) {
                if (err) utils.fail(res, err);
                else req.login(user, function (err) {
                    if (err) utils.fail(res, err);
                    else utils.succeed(res, {user: user});
                });  
            });
        });
    })
}

function postLocalLogin(req, res) {
    utils.succeed(res, {user: req.user});
}

function putLocalLogout(req, res) {
    utils.succeed(res);
}

exports.create = function(app) {
    app.post('/login/local', auth.localLogin, postLocalLogin);
    app.put('/logout', auth.logout, putLocalLogout);
    app.put('/user/local', putLocalUser);
};
