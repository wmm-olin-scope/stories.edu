
mongoose = require 'mongoose'

exports.promptSchema = new mongoose.Schema
	html: String

exports.Prompt = mongoose.model 'Prompt', exports.promptSchema