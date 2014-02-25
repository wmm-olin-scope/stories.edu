setup = ->

    g = {}

    String::capitalize = ->
        return (word[0].toUpperCase() + word[1..-1].toLowerCase() for word in this.split /\s+/).join ' ';

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
            disableInput getSchoolInput(), 'Select a city first...'
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
                ttl: 0 # TODO: when in production set to longer
        hound.initialize()
        hound

    getCityHound = (state) -> makeHound
        url: "/schools/cities/#{state}"
        filter: (cities) -> 
            {name: city, display: city.capitalize()} for city in cities
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

    getSchoolHound = (state, city) -> makeHound
        url: "/schools/by-city/#{state}/#{encodeURIComponent city.name}"
        filter: (schools) ->
            for school in schools
                school.display = school.name.capitalize()
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

    $('#teacher_name').keyup ->
        $('#mailto_name').val $(this).val()
        return

    $('#author_name').keyup ->
        $('#return_name').val $(this).val()
        return

    $('#mailto_school').focus ->
        $('#school_modal').modal('show')
        return

    $('#modal_submit').click ->
        $('#school_modal').modal('hide')
        console.log g.school
        if g.school != undefined
            $('#mailto_school').val g.school.name.capitalize()
            $('#mailto_street').val g.school.mailingAddress.capitalize()
            $('#mailto_city_state').val g.school.city.capitalize() + ", " + g.school.state + " " + g.school.zip

    $('#send_button').click ->
        teacher_name = $('#teacher_name').val()
        teacher_role = $('#teacher_role').val()
        message = $('#freetext').val()
        author_name = $('#author_name').val()
        author_role = $('#author_role').val()
        anon_request = $('#checkbox_input').is(':checked')
        return_name = $('#return_name').val()
        return_email = $('#return_email').val()
        mailto_name = $('#mailto_name').val()
        mailto_role = $('#mailto_role').val()
        mailto_school = $('#mailto_school').val()
        mailto_street = $('#mailto_street').val()
        mailto_city_state = $('#mailto_city_state').val()
        contents = {"teacher_name": teacher_name, "teacher_role": teacher_role, "message": message, 
        "author_name": author_name, "author_role": author_role, "anon_request": anon_request, 
        "return_name": return_name, "return_email": return_email, "mailto_name": mailto_name, 
        "mailto_role": mailto_role, "mailto_school": mailto_school, 
        "mailto_street": mailto_street, "mailto_city_state": mailto_city_state}
        console.log(contents)
        return contents

    populateStateOption()
    findTransitions.state()

    return
$ ->
    setup()
    return