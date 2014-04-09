
{print} = require 'sys'
{spawn, exec} = require 'child_process'

exports.execAndLog = (cmd, done) ->
  exec cmd, (err, stdout, stderr) ->
    process.stderr.write stderr if stderr?
    print stdout if stdout?
    process.stderr.write err.toString() if err
    done? err

allBuilds = []

exports.registerBuild = (build) ->
    allBuilds.push build

exports.buildTask = (name, description, func) ->
    exports.registerBuild {name, func}
    task "build:#{name}", description, func

task 'build', 'Runs every build:* task', (options) ->
    for {name, func} in allBuilds
        console.log name
        func options

