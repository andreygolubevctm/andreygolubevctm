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
            partnerDOBD: $(':input[name=health_healthCover_partner_dobInputD]'),
            partnerCoverLoading: $(':input[name=health_healthCover_partner_healthCoverLoading]'),
            dob: $('#health_healthCover_partner_dob'),
            currentCover: $('input[name=health_healthCover_partner_cover]'),
            appFields: $('#partnerFund, #partnerMemberID, #partnerContainer'),
            benefitsScrollerLinks: $('.benefitsScroller'),
            coverLoadingHeading: $('.benefitsContainer').find('h3:first-child')
        };

        $elements.partnerQuestionSet = $elements.partnerDOBD.add($elements.currentCover);

        meerkat.modules.fieldUtilities.hide($elements.partnerCoverLoading);

        var $checked = $elements.currentCover.filter(':checked');
        if($checked.length) {
            $checked.change();
        }
    }

    function _applyEventListeners() {
        $elements.currentCover.on('change', function toggleContinuousCover() {
            var $this = $(this),
                $checked = $this.filter(':checked'),
                hasPartner = _.indexOf(['F', 'C'], meerkat.modules.healthSituation.getSituation()) >= 0,
                hideField = !$checked.length || !hasPartner || $checked.val() === 'N' || ($checked.val() === 'Y' && !_.isEmpty($elements.dob.val()) && meerkat.modules.age.isLessThan31Or31AndBeforeJuly1($elements.dob.val()));
            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerCoverLoading,
                hideField
            );
        });

        $elements.dob.on('change', function updateSnapshot() {
            meerkat.messaging.publish(meerkatEvents.health.SNAPSHOT_FIELDS_CHANGE);
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
                meerkat.modules.fieldUtilities.hide($elements.partnerCoverLoading);
            }
        }
    }

    function _togglePartnerQuestionset(selected) {
        var hasPartner = _.indexOf(['F', 'C'], selected.situation) > -1;
        meerkat.modules.fieldUtilities.toggleVisible($elements.partnerQuestionSet.add($elements.partnerCoverLoading), !hasPartner);
        if(hasPartner && !_.isUndefined(getCurrentCover())) {
            // Need to trigger continuous cover visibility if required
            var $checked = $elements.currentCover.filter(':checked');
            if ($checked.length) $checked.change();
        } else {
            $elements.currentCover.change();
        }
    }

    function _setupAppFields() {
        $elements.appFields.toggleClass('hidden', meerkat.modules.healthChoices.hasPartner() === false);
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