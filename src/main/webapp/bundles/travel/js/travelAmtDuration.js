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

        $amtRegionLabels.on('click', function() {
            
            $amtRegionLabels.removeClass('active');
            $amtRegionLabels.siblings('input').prop('checked', false);

            $(this).addClass('active');
            $(this).siblings('input').prop('checked', true);

        });
    }

    meerkat.modules.register("travelAmtDurations", {
        initAmtDurations: initAmtDurations
    });

})(jQuery);