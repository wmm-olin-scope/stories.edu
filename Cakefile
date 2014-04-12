require 'coffee-script/register'
utils = require './build/utils'
target = require './build/target'

require './build/css'
require './build/js'
require './build/html'
require './build/s3'

###
fs = require 'fs'
{print} = require 'sys'
{spawn, exec} = require 'child_process'
uglify = require 'uglify-js'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
CleanCss = require 'clean-css'

publicJs = 'public/javascripts'
publicCss = 'public/stylesheets'

execAndLog = (cmd, done) ->
  exec cmd, (err, stdout, stderr) ->
    process.stderr.write stderr if stderr?
    print stdout if stdout?
    process.stderr.write err.toString() if err
    done? err

allBuilds = []

vendorDir = 'client/js/vendor'
vendorLibs = [# dependency order
  'jquery', 'bootstrap', 'underscore', 'typeahead.bundle', 'amplify',
  'bootstrap-switch.min', 'lscache', 'jquery.transit', 'history'
]

buildVendorLibs = ->
  result = uglify.minify ("#{vendorDir}/#{lib}.js" for lib in vendorLibs),
    outSourceMap: '/javascripts/vendor.js.map'
  fs.writeFileSync "#{publicJs}/vendor.js", result.code
  fs.writeFileSync "#{publicJs}/vendor.js.map", result.map

allBuilds.push buildVendorLibs
task 'build:vendor', 'Bundle vendor js libraries', buildVendorLibs


vendorCssDir = 'client/css/vendor'
vendorCss = ['bootstrap.min', 'bootstrap-spacelab.min', 'font-awesome.min',
             'dosis-font', 'bootstrap-switch.min', 'social-buttons-3',
             'typeahead']

buildVendorCss = ->
  joinedCss = ''
  for file in vendorCss
    joinedCss += fs.readFileSync("#{vendorCssDir}/#{file}.css") + '\n'

  minimizer = new CleanCss
    keepSpecialComments: 0
  minimized = minimizer.minify joinedCss
  fs.writeFileSync "#{publicCss}/vendor.css", minimized

allBuilds.push buildVendorCss
task 'build:vendor-css', 'Bundle vendor css', buildVendorCss

buildLocalCss = ->
  minimizer = new CleanCss
    keepSpecialComments: 0
  minimized = minimizer.minify fs.readFileSync('client/css/main.css')
  fs.writeFileSync "#{publicCss}/main.css", minimized

  minimized = minimizer.minify fs.readFileSync('client/css/desktop.css')
  fs.writeFileSync "#{publicCss}/desktop.css", minimized

allBuilds.push buildLocalCss
task 'build:local-css', 'Bundle local css', buildLocalCss

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
###
