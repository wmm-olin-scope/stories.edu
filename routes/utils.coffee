
exports.check = require("validator").check
exports.sanitize = require("validator").sanitize

exports.fail = (res, error) ->
  res.json
    success: false
    error: error

exports.failOnError = (res) -> [
    ->, # onFulfilled
    -> # onFulfilled
    (err) ->
      console.log err
      exports.fail res, err
  ]

exports.succeed = (res, resultObj) ->
  resultObj = resultObj or {}
  resultObj = {}  unless resultObj?
  resultObj.success = true
  res.json resultObj

exports.optional = (defaultValue, fun) ->
  (req, res) ->
    try
      return fun(req, res)
    catch _
      return defaultValue
    return

exports.checkBody = (name, fun, notPresentValue) ->
  notPresentValue = notPresentValue or `undefined`
  (req) ->
    value = req.body[name]
    (if value then fun(value) else notPresentValue)

exports.makeNameCheck = (variable) ->
  exports.checkBody variable, (name) ->
    exports.check(name).len 1, 32
    exports.sanitize(name).escape()


exports.doCheck = (req, res, fun) ->
  try
    return [
      false
      fun(req, res)
    ]
  catch err
    exports.fail res, err.message
    return [
      true
      null
    ]
  return

exports.checkAll = (req, res, fields) ->
  result = {}
  for name of fields
    check = exports.doCheck(req, res, fields[name])
    checker = fields[name]
    if check[0]
      return [
        true
        result
      ]
    result[name] = check[1]
  [
    false
    result
  ]

