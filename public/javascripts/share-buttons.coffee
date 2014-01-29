
siteUrl = 'http://www.redoedu.org'
facebookShareUrl = "https://www.facebook.com/sharer/sharer.php?u=#{encodeURIComponent siteUrl}"
twitterShareUrl = "https://twitter.com/share?url=#{encodeURIComponent siteUrl}&via=wmmedu"

showModal = (iframeUrl) ->
    $('#share-modal').modal('show')
    $('#share-modal').on 'shown.bs.modal', ->
        $('#share-modal-body').html """
                <iframe width="100%" height=100% url="#{iframeUrl}" frameborder="0">
                </iframe>
            """


$ ->
    $('#share-facebook').click -> window.open facebookShareUrl #showModal facebookShareUrl
    $('#share-twitter').click -> window.open twitterShareUrl #showModal twitterShareUrl