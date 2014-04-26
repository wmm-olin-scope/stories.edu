
POSTCARD_URL = '/postcards'

steps = [
    require('./step-1.coffee').step
    require('./step-2.coffee').step
    require('./step-3.coffee').step
]

normalizeSchoolData = (data) ->
    data = _.clone data
    return data unless data.schoolObj?
     
    data.schoolId = data.schoolObj._id
    data.schoolType = data.schoolObj.schoolType
    return _.omit data, 'schoolObj schoolName street city state zip'.split ' '
    
postcardFinished = (data) ->
    console.log {data}

    # amplify.store STEPS_STORAGE_KEY, {}

    showLoading()
    $.post POSTCARD_URL, normalizeSchoolData data
    .done (result) ->
        if result.success then switchToThankYou result
        else showError result.error
    .fail (error) -> showError error
    .always -> stopShowLoading()

switchToThankYou = ({postcard, school}) ->
    console.log {postcard, school}

showError = (error) ->
    $('#step-container').append """
        <div class="alert alert-danger alert-dismissable">
            <button type="button" class="close" data-dismiss="alert" 
                    aria-hidden="true">&times;</button>
            <strong>Try again!</strong> #{error.message or error}
        </div>
    """
    console.error error

showLoading = ->
    console.log 'loading'

stopShowLoading = ->
    console.log 'loading'


$ ->
    require('../share-buttons.coffee').setupButtons '#home-share-buttons'
    require('./steps').runSteps steps, postcardFinished
