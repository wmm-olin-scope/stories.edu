
{exec} = require 'child_process'
_ = require 'underscore'

task 'data:schools', 'Build the schools database', (options) ->
    dataTask = exec 'coffee data/schools.coffee',
        cwd: "#{__dirname}/.."
        env: _.clone process.env
    dataTask.stdout.on 'data', (data) -> console.log data.toString().trim()
    dataTask.stderr.on 'data', (error) -> console.error error.toString().trim()
    dataTask.on 'close', (code) ->
        console.log "Schools database builder exited with code #{code}"
