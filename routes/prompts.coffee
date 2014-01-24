
{Prompt} = require '../data/prompts'
utils = require '../lib/utils'

getIndex = (req, res) ->
    Prompt.find {}, (err, prompts) ->
        return utils.fail res, err if err
        res.render 'prompts/index', {prompts}

exports.create = (app) ->
    app.get '/prompts', getIndex
    app.get '/prompts/', getIndex