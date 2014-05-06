_ = require 'underscore'

exports.targets = targets =
    dev: 'development'
    staging: 'staging'
    prod: 'production'

exports.defaultTarget = targets.dev

targetString = ("#{key} (#{targets[key]})" for key in _.keys(targets)).join ', '
option '', '--target [target]', "Set the build target to one of: #{targetString}"

for short, long of targets
    option '', "--#{short}", "Set the target to be '#{long}'."
    exports["is#{long[0].toUpperCase()}#{long[1...]}"] = do (long) -> (options) ->
        exports.get(options) is long

exports.get = (options) ->
    shortFlag = null
    for short, long of targets
        if short of options
            throw 'More than one target set.' if shortFlag?
            shortFlag = long
    
    {target} = options
    if shortFlag and not target
        return shortFlag
    else if shortFlag and target
        throw 'More than one target set.'
    else if not target
        return exports.defaultTarget

    return targets[target] if target of targets
    return target if target in _.values targets

    throw "Unknown target #{target}."

