disableButton = (button) -> $(button).attr 'disabled', 'disabled'
enableButton = (button) -> $(button).removeAttr 'disabled'
isButtonDisabled = (button) -> $(button).attr 'disabled'

enableInput = (input, placeholder) -> 
    input.attr('disabled', no).val('').attr('placeholder', placeholder)
disableInput = (input, placeholder) ->
    input.typeahead 'destroy'
    input.attr('disabled', yes).val('').attr('placeholder', placeholder)

makeMultiInputQuestion = (div, dataFields) ->
    div: $ div
    run: (data, onNext) ->
        inputs = $ '.answer', div
        next = $ 'button.btn-next', div

        enableButton next
        for dataField in dataFields
            if data[dataField]
                $("[name='#{dataField}']").val data[dataField]
            else 
                disableButton next

        hasVal = (key) -> $(key).val()

        inputs.keyup ->
            emptyInputs = inputs.filter(() -> $(this).val() == "" )
            if emptyInputs.length then disableButton next
            else enableButton next

        next.click ->
            if ! (isButtonDisabled next) 
                for dataField in dataFields
                    data[dataField] = $("[name='#{dataField}']").val()
                console.log data
                onNext()


makeSimpleInputQuestion = (div, dataField) ->
    div: $ div
    run: (data, onNext) ->
        input = $ '#answer', div
        next = $ 'button.btn-next', div

        if data[dataField]
            input.val data[dataField]
            enableButton next
        else
            disableButton next

        input.keyup ->
            if input.val() then enableButton next
            else disableButton next
        next.click ->
            if input.val()
                data[dataField] = input.val()
                mixpanel.track "User clicked on button: "+ dataField.toUpperCase()
                onNext()


 # TODO: on resize
makeClip = (left=0, rightDelta=0) -> 
    wrapper = $ '#question-wrapper'
    "rect(0px,#{wrapper.width()+rightDelta}px,2000px,#{left}px)"

setupQuestionDivs = (divs) ->
    for div, i in divs
        if i > 0 then div.css
            display: 'none'
            x: transitionOffset
            clip: makeClip 0, -transitionOffset
        else div.css
            display: ''
            x: 0
            clip: makeClip 0, 0

serveQuestions = (questions, data, done) ->
    setupQuestionDivs (div for {div} in questions)

    index = 0
    serveNext = ->
        transitionOut questions[index].div
        if questions[++index]?
            updateProgress index, questions.length
            transitionIn questions[index].div
            questions[index].run data, serveNext
        else
            done data

    updateProgress index, questions.length
    questions[0].run data, serveNext

transitionOffset = 1500
transitionDuration = 600

updateProgress = (index, length) ->
    bar = $ '#progress .progress-bar'
    progress = (index+1)/length*100

    $('#progress-label').text "Step #{index+1} of #{length}"
    bar.attr 'aria-valuenow', "#{Math.round progress}"
    bar.transition
        width: "#{progress}%"
        duration: transitionDuration

transitionOut = (div) ->
    div.transition
        x: -transitionOffset
        opacity: 0
        clip: makeClip transitionOffset
        duration: transitionDuration
        complete: -> div.css 'display', 'none'

transitionIn = (div, widthDiv='#question-container') ->
    div.css 
        display: ''
        opacity: 0
        x: transitionOffset
        clip: makeClip 0, -transitionOffset
    div.width $(widthDiv).width()
    div.transition 
        x: 0
        clip: makeClip 0, 0
        opacity: 1
        duration: transitionDuration

reviewPostcard = (data) ->
    transitionOut $ '#prompt-container'
    transitionIn $ '#review-panel'

    div = $ '#review-panel'
    $('#who', div).text data.who
    $('#what', div).text data.what
    $('#name', div).text data.name
    $('#email', div).text data.email
    $('#addressee', div).text data.who

    $('#done').click ->
        window.open '/', '_self'

sendPostcard = (data) ->
    $.post '/postcards',
        message: data.what
        recipientFullName: data.who
        authorFullName: data.name
        authorEmail: data.email
    .fail (err) -> console.log err

setup = ->
    questions = [
        makeSimpleInputQuestion $('#who-question-form'), 'who'
        makeSimpleInputQuestion $('#when-question-form'), 'when'
        makeSimpleInputQuestion $('#what-question-form'), 'what'
        makeMultiInputQuestion $('#return-question-form'), ['name', 'email']
    ]
    serveQuestions questions, {}, (data) ->
        sendPostcard data
        reviewPostcard data



$ ->
    require('../share-buttons').setup()
    setup()