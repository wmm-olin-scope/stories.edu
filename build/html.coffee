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
utils.buildTask 'html:step2', 'Render the second postcard step',
    renderJade 'views/step2.jade', 'step2'
utils.buildTask 'html:step3', 'Render the third postcard step',
    renderJade 'views/step3.jade', 'step3'
utils.buildTask 'html:submitted', 'Render the submitted page',
    renderJade 'views/submitted.jade', 'submitted'
utils.buildTask 'html:about', 'Render the about page',
    renderJade 'views/about.jade', 'about'

