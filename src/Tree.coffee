class Tree
	root: null

	setChild: (content, parentLeaf)=>
		parentLeaf ?= @root
		newLeaf = new Leaf content
		if parentLeaf.children.length
			brotherLeaf = parentLeaf.children[parentLeaf.children.length-1]
			brotherLeaf.next = newLeaf
			newLeaf.prev = brotherLeaf
		parentLeaf.children.push newLeaf
		newLeaf.parent = parentLeaf
		newLeaf

	constructor: (content)->
		@root = new Leaf content

class Leaf
	prev: null
	next: null
	parent: null
	children: []
	content: null
	firstChild: ()=>
		return false unless @children.length
		@children[0]
	constructor: (content)->
		@prev = @next =@parent = @content = null
		@children = []
		@content = content