
fs = require 'fs'
utils = require './utils'
target = require './target'
CleanCss = require 'clean-css'

exports.publicDir = 'public/stylesheets'

vendorDir = 'client/css/vendor'
vendorLibs = [
    'bootstrap.min'
    'bootstrap-spacelab.min'
    'font-awesome.min'
    'dosis-font'
    'bootstrap-switch.min'
    'social-buttons-3'
    'typeahead'
]

utils.buildTask 'css:vendor', 'Bundle vendor css', (options) ->
    joinedCss = ''
    for file in vendorLibs
        joinedCss += fs.readFileSync("#{vendorDir}/#{file}.css") + '\n'

    minimizer = new CleanCss
        keepSpecialComments: 0
    minimized = minimizer.minify joinedCss
    fs.writeFileSync "#{exports.publicDir}/vendor.css", minimized


