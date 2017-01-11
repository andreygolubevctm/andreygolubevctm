;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,

        $elements = {};

    function initHealthPrimary() {
        _setupFields();
        _applyEventListeners();
        _eventSubscriptions();
    }

    function _setupFields() {
        $elements = {
            primaryCoverLoading: $(':input[name=health_healthCover_primary_healthCoverLoading]'),
            currentCover: $('input[name=health_healthCover_primary_cover]')
        };

        meerkat.modules.fieldUtilities.toggleFields($elements.primaryCoverLoading, $elements.currentCover.filter(':checked').val() === 'N');
    }

    function _applyEventListeners() {
        $elements.currentCover.on('change', function toggleContinuousCover() {
            var $this = $(this);
            meerkat.modules.fieldUtilities.toggleFields($elements.primaryCoverLoading, $this.filter(':checked').val() === 'N');
        });
    }

    function _eventSubscriptions() {
    }

    function getCurrentCover() {
        return $elements.currentCover.filter(':checked').val();
    }

    meerkat.modules.register('healthPrimary', {
        init: initHealthPrimary,
        getCurrentCover: getCurrentCover
    });

})(jQuery);