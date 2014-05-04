
exports.run = ({postcard, school}) ->
    fillPostcardFields postcard
    fillSchoolFields school
    require('./personalized-share').setup({postcard, school})
    handleEllipsis postcard

fillPostcardFields = (postcard) ->
    $('.postcard-salutation').text "Dear #{postcard.teacher}"
    $('.postcard-body').text postcard.note
    # $('.postcard-full-message-link').toggleClass 'hidden', yes
    $('.postcard-signature').text postcard.name
    $('.postcard-addressee').text postcard.teacher


fillSchoolFields = (school) ->
    $('.postcard-school').text capitalize school.name
    $('.postcard-city-state').text "#{capitalize school.city}, #{school.state}"

handleEllipsis = (postcard) ->
    $('.postcard-ellipsis-wrapper').dotdotdot
        after: '.postcard-full-message-link'

    onResize = ->
        height = $('.postcard-left').height()
        height -= $('.postcard-salutation').outerHeight yes
        height -= $('.postcard-closing').outerHeight yes
        height -= $('.postcard-signature').outerHeight yes
        $('.postcard-ellipsis-wrapper').height height

        $('.postcard-ellipsis-wrapper').trigger 'update'
        isTruncated = $('.postcard-ellipsis-wrapper').triggerHandler 'isTruncated'
        $('.postcard-full-message-link').toggleClass 'hidden', not isTruncated

    onResize()
    $(window).resize onResize


# TODO: copied from step-2, put in utils    
capitalize = (s) ->
    return null unless s?
    (w[0].toUpperCase() + w[1...].toLowerCase() for w in s.split /\s+/)
    .join ' '

