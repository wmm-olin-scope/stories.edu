
youtubeIdToUrl = (id) ->
    "//www.youtube.com/embed/#{id}?autoplay=1&showinfo=0&modestbranding=1&controls=1&rel=0&wmode=transparent"

openVideo = (title, youtubeId) ->
    modal = $ '.js-story-modal'
    # modal.find('#story-modal-title').text title # XXX No longer exists. Remove or reimplement?
    modal.find('iframe').attr 'src', youtubeIdToUrl(youtubeId)
    modal.modal 'show'

closeVideo = ->
    modal = $ '.js-story-modal'
    modal.find('iframe').attr 'src', ''

exports.setup = ->

    $('.js-story-carousel').find 'a'
        .css 'cursor', 'pointer'
        .click ->
            mixpanel.track 'User watched the carosel video: ' + $(this).attr('data-youtube-id')
            openVideo 'Some story', $(this).attr('data-youtube-id')

    $('.js-story-modal').on 'hide.bs.modal', (e) ->
        closeVideo()

    return