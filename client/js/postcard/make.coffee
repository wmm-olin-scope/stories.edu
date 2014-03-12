disableButton = (button) -> $(button).attr 'disabled', 'disabled'
enableButton = (button) -> $(button).removeAttr 'disabled'
isButtonDisabled = (button) -> $(button).attr 'disabled'

enableInput = (input, placeholder) -> 
    input.attr('disabled', no).val('').attr('placeholder', placeholder)
disableInput = (input, placeholder) ->
    input.typeahead 'destroy'
    input.attr('disabled', yes).val('').attr('placeholder', placeholder)


makeSimpleInputQuestion = (div, dataField)->
    div: $ div
    run: (data, onNext) ->
        input = $ 'input.answer', div
        next = $ 'button.btn-next', div

        if data[dataField]
            input.val data[dataField]
            enableButton next
        else
            disableButton next

        input.keyup ->
            if input.val() then enableButton next
            else disableButton next
        next.click ->
            if input.val()
                data[dataField] = input.text()
                onNext()

 # TODO: on resize
makeClip = (left=0, rightDelta=0) -> 
    wrapper = $ '#question-wrapper'
    "rect(0px,#{wrapper.width()+rightDelta}px,2000px,#{left}px)"

setupQuestionDivs = (divs) ->
    for div, i in divs
        div.css 'position', 'absolute'

        if i > 0 then div.css
            display: 'none'
            x: transitionOffset
            clip: makeClip 0, -transitionOffset
        else div.css
            display: ''
            x: 0
            clip: makeClip 0, 0

serveQuestions = (questions, data, done) ->
    setupQuestionDivs (div for {div} in questions)

    index = 0
    serveNext = ->
        transitionOut questions[index].div
        if questions[++index]?
            updateProgress index, questions.length
            transitionIn questions[index].div
            questions[index].run data, serveNext
        else
            done data

    updateProgress index, questions.length
    questions[0].run data, serveNext

transitionOffset = 1500
transitionDuration = 600

updateProgress = (index, length) ->
    bar = $ '#progress .progress-bar'
    progress = (index+1)/length*100

    $('#progress-label').text "Step #{index+1} of #{length}"
    bar.attr 'aria-valuenow', "#{Math.round progress}"
    bar.transition
        width: "#{progress}%"
        duration: transitionDuration

transitionOut = (div) ->
    div.transition
        x: -transitionOffset
        opacity: 0
        clip: makeClip transitionOffset
        duration: transitionDuration
        complete: -> div.css 'display', 'none'

transitionIn = (div) ->
    div.css 
        display: ''
        opacity: 0
        x: transitionOffset
        clip: makeClip 0, -transitionOffset
    div.width $('#question-container').width()
    div.transition 
        x: 0
        clip: makeClip 0, 0
        opacity: 1
        duration: transitionDuration

setup = ->
    questions = [
        makeSimpleInputQuestion $('#who-question-form'), 'who'
        makeSimpleInputQuestion $('#when-question-form'), 'when'
        makeSimpleInputQuestion $('#review-form'), 'postcard'
        makeSimpleInputQuestion $('#sharing-form'), 'share'
    ]
    serveQuestions questions, {}, (data) ->
        console.log data

