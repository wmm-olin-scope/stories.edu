
# taken from https://github.com/gouch/to-title-case/blob/master/to-title-case.js
toTitleCase = (string) ->
    smallWords = /^(a|an|and|as|at|but|by|en|for|if|in|nor|of|on|or|per|the|to|vs?\.?|via)$/i
    letters = /[A-Za-z0-9\u00C0-\u00FF]+[^\s-]*/g
    string.toLowerCase().replace letters, (match, index, title) ->
        if index > 0 and 
                index + match.length isnt title.length and 
                match.search(smallWords) > -1 and 
                title.charAt(index - 2) isnt ':' and 
                (title.charAt(index + match.length) isnt '-' or 
                        title.charAt(index - 1) is '-') and 
                title.charAt(index - 1).search(/[^\s-]/) < 0
            match.toLowerCase()
        else if match.substr(1).search(/[A-Z]|\../) > -1
            match
        else
            match.charAt(0).toUpperCase() + match.substr(1)

getStateSelect = -> $ '#find-by-city #state-select'
getCityInput = -> $ '#find-by-city #city-input'
getByCitySchoolInput = -> $ '#find-by-city-school'

getZipInput = -> $ '#find-by-zip #zip'
getByZipSchoolInput = -> $ '#find-by-zip #find-by-zip-school'

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

findByCityTransitions =
    state: ->
        getStateSelect().val ''
        disableInput getCityInput(), 'Select a state first...'
        disableInput getByCitySchoolInput(), 'Select a state first...'
        doStateSelection()
    city: (state) ->
        enableInput getCityInput(), 'City'
        disableInput getByCitySchoolInput(), 'Select a city first...'
        doCitySelection state
    school: (state, city) ->
        enableInput getByCitySchoolInput(), 'School'
        doByCitySchoolSelection state, city

doStateSelection = ->
    oldState = null
    getStateSelect().off 'change'
    getStateSelect().change ->
        state = getStateSelect().val()
        if state is ''
            findByCityTransitions.state()
        else if state isnt oldState
            findByCityTransitions.city state
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
            ttl: 0 # TODO: when in production set to longer
    hound.initialize()
    hound

getCityHound = (state) -> makeHound
    url: "/schools/cities/#{state}"
    filter: (cities) -> 
        {name: city, display: toTitleCase city} for city in cities
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
        findByCityTransitions.school state, city

getByCitySchoolHound = (state, city) -> makeHound
    url: "/schools/by-city/#{state}/#{encodeURIComponent city.name}"
    filter: (schools) ->
        for school in schools
            school.display = toTitleCase school.name
        schools
    accessor: (school) -> school.name

doByCitySchoolSelection = (state, city) ->
    hound = getByCitySchoolHound state, city
    input = getByCitySchoolInput()

    input.typeahead 'destroy'
    input.typeahead null,
        name: 'schools'
        displayKey: 'display'
        source: hound.ttAdapter()
    input.focus()

    input.off 'typeahead:selected'
    input.on 'typeahead:selected', (obj, school) -> 
        console.log school


findByZipTransitions =
    zip: ->
        getZipInput().val ''
        disableInput getByZipSchoolInput(), 'Input a ZIP code first...'
        doZipSelection()
    school: (zip) ->
        enableInput getByZipSchoolInput(), 'School'
        doByZipSchoolSelection zip

doZipSelection = ->
    input = getZipInput()
    setError = (error) -> 
        input.parents('.form-group').first().toggleClass 'has-error', error

    input.off 'input'
    input.on 'input', ->
        disableInput getByZipSchoolInput(), 'Input a ZIP code first...'
        zip = input.val()
        if /[0-9]{5}/.test zip
            setError no
            findByZipTransitions.school zip
        else
            setError /[^0-9]/.test zip

getByZipSchoolHound = (zip) -> makeHound
    url: "/schools/by-zip/#{zip}"
    filter: (schools) ->
        for school in schools
            school.display = toTitleCase school.name
        schools
    accessor: (school) -> school.name

doByZipSchoolSelection = (zip) ->
    hound = getByZipSchoolHound zip
    input = getByZipSchoolInput()

    input.typeahead 'destroy'
    input.typeahead null,
        name: 'schools'
        displayKey: 'display'
        source: hound.ttAdapter()
    input.focus()

    input.off 'typeahead:selected'
    input.on 'typeahead:selected', (obj, school) -> 
        console.log school

$ ->
    populateStateOption()
    findByCityTransitions.state()
    findByZipTransitions.zip()

