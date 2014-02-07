

populateStateOption = ->
    select = $('#state-select')
    select.empty()
    for state in stateList
        select.append "<option value=#{state}>#{state}</option>"

 stateList = [
    'AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL',
    'IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE',
    'NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD',
    'TN','TX','UT','VT','VA','WA','WV','WI','WY','AS','GU','MP','PR','VI']

cityHounds = {}
getCityHound = (state) ->
    if state not of cityHounds
        hound = new Bloodhound
            datumTokenizer: (d) -> Bloodhound.tokenizers.whitespace d.name
            queryTokenizer: Bloodhound.tokenizers.whitespace
            prefetch: 
                url: "/schools/cities/#{state}"
                filter: (cities) -> ({name: city} for city in cities)
        hound.initialize()
        cityHounds[state] = hound

    return cityHounds[state]

updateCityTypeahead = ->
    state = $('#find-by-city #state-select').val()
    hound = getCityHound state
    $('#find-by-city #city-input').typeahead null,
        name: 'cities'
        displayKey: 'name'
        source: hound.ttAdapter()

$ ->
    populateStateOption()
    $('#find-by-city #state-select').change updateCityTypeahead

