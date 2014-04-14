
exports.setup = (app) ->
    if app.get 'development'
        locals =
            staticUrl: app.get 'staticUrl'
            static: (url) -> "//#{locals.staticUrl}/#{url}"
        exports.render = (res, view) ->
            res.render view, locals
    else
        exports.render = (res, view) ->
            res.sendfile "public/html/#{view}.html"

exports.html = (view) -> (req, res) ->
    exports.render res, view

