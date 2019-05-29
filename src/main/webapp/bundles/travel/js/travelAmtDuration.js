;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var $amtDurationsfs,
        $amtRegionInputs,
        $amtRegionLabels;


    function initAmtDurations() {

        $amtDurationsfs = $("#amtDurationsfs");
        $amtRegionInputs = $amtDurationsfs.find('input');
        $amtRegionLabels = $amtRegionInputs.siblings('label');

        // borrow functionality from travelTripType.js for the selected states on the region checkboxes
        $amtRegionLabels.on('click', function() {
            meerkat.modules.tripType.toggleActiveState($(this).siblings('input'));
        });
    }

    meerkat.modules.register("travelAmtDurations", {
        initAmtDurations: initAmtDurations
    });

})(jQuery);