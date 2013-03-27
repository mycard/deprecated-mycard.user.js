class Card
	###
	# API format
	# name:
	#	$in : nameArray
	###
	name: null
	info: null
	getInfo: (callback)=>
		@init callback
	init: (callback)=>
		callback @name
	constructor: (name)->
		@name = name