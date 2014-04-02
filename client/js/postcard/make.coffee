
{StepManager} = require './steps/steps'

manager = new StepManager()
    #.add require('./steps/info').step
    .add require('./steps/input').step
    .add require('./steps/review').step

$ ->
    manager.setup()
    manager.start -> console.log {data}