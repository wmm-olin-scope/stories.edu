
POSTCARD_URL = '/postcards'

steps = [
    require('./step-1.coffee').step
    require('./step-2.coffee').step
    require('./step-3.coffee').step
]

normalizeSchoolData = (data) ->
    return unless data.schoolObj?
    data.schoolId = data.schoolObj._id
    data.schoolType = data.schoolObj.schoolType

    for field in 'schoolObj schoolName street city state zip'.split ' '
        delete data[field]
    
postcardFinished = (data) ->
    console.log {data}

    # amplify.store STEPS_STORAGE_KEY, {}
    normalizeSchoolData data

    showLoading()
    $.post POSTCARD_URL, data
    .done (result) ->
        if result.success then switchToThankYou result
        else showError result.error
    .fail (error) -> showError error
    .always -> stopShowLoading()

switchToThankYou = ({postcard, school}) ->
    console.log {postcard, school}

showError = (error) ->
    console.error error

showLoading = ->
    console.log 'loading'

stopShowLoading = ->
    console.log 'loading'


$ ->
    require('../share-buttons.coffee').setupButtons '#home-share-buttons'
    require('./steps').runSteps steps, postcardFinished
