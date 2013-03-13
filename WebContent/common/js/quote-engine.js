$(document).ready(function(){
	// PNG Fix for the obsolete trashpile that is IE6
	if ($.browser.msie && $.browser.version < 7) {
		$(document).pngFix();
	}
});

QuoteEngine=new Object();
QuoteEngine={
		
	_options: {},
	
	_init : function( options ){
		
		QuoteEngine._options = $.extend({
			currentSlide:	0,
			prevSlide:		-1,
			animating:		false,
			nav:			true,
			lastSlide:		5,
			speed:			"fast",
			noAnimation:	false
		}, options);
		
		$('#save-quote').hide();
		
		// Set up the Scrollable windows
		$('#qe-wrapper').scrollable({
			'items': '#qe-main',
			'item': '.qe-screen',
			'keyboard': false
		}).navigator();
		
		slide_callbacks.call( 'after', 0, -1 );
		
		this._options.nav = $("#qe-wrapper").data("scrollable");
		if (this._options.nav){
			// Just after click and just before scroll
			this._options.nav.onBeforeSeek(function(elm, idx) {
				QuoteEngine._options.animating=true;
				
				QuoteEngine._options.prevSlide = QuoteEngine._options.currentSlide;
				QuoteEngine._options.currentSlide=idx;
				
				slide_callbacks.call( 'before', idx, QuoteEngine._options.prevSlide ? QuoteEngine._options.prevSlide : 0 );
				
				if( QuoteEngine._options.noAnimation ) {
					$('#slide'+QuoteEngine._options.prevSlide).css( { 'max-height':'300px' });
					$('#slide'+QuoteEngine._options.currentSlide).css( { 'max-height':'5000px' });
				} else {
					$('#slide'+QuoteEngine._options.prevSlide).animate( { 'max-height':'300px' }, 750 );
					$('#slide'+QuoteEngine._options.currentSlide).animate( { 'max-height':'5000px' }, 750 );
				}
				if (idx == 0) {
					$('.prev').fadeOut("fast");
				} else {
					$('.prev').fadeIn("fast");
				}
			});
			this._options.nav.onSeek(function(elm, idx) {
				QuoteEngine.updateAddress(idx);
				QuoteEngine.ProgressBarUpdate(idx);
				
				Track.nextClicked(idx);
				
				if (idx==QuoteEngine._options.lastSlide){
					if (typeof Captcha !== 'undefined' && $("#captcha_code").val()!=""){
						Captcha.reload();
					}
				}
				if (QuoteEngine._options.prevSlide > -1) {
					$('body').removeClass('stage-'+QuoteEngine._options.prevSlide);
				}
				$('body').addClass('stage-'+QuoteEngine._options.currentSlide);
				
				QuoteEngine._options.animating=false;
				
				slide_callbacks.call( 'after', idx, QuoteEngine._options.prevSlide ? QuoteEngine._options.prevSlide : 0 );
			});
		}
		$(".prev").hide();
		
		$("#live-help").click(function(){
			this._options.nav.next();
		});
		
		/* //REFINE: this requires a more dynamic function that does not need specific verticals or ID types added */
		
		// This prevents the slide from breaking when the user tabs from the last field on the slide to the new field on the next slide
		carIds = ["#car_accessories :input", "#quote_vehicle_parking", "#driver_ncdpro :input", "#quote_drivers_regular_ncd", "#quote_options_driverOption", "#oktocall :input", "#fsg :input"];
		healthIds = ["#health_situation_healthSitu", "#health_benefits_benefitsExtras_LifestyleProducts", "#health_healthCover_health_cover_rebate :input", "#health_healthCover_income"];
		utilitiesIds = ["#utilities_resultsDisplayed_email", "#utilities_application_thingsToKnow_providerTermsAndConditions"];
		
		lastElementsIds = [];
		$.merge(lastElementsIds, carIds);
		$.merge(lastElementsIds, healthIds);
		$.merge(lastElementsIds, utilitiesIds);
		
		/* Prevent tabbing through form fields which causing slide
		 * content to offset in a really aweful way */
		$(lastElementsIds.join(',')).live('keydown', function(e) { 
		    var key = e.charCode ? e.charCode : e.keyCode;
		    if(key==9){
		       return false;
		    }
		    return true;
		});
		
		$('.text input, textarea').addClass('ui-widget ui-widget-content ui-corner-left ui-corner-right');		
		
		this._options.lastSlide = $('#qe-main .qe-screen').length-1;
	},
	nextSlide: function(callback){
		if (callback){
			this._nextCallback=callback;
			return;
		} else if (this._options.animating){
			return;
		}
		var ok=true;
		if (this._nextCallback){
			ok = this._nextCallback(this._options.currentSlide);
		}
		if (ok){
			if (this._options.currentSlide < this._options.lastSlide) {
				this._options.nav.next( QuoteEngine._options.noAnimation ? 1 : QuoteEngine._options.speed );
				this.scrollTo('html');
			} else {
				QuoteEngine.completed();
			}
		}
	},
	prevSlide: function(callback){
		if (callback){
			this._prevCallback=callback;
			return;
		} else if (this._options.animating){
			return;
		}
		
		var ok=true;
		if (this._prevCallback){
			ok = this._prevCallback(this._options.currentSlide);
		}
		if (ok){		
			if (this._options.currentSlide > 0) {
				this._options.nav.prev( QuoteEngine._options.noAnimation ? 1 : QuoteEngine._options.speed );
				this.scrollTo('html');
			}
		}
	},
	gotoSlide: function(options){
		
		options = $.extend({
			index:			0,
			speed:			QuoteEngine._options.speed,
			callback:		false,
			noAnimation:	QuoteEngine._options.noAnimation
		}, options);
		
		if (this._options.animating){
			return;
		}
		
		if(options.index < 0 || options.index > this._options.lastSlide) {
			return;
		}
		
		this._options.nav.seekTo(options.index, options.speed, options.callback);
	},
	updateAddress:function(stage){
		if (!stage){ 
			$.address.parameter("stage", stage+1, false );
		} else {
			$.address.parameter("stage", stage, false );
		}
	},
	getCurrentSlide:function(){
		return this._options.currentSlide;
	},
	ProgressBarUpdate:function(idx){
		var _count = 0;		
		$('#steps').find('li').each( function(){
			if( _count == idx) {
				$(this).removeClass('complete').addClass('current');
			} else if( _count < idx ){
				$(this).removeClass('current').addClass('complete');				
			} else {
				$(this).removeClass('complete current');
			};
			_count++;
		});
	},
	completed: function(callback){
		if (callback){
			this._completedCallback=callback;
		} else if (this._completedCallback){
			this._completedCallback();
		}
	}, 
	validate:function(submitOnValid){
		$("#mainform").validate().resetNumberOfInvalids();
		var numberOfInvalids = 0;
		
		// Validate the form
		$('#slide'+QuoteEngine._options.currentSlide + ' :input').each(function(index) {
			var id=$(this).attr("id");
			if (id && !$(this).not('.validate').is(':hidden') ){
				$("#mainform").validate().element("#" + id);
			}
		});

		var isValid=($("#mainform").validate().numberOfInvalids() == 0);
		if (isValid && submitOnValid){
			QuoteEngine.completed();
		} 
		return isValid;
	},
	resetValidation: function(){
		$("#mainform").validate().resetNumberOfInvalids();	
		$("#mainform").validate().resetForm();
		if (!$("#helpToolTip").is(':hidden')) $("#helpToolTip").fadeOut(100);		
	},
	scrollTo: function(id, time){
		if(time == undefined) { var time = 500 };
		if(id == undefined) { var id = 'html' };
		var $_x = $('#loading-popup:visible');
		if( $_x ){
			$_x.css('position', 'fixed').css('top', ($(window).height() - $_x.height()) /2 + 'px');
		};
		$('html, body').animate({ scrollTop: $(id).offset().top }, time );		
	}
};
$(document).ready(function(){
	QuoteEngine._init({
		currentSlide:	0,
		prevSlide:		-1,
		animating:		false,
		nav:			true,
		lastSlide:		5,
		speed:			"fast",
		noAnimation:	false			
	});
});


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
				data : qs,
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				}
			});
		}
};

