
{print} = require 'sys'
{spawn, exec} = require 'child_process'

exports.execAndLog = (cmd, done) ->
  exec cmd, (err, stdout, stderr) ->
    process.stderr.write stderr if stderr?
    print stdout if stdout?
    process.stderr.write err.toString() if err
    done? err

builds = []

exports.registerBuild = ({name, func}, async=yes) ->
    builds.push {name, func, async}

exports.buildTask = (name, description, func) ->
    exports.registerBuild {name, func}, no
    task "build:#{name}", description, func

exports.asyncBuildTask = (name, description, func) ->
    exports.registerBuild {name, func}, yes
    task "build:#{name}", description, func

task 'build', 'Runs every build:* task', (options) ->
    # TODO: we could do some parallel building if we're careful about 
    # dependencies.

    doBuild = (index) ->
        return if index >= builds.length
        {name, func, async} = builds[index]
        console.log name
        if async
            func options, -> doBuild index+1
        else
            func options
            doBuild index+1
    doBuild 0
