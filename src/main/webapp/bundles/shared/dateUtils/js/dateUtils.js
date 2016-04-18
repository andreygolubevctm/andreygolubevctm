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
    var twoDigits = /\d\d?/;
    var fourDigits = /\d{4}/;

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

    masks = {
        formDate: "DD/MM/YYYY"
    };

    var parseFlags = {
        D: [twoDigits, function (d, v) {
            d.day = v;
        }],
        M: [twoDigits, function (d, v) {
            d.month = v - 1;
        }],
        YYYY: [fourDigits, function (d, v) {
            d.year = v;
        }]
    };
    parseFlags.DD = parseFlags.D;
    parseFlags.MM = parseFlags.M;


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

    /**
     * Parse a date string into an object, changes - into /
     * @method parse
     * @param {string} dateStr Date string
     * @param {string} format Date parse format
     * @returns {Date|null}
     */
    function parse(dateStr, format) {

        if (typeof format !== 'string') {
            throw new Error('Invalid format in parse');
        }
        var isValid = true;
        var dateInfo = {};
        format.replace(token, function ($0) {
            if (parseFlags[$0]) {
                var info = parseFlags[$0];
                var index = dateStr.search(info[0]);
                if (!~index) {
                    isValid = false;
                } else {
                    dateStr.replace(info[0], function (result) {
                        info[1](dateInfo, result);
                        dateStr = dateStr.substr(index + result.length);
                        return result;
                    });
                }
            }

            return parseFlags[$0] ? '' : $0.slice(1, $0.length - 1);
        });

        if (!isValid) {
            return null;
        }
        var today = new Date();
        return new Date(dateInfo.year || today.getFullYear(), dateInfo.month || 0, dateInfo.day || 1);
    };

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
        return format(dateObj, masks.formDate);
    }

    // return date object following format DD/MM/YYYY
    function returnDate(dateInput) {
        if( dateInput instanceof Date){
            return dateInput;
        } else {
            return parse(dateInput , masks.formDate);
        }
    }

	meerkat.modules.register('dateUtils', {
		format  : format,
        parse : parse,
        getNiceDate : getNiceDate,
        returnDateValue : returnDateValue,
        returnDateValueFormFormat : returnDateValueFormFormat
	});

})(jQuery);