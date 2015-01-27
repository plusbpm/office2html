module.exports =
	pdf:
		default: ['--zoom','1.33']
		ipad: ['--fit-width','968']
	docx: {}
	unoconv: {}

	saveNamedOptions: (type, name, opts)->
		return "Указаный тип источника не предусмотрен (pdf,docx,unoconv)" if not type or not module.exports[type]?
		return "Не указано имя" if not name

		if opts
			return "Опции должны быть массивом строк" if not Array.isArray(opts)
			module.exports[type][name] = opts
		else
			delete module.exports[type][name]

