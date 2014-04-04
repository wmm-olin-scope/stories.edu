utils = require './utils'

exports.transitionDuration = transitionDuration = 600

exports.storageKey = storageKey = 'steps-data'

transitionIn = (div, index, cb) ->
    parent = div.parent()
    parent.transition
        'margin-left': "-#{(index)*100}%"
        complete: ->
            cb()
        duration: transitionDuration

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
        parts.reverse().join '-'

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
        setupStep = (step) ->
            step.setup()
            if step.steps?
                for step, i in step.steps
                    setupStep step
                    step.displayIndex = i
        setupStep root for root in @trees
        root.displayIndex = i for root, i in @trees

    start: (onDone) ->
        #data = amplify.store(storageKey) or {}
        data = {}

        handleState = =>
            state = History.getState()

            currentIndex = History.getCurrentIndex()
            external = state.data._index isnt (currentIndex - 1)

            console.log 'state changed', {url: History.getState().url, external}

            if external
                if state then @goToState state, data, onDone
                else @runLeaf @leaves[0], data, onDone

        History.Adapter.bind window, 'statechange', handleState
        handleState()

    goToState: (state, data, onDone) ->
        missed = =>
            console.log('missed.')
            @runLeaf @leaves[0], data, onDone
            @pushState()
        return missed() unless state?.url

        match = /step=([a-zA-Z0-9\-]*)/.exec state.url
        return missed() unless match
        path = match[1]
        console.log {path, name: @currentLeaf?.name}
        return if path is @currentLeaf?.getPath()

        for leaf in @leaves
            if leaf.getPath() is path
                return @runLeaf leaf, data, onDone
            else if not leaf.isDataComplete data
                @runLeaf leaf, data, onDone
                return @pushState()

        missed()

    pushState: (leaf=@currentLeaf) ->
        historyData = {_index: History.getCurrentIndex()}
        console.log 'pushing state', leaf.getPath()
        History.pushState historyData, 'Make a Postcard', 
                          "?step=#{leaf.getPath()}"

    runLeaf: (leaf, data, onDone) ->
        console.log 'Running leaf', {name: leaf.name, leaf}
        amplify.store storageKey, data

        @switchTo leaf, data, =>
            console.log "Leaf #{leaf.name} finished."
            index = 1 + @leaves.indexOf leaf
            if index >= @leaves.length
                amplify.store storageKey, {}
                onDone data
            else
                console.log "Running #{@leaves[index].name} now."
                @runLeaf @leaves[index], data, onDone
                @pushState()

    switchTo: (leaf, data, onNext) ->
        return if leaf is @currentLeaf
        console.log 'switching from ', @currentLeaf?.name, 'to', leaf?.name
        oldLeaf = @currentLeaf
        @currentLeaf = leaf
        if oldLeaf
            ancestor = oldLeaf.nearestAncestor leaf

            if ancestor
                currentBranch = oldLeaf.penultimateAncestor ancestor
                nextBranch = leaf.penultimateAncestor ancestor
            else
                currentBranch = oldLeaf.getRoot()
                nextBranch = leaf.getRoot()

            leaf.iterateUp (step) ->
                step.parent is nextBranch
            transitionIn nextBranch.container, nextBranch.displayIndex, ->
                ancestor?.onChildSwitch? currentBranch, nextBranch
                leaf.run data, onNext # Warning: if this happens before transitionIn completes,
                                      # the browser will move the DOM in an unpredictable way
                                      # to make the focus() element visible
        else
            #leaf.iterateDown (step) ->
            leaf.run data, onNext            
