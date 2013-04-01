class HtmlContent
	block = ['div', 'p', 'article', 'section', '#text']
	featureString = ['####', '====', '$$$$', null]
	domTree = breakPoint = null
	matchQueue = []


	# 遍历匹配DOM的子集块元素
	eachDom = (node, callback)->
		element = node.content
		unless element and element.childNodes.length
			# 没有子元素
			return callback off
		for item in element.childNodes
			continue if block.indexOf(item.nodeName.toLowerCase()) is -1
			domTree.setChild item, node
		breakPoint = node
		eachMatch node.firstChild(), ()->
			callback on

	eachMatch = (node, callback)->
		matchLastFeature node, (_break)->
			return callback() if _break or node.next is null
			eachMatch node.next, callback

	# 寻找结束特征
	matchLastFeature = (node, callback)->
		feature =  featureString[featureString.length-2]
		element = node.content
		text = element.innerText or element.textContent
		if text.indexOf(feature) is -1
			# 不包含特征
			return searchBack node, 0, (_res)->
				callback _res
		if node.content.childNodes and node.content.childNodes.length
			eachDom node, (hasChild)->
				return callback off if hasChild

	# 向上回朔寻找开始特征
	searchBack = (node, layer, callback)->
		layer++
		node = node.parent
		if node.parent is null
			return callback off
		text = node.content.innerText or node.content.textContent
		if text.indexOf(featureString[0]) is -1
			if node is breakPoint
				callback off
			else
				searchBack node, layer, callback
		else
			record node, layer, ()->
				callback on

	# 判断节点是不是要找的节点，若是则记录第一个匹配节点
	record = (node, layer, callback)->
		console.log node.content
		htmlNode = new HTMLNode node.content, layer
		htmlNode.parse ()->
			matchQueue.push htmlNode if htmlNode.isMatching
			callback()

	parse: (callback)=>
		window.domTree = domTree = new Tree document.body
		eachDom domTree.root, (res)->
			callback matchQueue
				
	constructor: ()->
		true