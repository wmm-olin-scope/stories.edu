
utils = require './utils'

transitionOffset = 2000
transitionDuration = 600

getWidth = (div) -> div.parent().width()

transitionOut = (div) ->
    div.transition
        x: -transitionOffset
        opacity: 0
        clip: makeClip transitionOffset, getWidth div
        duration: transitionDuration
        complete: -> 
            div.css 'display', 'none'
            $('body').scrollLeft 0

    setTimeout (-> $('body').scrollLeft 0), 1

transitionIn = (div) ->
    width = getWidth div
    div.width width

    div.css 
        display: ''
        opacity: 0
        x: transitionOffset
        clip: makeClip 0, width-transitionOffset
    
    div.transition 
        x: 0
        clip: makeClip 0, width
        opacity: 1
        duration: transitionDuration

makeClip = (left, width) -> 
    "rect(0px,#{width}px,2000px,#{left}px)"

placeOffscreen = (div) ->
    div.css
        display: 'none'
        x: transitionOffset
        clip: makeClip 0, getWidth(div)-transitionOffset

placeOnscreen = (div) ->
    div.css
        display: ''
        x: 0
        clip: makeClip 0, getWidth div

class exports.Step
    constructor: (@name, container) ->
        @container = $ container
        @isFirst = yes
        @isLast = yes

    setup: ->
        if @isFirst then placeOnscreen @container
        else placeOffscreen @container

    run: (data, onDone) ->
        transitionIn @container unless @isFirst
        @_run data, =>
            transitionOut @container unless @isLast
            onDone()

    _run: (data, onDone) -> throw 'Implement me'


class exports.StepGroup extends exports.Step
    constructor: (args...) ->
        super args...
        @steps = []

    add: (step) -> 
        @steps.push step
        return this

    setup: ->
        super()

        if @steps.length is 0
            console.warn "Group #{@name} contains no steps."
            return

        for step in steps
            step.isFirst = no
            step.isLast = no
        @steps[0].isFirst = yes
        @steps[@steps.length-1].isLast = yes

    _run: (data, onDone) ->
        runStep = (index) =>
            if index >= @steps.length 
                onDone()
            else
                @steps[index].run data, -> runStep index+1
        runStep 0 

class exports.TextInputStep extends exports.Step
    constructor: (name, container, @fields=[]) ->
        super name, container

    setup: ->
        super()
        @next = $ 'button.btn-next', @container
        @inputs = $ "[name='#{field}']", @container for field in @fields

    _run: (data, onDone) ->
        @inputs[0].focus()
        @fillInputs data

        @checkInputs()
        $ @inputs
            .keyup => @checkInputs
            .change => @checkInputs

        @next.click => @tryNext data, onDone
        @inputs[@inputs.length-1].keydown (event) =>
            @tryNext data, onDone if event.which is 13 # enter

    fillInputs: (data) ->
        for input, index in @inputs
            field = @fields[index]
            if data[field] then input.val data[field]

    checkInputs: ->
        utils.setButtonEnabled @next, _.every @inputs, (input) ->
            input.val()? and input.val().trim().length > 0

    extractData: ->
        data = {}
        for input, index in @inputsMap
            data[@fields[index]] = input.val()
        data

    tryNext: (data, onDone) ->
        return unless utils.isButtonEnabled @next
        newData = @extractData()
        mixpanel.track 'input', newData
        _.extend data, newData
        onDone()
                

