
{TextInputStep, StepGroup, transitionDuration} = require './steps'

whatStep = new TextInputStep 'what', '#what-panel', ['what']

authorStep = new TextInputStep 'author', '#author-panel',
                               ['authorName', 'authorEmail']
authorStep.run = (data, onDone) ->
    TextInputStep::run.call this, data, ->
        #mixpanel.people.set
        #    $email: data.authorEmail
        #    $name: data.authorName
        #mixpanel.alias data.authorEmail
        onDone()

exports.step = step = new StepGroup 'input', '#input'
    .add require('./where').step
    .add whatStep
    .add authorStep

exports.step.setup = ->
    StepGroup::setup.call step
    setProgress 0, step.steps.length

setProgress = (index) ->
    length = step.steps.length
    progress = (index+1)/length*100

    $ '#progress-label'
        .text "Step #{index+1} of #{length}"
    $ '#progress .progress-bar'
        .attr 'aria-valuenow', "#{Math.round progress}"
        .transition
            width: "#{progress}%"
            duration: transitionDuration

step.onChildSwitch = (previous, next) ->
    StepGroup::onChildSwitch.call step, previous, next
    setProgress step.steps.indexOf next