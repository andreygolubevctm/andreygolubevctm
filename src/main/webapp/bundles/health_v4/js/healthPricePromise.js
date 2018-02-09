;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $pricePromise = $('.price-promise-container');

    function init() {
        if (_.has(meerkat.site, 'pricePromiseHeights') && $pricePromise.length) {
            var state = meerkat.modules.deviceMediaState.get();
            _applyHeight(state);

            $pricePromise.removeClass('hidden');

            _eventSubscriptions();
        }
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function(eventObject) {
            var state = eventObject.state;
            _applyHeight(state);
        });

    }

    function _applyHeight(state) {
        $pricePromise.height(meerkat.site.pricePromiseHeights[state]);
    }

    meerkat.modules.register('healthPricePromise', {
        init: init
    });

})(jQuery);