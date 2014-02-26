
setup = ->

    capitalize = (s) ->
        (word[0].toUpperCase() + word[1...].toLowerCase() for word in s.split /\s+/).join ' '

    schoolsearch = new Bloodhound(
        datumTokenizer: (d) ->
            Bloodhound.tokenizers.whitespace d.num
        queryTokenizer: Bloodhound.tokenizers.whitespace
        remote:
            url: '/schools/by-name?text=%QUERY'
            filter: (schools) ->
                $.map schools, (school) ->
                    school.name = capitalize school.name
                    return school
    )

    schoolsearch.initialize()

    $('#video-button-desktop').click ->
        console.log('click on vid buttn')
        $('#video-modal').modal()
        if not window.VIDRECORDER?
            window.VIDRECORDER = {}
        window.VIDRECORDER.close = () -> $('#video-modal').modal('hide')
        console.log('attached handler')

    $('#teacher_name').keyup ->
        $('#mailto_name').val $(this).val()
        return

    $('#author_name').keyup ->
        $('#return_name').val $(this).val()
        return

    $('#mailto_school').focus ->
        $('#school_modal').modal('show')
        return

    $('#send_button').click ->
        contents =
            teacherName: $('#teacher_name').text()
            teacherRole: $('#teacher_role').text()
            message: $('#freetext').text()
            authorName: $('#author_name').text()
            authorRole: $('#author_role').text()
            anonRequest: $('#checkbox_input').is(':checked')
            returnName: $('#return_name').text()
            returnEmail: $('#return_email').text()
            mailtoName: $('#mailto_name').text()
            mailtoRole: $('#mailto_role').text()
            mailtoSchool: $('#mailto_school').text()
            mailtoStreet: $('#mailto_street').text()
            mailtoCityState: $('#mailto_city_state').text()
            youtubeId: $('#youtube_id').val()
        console.log(contents)
        return contents

    $("#mailto_school").typeahead null,
        displayKey: "name"
        source: schoolsearch.ttAdapter()
        minLength: 4

    $("#mailto_school").bind "typeahead:selected", (event, data, dataset) ->
        $('#mailto_street').val(data.mailingAddress.capitalize())
        $('#mailto_city_state').val(data.city.capitalize() + ", " + data.state + " " + data.zip)
        return
    return

$ ->
    require('../share-buttons').setup()
    require('./video-upload').setup()
    setup()