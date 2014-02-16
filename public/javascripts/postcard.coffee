setup = ->

    String::capitalize = ->
        return (word[0].toUpperCase() + word[1..-1].toLowerCase() for word in this.split /\s+/).join ' ';

    schoolsearch = new Bloodhound(
        datumTokenizer: (d) ->
            Bloodhound.tokenizers.whitespace d.num
        queryTokenizer: Bloodhound.tokenizers.whitespace
        remote:
            url: '/schools/by-name?text=%QUERY' 
            filter: (schools) -> 
                $.map schools, (school) ->
                    school.name = school.name.capitalize()
                    return school 
    )

    schoolsearch.initialize()

    $('#teacher_name').keyup ->
        $('#mailto_name').text $(this).text()
        return
    $('#send_button').click ->
        teacher_name = $('#teacher_name').text()
        teacher_role = $('#teacher_role').text()
        message = $('#freetext').text()
        author_name = $('#author_name').text()
        author_role = $('#author_role').text()
        anon_request = $('#checkbox_input').is(':checked')
        return_name = $('#return_name').text()
        return_email = $('#return_email').text()
        mailto_name = $('#mailto_name').text()
        mailto_role = $('#mailto_role').text()
        mailto_school = $('#mailto_school').text()
        mailto_street = $('#mailto_street').text()
        mailto_city_state = $('#mailto_city_state').text()
        contents = {"teacher_name": teacher_name, "teacher_role": teacher_role, "message": message, 
        "author_name": author_name, "author_role": author_role, "anon_request": anon_request, 
        "return_name": return_name, "return_email": return_email, "mailto_name": mailto_name, 
        "mailto_role": mailto_role, "mailto_school": mailto_school, 
        "mailto_street": mailto_street, "mailto_city_state": mailto_city_state}
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
    setup()
    return