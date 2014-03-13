////////////////////////////////////////////////////////////////
//// UTILITIES MODULE                                       ////
////--------------------------------------------------------////
//// This is just a module to put small common functions in ////
//// for use across the framework. Don't let this get out   ////
//// of hand, as good functionality should be promoted to   ////
//// module of it's own.                                    ////
////--------------------------------------------------------////
//// REQUIRES: jquery as $, underscorejs as _ for _.map     ////
////--------------------------------------------------------////
////////////////////////////////////////////////////////////////

;(function($, undefined){

	var meerkat = window.meerkat;

	var log = meerkat.logging.info;

	function slugify(text) {
		/* Slugify filter, in JavaScript! Results can be used in urls */

		// Remove non-standard characters entirely.
		text = text.replace(/[^\w\s-]/g, '');

		// Strip whitespace from the ends, and make it lowercase.
		text = text.replace(/^\s+/, '').replace(/\s+$/, '').toLowerCase();

		// Remove multiple hyphens/whitespace with a single hyphen.
		text = text.replace(/[-\s]+/g, '-');

		return text;
	}

	function scrollPageTo(element, timing, offsetFromTop, callback){
		var $ele = $(element);
		var tm = 250;
		var offset = 0;
		var didAnAnimation;

		if (typeof timing !== "undefined") { tm = timing; }
		if (typeof offsetFromTop !== "undefined") { offset = offsetFromTop; }

		if ($ele.offset().top < $(window).scrollTop()) {
			$('html, body').animate({
				scrollTop: $ele.offset().top + offset
			}, tm, function(){
				didAnAnimation = true;
				if (typeof callback == "function") callback(this,didAnAnimation);
			});
		} else {
			//We're already high enough, just fire the callback!
			didAnAnimation = false;
			if (typeof callback == "function") callback(this,didAnAnimation);
		}
	}

	jQuery.fn.animateAuto = function(prop, speed, callback){
		var elem, height, width;
		return this.each(function(i, el){
			el = jQuery(el), elem = el.clone().css({"height":"auto","width":"auto"}).appendTo("body");
			height = elem.css("height"),
			width = elem.css("width"),
			elem.remove();

			if(prop === "height")
				el.animate({"height":height}, speed, callback);
			else if(prop === "width")
				el.animate({"width":width}, speed, callback);
			else if(prop === "both")
				el.animate({"width":width,"height":height}, speed, callback);
		});
	};


	//
	// Return the current date as UTC. Includes the hours.
	//
	function UTCToday() {
		var today = new Date();
		return Date.UTC(today.getUTCFullYear(), today.getUTCMonth(), today.getUTCDate(), today.getUTCHours(), 0, 0, 0);
	}



	meerkat.modules.register('utilities', {
		slugify: slugify,
		scrollPageTo: scrollPageTo,
		getUTCToday: UTCToday
	});

})(jQuery);
