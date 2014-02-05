
mongoose = require 'mongoose'
Q = require 'q'

uri = process.env.MONGOLAB_URI or 
      process.env.MONGOHQ_URL or
      'mongodb://localhost/stories'

exports.connect = -> Q.ninvoke mongoose, 'connect', uri

exports.dropModel = (model) ->
    deferred = Q.defer()
    mongoose.connection.db.dropCollection model.collection.name, (err) ->
        console.warn err if err # swallow errors here
        deferred.resolve()
    deferred.promise

exports.batchInsert = (model, docs, batchSize=1024) ->
    return Q() unless docs

    console.log docs.length, batchSize
    console.log (x for x in [1...docs.length] by batchSize)

    # make sure that the collection exists
    exists = Q.ninvoke model, 'create', docs[0]

    batches = []
    for batchStart in [1...docs.length] by batchSize
        do (batchStart) -> batches.push ->
            console.log "Batch start #{batchStart}/#{docs.length} for #{model.modelName}"
            batch = docs[batchStart...(batchStart+batchSize)]
            Q.ninvoke model.collection, 'insert', batch, {w: 1}
    batches.reduce ((prom, next) -> prom.then next), exists
