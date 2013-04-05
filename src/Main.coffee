$ = null
unless console
	console =
		log: ()->
		info: ()->

class Main
	jQueryPath = 'http://lib.sinaapp.com/js/jquery/1.9.1/jquery-1.9.1.min.js'
	load = (path, callback)->
		scriptElement = document.createElement 'script'
		scriptElement.type = 'text/javascript'
		scriptElement.src = path
		scriptElement.onload =->
			callback()
		document.body.appendChild scriptElement		

	start: ()=>
		$ = jQuery
		parse =->
			htmlContent = new HtmlContent()
			htmlContent.parse (cardQueue)->
				Card.batchQueryInfo HTMLNode.names, ()->
					handle cardQueue
		handle = (cardQueue)->
			if typeof cardQueue is 'object' and cardQueue.length > 0
				build cardQueue.shift(), ()->
					handle cardQueue
		build = (data, callback)->
			cardDeck = new CardDeck data
			cardDeck.build callback
		$ ()->
			parse()

	constructor: ()->
		if typeof jQuery isnt 'undefined'
			@start()
		else
			load jQueryPath, ()=>
				start = ()=>
					jQuery.noConflict()
					@start()
				return start() if typeof jQuery isnt 'undefined'
				p = setInterval ()=>
					if typeof jQuery isnt 'undefined'
						start()
						clearInterval p

this.myCardUserJS ?= new Main()