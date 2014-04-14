
_render = null
exports.render = (res, view) -> _render res, view

exports.setup = (app) ->
    if app.get 'development'
        locals =
            staticUrl: app.get 'staticUrl'
            static: (url) -> "//#{locals.staticUrl}/#{url}"
        _render = (res, view) ->
            res.render view, locals
    else
        _render = (res, view) ->
            res.sendfile "public/html/#{view}.html"

exports.html = (view) -> (req, res) ->
    exports.render res, view

