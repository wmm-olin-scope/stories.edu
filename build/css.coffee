fs = require 'fs'
utils = require './utils'
target = require './target'
CleanCss = require 'clean-css'
less = require 'less'
Q = require 'q'
_ = require 'underscore'
walk = require 'walk'

exports.publicDir = 'public/stylesheets'

vendorDir = 'client/css/vendor'
vendorLibs = [
    'bootstrap.min'
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
    compileAllLocalLess options
    .fin -> done?()

task 'watch:less:local', 'Bundle local css/less', (options) ->
    doCompile = (changedFile) ->
        console.log "#{changedFile} changed, recompiling"
        compileAllLocalLess options
    doCompile = _.debounce doCompile, 10

    walk.walkSync 'client/css',
        filters: ['vendor', '.git']
        listeners:
            file: (root, {name}, next) ->
                end = '.less'
                if name[0] isnt '.' and name[name.length-end.length...] is end
                    fs.watch "#{root}/#{name}", (event) ->
                        doCompile name if event is 'change'
                next()
###
    for file in localFiles
        do (file) ->
            doCompile = ->
                compileLocalLess file, options
                .catch (error) ->
                    console.error "Error compile #{file}.less"
                    console.error error?.toString()
                .then -> console.log "#{file}.less recompiled"
                .fin()

            doCompile = _.debounce doCompile, 10
            fs.watch localLessFile(file), (event) ->
                doCompile() if event is 'change'
###

localLessFile = (file) -> "client/css/#{file}.less"

compileAllLocalLess = (options) ->
    Q.all (compileLocalLess file, options for file in localFiles)

compileLocalLess = (file, options) ->
    parser = new (less.Parser)
        paths: ['client/css/']
        filename: localLessFile file
    content = fs.readFileSync localLessFile(file), 'utf8'

    Q.ninvoke parser, 'parse', content
    .then (tree) ->
        css = tree.toCSS {compress: not target.isDevelopment options}
        fs.writeFileSync "#{exports.publicDir}/#{file}.css", css
    .catch (error) -> console.error "Error with #{file}.less: #{error}"
