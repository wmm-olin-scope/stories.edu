
utils = require './utils'

exports.transitionOffset = transitionOffset = 2000
exports.transitionDuration = transitionDuration = 600

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
    console.log 'placing offscreen', {div}
    div.css
        display: 'none'
        x: transitionOffset
        clip: makeClip 0, getWidth(div)-transitionOffset

placeOnscreen = (div) ->
    console.log 'placing onscreen', {div}
    div.css
        display: ''
        x: 0
        clip: makeClip 0, getWidth div

class exports.Step
    constructor: (@name, @container, @parent=null) ->
        @isFirst = yes
        @isLast = yes

    setup: ->
        @container = $ @container

    run: (data, onDone) ->

    isDataComplete: (data) -> yes

    getPath: ->
        parts = []
        @iterateUp (step) -> parts.push step.name
        "?step=#{parts.reverse().join '/'}"

    iterateUp: (onStep) ->
        @parent?.iterateUp(onStep) unless onStep(this) is yes

    iterateDown: (onStep) ->
        steps = []
        @iterateUp (step) -> steps.push step
        for step in steps.reverse()
            if onStep(step) is yes then break

    getRoot: ->
        root = this
        @iterateUp (step) -> root = step
        root

    nearestAncestor: (other) ->
        ancestor = null
        @iterateUp (parent) ->
            other.iterateUp (otherParent) ->
                if parent is otherParent
                    ancestor = parent
                    return yes
            return ancestor isnt null
        ancestor

    penultimateAncestor: (ancestor) ->
        previous = null
        @iterateUp (step) ->
            return yes if step is ancestor
            previous = step
        previous


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

    onChildSwitch: (previous, next) ->


class exports.TextInputStep extends exports.Step
    constructor: (name, container, @fields=[]) ->
        super name, container

    setup: ->
        super()
        @next = $ 'button.btn-next', @container
        @inputs = ($ "[name='#{field}']", @container for field in @fields)

    run: (data, onDone) ->
        console.log 'Text', {name: @name, data, inputs: @inputs, container: @container}
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

    isDataComplete: (data) -> 
        _.every @fields, (field) -> data[field]?.length > 0

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

        return this

    setup: ->
        console.log 'Setting up.'
        setupStep = (step) ->
            step.setup()
            if step.steps?
                setupStep step for step in step.steps
        setupStep root for root in @trees
        console.log 'Done setting up.'

    start: (data, onDone) -> 
        @runLeaf @leaves[0], data, onDone

    goto: (path, data, onDone) ->
        for leaf in @leaves
            if leaf.getPath() is path or not leaf.isDataComplete data
                return runLeaf leaf, data, onDone
        #TODO: handle this?
        console.log "Unknown path: #{path}"
        runLeaf @leaves[0], data, onDone

    runLeaf: (leaf, data, onDone) ->
        console.log 'Running leaf', {leaf}
        @switchTo leaf, data, =>
            index = 1 + @leaves.indexOf @currentLeaf
            return onDone data if index >= @leaves.length
            @runLeaf @leaves[index], data, onDone
        console.log 'Leaf running'

    switchTo: (leaf, data, onNext) ->
        if @currentLeaf
            ancestor = @currentLeaf.nearestAncestor leaf

            if ancestor
                currentBranch = @currentLeaf.penultimateAncestor ancestor
                nextBranch = leaf.penultimateAncestor ancestor
            else
                currentBranch = @currentLeaf.getRoot()
                nextBranch = leaf.getRoot()

            transitionOut currentBranch.container

            leaf.iterateUp (step) ->
                placeOnscreen step.container
                step.parent is nextBranch
            placeOffscreen nextBranch.container
            transitionIn nextBranch.container

            ancestor?.onChildSwitch? currentBranch, nextBranch
            leaf.run data, onNext
        else
            leaf.iterateDown (step) ->
                placeOnscreen step.container
            leaf.run data, onNext

        History.pushState _.clone(data), 'Make a Postcard', leaf.getPath()
        @currentLeaf = leaf
            