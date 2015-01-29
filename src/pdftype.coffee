fs 			= require "fs-extra"
path 		= require "path"
childpr		= require "child_process"

settings	= require "./settings"

class PdfType
	constructor: (srcfile, destfile)->
		@options = []
		@srcfile = path.normalize srcfile
		if destfile
			@destfile = path.normalize destfile
		else
			@destfile = srcfile + ".html"
	tune: (opts)->
		return if not opts
		if typeof opts is "string"
			return "Предустановленый набор настроек не найден" if not settings.pdf[opts]
			@options = settings.pdf[opts]
			return
		if Array.isArray opts
			@options = @options.concat opts
			return
		return "Опции должны быть именем предустановленных настроек, либо массивом строк с опциями"
	do: (cb)->
		from = path.basename @srcfile
		to = path.basename @destfile
		wd = path.dirname @srcfile

		args = [from,to].concat(@options)

		error = ""

		child = childpr.spawn "pdf2htmlEX", args, { cwd: wd }
		child.stdout.on "data", (chunk)-> # не используется
		child.stderr.on "data", (chunk)->
			error += chunk.toString()
		child.on "close", (code, signal)=>
			return cb error if code isnt 0
			fromFile = wd+"/"+to
			return cb() if fromFile is @destfile 
			fs.move fromFile, @destfile, cb

module.exports = PdfType