fs 			= require "fs-extra"
path 		= require "path"
childpr		= require "child_process"

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

		now = new Date()
		randomName = now.getYear()+"_"+now.getMonth()+"_"+now.getDate()+"_"+process.pid+"_"+(Math.random() * 0x100000000 + 1).toString(36)+".pdf"
		tmpfile = path.normalize settings.tmp_dir+"/#{randomName}"

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