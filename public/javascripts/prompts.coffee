

setup = ->
    $('#editor').summernote
        height: 300   
        focus: true
    $('#create').click -> putPrompt $('#editor').code()
    $('#clear').click -> clearEditor()

clearEditor = -> $('#editor').code ''

putPrompt = (prompt) ->
    req = 
        url: '/prompts/'
        type: 'PUT'
        data: {prompt}
    $.ajax(req)
        .fail(-> console.log 'Failed to put!')
        .done((res) ->
            console.log res
            clearEditor())

$ setup
    