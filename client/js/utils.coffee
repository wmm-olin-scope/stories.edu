
exports.capitalize = (s) ->
    return "" if s == ""
    return null unless s?
    (w[0].toUpperCase() + w[1...].toLowerCase() for w in s.split /\s+/)
    .join ' '
