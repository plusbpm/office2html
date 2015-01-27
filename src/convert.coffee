fs 			= require "fs"

PdfType		= require "./pdftype"
DocxType	= require "./docxtype"
UnoconvType	= require "./unoconvtype"

module.exports = (srcfile, destfile, options, cb)->

	return cb "Не указан файл источник" if not srcfile

	if typeof options is "function"
		cb = options
		options = null

	if typeof destfile is "function"
		cb = destfile
		destfile = null

	return "Не указана функция возврата (callback)" if not cb

	ext = srcfile.split(".").pop()
	switch ext
		when "pdf"
			cnv = new PdfType(srcfile, destfile)
		when "docx"
			cnv = new DocxType(srcfile, destfile)
		when "doc","odt","xls","xlsx","ods"
			cnv = new UnoconvType(srcfile, destfile)
		else
			return cb "Неподдерживаемый тип, или не указано расширение у файла."

	result = cnv.tune options
	return cb result if result

	fs.stat srcfile, (err, stat)->
		return cb err if err
		cnv.do cb

