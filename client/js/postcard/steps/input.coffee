
{TextInputStep, StepGroup} = require './steps'

infoStep = new TextInputStep 'info', '#info-panel', []

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

exports.group = group = new StepGroup 'input', '#input-panel'
    .add infoStep
    .add whoStep
    .add require('./where').step
    .add whatStep
    .add authorStep