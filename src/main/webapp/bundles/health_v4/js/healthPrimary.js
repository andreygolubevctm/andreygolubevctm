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
                $elements.primaryCurrentFundName,
                true
            );

        }
    }

    function getAppDob() {
        return $elements.appDob.val();
    }

    function getHealthPreviousFund() {
        return (((_.isUndefined($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val())) || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === '') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? (((_.isUndefined($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val())) || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === '') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() ) : $elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() );
    }

    function getHealthPreviousFundDescription() {
        return (((_.isUndefined($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val())) || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === '') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthApplicationPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? (((_.isUndefined($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val())) || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === '') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthAboutYouPrimaryPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements.healthAboutYouPrimaryPreviousFund.filter(':selected').text() ) : $elements.healthApplicationPrimaryPreviousFund.filter(':selected').text() );
    }

    meerkat.modules.register('healthPrimary', {
        init: initHealthPrimary,
        getCurrentCover: getCurrentCover,
        onStartInit: onStartInit,
        getAppDob: getAppDob,
        getHealthPreviousFund: getHealthPreviousFund,
        getHealthPreviousFundDescription: getHealthPreviousFundDescription
    });

})(jQuery);