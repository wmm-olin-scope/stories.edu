disableButton = (button) -> $(button).attr 'disabled', 'disabled'
enableButton = (button) -> $(button).removeAttr 'disabled'
isButtonDisabled = (button) -> $(button).attr 'disabled'

g = {}

enableInput = (input, placeholder) -> 
    input.attr('disabled', no).val('').attr('placeholder', placeholder)
disableInput = (input, placeholder) ->
    input.typeahead 'destroy'
    input.attr('disabled', yes).val('').attr('placeholder', placeholder)

capitalize = (s) ->
    (word[0].toUpperCase() + word[1...].toLowerCase() for word in s.split /\s+/).join ' '

getStateSelect = -> $ '#state'
getCityInput = -> $ '#city'
getSchoolInput = -> $ '#school'

makeMultiInputQuestion = (div, dataFields) ->
    div: $ div
    run: (data, onNext) ->
        inputs = $ '.answer', div
        next = $ 'button.btn-next', div

        inputs.first().focus()

        enableButton next
        for dataField in dataFields
            if data[dataField]
                $("[name='#{dataField}']").val data[dataField]
            else 
                disableButton next

        hasVal = (key) -> $(key).val()

        inputs.keyup ->
            emptyInputs = inputs.filter(() -> $(this).val() == "" )
            if emptyInputs.length then disableButton next
            else enableButton next

        next.click ->
            if ! (isButtonDisabled next) 
                for dataField in dataFields
                    data[dataField] = $("[name='#{dataField}']").val()
                ga 'send', 'event', 'button', 'click', 'postcard', 'user-info'
                onNext()


makeSimpleInputQuestion = (div, dataField) ->
    div: $ div
    run: (data, onNext) ->
        input = $ '#answer', div
        next = $ 'button.btn-next', div

        input.focus()

        if data[dataField]
            input.val data[dataField]
            enableButton next
        else
            disableButton next

        input.keyup ->
            if input.val() then enableButton next
            else disableButton next

        send = ->
            if input.val()
                data[dataField] = input.val()
                ga 'send', 'event', 'button', 'click', 'postcard', dataField
                onNext()

        next.click send
        input.keydown (event) ->
            send() if event.which is 13 # enter

            

makeSchoolInputQuestion = (div, dataField) ->
    div: $ div
    run: (data, onNext) ->
        input = $ '#answer', div
        next = $ 'button.btn-next', div

        if data[dataField]
            input.val data[dataField]
            if g.valid
                enableButton next
            else
                disableButton next
        else
            disableButton next

        input.keyup ->
            if input.val() && g.valid then enableButton next
            else disableButton next
        next.click ->
            if input.val() && g.valid
                data[dataField] = input.val()
                data['mailto_school'] = capitalize g.school.name
                data['mailto_street'] = capitalize g.school.mailingAddress
                data['mailto_city_state'] = "#{capitalize g.school.city}, #{g.school.state} #{g.school.zip}"
                data.school = g.school
                ga 'send', 'event', 'button', 'click', 'postcard', dataField
                onNext()

 # TODO: on resize
makeClip = (left=0, rightDelta=0) -> 
    wrapper = $ '#question-wrapper'
    "rect(0px,#{wrapper.width()+rightDelta}px,2000px,#{left}px)"

setupQuestionDivs = (divs) ->
    for div, i in divs
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

transitionIn = (div, widthDiv='#question-container') ->
    div.css 
        display: ''
        opacity: 0
        x: transitionOffset
        clip: makeClip 0, -transitionOffset
    div.width $(widthDiv).width()
    div.transition 
        x: 0
        clip: makeClip 0, 0
        opacity: 1
        duration: transitionDuration

reviewPostcard = (data) ->
    transitionOut $ '#prompt-container'
    transitionIn $ '#review-panel'

    div = $ '#review-panel'
    $('#who', div).text data.who
    $('#what', div).text data.what
    $('#name', div).text data.name
    $('#email', div).text data.email
    $('#addressee', div).text data.who
    $('#schoolName', div).text data.mailto_school
    $('#schoolAddress', div).text data.mailto_street
    $('#schoolCityStateZip', div).text data.mailto_city_state

    $('#done').click ->
        ga 'send', 'event', 'button', 'click', 'postcard', 'done'
        window.open '/', '_self'

sendPostcard = (data) ->
    $.post '/postcards',
        message: data.what
        recipientFullName: data.who
        authorFullName: data.name
        authorEmail: data.email
    .fail (err) -> console.log err

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

    input.addClass 'active-focus'
    input.trigger 'focus'

    input.off 'typeahead:selected'
    input.on 'typeahead:selected', (obj, school) -> 
        g.school = school

setup = ->
    questions = [
        makeSimpleInputQuestion $('#who-question-form'), 'who'
        makeSchoolInputQuestion $('#when-question-form'), 'when'
        makeSimpleInputQuestion $('#what-question-form'), 'what'
        makeMultiInputQuestion $('#return-question-form'), ['name', 'email']
    ]
    serveQuestions questions, {}, (data) ->
        sendPostcard data
        reviewPostcard data

    populateStateOption()
    findTransitions.state()

    $("#find-school").click ->
        ga 'send', 'event', 'button', 'click', 'postcard', 'find-school'
        $('#school_modal').modal('show')

    $('#modal_submit').click ->
        ga 'send', 'event', 'button', 'click', 'postcard', 'find-school-submit'
        $('#school_modal').modal('hide')
        input = $('#answer', $('#when-question-form'))
        next = $('button.btn-next', $('#when-question-form'))
        if g.school
            g.valid = true
            if input.val()
                enableButton next
        else 
            g.valid = false
            disableButton next

    getSchoolInput().focus ->
        if !($(this).hasClass 'active-focus')
            city_name = getCityInput().val()
            city = {name: city_name.toUpperCase(), display: city_name}
            doSchoolSelection getStateSelect().val(), city
        $(this).addClass('active-focus')

    getSchoolInput().blur ->
        $(this).removeClass "active-focus"

$ ->
    require('../share-buttons').setup()
    setup()
