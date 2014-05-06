
{spawn, exec} = require 'child_process'
target = require './target'
s3 = require './s3'
_ = require 'underscore'

task 'server', 'Run express server', (options) ->
    environment = _.clone process.env

    environment.STATIC_URL = s3.staticUrls[target.get options]
    environment.TARGET = target.get options
    for target in _.values target.targets
        if environment.TARGET is target
            environment[target.toUpperCase()] = '1'
        else
            delete environment[target.toUpperCase()]

    server = exec 'coffee app.coffee',
        cwd: "#{__dirname}/.."
        env: environment

    server.stdout.on 'data', (data) -> console.log data.toString().trim()
    server.stderr.on 'data', (error) -> console.error error.toString().trim()
    server.on 'close', (code) -> console.log "Server exited with code #{code}"

