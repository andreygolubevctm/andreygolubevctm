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
            primaryCoverRow: $('#health_healthCover_primaryCover'),
            currentCover: $('input[name=health_healthCover_primary_cover]'),
            partnerDOB: $('#benefits_partner_dob')
        };

        meerkat.modules.fieldUtilities.toggleFields($elements.primaryCoverLoading, getCurrentCover() === 'N');
    }

    function _applyEventListeners() {
        $elements.currentCover.on('change', function toggleContinuousCover() {
            var $this = $(this);
            meerkat.modules.fieldUtilities.toggleFields($elements.primaryCoverLoading, $this.filter(':checked').val() === 'N');
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function updateForBrochureware() {
            positionFieldsForBrochureware();
        });

        meerkat.messaging.subscribe(meerkatEvents.healthSituation.SITUATION_CHANGED, function togglePartnerFields() {
            positionFieldsForBrochureware();
        });
    }

    function positionFieldsForBrochureware() {
        if (meerkat.site.isFromBrochureSite) {
            if (meerkat.modules.healthChoices.hasPartner()) {
                $elements.primaryCoverLoading.closest('.fieldrow').insertBefore($elements.partnerDOB);
            } else {
                $elements.primaryCoverLoading.closest('.fieldrow').insertAfter($elements.primaryCoverRow);
            }

            meerkat.modules.fieldUtilities.disable($elements.primaryCoverLoading);
        }
    }

    function getCurrentCover() {
        return $elements.currentCover.filter(':checked').val();
    }

    meerkat.modules.register('healthPrimary', {
        init: initHealthPrimary,
        getCurrentCover: getCurrentCover,
        positionFieldsForBrochureware: positionFieldsForBrochureware
    });

})(jQuery);