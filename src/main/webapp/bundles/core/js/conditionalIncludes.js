;(function ($, meerkat) {

    var baseUrl;

    function init() {
        baseUrl = meerkat.site.urls.base;

        $(document).ready(function() {
            // Scripts that are important to be included earlier should go here.

        });

        $(window).load(function() {

            // Scripts that don't matter when they are included should go here

        });



    }

    // Must be registered so that meerkat.site is available.
    meerkat.modules.register("conditionalIncludes", {
        init: init
    });
})(jQuery, window.meerkat);