fs = require 'fs'

{print} = require 'sys'
{spawn, exec} = require 'child_process'

binDir = './node_modules/.bin'
publicJS = 'public/javascripts'
uglifyjs = "#{binDir}/uglifyjs"

execAndLog = (cmd, done) ->
  exec cmd, (err, stdout, stderr) ->
    process.stderr.write stderr if stderr?
    print stdout if stdout?
    process.stderr.write err.toString() if err
    done? err

buildDir = (dir, watch=no, done=null) ->
  watch = if watch then '-w ' else ''
  execAndLog "coffee -c #{watch} -o #{dir} #{dir}", done

allBuildDirs = ['routes', 'data', 'lib', 'public/javascripts', 'public/javascripts/schools', '.']

task 'build', 'Builds all dirs', ->
  for dir in allBuildDirs
    buildDir dir, no

task 'watch', 'Watches for changes in all dirs, builds', ->
  for dir in allBuildDirs
    buildDir dir, yes

for dir in allBuildDirs
  do (dir) ->
    task "build:#{dir.replace '/', '_'}", "Build #{dir}", ->
      buildDir "#{dir}", no
    task "watch:#{dir.replace '/', '_'}", "Watches and builds #{dir}", ->
      buildDir "#{dir}", yes


bundleVendorLibs = ->
  console.log "#{uglifyjs} client/js/vendor/*.js -c -e
              -o #{publicJS}/vendor.js 
              --source-map #{publicJS}/vendor.map 
              --source-map-url /javascripts/vendor.map"
  execAndLog "#{uglifyjs} client/js/vendor/*.js -c -e
              -o #{publicJS}/vendor.js 
              --source-map #{publicJS}/vendor.map 
              --source-map-url /javascripts/vendor.map"
task 'build:vendor', 'Bundle vendor js libraries', bundleVendorLibs

task 'server', 'Starts the node server', ->
  execAndLog 'coffee app.coffee --nodejs'
