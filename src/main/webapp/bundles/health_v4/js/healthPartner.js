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
            partnerHeading: $('.healthCoverPartnerHeading'),
            partnerCoverLoading: $(':input[name=health_healthCover_partner_healthCoverLoading]'),
            dob: $('#health_healthCover_partner_dob'),
            currentCover: $('input[name=health_healthCover_partner_cover]'),
            appFields: $('#partnerFund, #partnerMemberID, #partnerContainer'),
            benefitsScrollerLinks: $('.benefitsScroller'),
            coverLoadingHeading: $('.benefitsContainer').find('h3:first-child')
        };

        $elements.partnerCoverLoading.add($elements.dob).add($elements.currentCover).attr('data-attach','true');

        $elements.partnerQuestionSet = $elements.partnerDOBD.add($elements.currentCover).add($elements.partnerHeading);

        var $checked = $elements.currentCover.filter(':checked');
        if ($checked.length) {
            $checked.change();
        } else {
            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerCoverLoading,
                true
            );
        }
    }

    function _applyEventListeners() {
        $elements.currentCover.add($elements.dob).on('change', function toggleContinuousCover() {
            var $checked = $elements.currentCover.filter(':checked'),
                hasPartner = _.indexOf(['F', 'C', 'EF'], meerkat.modules.healthSituation.getSituation()) >= 0,
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
        meerkat.messaging.subscribe(meerkatEvents.healthSituation.SITUATION_CHANGED, function togglePartnerFields(selected) {
            _setupAppFields();
            _togglePartnerQuestionset(selected);
        });
    }

    function _togglePartnerQuestionset(selected) {
        var hasPartner = _.indexOf(['F', 'C', 'EF'], selected.situation) > -1;
        meerkat.modules.fieldUtilities.toggleVisible($elements.partnerQuestionSet, !hasPartner);
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