

exports.setupRow = (container) ->
    container = $ container
    modal = $('#sample-note-modal')

    modal.on 'hide.bs.modal', ->
        $('iframe', modal).remove()

    $('.sn-video-button', container).each ->
        button = $ this
        button.click ->
            $('.video-container', modal).append """
                <iframe src=#{button.data 'url'} frameborder='0' allowfullscreen='allowfullscreen'>
                </iframe>
            """

            $('.js-sample-note-name', modal).text button.data 'name'
            $('.js-sample-note-teacher', modal).text button.data 'teacher'
            $('.js-sample-note-school-city-state', modal).text(
                "from #{button.data 'school'} in #{button.data 'city'}, #{button.data 'state'}")
            modal.modal('show')



