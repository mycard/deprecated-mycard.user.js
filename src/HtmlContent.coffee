class HtmlContent
	self = this
	content = ''
	contentArray = []	# split by '$$$$'
	contentArrayLength = 0
	queue = []
	parseCallback = null

	###
	# 内容抓取
	#
	# 按 #*4分割(从开始到#*4)
	# 找到第一个##行
	# 判断是否为[*]
	# 同理====以及剩余部分(到$$$$前）
	# 分析下一个part的开头是否为[*]
	###
	drag = (startLine)->
		result = []

		text = contentArray[startLine]
		rule = [null, '####', '====', null]
		index = 0
		handles = []
		
		recursion = ()->
			if index < rule.length - 1
				filter text, rule[index], rule[index+1], off, (_res)->
					result.push _res
					index++
					recursion()
			else
				# 最后一部分的特殊处理
				filter contentArray[startLine+1], null, null, on, (_res)->
					result.push _res
					dragOnceOver startLine, result
		recursion()

	# 筛选字符串组
	filter = (text, startDelimiter, endDelimiter, fromFront, callback)->
		matchLine = (line, fromFront)->
			reg = if fromFront then /^\[(.*)\]/ else /\[(.*)\]$/
			m = reg.exec line.trim()
			return if m then m[1] else off

		text = text.trim() if typeof text is 'string'
		return callback '' unless text

		start = if startDelimiter then (text.indexOf(startDelimiter) + startDelimiter.length) else 0
		end = if endDelimiter then text.indexOf(endDelimiter) else text.length
		text = text.substr start, end - start
		return callback '' unless text

		data = text.split '##'
		result = []
		# 匹配前部
		if fromFront
			for line in data
				line = line.trim()
				continue unless line
				_r = matchLine line, on
				break unless _r
				result.push _r
			return callback result
		# 匹配后部
		for line in data
			line = line.trim()
			continue unless line
			_r = matchLine line
			if _r
				result.push _r
			else
				result = []
		callback result

	# 获得干净的数据
	refine = ()->
		console.log queue
		parseCallback queue

	dragOnceOver = (startLine, result)->
		startLine += 1
		queue.push result if result and result[0]
		return drag startLine if startLine < contentArrayLength
		refine() # All over


	parse: (callback)=>
		return callback off if contentArrayLength is 0
		parseCallback = callback
		###
		# drag -> dragOnceOver -> drag -> ... -> refine -> callback
		###
		drag 0
	constructor: ()->
		content = document.body.innerText or document.body.textContent	# TODO: 不考虑textarea和script中?
		content = content.replace /[\r\n]/g, ''
		contentArray = content.split '$$$$'
		contentArrayLength = contentArray.length