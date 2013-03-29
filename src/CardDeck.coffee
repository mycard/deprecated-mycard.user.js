class CardDeck
	cardPart = 4

	bulidCallback = null

	# 数组降维
	tile = (array, result, callback)=>
		return callback result unless array.length
		item = array.shift()
		if typeof item is 'string'
			result.push item if item
			tile array, result, callback
		else
			tile item, result, (res)->
				tile array, res, callback

	# 卡组渲染
	render = ()=>
		console.log self.cards

	names: [] # 按顺序存放卡组中卡片名称的数组
	cards: [] # 按顺序存放卡片信息的数组

	build: (callback)=>
		bulidCallback = callback
		
		console.log @names

	constructor: (data)->
		@names = data
