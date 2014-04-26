
utils = require './utils'
target = require './target'
s3 = require './s3'
fs = require 'fs'
uglify = require 'uglify-js'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
path = require 'path'
processPath = require.resolve 'process/browser.js'
{WritableStreamBuffer} = require 'stream-buffers'

exports.publicDir = 'public/javascripts'

vendorDir = 'client/js/vendor'
vendorLibs = [#dependency order
    'jquery',
    'bootstrap', 'jquery.transit'
    'underscore', 'amplify', 'history'
    'typeahead.bundle'
]

utils.buildTask 'js:vendor', 'Bundle vendor js libs', (options) ->
    development = target.isDevelopment options
    path = "#{exports.publicDir}/vendor.js"

    uglifyOptions = {}
    uglifyOptions.outSourceMap = "#{path}.map" if development
    
    libPaths = ("#{vendorDir}/#{lib}.js" for lib in vendorLibs)
    ugly = uglify.minify libPaths, uglifyOptions

    fs.writeFileSync path, ugly.code 
    fs.writeFileSync "#{path}.map", ugly.map if development

buildModule = (name, rootFile) -> (options, done) ->
    development = target.isDevelopment options
    m = browserify
        entries: ["./client/js/#{rootFile}"]
        extensions: ['.coffee']
    m.transform coffeeify

    path = "#{exports.publicDir}/#{name}.js"
    output = m.bundle
        debug: development
        # insertGlobals: yes
        insertGlobalVars:
            DEVELOPMENT: -> "#{development}"
            STAGING: -> "#{target.isStaging options}"
            PRODUCTION: -> "#{target.isProduction options}"
            TARGET: -> "'#{target.get options}'"
            STATIC_URL: -> "'#{s3.staticUrls[target.get options]}'"
            # insert-module-globals doesn't export defaultVars, so we'll have
            # to reproduce them here.
            process: -> "require(#{JSON.stringify processPath})"
            global: -> 'typeof self !== "undefined" ? self : 
                        typeof window !== "undefined" ? window : {}'
            Buffer: -> 'require("buffer").Buffer'
            __filename: (file, baseDir) ->
                JSON.stringify "/#{path.relative baseDir file}"
            __dirname: (file, baseDir) ->
                JSON.stringify path.dirname "/#{path.relative baseDir file}"

    if development
        output.pipe new fs.createWriteStream path
        done?()
    else
        buffer = new WritableStreamBuffer()
        output
            .on 'end', ->
                code = buffer.getContentsAsString 'utf8'
                ugly = uglify.minify code, {fromString: yes}
                fs.writeFileSync path, ugly.code
                done?()
            .pipe buffer

utils.asyncBuildTask 'js:index', 'Build the home page js',
    buildModule 'index', 'home/index.coffee'
utils.asyncBuildTask 'js:submitted', 'Build the make postcard submitted page js',
    buildModule 'submitted', 'submitted.coffee'

