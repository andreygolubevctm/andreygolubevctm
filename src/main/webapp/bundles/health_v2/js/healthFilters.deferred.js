/**
 * Description: External documentation:
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
            healthFilters: {},
            WEBAPP_LOCK: 'WEBAPP_LOCK',
            WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
        },
        model = {};

    function init() {

        // render template based off model?
        // init slider and government rebate would be an issue?
        
    }

    meerkat.modules.register("healthFilters", {
        init: init,
        events: {}
    });

})(jQuery);