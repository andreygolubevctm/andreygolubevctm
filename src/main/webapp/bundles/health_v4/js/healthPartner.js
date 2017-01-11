;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,

        $elements = {};

    function initHealthPartner() {
        _setupFields();
        _applyEventListeners();
        _eventSubscriptions();
        _setupAppFields();
    }

    function _setupFields() {
        $elements = {
            dob: $('#health_healthCover_partner_dob'),
            currentCover: $('input[name=health_healthCover_partner_cover]'),
            appFields: $('#partnerFund, #partnerMemberID, #partnerContainer')
        };
    }

    function _applyEventListeners() {
        $elements.dob.on('change', function updateSnapshot() {
            meerkat.messaging.publish(meerkatEvents.health.SNAPSHOT_FIELDS_CHANGE);
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.healthSituation.SITUATION_CHANGED, function togglePartnerFields() {
            _setupAppFields();
        });
    }

    function _setupAppFields() {
        $elements.appFields.toggleClass('hidden', meerkat.modules.healthChoices.hasPartner() === false);
    }

    function getCurrentCover() {
        return $elements.currentCover.filter(':checked').val();
    }

    meerkat.modules.register('healthPartner', {
        init: initHealthPartner,
        getCurrentCover: getCurrentCover
    });

})(jQuery);