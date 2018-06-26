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
        $elements = { //g
            partnerDOBD: $('select[name=health_healthCover_partner_dobInputD]'),
            partnerHeading: $('.healthCoverPartnerHeading'),
            partnerCoverLoading: $('input[name=health_healthCover_partner_healthCoverLoading]'),
            dob: $('#health_healthCover_partner_dob'),
            currentlyHaveAnyKindOfCoverPreResults: $('input[name=health_healthCover_partner_cover]'),
            partnerEverHadPrivateHospital_1: $('input[name=health_application_partner_everHadCoverPrivateHospital1]'),
            partnerEverHadPrivateHospital_2: $('input[name=health_application_partner_everHadCoverPrivateHospital2]'),
            partnerCurrentFundName: $('select[name=health_healthCover_partner_fundName]'),
            appFields: $('#partnerFund, #partnerMemberID, #partnerContainer'),
            additionalFieldsToHide: $('#health_insurance_preferences_additional_partner_fields'),
            benefitsScrollerLinks: $('.benefitsScroller'),
            coverLoadingHeading: $('.benefitsContainer').find('h3:first-child'),
            appDob: $('#health_application_partner_dob'),
            healthInsurancePreferencesPartnerPreviousFund: $('select[name=health_healthCover_partner_fundName]').children('option'),
            healthApplicationPartnerPreviousFund: $('select[name=health_previousfund_partner_fundName]').children('option')
        };

        $elements.partnerCoverLoading.add($elements.dob).add($elements.currentlyHaveAnyKindOfCoverPreResults).attr('data-attach','true');

        $elements.partnerQuestionSet = $elements.partnerDOBD.add($elements.currentlyHaveAnyKindOfCoverPreResults).add($elements.partnerHeading);
    }

    function _applyEventListeners() {
        $elements.currentlyHaveAnyKindOfCoverPreResults.add($elements.dob).on('change', function toggleContinuousCover() {
            var $checked = $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked'),
                hasPartner = meerkat.modules.healthChoices.hasPartner(),
                hideField = !$checked.length || !hasPartner || $checked.val() === 'N' || ($checked.val() === 'Y' && !_.isEmpty($elements.dob.val()) && !meerkat.modules.age.isAgeLhcApplicable($elements.dob.val()));

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerCoverLoading,
                hideField
            );
        });

        $elements.dob.on('change', function updateSnapshot() {
            meerkat.messaging.publish(meerkatEvents.health.SNAPSHOT_FIELDS_CHANGE);
        });

        $elements.currentlyHaveAnyKindOfCoverPreResults.on('change', function toggleEverHadPrivateHospitalCover_1() {
            var $checked = $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked'),
                hasPartner = meerkat.modules.healthChoices.hasPartner(),
                hideField = !$checked.length || !hasPartner || ($checked.val() === 'Y');

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerEverHadPrivateHospital_1,
                hideField
            );
        });

        $elements.currentlyHaveAnyKindOfCoverPreResults.on('change', function toggleCurrentHealthFund() {
            var $checked = $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked'),
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
        $elements.additionalFieldsToHide.toggleClass('hidden', meerkat.modules.healthChoices.hasPartner() === false);
    }

    function getCurrentlyHaveAnyKindOfCoverPreResults() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val();
    }

    function onStartInit() {
        var $checked = $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked');
        if ($checked.length) {
            $checked.change();
        } else {
            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerCoverLoading,
                true
            );

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.partnerEverHadPrivateHospital_1,
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
    function getNeverHadPrivateHospital_1() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'N' && $elements.partnerEverHadPrivateHospital_1.filter(':checked').val() === 'N';
    }

    // iff true, the applicant's partner does not currently have any cover but has held 'Private Hospital Cover' in the past
    function getHeldPrivateHealthInsuranceBeforeButNotCurrently() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'N' && $elements.partnerEverHadPrivateHospital_1.filter(':checked').val() === 'Y';
    }

    // iff true, the applicant's partner currently has and has always had continuous 'Private Hospital Cover'
    // iff false, (the test below is a better indicator) the applicant's partner currently has (either Private Hospital or Extras cover) && has not had continuous Private Hospital, but has never explicitly been asked if they have ever held Private Hospital Cover
    // iff null, the applicant's partner has selected that they do not currently have (either 'Private Hospital' or 'Extras cover')
    function getContinuousCover() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'Y' ? $elements.partnerCoverLoading.filter(':checked').val() === 'Y' : null;
    }

    // if true, the applicant's partner currently has (either 'Private Hospital' or 'Extras cover') && has not had continuous Private hospital,
    // but has never explicitly been asked if they have ever held 'Private Hospital Cover'
    function getNeverExplicitlyAskedIfHeldPrivateHospitalCover() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'Y' && $elements.partnerCoverLoading.filter(':checked').val() === 'N';
    }

    function getNeverHadPrivateHospital_2() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'Y' && $elements.primaryCoverLoading.filter(':checked').val() === 'N' && $elements.primaryEverHadPrivateHospital_2.filter(':checked').val() === 'N';
    }

    function getHealthPreviousFund() {
        return (((_.isUndefined($elements.healthApplicationPartnerPreviousFund.filter(':selected').val())) || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === '') || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === 'OTHER')) ? (((_.isUndefined($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val())) || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === '') || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() ) : $elements.healthApplicationPartnerPreviousFund.filter(':selected').val() );
    }

    function getHealthPreviousFundDescription() {
        return (((_.isUndefined($elements.healthApplicationPartnerPreviousFund.filter(':selected').val())) || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === '') || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === 'OTHER')) ? (((_.isUndefined($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val())) || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === '') || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').text() ) : $elements.healthApplicationPartnerPreviousFund.filter(':selected').text() );
    }

    meerkat.modules.register('healthPartner', {
        init: initHealthPartner,
        getCurrentlyHaveAnyKindOfCoverPreResults: getCurrentlyHaveAnyKindOfCoverPreResults,
        onStartInit: onStartInit,
        getAppDob: getAppDob,
        getContinuousCover: getContinuousCover,
        getNeverHadPrivateHospital_1: getNeverHadPrivateHospital_1,
        getNeverHadPrivateHospital_2: getNeverHadPrivateHospital_2,
        getHeldPrivateHealthInsuranceBeforeButNotCurrently: getHeldPrivateHealthInsuranceBeforeButNotCurrently,
        getNeverExplicitlyAskedIfHeldPrivateHospitalCover: getNeverExplicitlyAskedIfHeldPrivateHospitalCover,
        getHealthPreviousFund: getHealthPreviousFund,
        getHealthPreviousFundDescription: getHealthPreviousFundDescription
    });

})(jQuery);