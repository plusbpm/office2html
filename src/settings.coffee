path = require "path"

support_ext =
	pdf: ["pdf"]
	docx: ["docx"]
	unoconv: ["doc","odt","xls","xlsx","ods","ppt","pptx"]

all_ext = []
for k,v of support_ext
	all_ext = all_ext.concat v

module.exports =
	pdf:
		default: ['--zoom','1.33']
		ipad: ['--fit-width','968']
	docx: {}
	unoconv: {}
	tmp_dir: "/tmp"

	saveNamedOptions: (type, name, opts)->
		return "Указаный тип источника не предусмотрен (pdf,docx,unoconv)" if not type or not module.exports[type]?
		return "Не указано имя" if not name

		if opts
			return "Опции должны быть массивом строк" if not Array.isArray(opts)
			module.exports[type][name] = opts
		else
			delete module.exports[type][name]
	setTempDir: (dir)-> module.exports.tmp_dir = path.normalize dir

	support: (ext)-> ext in all_ext
