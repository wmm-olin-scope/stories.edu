
target = require './target'
_ = require 'underscore'

task 'email:send-postcards', 'Send out all unprocessed postcards', (options) ->
    require('../data/db').connect()
    .then ->
        dev = target.isDevelopment options
        require('../emails/send').sendAllUnprocessedPostcards dev
    .catch (error) -> console.error error.stack or error
    .fin -> console.log 'Done.'
