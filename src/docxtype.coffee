fs 			= require "fs-extra"
path 		= require "path"
mammoth		= require "mammoth"

class DocxType
	constructor: (@srcfile, @destfile)->
		@options = {}
		@srcfile = path.normalize srcfile
		if destfile
			@destfile = path.normalize destfile
		else
			@destfile = srcfile + ".html"
	tune: ()-> return
	do: (cb)->
		mammoth
			.convertToHtml {path:@srcfile}, @options
			.then (r)=>
				result = _wrap r.value
				fs.writeFile @destfile, result, cb
			.done()

_wrap = (v)->
	'<html><head><meta charset="utf-8"></head><body>'+v+'</body><html>'

module.exports = DocxType