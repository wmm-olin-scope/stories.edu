
mongoose = require 'mongoose'
random = require 'mongoose-random'

exports.promptSchema = new mongoose.Schema
	html: String

exports.promptSchema.plugin(random())

exports.Prompt = mongoose.model 'Prompt', exports.promptSchema
