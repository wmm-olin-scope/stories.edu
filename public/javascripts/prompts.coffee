
$ ->
    $('a[title]').tooltip {container: 'body'}

    $('.dropdown-menu input')
        .click(-> false)
        .change(-> 
            $(this).parent('.dropdown-menu').siblings('.dropdown-toggle')
                   .dropdown('toggle')
            return)
        .keydown('esc', -> @value = ''; $(this).change(); return)

    $('[data-role=magic-overlay]').each ->
        target = $ overlay.data 'target'
        $(this)
            .css('opacity', 0)
            .css('position', 'absolute')
            .offset(target.offset())
            .width(target.outerWidth())
            .height(target.outerHeight())

    $('#promptEditor').wysiwyg()