class Card

	types = ['warrior', 'spellcaster', 'fairy', 'fiend', 'zombie', 'machine', 'aqua', 'pyro', 'rock', 'winged_beast', 'plant', 'insect', 'thunder', 'dragon', 'beast', 'beast_warrior', 'dinosaur', 'fish' , 'sea_serpent', 'reptile', 'psychic', 'divine_beast', 'creator_god']
	_attributes = ['earth', 'water', 'fire', 'wind', 'light', 'dark', 'divine']
	categories = ['monster', 'spell', 'trap']
	card_types = [null, null, null, null, 'normal', 'effect', 'fusion', 'ritual', null, 'spirit', 'union', 'gemini','tuner', 'synchro', null, null, 'quick_play', 'continuous', 'equip', 'field', 'counter', 'flip', 'toon', 'xyz']
	thumbImagePath = 'http://images.my-card.in/thumbnail/';
	imagePath = 'http://images.my-card.in/';
	imageExt = '.jpg'

	@cardCache = {}
	# 批量获得卡片信息
	@batchQueryInfo = (names, callback)=>
		apiUrl = 'http://my-card.in/cards_zh'
		if typeof names is 'object' and names.length > 0
			# 过滤重复项
			names.splice i, 1 unless names[i] for i in [0...names.length]
			data = JSON.stringify "name":
				"$in": names

			$.getJSON apiUrl,
				q: data
			, (res)=>
				data = {}
				for info in res
					data[info.name] = info
				@batchQueryAttr data, callback

	# 批量获得卡片属性
	@batchQueryAttr = (cards, callback)->
		apiUrl = 'http://my-card.in/cards'
		ids = []
		nameIndex = {}
		$.each cards, (i, card)->
			return true unless card._id and card.name
			id = parseInt card._id, 10
			nameIndex[id] = card.name
			ids.push id if id > 0
		data = JSON.stringify "_id":
				"$in": ids
		$.getJSON apiUrl,
			l: ids.length
			q: data
		, (res)=>
			for info in res
				name = nameIndex[info._id]
				card = cards[name]
				@cardCache[name] = new Card card, info
			callback()

	id: null
	alias: null
	name: null
	category: null
	card_type: null
	type: null
	attribute: null
	level: null
	atk: null
	def: null
	description: null
	@image
	@thumb
	constructor: (card, info)->
		i=0
		while info.type
			if info.type & 1
				card_type = card_types[i] if card_types[i]
				category = categories[i] if categories[i]
			info.type >>= 1
			i++

		@id = info._id
		@alias = info.alias
		@name = card.name
		@category = category
		@card_type = card_type
		@type = (i = 0; (i++ until info.race >> i & 1); types[i]) if info.race
		@attribute = (i = 0; (i++ until info.attribute >> i & 1); _attributes[i]) if info.attribute
		@level = info.level if info.attribute
		@atk = info.atk if info.attribute
		@def = info.def if info.attribute
		@description = card.desc
		@image = imagePath + @id + imageExt
		@thumb = thumbImagePath + @id + imageExt