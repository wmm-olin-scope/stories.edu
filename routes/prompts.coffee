
{Prompt} = require '../data/prompts'
{succeed, fail} = utils = require './utils'

getIndex = (req, res) ->
    Prompt.find {}, (err, prompts) ->
        return fail res, err if err
        res.render 'prompts/index', {prompts}

checkPrompt = utils.checkBody 'prompt', (prompt) ->
    utils.check(prompt).len(1, 1e5)
    prompt

checkPromptId = (req) ->
    id = req.params.promptId
    utils.check(id).len(24)
    id

postPrompt = (req, res) ->
    [check, values] = utils.checkAll req, res,
        prompt: checkPrompt
    return if check
    
    Prompt.create {html: values.prompt}, (err, prompt) ->
        return fail res, err if err
        succeed res, prompt

deletePrompt = (req, res) ->
    [check, values] = utils.checkAll req, res,
        promptId: checkPromptId
    return if check

    Prompt.findByIdAndRemove values.promptId, (err) ->
        return fail res, err if err
        succeed res, {}

exports.create = (app) ->
    app.get '/prompts', getIndex
    app.get '/prompts/', getIndex
    app.post '/prompts', postPrompt
    app.del '/prompts/:promptId', deletePrompt