oldSetup = ->
    g = {
        lastFocus: 0
    }

    capitalize = (s) ->
        (word[0].toUpperCase() + word[1...].toLowerCase() for word in s.split /\s+/).join ' '

    getStateSelect = -> $ '#state'
    getCityInput = -> $ '#city'
    getSchoolInput = -> $ '#school'

    populateStateOption = ->
        select = getStateSelect()
        select.empty()
        select.append "<option value=\"\">State</option>"
        for state in stateList
            select.append "<option value=\"#{state}\">#{state}</option>"
        return

     stateList = [
        'AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL',
        'IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE',
        'NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD',
        'TN','TX','UT','VT','VA','WA','WV','WI','WY','AS','GU','MP','PR','VI']

    enableInput = (input, placeholder) -> 
        input.attr('disabled', no).val('').attr('placeholder', placeholder)
    disableInput = (input, placeholder) ->
        input.typeahead 'destroy'
        input.attr('disabled', yes).val('').attr('placeholder', placeholder)

    findTransitions =
        state: ->
            getStateSelect().val ''
            disableInput getCityInput(), 'Select a state first...'
            disableInput getSchoolInput(), 'Select a state first...'
            doStateSelection()
        city: (state) ->
            enableInput getCityInput(), 'City'
            enableInput getSchoolInput(), 'School'
            doCitySelection state
        school: (state, city) ->
            enableInput getSchoolInput(), 'School'
            doSchoolSelection state, city

    doStateSelection = ->
        oldState = null
        getStateSelect().off 'change'
        getStateSelect().change ->
            state = getStateSelect().val()
            if state is ''
                findTransitions.state()
            else if state isnt oldState
                findTransitions.city state
            oldState = state

    makeHound = (options) ->
        {url, filter, accessor} = options
        hound = new Bloodhound
            datumTokenizer: (d) -> 
                Bloodhound.tokenizers.whitespace accessor d
            queryTokenizer: Bloodhound.tokenizers.whitespace
            prefetch:
                url: url
                filter: filter
                ttl: 0 # TODbloO: when in production set to longer
        hound.initialize()
        hound

    getCityHound = (state) -> 
        makeHound
            url: "/schools/cities/#{state}"
            filter: (cities) -> 
                {name: city, display: capitalize city} for city in cities
            accessor: (city) -> city.name

    doCitySelection = (state) ->
        hound = getCityHound state
        input = getCityInput()

        input.typeahead 'destroy'
        input.typeahead null,
            name: 'cities'
            displayKey: 'display'
            source: hound.ttAdapter()
        input.focus()

        input.off 'typeahead:selected'
        input.on 'typeahead:selected', (obj, city) -> 
            findTransitions.school state, city


    getSchoolHound = (state, city) -> 
        if city.display != ""
            url = "/schools/by-city/#{state}/#{encodeURIComponent city.name}"
        else
            url = "/schools/by-state/#{state}"
        makeHound
            url: url
            filter: (schools) ->
                for school in schools
                    school.display = capitalize school.name
                schools
            accessor: (school) -> school.name

    doSchoolSelection = (state, city) ->
        hound = getSchoolHound state, city
        input = getSchoolInput()

        input.typeahead 'destroy'
        input.typeahead null,
            name: 'schools'
            displayKey: 'display'
            source: hound.ttAdapter()
        input.focus()

        input.off 'typeahead:selected'
        input.on 'typeahead:selected', (obj, school) -> 
            g.school = school
            console.log g.school

    $('#video-button-desktop').click ->
        $('#video-modal').modal()
        if not window.VIDRECORDER?
            window.VIDRECORDER = {}
        window.VIDRECORDER.close = () -> $('#video-modal').modal('hide')
        console.log('attached handler')

    getSchoolInput().focus (e) ->
        if (e.timeStamp - g.lastFocus) > 100
            g.lastFocus = e.timeStamp
            city_name = getCityInput().val()
            city = {name: city_name.toUpperCase(), display: city_name}
            doSchoolSelection getStateSelect().val(), city
        else
            g.lastFocus = e.timeStamp

    linkTextFields = (field1, field2) ->
        $(field1).keyup -> $(field2).val $(field1).val()
        $(field2).keyup -> $(field1).val $(field2).val()

    linkTextFields '#teacher_name', '#mailto_name'
    linkTextFields '#author_name', '#return_name'

    $('#mailto_school, #mailto_city_state, #mailto_street').focus ->
        $('#school_modal').modal('show')
        return

    $('#modal_submit').click ->
        $('#school_modal').modal('hide')
        console.log g.school
        if g.school != undefined
            $('#mailto_school').val capitalize g.school.name
            $('#mailto_street').val capitalize g.school.mailingAddress
            $('#mailto_city_state').val "#{capitalize g.school.city}, #{g.school.state} #{g.school.zip}"

    $('#send_button').click ->
        contents =
            message: $('#freetext').val()
            recipientFullName: $('#teacher_name').val()
            recipientRole: $('#teacher_role').val()
            authorFullName: $('#author_name').val()
            authorRole: $('#author_role').val()
            authorEmail: $('#return_email').val()
            anonymous: $('#checkbox_input').is ':checked'
            schoolId: g.school?._id
            schoolType: g.school?.schoolType
            youtubeId: $('#youtube_id').val()
        console.log(contents)
        $.post '/postcards', contents
            .done (result) -> console.log result
            .fail (err) -> console.log err

    populateStateOption()
    findTransitions.state()

$ ->
    require('../share-buttons').setup()
    setup()