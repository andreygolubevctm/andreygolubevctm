;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    function init() {
        if (_.has(meerkat.site, 'pricePromiseHeights') && $('.price-promise-container').length) {
            applyHeight();
            updateIframeSrc('start');
            _eventSubscriptions();
        }
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function(eventObject) {
            var state = eventObject.state;
            applyHeight(state);
        });

        meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function hashChange() {
            updateIframeSrc();
        });
    }

    function applyHeight(state) {
        var _state = state || meerkat.modules.deviceMediaState.get();
        $('.price-promise-container')
            .height(meerkat.site.pricePromiseHeights[_state])
            .removeClass('hidden');
    }

    function updateIframeSrc(step) {
        var _step = step || meerkat.modules.address.getWindowHash(),
            $iframe = $('.price-promise-container iframe[data-step="'+_step+'"]');

        if ($iframe.filter('[src]').length > 0) return;

        $iframe.attr('src', $iframe.attr('data-src'));
    }

    meerkat.modules.register('healthPricePromise', {
        init: init,
        applyHeight: applyHeight,
        updateIframeSrc: updateIframeSrc
    });

})(jQuery);