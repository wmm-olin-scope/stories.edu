
{StepManager} = require './steps/steps'

manager = new StepManager()
    #.add require('./steps/info').step
    .add require('./steps/input').step
    .add require('./steps/review').step

run = ->
    manager.setup()
    data = {}
    manager.start data, ->
        console.log {data}

$ ->
    History.Adapter.bind window, 'statechange', ->
        State = History.getState()
        console.log {State}
    
    console.log 'starting postcard'
    run()
    console.log 'running'
