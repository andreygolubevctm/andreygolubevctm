;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $paymentDetailsStart,
        $paymentMedicareColour,
        $paymentMedicareCover,
        $medicareYellowMessage,
        $medicareExpiryDayWrapper,
        $medicareExpiryMonthWrapper,
        $medicareExpiryYearWrapper,
        $medicareExpiryGroupWrapper,
        $unitElements,
        $personName,
        $primaryName,
        _postalNonStdStreetRegexRule,
        $primaryMemberNumber,
        $partnerMemberNumber,
        $primarySameFundsScript,
        $partnerSameFundsScript;

    function init(){
        $(document).ready(function () {
            $paymentDetailsStart = $("#health_payment_details_start");
            $paymentMedicareColour = $("#health_payment_medicare_colour");
            $paymentMedicareCover = $("#health_payment_medicare_cover");
            $medicareYellowMessage = $("#health_medicareDetails_yellowCardMessage");
            $medicareExpiryDayWrapper = $("#health_payment_medicare_expiry_cardExpiryDay").parent().parent();
            $medicareExpiryMonthWrapper = $("#health_payment_medicare_expiry_cardExpiryMonth").parent().parent();
            $medicareExpiryYearWrapper = $("#health_payment_medicare_expiry_cardExpiryYear").parent().parent();
            $medicareExpiryGroupWrapper = $("#health_payment_medicare_expiry_cardExpiryMonth").parent().parent().parent().parent();

            $unitElements = {
                appAddressUnitShop: $('#health_application_address_unitShop'),
                appAddressStreetNum: $('#health_application_address_streetNum'),
                appAddressUnitType: $('#health_application_address_unitType'),
                appPostalUnitShop: $('#health_application_postal_unitShop'),
                appPostalStreetNum: $('#health_application_postal_streetNum'),
                appPostalUnitType: $('#health_application_postal_unitType'),
                appPostalNonStdStreet: $('#health_application_postal_nonStdStreet')
            };
            $personName = $('.contactField.person_name');
            $primaryName = {
                first: $('#health_application_primary_firstname'),
                middle: $('#health_application_primary_middleName'),
                last: $('#health_application_primary_surname'),
                medicare: {
                    first: $('#health_payment_medicare_firstName'),
                    middle: $('#health_payment_medicare_middleName'),
                    last: $('#health_payment_medicare_surname')
                }
            };

            $primaryMemberNumber = $('#health_previousfund_primary_memberID');
            $partnerMemberNumber = $('#health_previousfund_partner_memberID');
            $primarySameFundsScript = $('.simples-dialogue-same-funds-primary');
            $partnerSameFundsScript = $('.simples-dialogue-same-funds-partner');
            _postalNonStdStreetRegexRule = $unitElements.appPostalNonStdStreet.attr('data-rule-regex');
        });
    }

    function _createFieldReferences (applicant) {
        return   {
            previousFundNumber: $('input[name=health_previousfund_' + applicant + '_memberID]'),
            previousFundExtrasNumber: $('input[name=health_previousfund_' + applicant + '_extras_memberID]'),
        };
    }

    function _prefillPreviousFund(applicant) {
        var selectedFieldCurrentVal = applicant == 'primary'? meerkat.modules.healthPreviousFund.getPrimaryPreviousFund() : meerkat.modules.healthPreviousFund.getPartnerPreviousFund() ;

        if(selectedFieldCurrentVal !== ''){
            $('input[name=health_previousfund_' + applicant + '_fundNameHidden]').attr('value',selectedFieldCurrentVal);
            if( applicant == 'primary'){
                $('input[name=health_previousfund_' + applicant + '_fundNameInput]').val($('#health_healthCover_primary_previousFundName :selected').text());
            }else{
                $('input[name=health_previousfund_' + applicant + '_fundNameInput]').val($('#health_healthCover_partner_previousFundName :selected').text());
            }
            $('input[name=health_previousfund_' + applicant + '_fundNameInput]').trigger('keyup');
            $('input[name=health_previousfund_' + applicant + '_fundNameInput]').parent().find('ul').trigger('click');
        }
    }

    // Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
    function onBeforeEnter(){
        // validate at least 1 contact number is entered
        $('#health_application_mobileinput').addRule('requireOneContactNumber', true, 'Please include at least one phone number');

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PARTNER,
            meerkat.modules.healthAboutYou.getPartnerCurrentCover());

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PRIMARY,
            meerkat.modules.healthAboutYou.getPrimaryCurrentCover());

        // Default Check format message on person name field
        $personName.parent().find('.person-name-check-format').addClass('hidden');
        
        $primarySameFundsScript.toggleClass('hidden', meerkat.modules.healthAboutYou.getPrimaryCurrentCover() === 'N' || meerkat.modules.healthAboutYou.getPrimaryHealthCurrentCover() !== 'C');

        $partnerSameFundsScript.toggleClass('hidden', meerkat.modules.healthAboutYou.getPartnerCurrentCover() === 'N' || meerkat.modules.healthAboutYou.getPartnerHealthCurrentCover() !== 'C');

        meerkat.modules.healthCancellationType.init();

        _prefillPreviousFund('primary');

        if(meerkat.modules.healthAboutYou.getPrimaryCurrentCover() === 'N') {
            $primaryMemberNumber.removeAttr('required');
        }else {
            $primaryMemberNumber.attr('required', true);
        }

        if(meerkat.modules.health.hasPartner()) {
            _prefillPreviousFund('partner');
            if(meerkat.modules.healthAboutYou.getPartnerCurrentCover() === 'N') {
                $partnerMemberNumber.removeAttr('required');
            }else {
                $partnerMemberNumber.attr('required', true);
            }
        }

        if(_.indexOf(['E','H'], meerkat.modules.healthAboutYou.getPrimaryHealthCurrentCover()) >= 0 && !meerkat.modules.healthPreviousFund.getPrimaryHasSameFund()) {
            $('#health_application_primary_cover_sameProviders_Y').prop('checked', true).change();
        }

        if(meerkat.modules.health.hasPartner() && _.indexOf(['E','H'], meerkat.modules.healthAboutYou.getPartnerHealthCurrentCover()) >= 0 && !meerkat.modules.healthPreviousFund.getPartnerHasSameFund()) {
            $('#health_application_partner_cover_sameProviders_Y').prop('checked', true).change();
        }
    }

    function onInitialise() {
        $paymentMedicareColour
            .addRule('medicareCardColour')
            .on('change', function() {
                var value = $(this).val();
                // set hidden Medicare cover value
                $paymentMedicareCover.val(value === 'none' ? 'N' : 'Y');

                // toggle message for Yellow card holders
                $medicareYellowMessage.toggleClass('hidden', value !== 'yellow');

                // Show expiry day field if yellow or blue medicare card and adjust field widths to suit
                var showMedicareDayField = (value === 'yellow' || value === 'blue');

                $medicareExpiryDayWrapper.toggleClass('hidden', !showMedicareDayField);

                $medicareExpiryMonthWrapper.toggleClass('col-xs-4  allow-for-exp-day', showMedicareDayField);
                $medicareExpiryMonthWrapper.toggleClass('col-xs-6', !showMedicareDayField);

                $medicareExpiryYearWrapper.toggleClass('col-xs-4', showMedicareDayField);
                $medicareExpiryYearWrapper.toggleClass('col-xs-6', !showMedicareDayField);
            })
            .trigger('change');

        // initialise start date datepicker from payment step as it will be used by selected fund
        $paymentDetailsStart
            .datepicker({ clearBtn:false, format:"dd/mm/yyyy" })
            .on("changeDate", function updateStartCoverDateHiddenField(e) {
                // fill the hidden field with selected value
                $("#health_payment_details_start").val( e.format() );
                meerkat.messaging.publish(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM);
            });

        $unitElements.appPostalUnitType.on('change', function toggleUnitRequiredFields() {
            _changeOtherFields(this.value);
            _toggleRegexValidation(this.value);
        }).trigger('change');

        $unitElements.appPostalStreetNum.on('blur', function () {
            setTimeout(function () {
                var $errorField = $('#health_application_postal_streetNum-error');
                var val = $unitElements.appPostalNonStdStreet.val();
                if ($errorField.length > 0 && (val == null || val.trim() === '')) {
                    if ($unitElements.appPostalUnitType.val() === 'PO') {
                        $errorField.text('Please enter "Po Box"');
                    } else {
                        $errorField.text('Please enter a street number');
                    }
                }
            }, 10);
        });

        $unitElements.appPostalNonStdStreet.on('blur', function () {
            setTimeout(function () {
                var $errorField = $('#health_application_postal_nonStdStreet-error');
                var val = $unitElements.appPostalNonStdStreet.val();
                if ($errorField.length > 0 && (val == null || val.trim() === '')) {
                    if ($unitElements.appPostalUnitType.val() === 'PO') {
                        $errorField.text('Please enter a box number');
                    } else {
                        $errorField.text('Please enter the postal street');
                    }
                }
            }, 10);
        });

        $unitElements.appAddressUnitShop.add($unitElements.appPostalUnitShop).on('change', function toggleUnitShopRequiredFields() {
            _toggleUnitShopRequired(this.id.indexOf('address') !== -1 ? 'Address' : 'Postal', !_.isEmpty(this.value));
        });

        initCapitalisationChecks();

        $primaryName.first.on('blur.apply', function(){
            $primaryName.medicare.first.val($primaryName.first.val());
        });

        $primaryName.middle.on('blur.apply', function(){
            $primaryName.medicare.middle.val($primaryName.middle.val());
        });

        $primaryName.last.on('blur.apply', function(){
            $primaryName.medicare.last.val($primaryName.last.val());
        });

        $primaryMemberNumber.on('keyup', function() {
            var input = $(this);
            var value = input.val().replace(/[\W_]+/g, '');
            input.val(value);
        });

        $partnerMemberNumber.on('keyup', function() {
            var input = $(this);
            var value = input.val().replace(/[\W_]+/g, '');
            input.val(value);
        });

        meerkat.messaging.subscribe(meerkat.modules.events.healthDependants.DEPENDANTS_RENDERED, initCapitalisationChecks);

        var $primary = _createFieldReferences('primary');
        var $partner = _createFieldReferences('partner');

        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function(step) {
            if(step.navigationId === 'apply') {
                var isAHM = Results.getSelectedProduct().info.FundCode === "AHM";
                $primary.previousFundNumber.prop("required", !isAHM);
                $partner.previousFundNumber.prop("required", !isAHM);
                $primary.previousFundExtrasNumber.prop("required", !isAHM);
                $partner.previousFundExtrasNumber.prop("required", !isAHM);

                if(isAHM) {
                    $primary.previousFundNumber.parent().toggleClass('has-error', false);
                    $partner.previousFundNumber.parent().toggleClass('has-error', false);
                    $primary.previousFundExtrasNumber.parent().toggleClass('has-error', false);
                    $partner.previousFundExtrasNumber.parent().toggleClass('has-error', false);

                    $primary.previousFundNumber.parent().find('label').remove();
                    $partner.previousFundNumber.parent().find('label').remove();
                    $primary.previousFundExtrasNumber.parent().find('label').remove();
                    $partner.previousFundExtrasNumber.parent().find('label').remove();

                    $('#applicationDetailsForm .journeyNavButtonError').toggleClass("hidden", true);
                }
            }
        });
    }

    function initCapitalisationChecks() {

        // Show "Check Capitalisation" message when value fails validation
        $('.check-capitalisation').off('change.capitalisationCheck')
        .on('change.capitalisationCheck', function checkCapitalisation() {
            var $that = $(this),
                value = $.trim($that.val()),
                showCheckCapitalisation = false,
                $checkCapitalisation = $that.parent().find('.person-name-check-format'),
                utils = meerkat.modules.stringUtils;

            if (!_.isEmpty(value)) {
                if ($that.hasClass('expect-sentence-case')) {
                    showCheckCapitalisation = utils.hasMultipleUppercase(value) || utils.startsWithLowercase(value);
                } else if ($that.hasClass('expect-title-case')) {
                    showCheckCapitalisation = utils.hasWordsStartingLowercase(value) || utils.isAllUppercase() || utils.hasWordsWithMultipleUppercase(value);
                } else {
                    // do nothing;
                }
            } else {
                // do nothing
            }

            $checkCapitalisation.toggleClass('hidden', showCheckCapitalisation === false);
        });
    }

    function _changeOtherFields(unitType) {
        //

        //For Simples, below are not correct
        var msgRequired = null,
            msgRequired2 = null;

        resetInputField('#health_application_postal_streetNumRow');
        resetInputField('#health_application_postal_nonStd_streetRow');
        if (unitType === 'PO') {
            $unitElements.appPostalStreetNum.closest('.form-group').find('p').text('Enter text "Po Box"');
            $unitElements.appPostalStreetNum.attr('placeholder', 'Please enter "Po Box"');
            msgRequired = 'Please enter "Po Box"';
            $unitElements.appPostalUnitShop.closest('.form-group').hide();
            $unitElements.appPostalNonStdStreet.closest('.form-group').find('p').text("Po Box number");
            $unitElements.appPostalNonStdStreet.attr('placeholder', 'Enter a box number e.g. 66');
            msgRequired2 = 'Please enter a box number';
        } else {
            $unitElements.appPostalStreetNum.closest('.form-group').find('p').text('Street Number');
            $unitElements.appPostalStreetNum.attr('placeholder', 'Enter street number e.g. 66');
            msgRequired = 'Please enter a street number';
            $unitElements.appPostalUnitShop.closest('.form-group').show();
            $unitElements.appPostalNonStdStreet.closest('.form-group').find('p').text("Street Name");
            $unitElements.appPostalNonStdStreet.attr('placeholder', 'Enter street name e.g. Smith Street');
            msgRequired2 = 'Please enter the postal street';
        }
        $unitElements.appPostalStreetNum.attr('data-msg-required', msgRequired);
        $unitElements.appPostalNonStdStreet.attr('data-msg-required', msgRequired2);
    }

    function _toggleRegexValidation(unitType) {
        if (unitType === 'PO') {
            $unitElements.appPostalNonStdStreet.removeRule('regex');
        } else {
            $unitElements.appPostalNonStdStreet.addRule('regex', _postalNonStdStreetRegexRule);
        }
    }

    function resetInputField(inputRowElement) {
        $(inputRowElement).find('input[type=text].form-control').val('');
        $(inputRowElement).find('.error-field').remove();
        $(inputRowElement).find('.has-error').removeClass('has-error');
    }

    function _toggleUnitShopRequired(addressType, isUnitShop) {
        $unitElements['app'+addressType+'UnitType'].setRequired(isUnitShop);

        // blur out of fields to trigger validation when unitShop not empty
        if (!isUnitShop) {
            $unitElements['app'+addressType+'UnitType'].blur();
        }
    }

    meerkat.modules.register('healthApplyStep', {
        init: init,
        onBeforeEnter: onBeforeEnter,
        onInitialise: onInitialise,
        initCapitalisationChecks: initCapitalisationChecks
    });

})(jQuery);