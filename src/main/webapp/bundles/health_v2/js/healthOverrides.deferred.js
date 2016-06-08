/*************************************
 * healthOverrides is distinct class
 * for performing custom manipulations
 *************************************
 */
;(function ($, undefined) {

    var meerkat = window.meerkat,
        moduleEvents = meerkat.events;

    function init() {
        applyEventListeners();
    }

    function applyEventListeners() {
        meerkat.messaging.subscribe(moduleEvents.coupon.COUPON_LOADED, moveCouponToTopOfSidePanel);
    }

    function moveCouponToTopOfSidePanel() {
        $('div.journeyEngineSlide').find('.fieldset-column-side').each(function() {
            var $col = $(this);
            var $coupon = $col.find('.coupon-tile-container');
            var $policy = $col.find('.policySummary-sidebar');
            if($policy && $coupon) {
                $coupon.prependTo($col);
            }
        });
    }

    meerkat.modules.register('healthOverrides', {
        init: init
    });

})(jQuery);