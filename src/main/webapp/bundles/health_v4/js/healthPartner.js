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
            partnerEverHadCover: $(':input[name=health_healthCover_partner_everHadCover]'),
            partnerCurrentFundName: $(':input[name=health_healthCover_partner_fundName]'),
            appFields: $('#partnerFund, #partnerMemberID, #partnerContainer'),
            benefitsScrollerLinks: $('.benefitsScroller'),
            coverLoadingHeading: $('.benefitsContainer').find('h3:first-child'),
            appDob: $('#health_application_partner_dob')
        };

        $elements.partnerCoverLoading.add($elements.dob).add($elements.currentCover).attr('data-attach','true');

        $elements.partnerQuestionSet = $elements.partnerDOBD.add($elements.currentCover).add($elements.partnerHeading);
    }

    function _applyEventListeners() {
        $elements.currentCover.add($elements.dob).on('change', function toggleContinuousCover() {
            var $checked = $elements.currentCover.filter(':checked'),
                hasPartner = meerkat.modules.healthChoices.hasPartner(),
                hideField = !$checked.length || !hasPartner || $checked.val() === 'N' || ($checked.val() === 'Y' && !_.isEmpty($elements.dob.val()) && meerkat.modules.age.isLessThan31Or31AndBeforeJuly1($elements.dob.val()));

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerCoverLoading,
                hideField
            );
        });

        $elements.dob.on('change', function updateSnapshot() {
            meerkat.messaging.publish(meerkatEvents.health.SNAPSHOT_FIELDS_CHANGE);
        });

        $elements.currentCover.on('change', function toggleEverHadCover() {
            var $checked = $elements.currentCover.filter(':checked'),
                hasPartner = meerkat.modules.healthChoices.hasPartner(),
                hideField = !$checked.length || !hasPartner || ($checked.val() === 'Y');

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerEverHadCover,
                hideField
            );
        });

        $elements.currentCover.on('change', function toggleCurrentHealthFund() {
            var $checked = $elements.currentCover.filter(':checked'),
                hasPartner = meerkat.modules.healthChoices.hasPartner(),
                hideField = !$checked.length || !hasPartner || ($checked.val() === 'N');

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerCurrentFundName,
                hideField
            );
        });

    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.healthSituation.SITUATION_CHANGED, function togglePartnerFields(selected) {
            _setupAppFields();
            _togglePartnerQuestionset(selected);
        });
    }

    function _togglePartnerQuestionset(selected) {
        var hasPartner = meerkat.modules.healthChoices.hasPartner();
        meerkat.modules.fieldUtilities.toggleVisible($elements.partnerQuestionSet, !hasPartner);
    }

    function _setupAppFields() {
        $elements.appFields.toggleClass('hidden', meerkat.modules.healthChoices.hasPartner() === false);
    }

    function getCurrentCover() {
        return $elements.currentCover.filter(':checked').val();
    }

    function onStartInit() {
        var $checked = $elements.currentCover.filter(':checked');
        if ($checked.length) {
            $checked.change();
        } else {
            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerCoverLoading,
                true
            );

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerEverHadCover,
                true
            );

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerCurrentFundName,
                true
            );

        }
    }

    function getAppDob() {
        return $elements.appDob.val();
    }

    // iff true, the applicant's partner has never held 'Private Hospital Cover'
    function getNeverHadCover() {
        return $elements.currentCover.filter(':checked').val() === 'N' && $elements.partnerEverHadCover.filter(':checked').val() === 'N';
    }

    // iff true, the applicant's partner does not currently have any cover but has held 'Private Hospital Cover' in the past
    function getHeldPrivateHealthInsuranceBeforeButNotCurrently() {
        return $elements.currentCover.filter(':checked').val() === 'N' && $elements.partnerEverHadCover.filter(':checked').val() === 'Y';
    }

    // iff true, the applicant's partner currently has and has always had continuous 'Private Hospital Cover'
    // iff false, (the test below is a better indicator) the applicant's partner currently has (either Private Hospital or Extras cover) && has not had continuous Private Hospital, but has never explicitly been asked if they have ever held Private Hospital Cover
    // iff null, the applicant's partner has selected that they do not currently have (either 'Private Hospital' or 'Extras cover')
    function getContinuousCover() {
        return $elements.currentCover.filter(':checked').val() === 'Y' ? $elements.partnerCoverLoading.filter(':checked').val() === 'Y' : null;
    }

    // if true, the applicant's partner currently has (either 'Private Hospital' or 'Extras cover') && has not had continuous Private hospital,
    // but has never explicitly been asked if they have ever held 'Private Hospital Cover'
    function getNeverExplicitlyAskedIfHeldPrivateHospitalCover() {
        return $elements.currentCover.filter(':checked').val() === 'Y' && $elements.partnerCoverLoading.filter(':checked').val() === 'N';
    }

    meerkat.modules.register('healthPartner', {
        init: initHealthPartner,
        getCurrentCover: getCurrentCover,
        onStartInit: onStartInit,
        getAppDob: getAppDob,
        getContinuousCover: getContinuousCover,
        getNeverHadCover: getNeverHadCover,
        getHeldPrivateHealthInsuranceBeforeButNotCurrently: getHeldPrivateHealthInsuranceBeforeButNotCurrently,
        getNeverExplicitlyAskedIfHeldPrivateHospitalCover: getNeverExplicitlyAskedIfHeldPrivateHospitalCover
    });

})(jQuery);