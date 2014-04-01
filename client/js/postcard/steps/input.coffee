
{TextInputStep, StepGroup, transitionDuration} = require './steps'

whoStep = new TextInputStep 'who', '#who-panel', ['who']

whatStep = new TextInputStep 'what', '#what-panel', ['what']

authorStep = new TextInputStep 'author', '#author-panel', 
                               ['authorName', 'authorEmail']
authorStep.run = (data, onDone) ->
    TextInputStep::run.call this, data, ->
        mixpanel.people.set 
            $email: data.authorEmail
            $name: data.authorName
        mixpanel.alias data.authorEmail
        onDone()

exports.step = step = new StepGroup 'input', '#input'
    .add whoStep
    .add require('./where').step
    .add whatStep
    .add authorStep

step.runChild = (data, onDone) ->
    StepGroup::runChild.call step, data, onDone

    index = step.stepIndex
    length = step.steps.length
    progress = (index+1)/length*100

    bar = 
    
    $ '#progress-label'
        .text "Step #{index+1} of #{length}"
    $ '#progress .progress-bar'
        .attr 'aria-valuenow', "#{Math.round progress}"
        .transition
            width: "#{progress}%"
            duration: transitionDuration