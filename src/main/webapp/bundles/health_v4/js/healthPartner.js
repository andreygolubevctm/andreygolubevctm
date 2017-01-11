;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {};

    function initHealthPartner() {
        _setupFields();
        _applyEventListeners();
        _eventSubscriptions();
    }

    function _setupFields() {

        $elements = {
            partnerDOBD: $(':input[name=health_healthCover_partner_dobInputD]'),
            partnerCoverLoading: $(':input[name=health_healthCover_partner_healthCoverLoading]'),
            dob: $('#health_healthCover_partner_dob'),
            currentCover: $('input[name=health_healthCover_partner_cover]'),
            appFields: $('#partnerFund, #partnerMemberID, #partnerContainer'),
            benefitsScrollerLinks: $('.benefitsScroller'),
            coverLoadingHeading: $('.benefitsContainer').find('h3:first-child')
        };

        $elements.partnerQuestionSet = $elements.partnerDOBD.add($elements.currentCover);

        meerkat.modules.fieldUtilities.toggleFields($elements.partnerCoverLoading, $elements.currentCover.filter(':checked').val() === 'N');
    }

    function _applyEventListeners() {
        $elements.dob.on('change', function updateSnapshot() {
            meerkat.messaging.publish(meerkatEvents.health.SNAPSHOT_FIELDS_CHANGE);
        });

        $elements.currentCover.on('change', function toggleContinuousCover() {
            var $this = $(this);
            meerkat.modules.fieldUtilities.toggleFields($elements.partnerCoverLoading, $this.filter(':checked').val() === 'N');
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_INIT, function updateForBrochureware() {
            positionFieldsForBrochureware();
        });

        meerkat.messaging.subscribe(meerkatEvents.healthSituation.SITUATION_CHANGED, function togglePartnerFields(selected) {
            _setupAppFields();
            _togglePartnerQuestionset(selected);

            positionFieldsForBrochureware();
        });
    }

    function positionFieldsForBrochureware() {
        if (meerkat.site.isFromBrochureSite) {
            if (!meerkat.modules.healthChoices.hasPartner()) {
                $elements.partnerQuestionSet.add($elements.partnerCoverLoading).closest('.fieldrow').hide();
                $elements.benefitsScrollerLinks.add($elements.coverLoadingHeading).hide();
            } else {
                $elements.partnerQuestionSet.add($elements.partnerCoverLoading).closest('.fieldrow').show();
                $elements.benefitsScrollerLinks.add($elements.coverLoadingHeading).show();
                meerkat.modules.fieldUtilities.disable($elements.partnerCoverLoading);
            }
        }
    }

    function _togglePartnerQuestionset(selected) {
        if (_.indexOf(['F', 'C'], selected.situation) > -1 ) {
            meerkat.modules.fieldUtilities.enable($elements.partnerQuestionSet);
        } else {
            meerkat.modules.fieldUtilities.disable($elements.partnerQuestionSet);
        }
    }

    function getCurrentCover() {
        return $elements.currentCover.filter(':checked').val();
    }

    meerkat.modules.register('healthPartner', {
        init: initHealthPartner,
        getCurrentCover: getCurrentCover,
        positionFieldsForBrochureware: positionFieldsForBrochureware
    });

})(jQuery);