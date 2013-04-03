class HTMLNode
	self = null
	@names = []

	block = ['div', 'p', 'article', 'section', '#text']
	featureString = ['####', '====', '$$$$', null]

	nodeText: null
	container: null
	startNode: null
	deck: []
	layer: 0 # 容器到内容的层数
	isMatching: false # 是否符合规则
	cards: []

	collectionToArray = (collection)->
		arr = []
		arr.push i for i in collection
		arr

	findStart = (element, layer, callback)->
		# 单层模式的开始元素就是其容器
		return callback element if layer is 0
		nodeArray = [element]

		for i in [0...layer]
			tmpArray = []
			for item in nodeArray
				for child in item.childNodes
					continue if block.indexOf(child.nodeName.toLowerCase()) is -1
					tmpArray.push child
			nodeArray = tmpArray

		startNode = null
		console.log nodeArray
		for item in nodeArray
			text = item.innerText or item.textContent
			text = text.trim()
			break if text.indexOf('####') > -1
			continue unless text
			if text.indexOf('##') > -1
				startNode = item if startNode is null
			else
				startNode = null
		throw 'no match start node' if startNode is null
		if startNode.nodeName.toLowerCase() is '#text'
			startNode = $('<m></m>').insertBefore startNode
		callback startNode

	# 按分隔符匹配节点文本并返回分隔符之间的文本
	filter = (nodeText, callback)->
		res = []
		start = end = 0
		for feature in featureString
			if feature
				end = nodeText.indexOf feature
			else
				end = nodeText.length
			throw 'feature not match' if end is -1
			text = nodeText.substr start, end - start
			start = end
			start += feature.length if typeof feature is 'string'
			res.push text
		callback res

	# 递归匹配卡区
	matchDeck = (input, output, callback)->
		return callback output if input.length is 0
		items = input.shift().split '##'
		fromFront = input.length is 0 # 最后一项时从前开始匹配
		tmp = []
		for item in items
			item = item.trim()
			continue unless item
			r = matchItem item, fromFront
			if fromFront
				break unless r
				tmp.push r
			else
				if r
					tmp.push r
				else
					tmp = []
		self.cards = self.cards.concat tmp
		output.push tmp
		matchDeck input, output, callback

	matchItem = (item, fromFront)->
		reg = if fromFront then /^\[(.*)\]/ else /\[(.*)\]$/
		m = reg.exec item.trim()
		return if m then m[1] else off

	setNams = (names)=>
		for name in names
			@names.push name if @names.indexOf(name) is -1

	parse: (callback)=>
		nodeText = @container.innerText or @container.textContent
		try
			filter nodeText, (deck)=>
				findStart @container, @layer, (start)=>
					@startNode = start
					window.kaze = @startNode
					matchDeck deck, [], (deck)=>
						@deck = deck
						@isMatching = on
						setNams @cards
						callback()
		catch e
			console.log e
			callback()

	constructor: (node, layer)->
		self = this
		@container = node
		@layer = layer