
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
        baseUrl: s3.baseUrls['target']
    fs.writeFileSync "#{exports.publicDir}/#{outName}.html", html

utils.buildTask 'html:index', 'Render the home page',
    renderJade 'views/index.jade', 'index'
