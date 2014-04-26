
STEPS_STORAGE_KEY = 'stepsData'
POSTCARD_URL = '/postcards'

steps = [
    require './step-1.coffee'
    require './step-2.coffee'
    require './step-3.coffee'
]

stepContainer = '#step-container'

runSteps = ->
    data = amplify.store(STEPS_STORAGE_KEY) or {}
    iter = (stepIndex) ->
        if stepIndex >= steps.length
            stepsFinished data
        else
            runStep steps[stepIndex], data, ->
                amplify.store STEPS_STORAGE_KEY, data
                iter stepIndex+1
    iter 0

runStep = (step, data, done) ->
    for otherStep in steps
        $(otherStep.id).toggleClass 'hidden', step isnt otherStep
    
    if step.setup? then step.setup data
    else defaultStepSetup step, data

    nextButton = $ '.js-btn-next', step.id

    canGoNext = no
    updateCanGoNext = (_canGoNext) ->
        canGoNext = _canGoNext
        nextButton.attr 'disabled', not canGoNext

    tryNext = ->
        return unless canGoNext
        if step.writeData? then step.writeData data
        else defaultStepWriteData step, data
        done()

    nextButton.click ->
        tryNext()
        return no # prevent form submission
    $(step.inputs[step.inputs.length-1].input).keydown ({which}) ->
        tryNext() if which is 13 # enter key

    if step.validate? then step.validate data, updateCanGoNext
    else defaultStepValidate step, data, updateCanGoNext

defaultStepSetup = (step, data) ->
    foundWithoutVal = no
    for {field, input} in step.inputs
        $(input).val data[field]
        if not foundWithoutVal and not data[field]
            $(input).focus()
            foundWithoutVal = yes

defaultStepValidate = (step, data, updateCanGoNext) ->
    check = ->
        updateCanGoNext _.every step.inputs, ({input, optional}) ->
            optional or $(input).val()?.trim().length > 0
    check()

    for {input} in step.inputs
        $(input).keyup check
                .change check

defaultStepWriteData = (step, data) ->
    for {field, input} in step.inputs
        data[field] = $(input).val()


normalizeSchoolData = (data) ->
    return unless data.schoolObj?
    data.schoolId = data.schoolObj._id
    data.schoolType = data.schoolObj.schoolType

    for field in 'schoolObj schoolName street city state zip'.split ' '
        delete data[field]
    
stepsFinished = (data) ->
    # amplify.store STEPS_STORAGE_KEY, {}
    normalizeSchoolData data
    showLoading()
    $.post POSTCARD_URL, data
    .done (result) ->
        if result.success then switchToThankYou result
        else showError result.error
    .fail (error) -> showError error
    .always -> stopShowLoading()

switchToThankYou = ({postcard, school}) ->
    console.log {postcard, school}

showError = (error) ->
    console.error error

showLoading = ->

stopShowLoading = ->


$ ->
    require('../share-buttons.coffee').setupButtons '#home-share-buttons'
    runSteps()
