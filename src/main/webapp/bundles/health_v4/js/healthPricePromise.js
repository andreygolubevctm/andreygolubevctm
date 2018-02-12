;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    function init() {
        if (_.has(meerkat.site, 'pricePromiseHeights') && $('.price-promise-container').length) {
            applyHeight();
            _eventSubscriptions();
        }
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function(eventObject) {
            var state = eventObject.state;
            applyHeight(state);
        });
    }

    function applyHeight(state) {
        var _state = state || meerkat.modules.deviceMediaState.get();
        $('.price-promise-container')
            .height(meerkat.site.pricePromiseHeights[_state])
            .removeClass('hidden');
    }

    meerkat.modules.register('healthPricePromise', {
        init: init,
        applyHeight: applyHeight
    });

})(jQuery);