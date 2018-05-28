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
            primaryCoverLoading: $(':input[name=health_healthCover_primary_healthCoverLoading]'),
            primaryCoverRow: $('#health_healthCover_primaryCover'),
            currentCover: $('input[name=health_healthCover_primary_cover]'),
            primaryEverHadCover: $(':input[name=health_healthCover_primary_everHadCover]'),
            primaryCurrentFundName: $(':input[name=health_healthCover_primary_fundName]'),
            dob: $('#health_healthCover_primary_dob'),
            partnerDOB: $('#benefits_partner_dob'),
            appDob: $('#health_application_primary_dob'),
            healthAboutYouPrimaryPreviousFund: $(':input[name=health_healthCover_primary_fundName]').children('option'),
            healthApplicationPrimaryPreviousFund: $(':input[name=health_previousfund_primary_fundName]').children('option')
        };

	    $elements.primaryCoverLoading.add($elements.dob).add($elements.currentCover).attr('data-attach','true');
    }

    function _applyEventListeners() {
        $elements.currentCover.add($elements.dob).on('change', function toggleContinuousCover() {
            var $checked = $elements.currentCover.filter(':checked'),
                hideField = !$checked.length || ($checked.val() === 'N') || ($checked.val() === 'Y' && meerkat.modules.age.isLessThan31Or31AndBeforeJuly1($elements.dob.val()));

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryCoverLoading,
                hideField
            );
        });

        $elements.currentCover.on('change', function toggleEverHadCover() {
            var $checked = $elements.currentCover.filter(':checked'),
                hideField = !$checked.length || ($checked.val() === 'Y');

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryEverHadCover,
                hideField
            );
        });

        $elements.currentCover.on('change', function toggleCurrentHealthFund() {
            var $checked = $elements.currentCover.filter(':checked'),
                hideField = !$checked.length || ($checked.val() === 'N');

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryCurrentFundName,
                hideField
            );
        });

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
                $elements.primaryCoverLoading,
                true
            );

            meerkat.modules.fieldUtilities.toggleVisible(
                $elements.primaryEverHadCover,
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
    function getNeverHadCover() {
        return $elements.currentCover.filter(':checked').val() === 'N' && $elements.primaryEverHadCover.filter(':checked').val() === 'N';
    }

    // iff true, the applicant does not currently have any cover but has held 'Private Hospital Cover' in the past
    function getHeldPrivateHealthInsuranceBeforeButNotCurrently() {
        return $elements.currentCover.filter(':checked').val() === 'N' && $elements.primaryEverHadCover.filter(':checked').val() === 'Y';
    }

    // iff true, the applicant currently has and has always had continuous 'Private Hospital Cover'
    // iff false, (the test below is a better indicator) the primary applicant currently has (either Private Hospital or Extras cover) && has not had continuous Private Hospital, but has never explicitly been asked if they have ever held Private Hospital Cover
    // iff null, the applicant has selected that they do not currently have (either 'Private Hospital' or 'Extras cover')
    function getContinuousCover() {
        return $elements.currentCover.filter(':checked').val() === 'Y' ? $elements.primaryCoverLoading.filter(':checked').val() === 'Y' : null;
    }

    // if true, the primary applicant currently has (either Private Hospital or Extras cover) && has not had continuous Private hospital,
    // but has never explicitly been asked if they have ever held Private Hospital Cover
    function getNeverExplicitlyAskedIfHeldPrivateHospitalCover() {
        return $elements.currentCover.filter(':checked').val() === 'Y' && $elements.primaryCoverLoading.filter(':checked').val() === 'N';
    }

    function getHealthPreviousFund() {
        return ((($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === '') || (typeof $elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'undefined') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? ((($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === '') || (typeof $elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'undefined') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() ) : $elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() );
    }

    function getHealthPreviousFundDescription() {
        return ((($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === '') || (typeof $elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'undefined') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? ((($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === '') || (typeof $elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'undefined') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements.healthAboutYouPrimaryPreviousFund.filter(':selected').text() ) : $elements.healthApplicationPrimaryPreviousFund.filter(':selected').text() );
    }

    meerkat.modules.register('healthPrimary', {
        init: initHealthPrimary,
        getCurrentCover: getCurrentCover,
        onStartInit: onStartInit,
        getAppDob: getAppDob,
        getContinuousCover: getContinuousCover,
        getNeverHadCover: getNeverHadCover,
        getHeldPrivateHealthInsuranceBeforeButNotCurrently: getHeldPrivateHealthInsuranceBeforeButNotCurrently,
        getNeverExplicitlyAskedIfHeldPrivateHospitalCover: getNeverExplicitlyAskedIfHeldPrivateHospitalCover,
        getHealthPreviousFund: getHealthPreviousFund,
        getHealthPreviousFundDescription: getHealthPreviousFundDescription
    });

})(jQuery);