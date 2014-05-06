_ = require 'underscore'

exports.run = ({postcard, school}) ->
    fillPostcardFields postcard
    fillSchoolFields school
    require('./personalized-share').setup({postcard, school})
    handleDesktopEllipsis postcard

fillPostcardFields = (postcard) ->
    $('.postcard-salutation').text "Dear #{_.unescape(postcard.teacher)}"
    $('.postcard-body').text _.unescape(postcard.note)
    $('.postcard-signature').text _.unescape(postcard.name)
    $('.postcard-addressee').text _.unescape(postcard.teacher)

fillSchoolFields = (school) ->
    $('.postcard-school').text capitalize _.unescape(school.name)
    $('.postcard-city-state').text "#{capitalize _.unescape(school.city)}, #{_.unescape(school.state)}"

handleDesktopEllipsis = (postcard) ->
    container = '.postcard-container'
    $local = (x) -> $(x, container)

    $local('.postcard-ellipsis-wrapper').dotdotdot
        after: ".postcard-full-message-link"

    onResize = ->
        height = $local('.postcard-left').height()
        height -= $local('.postcard-salutation').outerHeight yes
        height -= $local('.postcard-closing').outerHeight yes
        height -= $local('.postcard-signature').outerHeight yes
        $local('.postcard-ellipsis-wrapper').height height

        $local('.postcard-ellipsis-wrapper').trigger 'update'
        isTruncated = $local('.postcard-ellipsis-wrapper').triggerHandler 'isTruncated'
        $local('.postcard-full-message-link').toggleClass 'hidden', not isTruncated

    onResize()
    $(window).resize onResize

# TODO: copied from step-2, put in utils    
capitalize = (s) ->
    return null unless s?
    (w[0].toUpperCase() + w[1...].toLowerCase() for w in s.split /\s+/)
    .join ' '

