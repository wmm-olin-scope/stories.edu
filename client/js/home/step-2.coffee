
exports.step = step = new (require('./steps').Step) '#step-2', [
    {field: 'state', input: '.js-state-field'}
    {field: 'city', input: '.js-city-field'}
    {field: 'schoolName', input: '.js-school-field'}
]
step.listenOnLastInputEnter = no

# memoize is actually semantic here, typeahead starts to wrap input fields,
# so we need to make sure that we always point to the underlying input element
# otherwise $::val() doesn't work.
memoize = (f) ->
    val = null
    -> if val then val else val = f()
stateSelect = memoize -> $ '.js-state-field', step.id
cityInput = memoize -> $ '.js-city-field', step.id
schoolInput = memoize -> $ '.js-school-field', step.id

step.setup = (data) ->
    populateStateOption()

    fillInputs data
    for {field, input} in @inputs
        if not $(input).val()
            $(input).focus()
            break

stateList = [
    'AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL',
    'IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE',
    'NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD',
    'TN','TX','UT','VT','VA','WA','WV','WI','WY','AS','GU','MP','PR','VI']

populateStateOption = ->
    select = stateSelect()
    select.empty()
    select.append "<option value=\"\">State</option>"
    for state in stateList
        select.append "<option value=\"#{state}\">#{state}</option>"
    return

fillInputs = (data) ->
    if data.schoolObj?
        {state, city, name: schoolName} = data.schoolObj
    else
        {state, city, schoolName} = data
    stateSelect().val state?.toUpperCase()
    cityInput().val capitalize city
    schoolInput().val capitalize schoolName

step.validate = (data, updateCanGoNext) ->
    for {input} in @inputs
        $(input).keyup -> check data, updateCanGoNext
                .change -> check data, updateCanGoNext

    # initialize
    schoolObj = data.schoolObj # save this while we recreate hounds

    check data, updateCanGoNext
    cityInput().focus()
    if data.city
        cityInput().val oldCity = data.city

        schoolInput().focus()
        invalidateSchoolAutocomplete data
        cityInput().val oldCity = data.city # need to reset it

        if data.schoolName
            schoolInput().val oldSchoolName = data.schoolName
            updateCanGoNext yes

    data.schoolObj = schoolObj # saved


check = (data, updateCanGoNext) ->
    updateCanGoNext _.every [checkState, checkCity, checkSchool], (func) ->
        func data

oldState = {} # unique obj
checkState = (data) ->
    state = stateSelect().val()
    ok = state?.length > 0
    return ok if oldState is state
    oldState = state

    if state
        setInputEnabled cityInput(), yes, 'City'
        setInputEnabled schoolInput(), yes, 'School'
        invalidateCityAutocomplete data
        invalidateSchoolAutocomplete data
        cityInput().focus()
    else
        setInputEnabled cityInput(), no, 'Select a state first...'
        setInputEnabled schoolInput(), no, 'Select a state first...'

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

    for event in ['typeahead:selected', 'typeahead:autocompleted']
        input.off event
        input.on event, (obj, value) -> onSelect value

oldCity = {}
checkCity = (data) ->
    city = cityInput().val()
    ok = city?.length > 0
    if city isnt oldCity
        oldCity = city
        invalidateSchoolAutocomplete data
    return ok

invalidateCityAutocomplete = (data) ->
    data.schoolObj = null

    state = stateSelect().val()
    if not state
        cityInput().typeahead 'destroy'
        return

    hound = makeHound
        url: "/schools/cities/#{stateSelect().val().toUpperCase()}"
        filter: (cities) ->
            {name: city, display: capitalize city} for city in cities
        accessor: (city) -> city.name

    autocomplete cityInput(), hound, 'cities', ({name: city}) ->
        oldCity = cityInput().val()
        invalidateSchoolAutocomplete data
        schoolInput().focus()

oldSchoolName = {}
checkSchool = (data) ->
    schoolName = schoolInput().val()
    ok = schoolName?.length > 0
    if schoolName isnt oldSchoolName
        oldSchoolName = schoolName
        data.schoolObj = null # clear any autocompleted school
    return ok

invalidateSchoolAutocomplete = (data) ->
    data.schoolObj = null

    state = stateSelect().val()
    city = cityInput().val()
    if not state or not city
        schoolInput().typeahead 'destroy'
        return

    city = encodeURIComponent city.toUpperCase()
    url =
        if city then "/schools/by-city/#{state}/#{city}"
        else "/schools/by-state/#{state}"

    hound = makeHound
        url: url
        filter: (schools) ->
            filtered = []
            for school in schools when school.name
                school.display = capitalize school.name
                filtered.push school
            filtered
        accessor: (school) -> school.display
    
    autocomplete schoolInput(), hound, 'schools', (school) ->
        console.log {school}
        oldSchoolName = schoolInput().val()
        data.schoolObj = school
        cityInput().val capitalize school.city

step.writeData = (data) ->
    schoolObj = data.schoolObj
    if schoolObj?
        {name: school, mailingAddress: street, city, state, zip} = schoolObj
        data.schoolName = capitalize school
        data.street = capitalize street
        data.city = capitalize city
        data.state = state
        data.zip = zip
    else
        data.schoolName = schoolInput().val()
        data.city = cityInput().val()
        data.state = stateSelect().val()

capitalize = (s) ->
    return null unless s?
    (w[0].toUpperCase() + w[1...].toLowerCase() for w in s.split /\s+/)
    .join ' '

setInputEnabled = (input, enabled=yes, placeholder='') ->
    $ input
        .attr 'disabled', not enabled
        .val ''
        .attr 'placeholder', placeholder
