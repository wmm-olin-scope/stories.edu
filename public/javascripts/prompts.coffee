

setup = ->
    $('#editor').summernote
        height: 300   
        focus: true
    $('#create').click -> putPrompt $('#editor').code()
    $('#clear').click -> clearEditor()
    $('.delete-prompt').click -> deletePrompt $(this).attr 'data-prompt-id'

clearEditor = -> $('#editor').code ''

deletePrompt = (id) ->

putPrompt = (prompt) ->
    req = 
        url: '/prompts/'
        type: 'PUT'
        data: {prompt}
    $.ajax(req)
        .fail(-> console.log 'Failed to put!')
        .done((res) -> location.reload true)

$ setup
    