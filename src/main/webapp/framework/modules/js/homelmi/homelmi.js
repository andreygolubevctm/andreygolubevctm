/**
 * Description: Placeholder file so it can generate
 */
(function($, undefined) {
    /**
     * This is required as core uses vertical JS module to find getVerticalFilter function in tracking.js
     * @returns {vertical}
     */
    function getVerticalFilter() {
        return meerkat.site.vertical;
    }

    meerkat.modules.register("homelmi", {
        init: function() {},
        events: {},
        getVerticalFilter: getVerticalFilter
    });
})(jQuery);