;(function($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var moduleEvents = {
        paymentFrequencyButtons : {
            CHANGED: 'FILTERS_CHANGED'
        }
    };

    var $buttonGroup,
        $button;

    function init() {
        $buttonGroup = $('.payment-frequency-buttons');
        $button = $buttonGroup.find('input[type=radio]');

        eventSubscriptions();
    }

    function eventSubscriptions() {
        // hide component while results are in progress
        $(document).on('resultsFetchStart', function onResultsFetchStart() {
            $buttonGroup.addClass('hidden');
        });


        // show component once results are fetched and results are available
        $(document).on("resultsFetchFinish", function() {
            if (Results.model.availableCounts > 0) {
                $buttonGroup.removeClass('hidden');
            }
        });

        $button.on('change', function() {
            Results.setFrequency($(this).val());
            meerkat.messaging.publish(moduleEvents.paymentFrequencyButtons.CHANGED);
        });
    }

    function set(frequency) {
        $buttonGroup.find('input[value='+frequency+']').prop('checked', true).attr('checked', 'checked').change();
    }

    meerkat.modules.register('paymentFrequencyButtons', {
        init: init,
        set: set,
        events: moduleEvents
    });
})(jQuery);