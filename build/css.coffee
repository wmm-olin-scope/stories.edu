
fs = require 'fs'
utils = require './utils'
target = require './target'
CleanCss = require 'clean-css'
less = require 'less'
Q = require 'q'
_ = require 'underscore'

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

minify = (css) ->
    minimizer = new CleanCss
        keepSpecialComments: 0
    minimizer.minify css

utils.buildTask 'css:vendor', 'Bundle vendor css', (options) ->
    joinedCss = ''
    for file in vendorLibs
        joinedCss += fs.readFileSync("#{vendorDir}/#{file}.css") + '\n'
    fs.writeFileSync "#{exports.publicDir}/vendor.css", minify joinedCss

localFiles = ['main', 'desktop']

utils.asyncBuildTask 'less:local', 'Bundle local css/less', (options, done) ->
    Q.all (compileLocalLess file, options for file in localFiles)
    .fin -> done?()

task 'watch:less:local', 'Bundle local css/less', (options) ->
    for file in localFiles
        do (file) ->
            doCompile = ->
                compileLocalLess file, options
                .fin -> console.log "#{file}.less recompiled"
            doCompile = _.debounce doCompile, 10
            fs.watch localLessFile(file), (event) ->
                doCompile() if event is 'change'

localLessFile = (file) -> "client/css/#{file}.less"

compileLocalLess = (file, options) ->
    content = fs.readFileSync localLessFile(file), 'utf8'
    Q.ninvoke less, 'render', content
    .catch (error) -> console.error "Error with #{file}.less: #{error}"
    .then (css) ->
        if not target.isDevelopment options
            css = minify css
        fs.writeFileSync "#{exports.publicDir}/#{file}.css", css
        Q()
