utils = require './utils'
{get: getTarget} = require './target'
fs = require 'fs'
jade = require 'jade'
s3 = require './s3'

exports.publicDir = 'public/html'

renderJade = (jadeFile, outName) -> (options) ->
    target = getTarget options
    html = jade.renderFile jadeFile,
        filename: jadeFile
        pretty: target is 'development'
        compileDebug: target is 'development'
        target: target
        staticUrl: s3.staticUrls[target]
        static: (end) -> "//#{s3.staticUrls[target]}/#{end}"
    fs.writeFileSync "#{exports.publicDir}/#{outName}.html", html

utils.buildTask 'html:index', 'Render the home page',
    renderJade 'views/index.jade', 'index'
utils.buildTask 'html:privacy', 'Render the privacy page',
    renderJade 'views/privacy.jade', 'privacy'
utils.buildTask 'html:thank-you', 'Render the thank you page',
    renderJade 'views/thank-you.jade', 'thank-you'
utils.buildTask 'html:about', 'Render the about page',
    renderJade 'views/about.jade', 'about'
utils.buildTask 'html:unsubscribe', 'Render the unsubscribe page',
    renderJade 'views/unsubscribe.jade', 'unsubscribe'

