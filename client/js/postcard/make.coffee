
setup = ->
    g = {}

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

    getSchoolHound = (state, city) -> makeHound
        url: "/schools/by-city/#{state}/#{encodeURIComponent city.name}"
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
        console.log('click on vid buttn')
        $('#video-modal').modal()
        if not window.VIDRECORDER?
            window.VIDRECORDER = {}
        window.VIDRECORDER.close = () -> $('#video-modal').modal('hide')
        console.log('attached handler')

    linkTextFields = (field1, field2) ->
        $(field1).keyup -> $(field2).val $(field1).val()
        $(field2).keyup -> $(field1).val $(field2).val()

    linkTextFields '#teacher_name', '#mailto_name'
    linkTextFields '#author_name', '#return_name'
    linkTextFields '#author_role', '#mailto_role'

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
            authorEmail: $('@return_email').val()
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
    require('./video-upload').setup()
    setup()