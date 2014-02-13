align_button = -> 
    desired_height = $('.content').height() - 160
    $('#spacer').height desired_height

setup = -> 
    align_button()
    $(window).resize -> 
        align_button()
        return
    $('.text-content').resize -> 
        align_button()
        return
    $('#teacher_name').keyup ->
        console.log $(this).text() 
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
    return

$ ->
    setup()
    return