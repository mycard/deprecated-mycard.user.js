class CardDeck
	panelName = ['主卡组', '副卡组', '额外卡组', '临时卡组']
	render = (panel, position)->
		if position.left + 528 > document.documentElement.clientWidth
			position.left = if document.documentElement.clientWidth > 0 then (document.documentElement.clientWidth - 528) else 0
		# 构造容器
		container = $('<div></div>').css
			'position': 'absolute'
			'top': "#{position.top}px"
			'left': "#{position.left}px"
			'width': '518px'
			'background': '#FFFFFF'

		# 构造4个卡组
		for i in [0...4]
			console.log i
			continue unless panel[i] and panel[i].length
			fieldset = $('<fieldset></fieldset>').css
				'height': '295px'
				'background': '#F9F9F9'
				'border-radius': '6px'
				'color': '#666666'
				'font-size': '12px'
				'margin': '14px 0 0'
				'padding': '5px'
			legend = $("<legend>#{panelName[i]}<small>(#{panel[i].length})</small></legend>").css
				'color': '#666666'
				'font-size': '14px'
				'margin-left': '8px'
			console.log legend.html()
			legend.children('small').attr 'font-size', '10px'
			deckPart = $('<div></div>').attr
				'margin': '0 -3px 0 -3px'
			for card in panel[i]
				img = $('<img />').attr
					'width': '44'
					'height': '64'
					'src': card.thumb
				.css
					'float': 'left'
					'margin': '0 3px 8px 3px'
					'overflow': 'visible'
				deckPart.append img
			container.append fieldset.append(legend).append(deckPart)
		$('body').append container


	panel: []
	data: null
	build: (callback)=>
		return callback() unless @data.isMatching
		position = $(@data.startNode).position()
		for deck in @data.deck
			tmp = []
			for name in deck
				tmp.push Card.cardCache[name] if Card.cardCache[name]
			@panel.push tmp
		render @panel, position
	constructor: (data)->
		@data = data
