lang = {}
(->
	type = attribute = card_type = {}
	type.aqua = '水族'
	type.beast = '兽族'
	type.beast_warrior = '兽战士族'
	type.creator_god = '创造神族'
	type.dinosaur = '恐龙族'
	type.divine_beast = '幻神兽族'
	type.dragon = '龙族'
	type.fairy = '天使族'
	type.fiend = '恶魔族'
	type.fish = '鱼族'
	type.insect = '昆虫族'
	type.machine = '机械族'
	type.plant = '植物族'
	type.psychic = '念动力族'
	type.pyro = '炎族'
	type.reptile = '爬虫族'
	type.rock = '岩石族'
	type.sea_serpent = '海龙族'
	type.spellcaster = '魔法使族'
	type.thunder = '雷族'
	type.warrior = '战士族'
	type.winged_beast = '鸟兽族'
	type.zombie = '不死族'

	attribute.dark = '暗'
	attribute.divine = '神'
	attribute.earth = '地'
	attribute.fire = '炎'
	attribute.light = '光'
	attribute.water = '水'
	attribute.wind = '风'

	card_type.normal = '通常'
	card_type.effect = '效果'
	card_type.fusion = '融合'
	card_type.ritual = '仪式'
	card_type.spirit = '灵魂'
	card_type.union = '同盟'
	card_type.gemini = '二重'
	card_type.tuner = '调整'
	card_type.synchro = '同调'
	card_type.quick_play = '速攻'
	card_type.continuous = '永续'
	card_type.equip = '装备'
	card_type.field = '场地'
	card_type.counter = '反击'
	card_type.flip = '反转'
	card_type.toon = '卡通'
	card_type.xyz = '超量'

	lang.type = type
	lang.attribute = attribute
	lang.card_type = card_type
)()

lang.get = (type, value)->
	return '' unless type and value
	if this[type] and this[type][value]
		return this[type][value]
	return ''