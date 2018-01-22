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
    var shortMonthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
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
            MMM: function(dateObj) {
                return shortMonthNames[dateObj.getMonth()];
            },
            YYYY: function(dateObj) {
                return dateObj.getFullYear();
            },
            MM: function(dateObj) {
                return pad(dateObj.getMonth() + 1);
            },
            dddd: function(dateObj) {
                return dayNames[dateObj.getDay()];
            },
            HH: function(dateObj) {
                return pad(dateObj.getHours());
            },
            mm: function(dateObj) {
                return pad(dateObj.getMinutes());
            }
        },
        masks = {
            formDate: "DD/MM/YYYY",
            serverDate : "YYYY-MM-DD",
            longDate : "dddd, D MMMM YYYY",
            dateTime : "YYYY-MM-DDTHH:mm"
        },
        parseFlags = {
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
    }

    // param: Date object
    // returns: long date string in the following format:
    // dddd, D MMMM YYYY
    // e.g. Monday, 25 April 2016
    function dateValueLongFormat( dateObj ) {
        return format(dateObj, masks.longDate);
    }

    // param: Date object
    // returns: server date string in the following format:
    // YYYY-MM-DD
    // e.g. 2016-04-25
    function dateValueServerFormat(dateObj){
        return format(dateObj, masks.serverDate);
    }

    // param: Date object
    // returns: form date string in the following format:
    // DD/MM/YYYY
    // e.g. 25/04/2016
    // throw Error if date is invalid
    function dateValueFormFormat(dateObj){
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

    // return date string in the following format:
    // YYYY-MM-DDTHH:mm
    // Useful for <input type="datetime"> element
    function returnDateTimeString(dateObj) {
        return format(dateObj, masks.dateTime);
    }

    meerkat.modules.register('dateUtils', {
        format  : format,
        parse : parse,
        returnDate: returnDate,
        dateValueLongFormat : dateValueLongFormat,
        dateValueServerFormat : dateValueServerFormat,
        dateValueFormFormat : dateValueFormFormat,
        returnDateTimeString: returnDateTimeString
    });

})(jQuery);