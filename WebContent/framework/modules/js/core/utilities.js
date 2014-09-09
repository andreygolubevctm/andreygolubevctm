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
		var calledBack = false;

		if (typeof timing !== "undefined") { tm = timing; }
		if (typeof offsetFromTop !== "undefined") { offset = offsetFromTop; }

		if ($ele.offset().top < $(window).scrollTop()) {
			$('html, body').animate({
				scrollTop: $ele.offset().top + offset
			}, tm, function(){
				didAnAnimation = true;
				if (!calledBack && typeof callback == "function") {
					// avoids the callback to be called twice (because of the "html, body" selector itself required for cross browser compatibility)
					calledBack = true;
					callback(this,didAnAnimation);
				}
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

	function returnAge(_dobString, round) {
		var _now = new Date();
			_now.setHours(0,0,0);
		var _dob = returnDate(_dobString);
		var _years = _now.getFullYear() - _dob.getFullYear();

		if(_years < 1){
			return (_now - _dob) / (1000 * 60 * 60 * 24 * 365);
		}

		//leap year offset
		var _leapYears = _years - ( _now.getFullYear() % 4);
		_leapYears = (_leapYears - ( _leapYears % 4 )) /4;
		var _offset1 = ((_leapYears * 366) + ((_years - _leapYears) * 365)) / _years;

		//birthday offset - as it's always so close
		var _offset2 = +0.005;
		if(  (_dob.getMonth() == _now.getMonth()) && (_dob.getDate() > _now.getDate()) ){
			_offset2 = -0.005;
		}

		var _age = (_now - _dob) / (1000 * 60 * 60 * 24 * _offset1) + _offset2;
		if (round) {
			return Math.floor(_age);
		}
		else {
			return _age;
		}
	}

	function returnDate(_dateString){
		return new Date(_dateString.substring(6,10), _dateString.substring(3,5) - 1, _dateString.substring(0,2));
	}

	function returnDateValue(_date){
		var _dayString = leadingZero( _date.getDate() );
		var _monthString = leadingZero( _date.getMonth() + 1 );
		return _date.getFullYear() +'-'+ _monthString +'-'+ _dayString;
	}

	function invertDate(dt, del) {
		del = del || "/";
		return dt.split(del).reverse().join(del);
	}

	function isValidNumericKeypressEvent(e, decimal) {

		decimal = _.isBoolean(decimal) ? decimal : false;
		var key;
		var keychar;

		if (window.event) {
			key = window.event.keyCode;
		} else if (e) {
			key = e.which;
		} else {
			return true;
		}

		keychar = String.fromCharCode(key);

		var safeList = [8,35,37,39];
		// backspace, left/right arrow, end and number pad

		if ((key==null) || (key===0) || (key==9) || (key==12) || (key==13) || (key==27) ) {
			return true;
		} else if (_.indexOf(safeList, key) !== -1 || (("0123456789").indexOf(keychar) > -1)) {
			return true;
		} else if (decimal && (keychar == ".")) {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * Will attempt to identify if a plugin has loaded every 300ms for 10 seconds.
	 * @param {String} plugin The plugin name e.g. scrollTo, or sessioncamRecorder.
	 */
	function pluginReady(plugin) {
		// return a deffered object that will resolve when the plugin is
		// available.

		var pluginDef = $.Deferred();
		// save if already exists with cache.
		if (!!jQuery.fn[plugin] || !!window[plugin]) {
			pluginDef.resolve();
			return pluginDef.promise();
		}
		var pluginInterval = setInterval(function() {
			if (!!jQuery.fn[plugin] || !!window[plugin])
				pluginDef.resolve();
		}, 300);

		// give up after 10 seconds
		setTimeout(function() {
			clearInterval(pluginInterval);
		}, 10000);

		$.when(pluginDef).then(function() {
			clearInterval(pluginInterval);
		});

		return pluginDef.promise();
	}

	meerkat.modules.register('utilities', {
		slugify: slugify,
		scrollPageTo: scrollPageTo,
		getUTCToday: UTCToday,
		returnAge: returnAge,
		returnDate: returnDate,
		isValidNumericKeypressEvent: isValidNumericKeypressEvent,
		invertDate: invertDate,
		returnDateValue : returnDateValue,
		pluginReady: pluginReady
	});

})(jQuery);

jQuery.fn.extend({
	refreshLayout: function(){
		var $trick = $("<div>");
		$(this).append($trick);
		_.defer(function(){
			$(this).remove($trick);
		});
	}
});