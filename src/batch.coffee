# Name批量转换为Card的接口
Batch = (names, callback)->
	apiUrl = 'http://my-card.in/cards_zh'
	# 数组降维
	tile = (array, result, _callback)=>
		return _callback result unless array.length
		item = array.shift()
		if typeof item is 'string'
			result.push item if item
			tile array, result, _callback
		else
			tile item, result, (res)->
				tile array, res, _callback

	return unless names.length


	tile names, [], (names)->
		names.splice i, 1 unless names[i] for i in [0...names.length]
		data = JSON.stringify "name":
			"$in": names

		$.getJSON apiUrl,
			q: data
		, (res)->
			for info in res
				cardCache[info.name] = info
			console.log cardCache
			callback()