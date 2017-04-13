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
            dob: $('#health_healthCover_primary_dob'),
            partnerDOB: $('#benefits_partner_dob')
        };

        var $checked = $elements.currentCover.filter(':checked');
        if($checked.length) {
            $checked.change();
        }
    }

    function _applyEventListeners() {
        $elements.currentCover.on('change', function toggleContinuousCover() {
            var $this = $(this),
                $checked = $this.filter(':checked'),
                hideField = !$checked.length || ($checked.val() === 'N') || ($checked.val() === 'Y' && meerkat.modules.age.isLessThan31Or31AndBeforeJuly1($elements.dob.val()));

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryCoverLoading,
                hideField
            );
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

            meerkat.modules.fieldUtilities.hide($elements.primaryCoverLoading);
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