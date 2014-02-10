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
    return

$ ->
    setup()
    return