dialog = null
class Main
	load = (path, callback)->
		scriptElement = document.createElement 'script'
		scriptElement.type = 'text/javascript'
		scriptElement.src = path
		scriptElement.onload =->
			callback()
		document.body.appendChild scriptElement		

	start: ()=>
		dialog = new kDialog
			hasOverlay: on
			width: 560
			height: 280
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
			unless window.console
				# for IE
				window.console =
					log: ()->
					info: ()->
			parse()

	constructor: ()->
		p = setInterval ()=>
			if jQuery
				@start()
				clearInterval p
		, 10

this.myCardUserJS ?= new Main()