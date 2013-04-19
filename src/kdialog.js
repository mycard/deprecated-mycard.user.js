var kDialog = function(o) {
	var option = o || {};
	var self = this;
	var container,overlay,panel = null;
	var divMaker = function(attribute, style, parentObj) {
		attribute = attribute || {};
		style = style || {};
		var obj = document.createElement('div');
		for (var key in attribute) {
			if (key == 'class') {
				obj.setAttribute('class', attribute[key]);
				obj.setAttribute('className', attribute[key]);	// 兼容IE
			} else {
				obj.setAttribute(key, attribute[key]);
			}
		}
		for (var key in style) {
			obj.style[key] = style[key];
		}
		if (!parentObj) {
			parentObj = document.body;
		}
		parentObj.appendChild(obj);
		return obj;
	}
	var getWidth	= function() {
		var width	= window.innerWidth;
		if (width == undefined) { // IE
			width	= document.documentElement.clientWidth;
		}
		return width;
	}
	var getHeight = function() {
		var height	= window.innerHeight;
		if (height == undefined) { //IE
			height	= document.documentElement.clientHeight;
			height	= ((window.screen.height - 100) < height) ? window.screen.height - 100 : height;
		}
		return height;
	}
	var bind = function bind(obj, action, func) {
		if (window.addEventListener) {
			obj.addEventListener( action, function(event) {
				func(obj, event);
			}, false);
		} else if (window.attachEvent) { //IE
			obj.attachEvent('on' +action, function(event) {
				func(obj, event);
			});
		}
	}
	var unbind = function(obj, action, func) {
		if (window.removeEventListener) {
			obj.removeEventListener(action, func , false);
		} else if (window.detachEvent) { //IE
			obj.detachEvent(action, func);
		}
	}
	self.isOpen = false;
	self.miniWin = false;
	self.open = function() {
		var left, top, close, shadow;
		if (self.isOpen) return;
		self.isOpen = true;
		option.width	= (option.width + 16) || 400;
		option.height	= (option.height + 16) || 280;
		option.title	= option.title || '';
		left = (getWidth() - option.width) / 2;
		if (left < 0) left = 0;
		left += 'px';
		top = (getHeight() - option.height) / 2;
		if (top < 0) top = 0;
		top += 'px';
		if (option.hasOverlay) {
			overlay = divMaker({}, {
				'width':'100%',
				'height':'100%',
				'top':0, 
				'left': 0,
				'position': 'fixed',
				'background-color':'#CCC',
				'z-index':'1000',
				'opacity':'0.3',
				'filter': 'alpha(opacity=30)'
			});
		}
		container = divMaker({}, {
			'width':(option.width+'px'),
			'height':(option.height+'px'),
			'left':left,
			'top':top,
			'position':'absolute',
			'z-index':'1001'
		});
		shadow	= divMaker({},{
			'position':'absolute',
			'z-index':'1001',
			'width':'100%',
			'height':'100%',
			'background-color':'#333',
			'opacity':'0.3',
			'filter':'alpha(opacity=30)'
		},container);
		close	= divMaker({},{
			'position':'absolute',
			'z-index':'1003',
			'width':'30px',
			'height':'30px',
			'top':'10px',
			'right':'0',
			'cursor':'pointer',
			'font-size': '18px'
		},container);
		close.innerHTML = 'x';
		panel	= divMaker({}, {
			'width':(option.width-16+'px'),
			'height':(option.height-16+'px'),
			'left':'8px',
			'top':'8px',
			'position':'absolute',
			'z-index':'1002',
			'background':'#fff'
		}, container);
		if (option.url) {
			var ifm	= document.createElement('iframe');
			ifm.src	= option.url;
			ifm.style.width		= '100%';
			ifm.style.height	= '100%';
			ifm.frameBorder		= 0;
			panel.appendChild(ifm);
		} else if (option.html) {
			var s = new Array();
			panel.innerHTML = option.html.replace(/<script[^>]+>([\s\S]+?)<\/script>/ig,function($1,$2){
				s.push($2);
				return '';
			});
			for (var i=0,l=s.length; i<l; i++) {
				window[ "eval" ].call( window, s[i] );
			}
		} else if(option.text) {
			panel.innerHTML = '<p style="line-height: '+(option.height-26)+'px; text-align:center;">'+option.text+'</p>';
		}
		bind(close, 'click', self.close);
		self.panel = panel
	} 
	self.close = function() {
		if (!self.isOpen) return;
		self.isOpen = false;
		if (overlay) {
			overlay.parentNode.removeChild(overlay);
		}
		if (container) {
			container.parentNode.removeChild(container);
		}
	}
	self.resize = function(newWidth, newHeight) {
		if (newWidth && newWidth > 0) {
			container.style.width = newWidth + 16 + 'px';
			panel.style.width = newWidth + 'px';
		}
		if (newHeight && newHeight > 0) {
			container.style.height = newHeight + 16 + 'px';
			panel.style.height = newHeight + 'px';
		}
	}
}