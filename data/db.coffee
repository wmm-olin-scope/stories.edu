
mongoose = require 'mongoose'
uri = process.env.MONGOLAB_URI or 
      process.env.MONGOHQ_URL or
      'mongodb://localhost/stories'

exports.connect = (done) ->
    mongoose.connect uri, (err, res) ->
        if err
            console.log "Couldn't connect to MongoDB: #{err}"
        else
            console.log 'Connected to MongoDB!'
            done() if done

exports.dropModel = (model, done) ->
    mongoose.connection.db.dropCollection(model.collection.name, done)

exports.batchInsert = (model, docs, done=(->), batchSize=1024) ->
    return unless docs

    # make sure that the collection exists
    model.create docs[0], (err) ->
        return done err if err

        doBatch = (index) ->
            return done() if index >= docs.length
            end = index + batchSize
            model.collection.insert docs[index...end], {w: 1}, (err) ->
                return done err if err
                doBatch end
        doBatch 1
