////////////////////////////////////////////////////////////////
//// Date UTILITIES MODULE                                       ////
////--------------------------------------------------------////
//// This is just a module to put small common date functions in ////
//// for use across the framework. Don't let this get out   ////
//// of hand, as good functionality should be promoted to   ////
//// module of it's own.                                    ////
////--------------------------------------------------------////
////--------------------------------------------------------////
////////////////////////////////////////////////////////////////

;(function($, undefined){

	var meerkat = window.meerkat;

    var dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
	var monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var token = /d{1,4}|M{1,4}|YY(?:YY)?|S{1,3}|Do|ZZ|([HhMsDm])\1?|[aA]|"[^"]*"|'[^']*'/g;

	var formatFlags = {
        D: function(dateObj) {
            return dateObj.getDate();
        },
        DD: function(dateObj) {
            return pad(dateObj.getDate());
        },
        Do: function(dateObj) {
            return doFn(dateObj.getDate());
        },
		MMMM: function(dateObj) {
			return monthNames[dateObj.getMonth()];
		},
		YYYY: function(dateObj) {
			return dateObj.getFullYear();
		},
		MM: function(dateObj) {
			return pad(dateObj.getMonth() + 1);
		},
        dddd: function(dateObj) {
            return dayNames[dateObj.getDay()];
        }
	};

    function doFn(day) {
        return day + ['th', 'st', 'nd', 'rd'][day % 10 > 3 ? 0 : (day - day % 10 !== 10) * day % 10];
    }

    function pad(val, len) {
		val = String(val);
		len = len || 2;
		while (val.length < len) {
			val = '0' + val;
		}
		return val;
	}

	function format(dateObj, mask){

		if (typeof dateObj === 'number') {
			dateObj = new Date(dateObj);
		}

		if (Object.prototype.toString.call(dateObj) !== '[object Date]' || isNaN(dateObj.getTime())) {
			throw new Error('Invalid Date in format');
		}

		return mask.replace(token, function ($0) {
			return $0 in formatFlags ? formatFlags[$0](dateObj) : $0.slice(1, $0.length - 1);
		});
	}

    // return nice date string in dddd, D MMMM YYYY e.g. Monday, 25 April 2016
    function getNiceDate( dateObj ) {
        return format(dateObj, "dddd, D MMMM YYYY");
    }

    // return date string in YYYY-MM-DD
    function returnDateValue(dateObj){
        return format(dateObj, "YYYY-MM-DD");
    }

    // return date string in DD/MM/YYYY
    function returnDateValueFormFormat(dateObj){
        return format(dateObj, "DD/MM/YYYY");
    }

	meerkat.modules.register('dateUtils', {
		format  : format,
        getNiceDate : getNiceDate,
        returnDateValue : returnDateValue,
        returnDateValueFormFormat : returnDateValueFormFormat
	});

})(jQuery);