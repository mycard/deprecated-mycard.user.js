class CardDeck
	panelNames = ['主卡组', '副卡组', '额外卡组', '临时卡组']
	infoNames = [['卡类', 'card_type'],
		['种族', 'type'],
		['属性', 'attribute'],
		['星阶', 'level'],
		['攻击', 'atk'],
		['守备', 'def']]
	siderNameBox = siderImageBox = siderDescriptionBox = null
	siderInfoFields = []
	cardChange = (img)->
		info = img.data 'info'
		siderNameBox.empty().append "<a href=\"#\" target=\"_blank\">#{info.name}</a>"
		siderImageBox.children('img').attr 'src', info.image
		for field in siderInfoFields
			type = field.attr 'card-title'
			field.html info[type]
		siderDescriptionBox.html info.description
	render = (panel, position)->
		if position.left + 828 > document.documentElement.clientWidth
			position.left = if document.documentElement.clientWidth > 0 then (document.documentElement.clientWidth - 828) else 0
		# 构造容器
		container = $('<div></div>').css
			'position': 'absolute'
			'top': "#{position.top}px"
			'left': "#{position.left}px"
			'width': '818px'
			'background': '#FFFFFF'
			'padding': '4px'
			'margin': '4px'
			'bordder': '2px solid #CCCCCC'
			'border-radius': '4px'
			'box-shadow': '0 0 4px #CCCCCC'

		# 构造边栏
		sider = $('<div></div>').css
			'float':  'right'
			'width': '300px'
			'position': 'relative'
		siderNameBox = $('<div></div>').css
			'width': '300px'
			'height': 'auto'
			'padding': '8px 0'
			'margin': 0
			'font-weight': 'bold'
			'text-shadow': '1px 1px 2px #ccc'
			'font-size': '24px'
			'text-align': 'center'
			'background': '#eee'
			'height': '29px'
		siderImageBox = $('<div><img src="http://my-card.in/assets/images/decks/card.jpg" width="130" height="187" /></div>').css
			'margin': '10px 0 0 10px'
			'height': 'auto'
			'width': 'auto'
			'float': 'left'
		siderInfoBox = $('<div></div>').css
			'width': '135px'
			'height': '180px'
			'padding': '15px 5px 5px 5px'
			'margin': '7px 0 0 10px'
			'float': 'left'
		siderInfoItemName = $('<div></div>').css
			'width': '60px'
			'height': '14px'
			'line-height': '14px'
			'padding-bottom': '5px'
			'margin-bottom': '10px'
			'color': '#ffad6e'
			'font-size': '12px'
			'text-shadow': '1px 1px 2px #eee'
			'border-bottom': '1px dashed #ccc'
			'float': 'left'
		siderInfoItemContent = $('<div class="mycard-info-item"></div>').css
			'width': '75px'
			'height': '14px'
			'padding-bottom': '5px'
			'margin-bottom': '10px'
			'font-size': '12px'
			'color': 'thead_bg#999999'
			'text-shadow': '1px 1px 2px #eee'
			'border-bottom': '1px dashed #ccc'
			'white-space': 'nowrap'
			'text-overflow': 'ellipsis'
			'overflow': 'hidden'
			'float': 'left'
		siderDescriptionBox = $('<div></div>').css
			'border-bottom': '1px solid #CCCCCC'
			'border-top': '1px solid #CCCCCC'
			'height': '370px'
			'margin': '15px 0 0'
			'padding': '10px'
			'width': '280px'
			'color': '#999999'
			'float': 'left'

		for info in infoNames 
			nameElement = siderInfoItemName.clone().html info[0]
			contentElement = siderInfoItemContent.clone().attr 'card-title', info[1]
			siderInfoFields.push contentElement
			siderInfoBox.append nameElement
			siderInfoBox.append contentElement
		sider.append siderNameBox
		sider.append siderImageBox
		sider.append siderInfoBox
		sider.append siderDescriptionBox

		# 构造4个卡组
		main = $('<div></div>').css
			'float':  'left'
			'position': 'relative'
		for i in [0...4]
			continue unless panel[i] and panel[i].length
			fieldset = $('<fieldset></fieldset>').css
				'width': '500px'
				'height': '295px'
				'background': '#F9F9F9'
				'border-radius': '6px'
				'color': '#666666'
				'font-size': '12px'
				'margin': '14px 0 0'
				'padding': '5px'
			legend = $("<legend>#{panelNames[i]}<small>(#{panel[i].length})</small></legend>").css
				'color': '#666666'
				'font-size': '14px'
				'margin-left': '8px'
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
				img.data 'info', card
				img.bind 'mouseenter', ()->
					cardChange $ this
			fieldset.append legend
			fieldset.append deckPart
			main.append fieldset
		container.append main
		container.append sider
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
