
STEPS_STORAGE_KEY = 'stepsData'

class exports.Step
    constructor: (@id, @inputs) ->
        @listenOnLastInputEnter = yes

    setup: (data) ->
        foundWithoutVal = no
        for {field, input} in @inputs
            $(input).val data[field]
            if not foundWithoutVal and not data[field]
                $(input).focus()
                foundWithoutVal = yes

    run: (data, done) ->
        @setup data

        nextButton = $ '.js-btn-next', @id

        canGoNext = no
        updateCanGoNext = (_canGoNext) ->
            canGoNext = _canGoNext
            nextButton.attr 'disabled', not canGoNext

        tryNext = =>
            return unless canGoNext
            @writeData data
            done()

        nextButton.click ->
            tryNext()
            return no # prevent form submission
        if @listenOnLastInputEnter
            $(@inputs[@inputs.length-1].input).keydown ({which}) ->
                tryNext() if which is 13 # enter key

        @validate data, updateCanGoNext

    validate: (data, updateCanGoNext) ->
        check = ->
            updateCanGoNext _.every @inputs, ({input, optional}) ->
                optional or $(input).val()?.trim().length > 0
        check()

        for {input} in @inputs
            $(input).keyup check
                    .change check

    writeData: (data) ->
        for {field, input} in @inputs
            data[field] = $(input).val()
            if field is 'email'
                mixpanel.people.set
                  $email: data[field]
                mixpanel.alias(data[field])
            if field is 'name'
                mixpanel.people.set
                  $name: data[field]
        mixpanel.track 'input', @inputs


exports.runSteps = (steps, done) ->
    data = amplify.store(STEPS_STORAGE_KEY) or {}

    iter = (stepIndex) ->
        if stepIndex >= steps.length
            amplify.store STEPS_STORAGE_KEY, {}
            done data
        else
            step = steps[stepIndex]
            for otherStep in steps
                $(otherStep.id).toggleClass 'hidden', step isnt otherStep
            step.run data, ->
                amplify.store STEPS_STORAGE_KEY, data
                iter stepIndex+1
    iter 0


                
