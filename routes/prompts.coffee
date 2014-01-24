
{Prompt} = require '../data/prompts'
utils = require '../lib/utils'

getIndex = (req, res) ->
    Prompt.find {}, (err, prompts) ->
        return utils.fail res, err if err
        res.render 'prompts/index', {prompts}

checkPrompt = utils.checkBody 'prompt', (prompt) ->
    utils.check(prompt).len(1, 1e5)
    prompt

putPrompt = (req, res) ->
    [check, values] = utils.checkAll req, res,
        prompt: checkPrompt
    return if check
    
    Prompt.create {html: values.prompt}, (err, prompt) ->
        return utils.fail res, err if err
        utils.succeed res, prompt

exports.create = (app) ->
    app.get '/prompts', getIndex
    app.get '/prompts/', getIndex
    app.put '/prompts/', putPrompt