;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        _excessTextMapping = [
            '$0',
            '$1 - $250',
            '$251 - $500',
            'Maximum excess applied'
        ];

    function initHealthRefineResultsMobileExcess() {
        _setupElements();
        _eventSubscriptions();

        return this;
    }

    function _setupElements() {
        $elements.excess = $('#health_excess');
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.refineResults.REFINE_RESULTS_OPENED, function () {
            $(':input[name=health_refine_results_excess]')
                .filter('[value=' + $elements.excess.val() + ']').prop('checked', true)
                .parent().addClass('active');
        });

        meerkat.messaging.subscribe(meerkatEvents.refineResults.REFINE_RESULTS_FOOTER_BUTTON_UPDATE_CALLBACK, function() {
            $elements.excess.val($(':input[name=health_refine_results_excess]').filter(':checked').val());
        });
    }

    function getText() {
        return _excessTextMapping[$elements.excess.val() - 1];
    }

    meerkat.modules.register('healthRefineResultsMobileExcess', {
        initHealthRefineResultsMobileExcess: initHealthRefineResultsMobileExcess,
        events: moduleEvents,
        getText: getText
    });

})(jQuery);