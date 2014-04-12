{AWS} = require './aws'
Q = require 'q'
fs = require 'fs'
path = require 'path'
{walk} = require 'walk'
mime = require 'mime'
md5 = require 'MD5'
target = require './target'

exports.LOCAL_BUCKET = 'public'

exports.s3 = s3 = new AWS.S3()

exports.buckets = buckets =
    production: 'thankateacher'
    staging: 'thankateacherstaging'
    logging: 'thankateacherlog'

exports.staticUrls =
    development: 'localhost:5001'
    production: 'd1zp18hignnzt1.cloudfront.net'
    staging: 's3.amazonaws.com/thankateacherstaging'

exports.cacheMaxAges = # in seconds
    development: 0
    production: 60*60
    staging: 1*60
    
task 's3:push', 'Push files to S3', (options) ->
    return if target.isDevelopment options

    putFile = (file) ->
        console.log "Uploading #{file}"

        maxAge = exports.cacheMaxAges[target.get options]
        content = fs.readFileSync file
        key = path.relative(exports.LOCAL_BUCKET, file).replace '\\', '/'

        Q.ninvoke s3, 'putObject',
            Bucket: buckets[target.get options]
            Key: key
            ACL: 'public-read'
            Body: content
            CacheControl: "no-transform,public,max-age=#{maxAge}"
            # ContentMD5: md5 content
            ContentType: mime.lookup file
            Expires: new Date(Date.now() + maxAge*1000)
            StorageClass: 'REDUCED_REDUNDANCY' # easy reproduce, saves money

    putOperations = []
    walk exports.LOCAL_BUCKET, {followLinks: no}
        .on 'file', (root, {name}, next) ->
            return next() if name? is 'Thumbs.db' or name?[0] is '.'
            putOperations.push putFile path.join root, name
            next()
        .on 'error', (error) ->
            console.error error
        .on 'end', ->
            Q.all putOperations
            .catch (error) -> console.error error
            .fin -> console.log 'Done.'
