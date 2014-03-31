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
    return null unless s?
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
                tracking = {}
                for dataField in dataFields
                    data[dataField] = $("[name='#{dataField}']").val()
                    tracking[dataField] = data[dataField]
                    # TODO: mixpanel integration needs testing
                    if dataField is 'email'
                        mixpanel.people.set
                          $email: data[dataField]
                        mixpanel.alias(data[dataField])
                    if dataField is 'name' 
                        mixpanel.people.set
                          $name: data[dataField]
                mixpanel.track 'input', tracking
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
                mixpanel.track 'input',
                  dataField: data[dataField]
                onNext()

        next.click send
        input.keydown (event) ->
            send() if event.which is 13 # enter

makeSchoolInputQuestion = (div, dataField) ->
    div: $ div
    run: (data, onNext) ->
        whenInput = $ '#whenAnswer', div
        next = $ 'button.btn-next', div

        checkInputs = ->
            valid = (g.school or getSchoolInput().val()) and whenInput.val()
            if valid then enableButton next
            else disableButton next
            valid

        getSchoolInput().keyup checkInputs
        getSchoolInput().change checkInputs
        whenInput.keyup checkInputs
        checkInputs()

        send = ->
            return unless checkInputs()

            data[dataField] = whenInput.val()

            if g.school?
                data.school = g.school
                data.schoolName = capitalize g.school.name
                data.street = capitalize g.school.mailingAddress
                data.city = capitalize g.school.city
                data.state = g.school.state
                data.zip = g.school.zip
            else
                data.schoolName = getSchoolInput().val()
                data.city = getCityInput().val()
                data.state = getStateSelect().val()
                data.zip = ''
                data.street = ''

            getSchoolInput().typeahead 'destroy'
            getCityInput().typeahead 'destroy'

            mixpanel.track 'input',
              dataField: data[dataField]
            setTimeout onNext, 1

        next.click send
        whenInput.keydown (event) ->
            send() if event.which is 13 # enter


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
        complete: ->
            div.css 'display', 'none'
            $('body').scrollLeft 0

    setTimeout (-> $('body').scrollLeft 0), 1

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
    $('#schoolName', div).text data.schoolName
    $('#schoolAddress', div).text data.street
    $('#schoolCityStateZip', div).text "#{data.city}, #{data.state} #{data.zip}"

    $('#done').click ->
        mixpanel.track 'click',
          action: 'done'
        mixpanel.identify(data.email)
        window.open '/', '_self'

sendPostcard = (data) ->
    postcard =
        message: data.what
        recipientFullName: data.who
        authorFullName: data.name
        authorEmail: data.email

    if data.school?
        postcard.schoolId = data.school._id
        postcard.schoolType = data.school.schoolType

    $.post '/postcards', postcard
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

    for event in ['typeahead:selected', 'typeahead:autocompleted']
        input.off event
        input.on event, (obj, city) ->
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

    for event in ['typeahead:selected', 'typeahead:autocompleted']
        input.off event
        input.on event, (obj, school) ->
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