var RegisteredSlideCallback = function( params )
{
	var that =			this,
		params =		$.extend({
			mode:		"after", // Before / After
			direction:	false, // false, forward or reverse
			slide_id:	0, // negative number for any slide
			callback:	null
		}, params);
	
	var canCall = function( mode, slide_id, current_slide )
	{
		return	mode == params.mode && 
				(params.slide_id < 0 || (params.slide_id == slide_id && typeof params.callback == 'function')) &&
				(params.direction === false || ((params.direction == 'forward' && current_slide < slide_id) || (params.direction == 'reverse' && current_slide > slide_id)));
	};
	
	this.call = function( mode, slide_id, current_slide )
	{
		if( canCall(mode, slide_id, current_slide) )
		{
			params.callback();
		}
	};
};

var SlideCallbacks = function()
{
	var that = 	this,
	callbacks =	[];
	
	this.register = function( params )
	{
		callbacks.push( new RegisteredSlideCallback(params) );
	};
	
	this.call = function( mode, slide_id, current_slide )
	{
		for(var i in callbacks)
		{
			if( typeof callbacks[i] == "object" && callbacks[i].constructor === RegisteredSlideCallback )
			{
				callbacks[i].call( mode, slide_id, current_slide );
			}
		}
	};
};

var slide_callbacks = new SlideCallbacks();
