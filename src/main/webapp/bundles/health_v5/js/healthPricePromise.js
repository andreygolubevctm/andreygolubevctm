;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        dismissed = false;

    function init() {
        if (_.has(meerkat.site, 'pricePromiseHeights') && $('.price-promise-container').length) {
            applyHeight();
            updateIframeSrc('start');
            _eventSubscriptions();
            _eventListeners();
        }
    }

    function _eventListeners() {
        $('.price-promise-container').find('.price-promise-close').on('click', _dismissPricePromise);
    }

    function _dismissPricePromise(event) {
        event.stopPropagation();
        //if we dismiss one, we want to dismiss all dismissable price promises
        var dismissableContainers = $('[data-dismissible="true"]');
        dismissableContainers.each(function() {
            $(this).addClass('hidden');
        });
        dismissed = true;
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
            .height(250)
            .removeClass(dismissed ? '' : 'hidden');
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