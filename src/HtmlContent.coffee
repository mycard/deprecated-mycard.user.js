class HtmlContent
	block = ['div', 'p', 'article', 'section', '#text', 'table', 'tr', 'tbody', 'td']
	featureString = ['####', '====', '$$$$', null]
	domTree = breakPoint = null
	matchQueue = []


	# 遍历匹配DOM的子集块元素
	eachDom = (node, parentMatched, callback)->
		element = node.content
		unless element and element.childNodes.length
			# 没有子元素
			return callback off
		for item in element.childNodes
			continue if block.indexOf(item.nodeName.toLowerCase()) is -1
			domTree.setChild item, node
		breakPoint = node.parent
		eachMatch node.firstChild(), parentMatched, off, ()->
			callback on

	eachMatch = (node, parentMatched, brotherMatched, callback)->
		matchLastFeature node, (matched)->
			brotherMatched = on if matched
			if node.next is null
				if !brotherMatched and parentMatched
					# 这一层都没有但是父元素有的话,回朔寻找
					return searchBack node.parent, 1, callback
				return callback()
			eachMatch node.next, parentMatched, brotherMatched, callback

	# 寻找结束特征
	matchLastFeature = (node, callback)->
		feature =  featureString[featureString.length-2]
		element = node.content
		text = element.innerText or element.textContent
		if text.indexOf(feature) is -1
			# 不包含特征
			return callback off
		if node.content.childNodes and node.content.childNodes.length
			return eachDom node, on, (hasChild)->
				return callback on if hasChild
				searchBack node.parent, 1, ()->
					callback on
		searchBack node.parent, 0, ()->
			callback on

	# 向上回朔寻找开始特征
	searchBack = (node, layer, callback)->
		layer++
		if node.parent is null
			return callback()
		text = node.content.innerText or node.content.textContent
		if text.indexOf(featureString[0]) is -1
			if breakPoint and node is breakPoint
				callback()
			else
				searchBack node.parent, layer, callback
		else
			record node, layer, ()->
				callback()

	# 判断节点是不是要找的节点，若是则记录第一个匹配节点
	record = (node, layer, callback)->
		htmlNode = new HTMLNode node.content, layer
		htmlNode.parse ()->
			matchQueue.push htmlNode if htmlNode.isMatching
			callback()

	parse: (callback)=>
		window.domTree = domTree = new Tree document.body
		eachDom domTree.root, off, (res)->
			callback matchQueue
				
	constructor: ()->
		true