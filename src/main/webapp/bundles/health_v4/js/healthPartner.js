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
            additionalFieldsToHide: $('#health_insurance_preferences_additional_partner_fields'),
            benefitsScrollerLinks: $('.benefitsScroller'),
            coverLoadingHeading: $('.benefitsContainer').find('h3:first-child'),
            appDob: $('#health_application_partner_dob'),
            healthInsurancePreferencesPartnerPreviousFund: $(':input[name=health_healthCover_partner_fundName]').children('option'),
            healthApplicationPartnerPreviousFund: $(':input[name=health_previousfund_partner_fundName]').children('option')
        };

        $elements.partnerCoverLoading.add($elements.dob).add($elements.currentCover).attr('data-attach','true');

        $elements.partnerQuestionSet = $elements.partnerDOBD.add($elements.currentCover).add($elements.partnerHeading);
    }

    function _applyEventListeners() {

        $elements.dob.on('change', function updateSnapshot() {
            meerkat.messaging.publish(meerkatEvents.health.SNAPSHOT_FIELDS_CHANGE);
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
        $elements.additionalFieldsToHide.toggleClass('hidden', meerkat.modules.healthChoices.hasPartner() === false);
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
                $elements.partnerCurrentFundName,
                true
            );

        }
    }

    function getAppDob() {
        return $elements.appDob.val();
    }

    function getHealthPreviousFund() {
        return (((_.isUndefined($elements.healthApplicationPartnerPreviousFund.filter(':selected').val())) || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === '') || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === 'OTHER')) ? (((_.isUndefined($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val())) || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === '') || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() ) : $elements.healthApplicationPartnerPreviousFund.filter(':selected').val() );
    }

    function getHealthPreviousFundDescription() {
        return (((_.isUndefined($elements.healthApplicationPartnerPreviousFund.filter(':selected').val())) || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === '') || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthApplicationPartnerPreviousFund.filter(':selected').val() === 'OTHER')) ? (((_.isUndefined($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val())) || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === '') || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === 'NONE') || ($elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements.healthInsurancePreferencesPartnerPreviousFund.filter(':selected').text() ) : $elements.healthApplicationPartnerPreviousFund.filter(':selected').text() );
    }

    meerkat.modules.register('healthPartner', {
        init: initHealthPartner,
        getCurrentCover: getCurrentCover,
        onStartInit: onStartInit,
        getAppDob: getAppDob,
        getHealthPreviousFund: getHealthPreviousFund,
        getHealthPreviousFundDescription: getHealthPreviousFundDescription
    });

})(jQuery);