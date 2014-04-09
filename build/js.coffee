
utils = require './utils'
target = require './target'
fs = require 'fs'
uglify = require 'uglify-js'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
{WritableStreamBuffer} = require 'stream-buffers'

exports.publicDir = 'public/javascripts'

buildModule = (name, rootFile) -> (options) ->
    debug = target.isDevelopment options
    m = browserify
        entries: ["./client/js/#{rootFile}"]
        extensions: ['.coffee']
    m.transform coffeeify

    path = "#{exports.publicDir}/#{name}.js"
    output = m.bundle {debug}

    if debug
        output.pipe new fs.createWriteStream path
    else
        buffer = new WritableStreamBuffer()
        output
            .on 'end', ->
                code = buffer.getContentsAsString 'utf8'
                ugly = uglify.minify code, {fromString: yes}
                fs.writeFileSync path, ugly.code
            .pipe buffer

utils.buildTask 'js:home', 'Build the home page js',
    buildModule 'home', 'home/index.coffee'
utils.buildTask 'js:make-postcard', 'Build the make postcard page js',
    buildModule 'make-postcard', 'postcard/make.coffee'


vendorDir = 'client/js/vendor'
vendorLibs = [#dependency order
    'jquery',
    'bootstrap', 'jquery.transit'
    'underscore', 'amplify', 'history'
    'bootstrap-switch.min', 'typeahead.bundle'
]

utils.buildTask 'js:vendor', 'Bundle vendor js libs', (options) ->
    debug = target.isDevelopment options
    path = "#{exports.publicDir}/vendor.js"

    uglifyOptions = {}
    uglifyOptions.outSourceMap = "#{path}.map" if debug
    
    libPaths = ("#{vendorDir}/#{lib}.js" for lib in vendorLibs)
    ugly = uglify.minify libPaths, uglifyOptions

    fs.writeFileSync path, ugly.code 
    fs.writeFileSync "#{path}.map", ugly.map if debug
