fs = require 'fs'

{print} = require 'sys'
{spawn, exec} = require 'child_process'

buildDir = (dir, watch=no, done=null) ->
  watch = if watch then '-w ' else ''
  exec "coffee -c #{watch} -o #{dir} #{dir}", (err, stdout, stderr) ->
    process.stderr.write stderr if stderr?
    print stdout if stdout?
    process.stderr.write err.toString() if err
    done? err

allBuildDirs = ['routes', 'data', 'lib', '.']

task 'build', 'Builds all dirs', ->
  for dir in allBuildDirs
    buildDir dir, no

task 'watch', 'Watches for changes in all dirs, builds', ->
  for dir in allBuildDirs
    buildDir dir, yes

for dir in allBuildDirs
  do (dir) ->
    task "build:#{dir}", "Build #{dir}", ->
      buildDir "#{dir}", no
    task "watch:#{dir}", "Watches and builds #{dir}", ->
      buildDir "#{dir}", yes

task 'server', 'Starts the node server', ->
  node = spawn 'node', ['app.js']
  node.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  node.stdout.on 'data', (data) ->
    print data.toString()
  node.on 'exit', (code) ->
    print "server exiting with code #{code}"

task 'test', '', ->
  exec 'coffee -c test.coffee', (err, stdout, stderr) ->
    console.log err, stdout, stderr