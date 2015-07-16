/*!
 * CTM-Platform v0.8.3
 * Copyright 2015 Compare The Market Pty Ltd
 * http://www.comparethemarket.com.au/
 */

(function($, undefined) {
    function getVerticalFilter() {
        return meerkat.site.vertical;
    }
    meerkat.modules.register("homelmi", {
        init: function() {},
        events: {},
        getVerticalFilter: getVerticalFilter
    });
})(jQuery);