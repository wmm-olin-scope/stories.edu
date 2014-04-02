
{TextInputStep, transitionDuration} = require './steps'
{setInputEnabled, capitalize} = require './utils'

exports.step = step = new TextInputStep 'where', '#where-panel', ['when']

step.setup = ->
    TextInputStep::setup.call step

    step.stateSelect = $ "[name='state']", step.container
    step.cityInput = $ "[name='city']", step.container
    step.schoolNameInput = $ "[name='school-name']", step.container

    populateStateOption()
    #fixSchoolFocus()

    step.stateSelect.off 'change'

step.isDataComplete = (data) ->
    return no unless TextInputStep::isDataComplete.call step, data
    data.school or (data.state and data.city and data.schoolName)

step.run = (data, onDone) ->
    TextInputStep::run.call step, data, onDone
    setTimeout (-> step.stateSelect.focus()), transitionDuration

stateList = [
    'AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL',
    'IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE',
    'NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD',
    'TN','TX','UT','VT','VA','WA','WV','WI','WY','AS','GU','MP','PR','VI']

populateStateOption = ->
    select = step.stateSelect
    select.empty()
    select.append "<option value=\"\">State</option>"
    for state in stateList
        select.append "<option value=\"#{state}\">#{state}</option>"
    return

fixSchoolFocus = ->
    step.schoolNameInput.focus ->
        if not step.schoolNameInput.hasClass 'active-focus'
            city = step.cityInput.val()
            findTransitions.school step.stateSelect.val(),
                name: city.toUpperCase()
                display: city
        step.schoolNameInput.addClass 'active-focus'

    step.schoolNameInput.blur ->
        step.schoolNameInput.removeClass 'active-focus'


step.fillInputs = (data) ->
    TextInputStep::fillInputs.call step, data

    if data.school?
        step.school = data.school
        step.stateSelect.val capitalize data.school.state
        step.cityInput.val capitalize data.school.city
        step.schoolNameInput.val capitalize data.school.name
    else
        step.school = null
        step.stateSelect.val data.state
        step.cityInput.val data.city
        step.schoolNameInput.val data.schoolName

    for input in [step.stateSelect, step.cityInput, step.schoolNameInput]
        $(input)
            .keyup -> step.checkInputs()
            .change -> step.checkInputs()

step.checkInputs = ->
    whenGood = TextInputStep::checkInputs.call step
    stateGood = checkState()
    cityGood = checkCity()
    schoolGood = checkSchool()
    return _.every [whenGood, stateGood, cityGood, schoolGood]

oldState = {} # unique obj
checkState = ->
    state = step.stateSelect.val()
    ok = state?.length > 0
    return ok if oldState is state
    oldState = state

    if state
        invalidateCityAutocomplete()
        invalidateSchoolAutocomplete()

    if state
        setInputEnabled step.cityInput, yes, 'City'
        setInputEnabled step.schoolNameInput, yes, 'School'
        step.cityInput.focus()
    else
        setInputEnabled step.cityInput, no, 'Select a state first...'
        setInputEnabled step.schoolNameInput, no, 'Select a state first...'

    return ok

makeHound = (options) ->
    {url, filter, accessor} = options
    hound = new Bloodhound
        datumTokenizer: (d) -> 
            Bloodhound.tokenizers.whitespace accessor d
        queryTokenizer: Bloodhound.tokenizers.whitespace
        prefetch:
            url: url
            filter: filter
            ttl: 0 
    hound.initialize()
    hound

autocomplete = (input, hound, name, onSelect) ->
    input.typeahead 'destroy'
    input.typeahead null,
        name: name
        displayKey: 'display'
        source: hound.ttAdapter()

    #input.addClass 'active-focus'
    #input.focus()

    for event in ['typeahead:selected', 'typeahead:autocompleted']
        input.off event
        input.on event, (obj, value) -> onSelect value

oldCity = {}
checkCity = ->
    city = step.cityInput.val()
    ok = city?.length > 0
    if city isnt oldCity
        oldCity = city
        invalidateSchoolAutocomplete()
    return ok

invalidateCityAutocomplete = ->
    step.school = null

    state = step.stateSelect.val()
    if not state
        step.cityInput.typeahead 'destroy'
        return

    hound = makeHound
        url: "/schools/cities/#{step.stateSelect.val().toUpperCase()}"
        filter: (cities) -> 
            {name: city, display: capitalize city} for city in cities
        accessor: (city) -> city.name

    autocomplete step.cityInput, hound, 'cities', ({name: city}) ->
        oldCity = step.cityInput.val()
        invalidateSchoolAutocomplete()
        step.schoolNameInput.focus()

oldSchoolName = {}
checkSchool = ->
    schoolName = step.schoolNameInput.val()
    ok = schoolName?.length > 0
    if schoolName isnt oldSchoolName
        oldSchoolName = schoolName
    return ok

invalidateSchoolAutocomplete = ->
    step.school = null

    state = step.stateSelect.val()
    city = step.cityInput.val()
    if not state or not city
        step.schoolNameInput.typeahead 'destroy'
        return

    city = encodeURIComponent city.toUpperCase()
    url = 
        if city then "/schools/by-city/#{state}/#{city}"
        else "/schools/by-state/#{state}"

    hound = makeHound
        url: url
        filter: (schools) ->
            for school in schools
                school.display = capitalize school.name
            schools
        accessor: (school) -> school.name
    
    autocomplete step.schoolNameInput, hound, 'schools', (school) ->
        step.school = school
        step.cityInput.val capitalize school.city
        step.inputs[0].focus()

step.extractData = ->
    data = TextInputStep::extractData.call step

    school = step.school
    if school?
        data.school = school
        data.schoolName = capitalize school.name
        data.street = capitalize school.mailingAddress
        data.city = capitalize school.city
        data.state = school.state
        data.zip = school.zip
    else
        data.schoolName = step.schoolNameInput.val()
        data.city = step.cityInput.val()
        data.state = step.stateSelect.val()
    data 

