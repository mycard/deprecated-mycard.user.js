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

	getDeckName =->
		title = $('title').text()
		split = /[,\.\-_\s]/
		title.substr 0, title.indexOf title.match split
	getCardUsage = (data)->
		encodeKey = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_='
		result = ''
		prev_card = null
		count = 0
		for panel_index in [0...3]
			for card in data[panel_index]
				if card is prev_card
					count++
					continue
				card_usage =
					card_id: card.id
					side: panel_index is 1
					count: count
				count = 0
				prev_card = card
				c = card_usage.side << 29 | card_usage.count << 27 | card_usage.card_id
				result += encodeKey.charAt((c >> i * 6) & 0x3F) for i in [4..0]
		result

	render = (panel, position, deckName, cardUsage, callback)->
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
		# 卡组编辑器链接
		operaNewTab = $('<a></a>').css(Style.operaIco).css('background', 'none')
		$('<img />').appendTo(operaNewTab).attr
			src: 'http://my-card.in/assets/images/decks/search.png'
			alt: '' 
			width: '24'
		operaNewTab.attr
			href: "https://my-card.in/decks?name=#{deckName}&cards=#{cardUsage}"
			title: '在卡组编辑器中打开'
			target: '_blank'
		# 下载(ygopro格式)
		operaDownYdk = $('<a></a>').css(Style.operaIco).css('background', 'none')
		$('<img />').appendTo(operaDownYdk).attr
			src: 'http://my-card.in/assets/images/decks/download_ydk.png'
			alt: 'download ygopro格式'
			width: '24'
		operaDownYdk.attr
			href: "https://my-card.in/decks/new.ydk?name=#{deckName}&cards=#{cardUsage}"
			title: '下载(ygopro格式)'
			target: '_blank'
		# 下载(ocgsoft格式)
		operaDownDeck = $('<a></a>').css(Style.operaIco).css('background', 'none')
		$('<img />').appendTo(operaDownDeck).attr
			src: 'http://my-card.in/assets/images/decks/download_deck.png'
			alt: 'download ocgsoft'
			width: '24'
		operaDownDeck.attr
			href: "https://my-card.in/decks.deck?name=#{deckName}&cards=#{cardUsage}"
			title: '下载(ocgsoft格式)'
			target: '_blank'
		# 在ygopro中打开
		operaYgopro = $('<a></a>').css(Style.operaIco).css('background', 'none')
		$('<img />').appendTo(operaYgopro).attr
			src: 'http://my-card.in/assets/images/decks/ygopro.png'
			alt: ''
			width: '24'
		operaYgopro.attr
			href: "mycard://my-card.in/decks.ydk?name=#{deckName}&cards=#{cardUsage}"
			title: '在ygopro中打开 (需要安装mycard)'
			target: '_blank'
		# 分享
		operaShare = $('<a title="分享" href="javascript:;"></a>').css(Style.operaIco).css('background', 'none')
		$('<img />').appendTo(operaShare).attr
			src: 'http://my-card.in/assets/images/decks/share.png'
			alt: ''
			width: '24'
		operaShare.bind 'click', ()->
			return false if dialog.isOpen
			dialog.open()
			renderDialog $(dialog.panel), deckName, cardUsage

		# 这是什么
		operaWhatsThis = $('<a>?</a>').css(Style.operaIco).attr
			'href': 'http://my-card.in/mycard/mycard.user.js.html'
			'target': '_blank'

		operaPanel.append operaNewTab
		operaPanel.append operaDownYdk
		operaPanel.append operaDownDeck
		operaPanel.append operaYgopro
		operaPanel.append operaShare
		operaPanel.append operaWhatsThis
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
				img = $("<img />")
				img.attr
					width: '44'
					height: '64'
					src: card.thumb
					alt: card.name
					title: ''
				img.css Style.cardImage
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

	renderDialog = (panel, deckName, cardUsage)->
		title = $('<div>share</div>').css Style.shareTitle
		body = $('<div></div>').css Style.shareBody
		left = $('<div></div>').css Style.shareLeft
		right = $('<div></div>').css Style.shareRight

		urlFieldset = $('<fieldset></fieldset>').css Style.shareFieldset
		urlLegend = $('<legend align="center">URL</legend>').css 'padding-top', '3px'
		urlInput = $('<input />').attr
			'type': 'text'
			'readonly': '1'
		urlShortBtn = $('<button>获取短地址</button>')
		urlInfo = $('<p>复制地址发送给你的好友</p>')

		shareFieldset = $('<fieldset></fieldset>').css Style.shareFieldset
		shareLegend = $('<legend align="center">share</legend>').css 'padding-top', '3px'
		addThisPanel = $('<div class="ddthis_toolbox addthis_default_style addthis_32x32_style"></div>').attr
			'addthis:url': "https://my-card.in/decks?name=#{deckName}&cards=#{cardUsage}"
		for i in ['preferred_1', 'preferred_2', 'preferred_3', 'preferred_4', 'compact']
			btn = $('<a></a>').addClass "addthis_button_#{i}"
			addThisPanel.append btn
		addThisPanel.append $ '<a class="addthis_counter addthis_bubble_style"></a>'
		urlFieldset.append urlLegend
		urlFieldset.append urlInput
		urlFieldset.append urlShortBtn
		urlFieldset.append urlInfo
		shareFieldset.append shareLegend
		shareFieldset.append addThisPanel
		left.append urlFieldset
		left.append shareFieldset

		QRFieldset = $('<fieldset></fieldset>').css Style.shareFieldset
		QRLegend = $('<legend align="center">QR Code</legend>').css 'padding-top', '3px'
		QRImage = $('<img />').attr 'src', 'https://chart.googleapis.com/chart?chs=171x171&cht=qr&chld=|0&chl=' + encodeURIComponent("https://my-card.in/decks?name=#{deckName}&cards=#{cardUsage}")
		QRFieldset.append QRLegend
		QRFieldset.append QRImage
		right.append QRFieldset

		body.append left
		body.append right

		panel.append title
		panel.append body

		if typeof addthis is 'undefined'
			$.getScript 'http://s7.addthis.com/js/300/addthis_widget.js#pubid=ra-504b398d148616ce&async=1', ()->
				addthis.init()
		else
			addthis.init()

	panel: []	# 4个卡区的数据
	data: null
	build: (callback)=>
		return callback() unless @data.isMatching
		position = $(@data.startNode).position()
		for deck in @data.deck
			tmp = []
			for name in deck
				tmp.push Card.cardCache[name] if Card.cardCache[name]
			@panel.push tmp
		render @panel, position, getDeckName(), getCardUsage(@panel), (containerHeight)=>
			@data.startNode.before $("<div style=\"height:#{containerHeight}px;\"></div>")

	constructor: (data)->
		@data = data
