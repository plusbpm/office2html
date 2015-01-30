stack = []

busy = null

module.exports =
	setNext: (obj, cb)->
		stack.unshift {class:obj, cbk: cb}
		setTimeout module.exports.makeNext, 50
	makeNext: ()->
		return if busy or stack.length is 0
		busy = true
		next = stack.pop()
		next.class.make (err)->
			busy = null
			next.cbk err
			module.exports.makeNext()
			return
