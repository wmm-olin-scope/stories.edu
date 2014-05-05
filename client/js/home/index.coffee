
POSTCARD_URL = '/postcards'

makeThankYouUrl = (postcard) ->
    "/thank-you/#{postcard._id}"

steps = [
    require('./step-1.coffee').step
    require('./step-2.coffee').step
    require('./step-3.coffee').step
]

normalizeSchoolData = (data) ->
    data = _.clone data
    return data unless data.schoolObj?._id
     
    data.schoolId = data.schoolObj._id
    data.schoolType = data.schoolObj.schoolType
    return _.omit data, 'schoolObj schoolName street city state zip'.split ' '
    
postcardFinished = (data) ->
    console.log {data}

    spinner = Ladda.create $('#send-note').get(0)
    spinner.start()

    $.post POSTCARD_URL, normalizeSchoolData data
    .done (result) ->
        if result.success then switchToThankYou result
        else showError result.error
    .fail (error) -> showError error
    .always -> spinner.stop()

switchToThankYou = ({postcard, school}) ->
    $('#make-postcard').toggleClass 'hidden', yes
    $('#show-postcard').toggleClass 'hidden', no
    $('#secondary-content').toggleClass 'hidden', yes

    url = makeThankYouUrl postcard
    if window.history?.pushState
        window.history.pushState {postcard, school}, 'Thank you!', url
    else
        # forces a reload, oh well, screw you for using an old browser
        window.location.pathname = url

    require('../postcard.coffee').run {postcard, school}

showError = (error) ->
    $('#step-container').append """
        <div class="alert alert-danger alert-dismissable">
            <button type="button" class="close" data-dismiss="alert" 
                    aria-hidden="true">&times;</button>
            <strong>Try again!</strong> #{error.message or error}
        </div>
    """
    console.error error


$ ->
    require('../share-buttons.coffee').setupButtons '.js-share-buttons'
    require('../sample-notes.coffee').setupRow '#js-sample-notes-row'
    require('./steps').runSteps steps, postcardFinished
