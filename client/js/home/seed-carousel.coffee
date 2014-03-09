
youtubeIdToUrl = (id) ->
    "//www.youtube.com/embed/#{id}?autoplay=1&showinfo=0&modestbranding=1&controls=1&rel=0&wmode=transparent"

openVideo = (title, youtubeId) ->
    modal = $ '#story-modal'
    modal.find('#story-modal-title').text title
    modal.find('iframe').attr 'src', youtubeIdToUrl(youtubeId)
    modal.modal 'show'

closeVideo = -> 
    modal = $ '#story-modal'
    modal.find('iframe').attr 'src', ''

exports.setup = ->

    $('#story-carousel').find 'a'
        .css 'cursor', 'pointer'
        .click -> openVideo 'Some story', $(this).attr('data-youtube-id')

    $('#story-modal').on 'hide.bs.modal', (e) ->
        closeVideo()

    return
