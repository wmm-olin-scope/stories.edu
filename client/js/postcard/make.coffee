
{StepGroup} = require './steps/steps'

flow = new StepGroup 'postcard', '#make-postcard'
    #.add require('./steps/info').step
    .add require('./steps/input').step
    .add require('./steps/review').step

run = ->
    flow.setup()
    data = {}
    flow.run data, ->
        console.log {data}

$ ->
    console.log 'starting postcard'
    run()
    console.log 'running'