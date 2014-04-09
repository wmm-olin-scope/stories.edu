{AWS} = require './aws'
Q = require 'q'

s3 = new AWS.S3()

exports.buckets = buckets =
    production: 'thankateacher'
    staging: 'thankateacherstaging'
    logging: 'thankateacherlog'

Q.ninvoke s3, 'getBucketAcl', {Bucket: buckets.production}
.catch (error) -> console.log {error}
.then (data) -> console.log {data}

