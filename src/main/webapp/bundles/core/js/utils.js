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

		if ($ele.offset().top < $(window).scrollTop() ||
			// condition used to check when right top journey button clicked on health_v4
			( ($ele.offset().top + $ele.height()) > ($(window).scrollTop() + $(window).height()) )) {

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

	//
	// Return the current date as UTC. Includes the hours.
	//
	function UTCToday() {
		var today = new Date();
		return Date.UTC(today.getUTCFullYear(), today.getUTCMonth(), today.getUTCDate(), today.getUTCHours(), 0, 0, 0);
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
		if (!!jQuery.fn[plugin] || !!window[plugin] || !!window.meerkat.modules[plugin]) {
			pluginDef.resolve();
			return pluginDef.promise();
		}
		var pluginInterval = setInterval(function() {
			if (!!jQuery.fn[plugin] || !!window[plugin] || !!window.meerkat.modules[plugin])
				pluginDef.resolve();
		}, 300);

		// give up after 15 seconds
		setTimeout(function() {
			clearInterval(pluginInterval);
		}, 15000);

		$.when(pluginDef).then(function() {
			clearInterval(pluginInterval);
		});

		return pluginDef.promise();
	}

	/*
	 * Add no. of business days(excluding weekends) in a date to get next date
	 * Param fromDate, javascript Date object
	 * Param days, how many business days to add
	 */
	function calcWorkingDays(fromDate, days) {
		var count = 0;
		while (count < days) {
			fromDate.setDate(fromDate.getDate() + 1);
			if (fromDate.getDay() !== 0 && fromDate.getDay() !== 6) // Skip weekends
				count++;
		}
		return fromDate;
	}

	/**
	 * Formats a UK date as a US date
	 * @param date
	 * @returns {string}
	 */
	function formatUKToUSDate(date) {
		var delimiter = date.match(/(-)/) ? "-" : "/";
		date = date.split(delimiter);
		var day = date[0];
		date[0] = date[1];
		date[1] = day;
		return date.join(delimiter);
	}

	/**
	 * Returns a "time ago" formatted string
	 * @param date (mm/dd/yyyy format)
	 * @returns {string}
	 */
	function getTimeAgo(date) {
		if(date instanceof Date === false)
			date = new Date(date);

		var seconds = Math.floor((new Date() - date) / 1000),
			interval = Math.floor(seconds / 31536000);

		if (interval > 1)
			return interval + " years";

		interval = Math.floor(seconds / 2592000);

		if (interval > 1)
			return interval + " months";

		interval = Math.floor(seconds / 86400);

		if (interval > 1)
			return interval + " days";

		interval = Math.floor(seconds / 3600);

		if (interval > 1)
			return interval + " hours";

		interval = Math.floor(seconds / 60);

		if (interval > 1)
			return interval + " minutes";

		return Math.floor(seconds) + " seconds";
	}

	/**
	 * Returns a html node
	 * @param string elementType
	 * @param object props
	 * @returns {node}
	 */


	function createElement(elementType, props) {
		var element = document.createElement(elementType);
		if (props && props.children) {
			element.append(props.children);
			delete props.children;
		}

		for (var key in props) {
			element.setAttribute(key, props[key]);
		}
		return element;
	}

	meerkat.modules.register('utils', {
		slugify: slugify,
		scrollPageTo: scrollPageTo,
		getUTCToday: UTCToday,
		isValidNumericKeypressEvent: isValidNumericKeypressEvent,
		invertDate: invertDate,
		pluginReady: pluginReady,
		calcWorkingDays: calcWorkingDays,
		getTimeAgo: getTimeAgo,
		formatUKToUSDate: formatUKToUSDate,
		createElement: createElement
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
