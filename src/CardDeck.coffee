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

	loadImageError = (img)->


	render = (panel, position, callback)->
		clientWidth = document.documentElement.clientWidth
		if position.left + 828 > clientWidth
			position.left = if clientWidth > 0 then (clientWidth - 828) else 0
		# 构造容器
		container = $('<div></div>').css Style.container
		container.css
			'top': "#{position.top}px"
			'left': "#{position.left}px"

		# 构造边栏
		sider = $('<div></div>').css Style.sider
		siderNameBox = $('<div></div>').css Style.siderNameBox
		siderImageBox = $('<div><img src="http://my-card.in/assets/images/decks/card.jpg" width="130" height="187" /></div>').css Style.siderImageBox
		siderInfoBox = $('<div></div>').css Style.siderInfoBox
		siderInfoItemName = $('<div></div>').css Style.siderInfoItemName
		siderInfoItemContent = $('<div class="mycard-info-item"></div>').css Style.siderInfoItemContent
		siderDescriptionBox = $('<div></div>').css Style.siderDescriptionBox

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

		# 构造主体
		main = $('<div></div>').css Style.main

		# 构造操作栏
		operaPanel = $('<div></div>').css Style.operaPanel
		# 这是什么
		operaWhatsThis = $('<a>?</a>').css(Style.operaIco).attr
			'href': 'http://my-card.in/mycard/mycard.user.js.html'
			'target': '_blank'
		# 分享
		operaShare = $('<a></a>').css(Style.operaIco).css('background': 'none')
		operaShare.append $ '<img src="http://my-card.in/assets/images/decks/share.png" alt="" title="分享" width="24" />'
		# 在ygopro中打开
		operaYgopro = $('<a></a>').css(Style.operaIco).css('background': 'none')
		operaYgopro.append $ '<img class="mycard_ope" src="http://my-card.in/assets/images/decks/ygopro.png" alt="" title="在ygopro中打开 (需要安装mycard)" width="24" />'
		# 下载(ocgsoft格式)
		# 下载(ygopro格式)
		# 卡组编辑器链接

		main.append operaPanel

		# 构造卡组区
		for i in [0...panelNames.length]
			continue unless panel[i] and panel[i].length
			fieldset = $('<fieldset></fieldset>').css Style.fieldset
			legend = $("<legend>#{panelNames[i]}<small>(#{panel[i].length})</small></legend>").css Style.legend
			legend.children('small').css 'font-size', '10px'
			deckPart = $('<div></div>').css
				'margin': '0 -3px 0 -3px'
			for card in panel[i]
				img = $("<img width=\"44\" height=\"64\" src=\"#{card.thumb}test\" alt=\"#{card.name}\" />").css Style.cardImage
				url = "http://my-card.in/cards/#{card.name}"
				$("<a title=\"#{card.name}\" href=\"#{url}\" target=\"_blank\"></a>").append(img).appendTo deckPart
				img.data 'info', card
				img.bind 'mouseenter', ()->
					cardChange $ this
				img.bind 'error', ()->
					loadImageError this
			fieldset.append legend
			fieldset.append deckPart
			main.append fieldset
		container.append main
		container.append sider
		$('body').append container
		callback container.height()

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
		render @panel, position, (containerHeight)=>
			@data.startNode.before $("<div style=\"height:#{containerHeight}px;\"></div>")

	constructor: (data)->
		@data = data
