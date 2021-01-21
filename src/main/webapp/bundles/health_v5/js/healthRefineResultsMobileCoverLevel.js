;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        _coverLevelTextMapping = [
            'Basic',
            'Bronze',
            'Silver',
            'Gold'
        ];

    function initHealthRefineResultsMobileCoverLevel() {
        _setupElements();
        _eventSubscriptions();

        return this;
    }

    function _setupElements() {
        $elements.coverLevel = $('#health_coverLevel');
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.refineResults.REFINE_RESULTS_OPENED, function () {
            $(':input[name=health_refine_results_coverLevel]')
                .filter('[value=' + $elements.coverLevel.val() + ']').prop('checked', true)
                .parent().addClass('active');
        });

        meerkat.messaging.subscribe(meerkatEvents.refineResults.REFINE_RESULTS_FOOTER_BUTTON_UPDATE_CALLBACK, function() {
            $elements.coverLevel.val($(':input[name=health_refine_results_coverLevel]').filter(':checked').val());
        });
    }

    function getText() {
        return _coverLevelTextMapping[$elements.coverLevel.val() - 1];
    }

    meerkat.modules.register('healthRefineResultsMobileCoverLevel', {
        initHealthRefineResultsMobileCoverLevel: initHealthRefineResultsMobileCoverLevel,
        events: meerkatEvents,
        getText: getText
    });

})(jQuery);