fs 			= require "fs"
path 		= require "path"
childpr		= require "child_process"
temp 		= require "temp"

settings	= require "./settings"

PdfType		= require "./pdftype"

class UnoconvType
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
			return "Предустановленый набор настроек не найден" if not settings.unoconv[opts]
			@options = settings.unoconv[opts]
			return
		if Array.isArray opts
			@options = @options.concat opts
			return
		return "Опции должны быть именем предустановленных настроек, либо массивом строк с опциями"
	do: (cb)->

		error = ""
		tmpfile = temp.path {prefix: 'unoconv-office-'}

		args = ["-o",tmpfile,"--format=pdf"].concat(@options)
		args.push(@srcfile)

		child = childpr.spawn "unoconv", args
		child.stderr.on "data", (chunk)-> error += chunk.toString()
		child.on "close", (code, signal)=>
			return cb error if code isnt 0
			pdft = new PdfType(tmpfile, @destfile)
			pdft.tune "default"
			pdft.do (err)-> fs.unlink tmpfile, ()-> cb(err)

module.exports = UnoconvType