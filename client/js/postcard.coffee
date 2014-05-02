
exports.run = ({postcard, school}) ->
    console.log 'Running postcard!'
    console.log {postcard, school}
    fillPostcardFields postcard
    fillSchoolFields school
    require('./personalized-share').setup({postcard, school})

fillPostcardFields = (postcard) ->
    $('.postcard-salutation').text "Dear #{postcard.teacher}"
    $('.postcard-body').text postcard.note
    $('.postcard-full-message-link').toggleClass 'hidden', yes
    $('.postcard-signature').text postcard.name
    $('.postcard-addressee').text postcard.teacher

fillSchoolFields = (school) ->
    $('.postcard-school').text capitalize school.name
    $('.postcard-city-state').text "#{capitalize school.city}, #{school.state}"

# TODO: copied from step-2, put in utils    
capitalize = (s) ->
    return null unless s?
    (w[0].toUpperCase() + w[1...].toLowerCase() for w in s.split /\s+/)
    .join ' '

