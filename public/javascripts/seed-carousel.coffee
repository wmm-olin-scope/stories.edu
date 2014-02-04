
youtubeIdToUrl = (id) ->
    "//www.youtube.com/embed/#{id}?showinfo=0&modestbranding=1&controls=1"

openVideo = (title, youtubeId) ->
    modal = $ '#story-modal'
    modal.find('#story-modal-title').text title
    modal.find('iframe').attr 'src', youtubeIdToUrl(youtubeId)
    modal.modal 'show'

$ ->
    $('#story-carousel').find('a').click ->
        openVideo 'Some story', 'wX78iKhInsc'