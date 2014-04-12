AWS = require 'aws-sdk'

AWS.config.update
    accessKeyId: process.env.AWS_KEY
    secretAccessKey: process.env.AWS_SECRET

exports.AWS = AWS
