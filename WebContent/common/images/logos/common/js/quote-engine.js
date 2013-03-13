$(document).ready(function(){
	// PNG Fix for the obsolete trashpile that is IE6
	if ($.browser.msie && $.browser.version < 7) {
		$(document).pngFix();
	}
});

var slideIdx = 0;
function initQuoteEngineScreens(){
	$('#save-quote').hide();
	// Set up the Scrollable windows
	$('#qe-wrapper').scrollable({
		'items': '#qe-main',
		'item': '.qe-screen',
		'keyboard': false
	}).navigator();
	
	var api = $("#qe-wrapper").data("scrollable");
	
	// Just after click and just before scroll
	api.onBeforeSeek(function(elm, idx) {
		slideIdx=idx;
		if (idx == 0) {
			$('.prev').fadeOut("fast");
			$('.next').fadeIn("fast");
		} else if (idx >= 6) {
			$('.prev').fadeOut("fast");
			$('.next').fadeOut("fast");
		} else {
			$('.prev').fadeIn("fast");
			$('.next').fadeIn("fast");
		}
	});
	
	$(".prev").hide();
	
	$("#live-help").click(function(){
		api.next();
	});
	
}

function initFormElements()
{
	$('.text input, textarea').addClass('ui-widget ui-widget-content ui-corner-left ui-corner-right');
	//$('select').combobox();
	//$('select').selectbox();
	//$('.binary input').binaryoption();
}

function initInterimSliders()
{
	// CUSTOMISE RANGE VALUES HERE
	$('div.slider > div').slider({
		'max': 1,
		'min': -1
	});
}

// Results Page Basket
var Basket = new Object();
Basket = {
	prefix: 'basket-item-', // HTML prefix
	basketItems: [], // Internal item IDs
	
	create: function(container){
		this.container = (container || $('#basket'));
		
		var self = this;
		
		$('a.remove')
			.live('click', function() {
				self.removeItem($(this).closest('.item').attr('id'));
			});
	},
	
	addItem: function(identifier){
		if (!this.isFull() && !this.hasItem(identifier)) {
			this.basketItems.push(identifier);
			
			if ($(this.container).not(':visible')) {
				$(this.container).slideDown('fast');
			}
			
			// Now create the item and append it
			var item = this._createItem(identifier);
			$(this.container).find('.basket-items').append(item);
			
			// Animate the fakery
			var trigger = $('#' + identifier);
			var target  = $(this.container); // From above
			
			var mockItem = $('<div class="animation-mock-item">').appendTo('body').css({
				width: trigger.width(),
				height: trigger.height(),
				top: trigger.offset().top,
				left: trigger.offset().left,
				'z-index': 30
			});
			
			mockItem.animate({
				width: Math.max(target.width(),200),
				height: Math.max(target.height(),80),
				top: target.offset().top,
				left: target.offset().left,
				opacity: '0.20'
			}, 400, "easeInOutQuint", function() {
				$(item).slideDown("fast");
				$(this).remove();
			});
			
			// IE6,7 don't like the animate function, so never show the element
			// In this case, we are punishing ie8,9 as well
			if ($.browser.msie && !$(item).is(':visible')) {
				$(item).slideDown(400);
			}
			
			switch(this.basketItems.length){
			case 1:
				$(".compare-selected").hide();
				$(".compare-pick-one").hide();
				$(".compare-pick-two").slideDown(400);
				break;
			case 2:
				$(".compare-pick-two").slideUp(400);
				$(".compare-pick-one").slideDown(400);
				$(".compare-selected").slideDown(400);
				break; 
			case 3:
				$(".compare-pick-one").slideUp(400);
				break;
			}
			
			return true;
		}
		
		return false;
	},

	_createItem: function(identifier){
		var elm = $('#' + identifier);
		
		var item =
			'<div class="item" id="' + this.prefix + identifier + '" style="display:none;">' +
			'	<a href="javascript:void(0)" class="remove">Remove</a>' +
			'	<div class="thumb"><img src="' + elm.find('.thumb img').attr('src') + '" alt="" /></div>' +
			'	<div class="description"><h5>' + elm.find('h5').html() +
			'	</h5></div>' +
			'</div>';
		
		return $(item);
	},
	
	removeItem: function(identifier){
		// Clean the ID. We have 2 sources for it, so we need to ensure no prefix
		var _pre = new RegExp(this.prefix);
		var _identifier = identifier.replace(_pre, '');
		
		this.basketItems = $.map(this.basketItems, function(elm) {
			var _elm = elm.replace(_pre, '');
			
			if (_elm != _identifier) {
				return elm;
			}
		});
		
		// Fade out the box
		$('#' + this.prefix + _identifier).slideUp().fadeOut('normal', function() { $(this).remove(); });
		
		// Uncheck the compare button in the table
		$('#' + _identifier).find('a.compare').removeClass('compare-on');
		
		// Update the "compare" button
		switch(this.basketItems.length){
		case 1:
			$(".compare-selected").slideUp(400);
			$(".compare-pick-one").slideUp(400);
			$(".compare-pick-two").slideDown(400);
			break;
		case 2:
			$(".compare-pick-one").slideDown(400);
			break;			
		}
		
		if (this.isEmpty()) {
			$(this.container).slideUp(400);
		}
		
		return true;
	},
	
	clear: function(){
		while(this.basketItems.length > 0){
			this.removeItem(this.basketItems.pop());
		}
		$(this.container).hide();
	},
	
	isFull: function(){
		return (this.basketItems.length == 3);
	},
	
	isEmpty: function(){
		return (this.basketItems.length == 0);
	},
	
	hasItem: function(identifier){
		return (!!($.inArray(identifier, this.basketItems) > -1));
	}
};
var PageLog = new Object();
PageLog = {
		url : 'ajax/write/page_log.jsp' ,
		log: function(pageId, data){
			
			var qs="pageId="+encodeURI(pageId);
			if (data!= undefined){
				qs+="&pageData="+encodeURI(data);
			}
			$.ajax({
				url : this.url,
				data : qs
			});
		}
};
