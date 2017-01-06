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
            currentCover: $('input[name=health_healthCover_primary_cover]')
        };
    }

    function _applyEventListeners() {
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