
{capitalize} = require './utils.coffee'

getPostcardId = ->
    url = window.location.pathname
    index = url.lastIndexOf? '/'
    return unless index >= 0

    idString = url[index+1...]
    if idString.length >= 24
        idString[...24]
    else
        null

getPostcard = (postcardId, done) ->
    $.get "/postcards/#{postcardId}"
    .done (result) ->
        if result.success then done null, result
        else done result.error
    .fail (error) -> done error


showError = (error) ->
    window.open '/404', '_self'

$ ->
    postcardId = getPostcardId()
    return showError 'We couldn\'t find this thank you note.' unless postcardId

    getPostcard postcardId, (error, result) ->
        return showError (error.message or error) if error
        if result.school? and result.school.name?
            $('.postcard-title').text "#{result.postcard.name} thanked #{result.postcard.teacher} at #{capitalize result.school.name}"
        else
            $('.postcard-title').text "#{result.postcard.name} thanked #{result.postcard.teacher}"
        require('./postcard.coffee').run result
