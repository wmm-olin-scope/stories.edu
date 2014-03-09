fs = require 'fs'

{print} = require 'sys'
{spawn, exec} = require 'child_process'
uglify = require 'uglify-js'
browserify = require 'browserify'
coffeeify = require 'coffeeify'

publicJs = 'public/javascripts'

execAndLog = (cmd, done) ->
  exec cmd, (err, stdout, stderr) ->
    process.stderr.write stderr if stderr?
    print stdout if stdout?
    process.stderr.write err.toString() if err
    done? err

allBuilds = []

vendorDir = 'client/js/vendor'
vendorLibs = [# dependency order
  'jquery', 'bootstrap', 'underscore', 'typeahead.bundle', 'summernote',
  'bootstrap-switch.min', 'lscache', 'jquery.transit'
]

buildVendorLibs = ->
  result = uglify.minify ("#{vendorDir}/#{lib}.js" for lib in vendorLibs),
    outSourceMap: '/javascripts/vendor.js.map'
  fs.writeFileSync "#{publicJs}/vendor.js", result.code
  fs.writeFileSync "#{publicJs}/vendor.js.map", result.map

allBuilds.push buildVendorLibs
task 'build:vendor', 'Bundle vendor js libraries', buildVendorLibs


buildClientModule = (name, rootFile, debug=yes) -> 
  buildFunc = ->
    b = browserify
      entries: ["./client/js/#{rootFile}"]
      extensions: ['.coffee']
    b.transform coffeeify

    output = fs.createWriteStream "#{publicJs}/#{name}.js"
    b.bundle({debug}).pipe(output)

  allBuilds.push buildFunc
  return buildFunc

task 'build:home', 'Build the home page js', 
  buildClientModule 'home', 'home/index.coffee'
task 'build:make-postcard', 'Build the make postcard page js', 
  buildClientModule 'make-postcard', 'postcard/make.coffee'
task 'build:prompts', 'Build the prompts page js', 
  buildClientModule 'prompts', 'prompts/index.coffee'

task 'data', 'Rebuild the database', ->
  execAndLog 'coffee data/schools.coffee'

task 'build', 'Build all the things', -> 
  build() for build in allBuilds

task 'sbuild', '', buildClientModule 'make-postcard', 'postcard/make.coffee'

task 'server', 'Starts the node server', ->
  execAndLog 'coffee app.coffee --nodejs'