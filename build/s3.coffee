{AWS} = require './aws'
Q = require 'q'

exports.s3 = s3 = new AWS.S3()

exports.buckets = buckets =
    production: 'thankateacher'
    staging: 'thankateacherstaging'
    logging: 'thankateacherlog'

exports.baseUrls =
    development: 'localhost:5001'
    production: 'd1zp18hignnzt1.cloudfront.net'
    staging: 's3.amazonaws.com/thankateacherstaging'
