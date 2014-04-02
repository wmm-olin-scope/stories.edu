
{StepGroup} = require './steps/steps'

flow = new StepGroup 'postcard', '.js-tt-postcard-creator'
    #.add require('./steps/info').step
    .add require('./steps/input').step
    .add require('./steps/review').step

run = ->
    flow.setup()
    data = {}
    flow.run data, ->
        console.log {data}

$ ->
    History.Adapter.bind window, 'statechange', ->
        State = History.getState()
        console.log {State}

    console.log 'starting postcard'
    run()
    console.log 'running'
