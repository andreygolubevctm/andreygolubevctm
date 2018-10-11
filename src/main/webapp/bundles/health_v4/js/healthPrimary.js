;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {};

    function initHealthPrimary() {
        _setupFields();
        _applyEventListeners();
    }

    function _setupFields() {
        $elements = {
            primaryCoverLoading: $('input[name=health_healthCover_primary_healthCoverLoading]'),
            primaryCoverRow: $('#health_healthCover_primaryCover'),
            currentlyHaveAnyKindOfCoverPreResults: $('input[name=health_healthCover_primary_cover]'),
            primaryEverHadPrivateHospital_1: $('input[name=health_application_primary_everHadCoverPrivateHospital1]'),
            primaryEverHadPrivateHospital_2: $('input[name=health_application_primary_everHadCoverPrivateHospital2]'),
            primaryCurrentFundName: $('select[name=health_healthCover_primary_fundName]'),
            dob: $('#health_healthCover_primary_dob'),
            partnerDOB: $('#benefits_partner_dob'),
            appDob: $('#health_application_primary_dob'),
            healthAboutYouPrimaryPreviousFund: $('select[name=health_healthCover_primary_fundName]').children('option'),
            healthApplicationPrimaryPreviousFund: $('select[name=health_previousfund_primary_fundName]').children('option')
        };

	    $elements.primaryCoverLoading.add($elements.dob).add($elements.currentlyHaveAnyKindOfCoverPreResults).attr('data-attach','true');
    }

    function _applyEventListeners() {
        $elements.currentlyHaveAnyKindOfCoverPreResults.add($elements.dob).on('change', function toggleContinuousCover() {
            var $checked = $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked'),
                hideField = !$checked.length || ($checked.val() === 'N') || ($checked.val() === 'Y' && !meerkat.modules.age.isAgeLhcApplicable($elements.dob.val()));

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryCoverLoading,
                hideField
            );
        });

        $elements.currentlyHaveAnyKindOfCoverPreResults.on('change', function toggleEverHadPrivateHospitalCover_1() {
            var $checked = $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked'),
                hideField = !$checked.length || ($checked.val() === 'Y');

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryEverHadPrivateHospital_1,
                hideField
            );
        });

        $elements.currentlyHaveAnyKindOfCoverPreResults.on('change', function toggleCurrentHealthFund() {
            var $checked = $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked'),
                hideField = !$checked.length || ($checked.val() === 'N');

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryCurrentFundName,
                hideField
            );
        });

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
                $elements.primaryCoverLoading,
                true
            );

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryEverHadPrivateHospital_1,
                true
            );

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryCurrentFundName,
                true
            );

        }
    }

    function getAppDob() {
        return $elements.appDob.val();
    }

    // iff true, the applicant has never held 'Private Hospital Cover'
    function getNeverHadPrivateHospital_1() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'N' && $elements.primaryEverHadPrivateHospital_1.filter(':checked').val() === 'N';
    }

    // iff true, the applicant does not currently have any cover but has held 'Private Hospital Cover' in the past
    function getHeldPrivateHealthInsuranceBeforeButNotCurrently() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'N' && $elements.primaryEverHadPrivateHospital_1.filter(':checked').val() === 'Y';
    }

    // iff true, the applicant currently has and has always had continuous 'Private Hospital Cover'
    // iff false, (the test below is a better indicator) the primary applicant currently has (either Private Hospital or Extras cover) && has not had continuous Private Hospital, but has never explicitly been asked if they have ever held Private Hospital Cover
    // iff null, the applicant has selected that they do not currently have (either 'Private Hospital' or 'Extras cover')
    function getContinuousCover() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'Y' ? $elements.primaryCoverLoading.filter(':checked').val() === 'Y' : null;
    }

    // if true, the primary applicant currently has (either Private Hospital or Extras cover) && has not had continuous Private hospital,
    // but has never explicitly been asked if they have ever held Private Hospital Cover
    function getNeverExplicitlyAskedIfHeldPrivateHospitalCover() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'Y' && $elements.primaryCoverLoading.filter(':checked').val() === 'N';
    }

    function getNeverHadPrivateHospital_2() {
        return $elements.currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'Y' && $elements.primaryCoverLoading.filter(':checked').val() === 'N' && $elements.primaryEverHadPrivateHospital_2.filter(':checked').val() === 'N';
    }

    function getHealthPreviousFund() {
        return (((_.isUndefined($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val())) || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === '') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? (((_.isUndefined($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val())) || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === '') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() ) : $elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() );
    }

    function getHealthPreviousFundDescription() {
        return (((_.isUndefined($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val())) || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === '') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? (((_.isUndefined($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val())) || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === '') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements.healthAboutYouPrimaryPreviousFund.filter(':selected').text() ) : $elements.healthApplicationPrimaryPreviousFund.filter(':selected').text() );
    }

    meerkat.modules.register('healthPrimary', {
        init: initHealthPrimary,
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