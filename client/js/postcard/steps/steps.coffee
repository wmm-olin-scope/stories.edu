
utils = require './utils'

exports.transitionOffset = transitionOffset = '100%' # 2000
exports.transitionDuration = transitionDuration = 600

getWidth = (div) -> div.parent().width()

transitionOut = (div) ->
    div.transition
        x: -transitionOffset
        opacity: 0
        #clip: makeClip transitionOffset, getWidth div
        duration: transitionDuration
        complete: -> 
            div.css 'display', 'none'
            $('body').scrollLeft 0

    setTimeout (-> $('body').scrollLeft 0), 1

transitionIn = (div) ->
    #width = getWidth div
    # div.width width

    div.css 
        display: ''
        # opacity: 0
        # x: transitionOffset
        #clip: makeClip 0, width-transitionOffset
    
    div.transition 
        # x: 0
        #clip: makeClip 0, width
        # opacity: 1
        duration: transitionDuration

#makeClip = (left, width) -> 
#    "rect(0px,#{width}px,2000px,#{left}px)"

placeOffscreen = (div) ->
    div.css
        # display: 'none'
        x: transitionOffset
        #clip: makeClip 0, getWidth(div)-transitionOffset

placeOnscreen = (div) ->
    div.css
        display: ''
        x: 0
        #clip: makeClip 0, getWidth div

class exports.Step
    constructor: (@name, @container, @parent=null) ->
        @isFirst = yes
        @isLast = yes

    setup: ->
        @container = $ @container
        if @isFirst then placeOnscreen @container
        else placeOffscreen @container

    run: (data, onDone) ->
        History.pushState _.clone(data), name, @getPath()
        transitionIn @container unless @isFirst

        @_run data, =>
            transitionOut @container unless @isLast
            onDone()

    _run: (data, onDone) -> throw 'Implement me'

    getPath: ->
        parts = []
        step = this
        while step
            parts.push step.name
            step = step.parent
        "?step=#{parts.reverse().join '/'}"


class exports.StepGroup extends exports.Step
    constructor: (args...) ->
        super args...
        @steps = []

    add: (step) -> 
        @steps.push step
        step.parent = this
        return this

    setup: ->
        super()

        if @steps.length is 0
            console.warn "Group #{@name} contains no steps."
            return

        for step in @steps
            step.isFirst = no
            step.isLast = no
        @steps[0].isFirst = yes
        @steps[@steps.length-1].isLast = yes
        step.setup() for step in @steps

        @stepIndex = 0
        
    runChild: (data, onDone) ->
        if @stepIndex >= @steps.length 
            onDone()
        else
            @steps[@stepIndex].run data, =>
                @stepIndex++
                @runChild data, onDone

    _run: (data, onDone) -> @runChild data, onDone

    gotoPath: (path) ->
        parts = path[path.indexOf('=')+1...].split '/'
        console.log {parts}
        throw 'Cannot match state' if parts.shift() isnt @name
        @_goto parts

    _goto: (pathParts) ->
        if parts
            next = parts.shift()
            for step, i in @steps
                if step.name is next
                    @stepIndex = i
                    step._goto parts
                


class exports.TextInputStep extends exports.Step
    constructor: (name, container, @fields=[]) ->
        super name, container

    setup: ->
        super()
        @next = $ 'button.btn-next', @container
        @inputs = ($ "[name='#{field}']", @container for field in @fields)

    _run: (data, onDone) ->
        console.log {name: @name, data, inputs: @inputs, container: @container}
        @inputs[0].focus()
        @fillInputs data

        @checkInputs()
        @setupEvents data, onDone

    setupEvents: (data, onDone) ->
        for input in @inputs
            input.keyup => @checkInputs()
                 .change => @checkInputs()

        @next.click => @tryNext data, onDone
        $(@inputs[@inputs.length-1]).keydown (event) =>
            @tryNext data, onDone if event.which is 13 # enter

    fillInputs: (data) ->
        for input, index in @inputs
            field = @fields[index]
            if data[field] then input.val data[field]

    checkInputs: ->
        utils.setButtonEnabled @next, _.every @inputs, (input) ->
            $(input).val()?.trim().length > 0

    extractData: ->
        data = {}
        for input, index in @inputs
            data[@fields[index]] = $(input).val()
        data

    tryNext: (data, onDone) ->
        return unless utils.isButtonEnabled @next
        newData = @extractData()
        mixpanel.track "input:postcard:#{@name}", newData
        _.extend data, newData
        onDone()

class exports.StepManager
    constructor: ->
        @trees = []
        @leaves = []
        @pathMapping = {}
        @currentLeaf = null

    add: (root) ->
        @trees.push root

        addChild = (step) =>
            @pathMapping[step.getPath()] = step
            if step.steps?
                addChild child for child in step.steps
            else
                @leaves.push step
        addChild root

    start: (data, onDone) ->

    loadPath: (data, onDone) ->

    switchTo: (leaf) ->
        if @currentLeaf
            leaf
        else
            console.log 'abc'



