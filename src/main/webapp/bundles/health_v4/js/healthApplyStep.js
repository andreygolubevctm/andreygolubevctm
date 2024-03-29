;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        $unitElements,
        _postalNonStdStreetRegexRule;

    function init(){
        $(document).ready(function () {
            $elements = {
                primaryFirstname: $('#health_application_primary_firstname'),
                paymentMedicareColour: $('input[name=health_payment_medicare_colour]'),
                paymentMedicareCover: $("#health_payment_medicare_cover"),
                medicareYellowMessage: $("#health_medicareDetails_yellowCardMessage"),
                medicareExpiryDayWrapper: $("#health_payment_medicare_expiry_cardExpiryDay").parent().parent(),
                medicareExpiryMonthWrapper: $("#health_payment_medicare_expiry_cardExpiryMonth").parent().parent(),
                medicareExpiryYearWrapper: $("#health_payment_medicare_expiry_cardExpiryYear").parent().parent(),
                medicareExpiryGroupWrapper: $("#health_payment_medicare_expiry_cardExpiryMonth").parent().parent().parent().parent(),
                genderToggle: $('.person-gender-toggle input[type=radio]'),
                appMobile: $('#health_application_mobileinput'),
                appPostcode: $('#health_application_address_postCode'),
                appStreetSearch: $('#health_application_address_streetSearch'),
                appSuburb: $('#health_application_address_suburb'),
                appSuburbName: $('#health_application_address_suburbName'),
                appState: $('#health_application_address_state'),
                healthSituationState: $('#health_situation_state'),
                healthProductHospitalClass: $('#health_application_productClassification_hospital'),
                healthProductExtrasClass: $('#health_application_productClassification_extras'),
                primary: _createFieldReferences('primary'),
                partner: _createFieldReferences('partner')
            };

            $unitElements = {
                appAddressUnitShop: $('#health_application_address_unitShop'),
                appAddressStreetNum: $('#health_application_address_streetNum'),
                appAddressUnitType: $('#health_application_address_unitType'),
                appPostalUnitShop: $('#health_application_postal_unitShop'),
                appPostalStreetNum: $('#health_application_postal_streetNum'),
                appPostalUnitType: $('#health_application_postal_unitType'),
                appPostalNonStdStreet: $('#health_application_postal_nonStdStreet')
            };

            _postalNonStdStreetRegexRule = $unitElements.appPostalNonStdStreet.attr('data-rule-regex');
        });
    }

    function _createFieldReferences (applicant) {
        var applicantFields =  {
            currentlyHaveAnyKindOfCoverPreResults: $('input[name=health_healthCover_' + applicant + '_cover]'),
            currentlyHaveAnyKindOfCoverPreResultsBtnGroup: $('#_' + applicant + '_health_cover'),
            currentlyHaveAnyKindOfCoverApplyPage: $('#health_application_' + applicant + '_health_cover'),
            healthFundHistoryRow: $('#' + applicant + 'FundHistory'),
            healthApplicationDOB: $('#health_application_' + applicant + '_dob'),
            aboutYouPreviousFund: $('select[name=health_healthCover_' + applicant + '_fundName]').children('option'),
            healthApplicationPreviousFund: $('select[name=health_previousfund_' + applicant + '_fundName]').children('option'),
            healthApplicationPreviousFundLabel: $('[for=health_previousfund_' + applicant + '_fundName]'),
            previousCoverTypeRow: $('#health_application_' + applicant + 'CoverType'),
            previousCoverType: $('input[name=health_application_' + applicant + '_cover_type]'),
            previousCoverSameProvidersCheckboxRow: $('#health_application_' + applicant + 'CoverSameProviders'),
            hospitalFundHeader: $('#' + applicant + 'HospitalCover'),
            everHadPrivateHospitalRow_1: $('#health_application_' + applicant + 'CoverEverHadPrivateHospital1'),
            everHadPrivateHospitalBtnGroup_1: $('#health_application_' + applicant + '_ever_had_health_coverPrivateHospital1'),
            everHadPrivateHospital_1: $('input[name=health_application_' + applicant + '_everHadCoverPrivateHospital1]'),
            publicHospital1NoCoverText: $('#health_application_' + applicant + 'CoverEverHadPrivateHospital1').find('.applyFullLHCAdditionalText'),
            everHadPrivateHospitalRow_2: $('#health_application_' + applicant + 'CoverEverHadPrivateHospital2'),
            everHadPrivateHospitalBtnGroup_2: $('#health_application_' + applicant + '_ever_had_health_coverPrivateHospital2'),
            everHadPrivateHospital_2: $('input[name=health_application_' + applicant + '_everHadCoverPrivateHospital2]'),
            publicHospital2NoCoverText: $('#health_application_' + applicant + 'CoverEverHadPrivateHospital2').find('.applyFullLHCAdditionalText'),
            healthContinuousCoverRow: $('#health-continuous-cover-' + applicant),
            healthContinuousCoverBtnGroup: $('#_' + applicant + '_health_cover_loading'),
            healthContinuousCover:  $('input[name=health_healthCover_' + applicant + '_healthCoverLoading]'),
            iDontKnowMyDateRangesRow:  $('#' + applicant + 'LhcDatesUnsureApplyFullLHC'),
            iDontKnowMyDateRanges:  $('input[name=health_previousfund_' + applicant + '_fundHistory_dates_unsure]'),
            iDontKnowMyDateRangesPromptText: $('#' + applicant + 'LhcDatesUnsureApplyFullLHC .applyFullLHCAdditionalText'),
            receivesAgeBasedDiscountRow: $('#' + applicant + '_abd'),
            receivesAgeBasedDiscount: $('#' + applicant + '_abd_health_cover'),
            ageBasedDiscountPolicyStartRow: $('#health_previousfund_' + applicant + '_abd_start_date'),
            previousFundNumber: $('input[name=health_previousfund_' + applicant + '_memberID]'),
            previousFundExtrasNumber: $('input[name=health_previousfund_' + applicant + '_extras_memberID]'),
            extrasFund: $('#' + applicant + 'extrasfund')
        };

        if (applicant === 'primary') {
            applicantFields['currentlyHaveAnyKindOfCoverPreResultsBtnGroup'] = $('#health_healthCover_health_cover');
            applicantFields['currentlyHaveAnyKindOfCoverApplyPage'] = $('#health_application_health_cover');
            applicantFields['everHadPrivateHospitalBtnGroup_1'] = $('#health_application_ever_had_health_coverPrivateHospital1');
            applicantFields['everHadPrivateHospitalBtnGroup_2'] = $('#health_application_ever_had_health_coverPrivateHospital2');
            applicantFields['healthContinuousCoverBtnGroup'] = $('#health_healthCover_health_cover_loading');
        }

        return applicantFields;
    }

    // Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
    function onBeforeEnter() {
        // validate at least 1 contact number is entered
        $elements.appMobile.addRule('requireOneContactNumber', true, 'Please include at least one phone number');

        _prefill_currentlyHaveAnyKindOfCover('primary');
        _prefillPreviousFund('primary');
        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PRIMARY,
            meerkat.modules.healthPrimary.getCurrentlyHaveAnyKindOfCoverPreResults());

        if (meerkat.modules.healthChoices.hasPartner()) {
            _prefill_currentlyHaveAnyKindOfCover('partner');
            _prefillPreviousFund('partner');
        }
        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PARTNER,
            meerkat.modules.healthPartner.getCurrentlyHaveAnyKindOfCoverPreResults());

        _toggleSelectGender('primary');
        _toggleCurrentlyHaveAnyKindOfCover('primary');

        if (meerkat.modules.healthChoices.hasPartner()) {
            _toggleSelectGender('partner');
            _toggleCurrentlyHaveAnyKindOfCover('partner');
        }

        setRabdQuestions();
        setHospitalCoverClass();
        setExtrasCoverClass();

        meerkat.messaging.subscribe(meerkatEvents.TRIGGER_UPDATE_PREMIUM, function triggerUpdatePremium(){
            _toggleAgeBasedDiscountQuestion('primary');
            if (meerkat.modules.healthChoices.hasPartner()) {
                _toggleAgeBasedDiscountQuestion('partner');
            }
		});
    }

    function onInitialise() {
        _applyEventListeners();
        _applyEventListenersByApplicant('primary');
        _applyEventListenersByApplicant('partner');
    }

    function _applyEventListeners() {

        // Listen to any input field which could change the premium. (on step 4 and 5)
        $(".changes-premium :input").on('change', function(){
            meerkat.messaging.publish(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM);
        });

        // Check state selection
        $elements.appPostcode.add($elements.appStreetSearch).add($elements.appSuburb).on('change', function() {
            testStatesParity();
        });

        $elements.paymentMedicareColour
            .addRule('medicareCardColour')
            .on('change', function() {
                var value = $elements.paymentMedicareColour.filter(':checked').val();
                // set hidden Medicare cover value
                $elements.paymentMedicareCover.val(value === 'none' ? 'N' : 'Y');

                // toggle message for Yellow card holders
                $elements.medicareYellowMessage.toggleClass('hidden', value !== 'yellow');

                // Show expiry day field if yellow or blue medicare card and adjust field widths to suit
                var showMedicareDayField = (value === 'yellow' || value === 'blue');

                $elements.medicareExpiryDayWrapper.toggleClass('hidden', !showMedicareDayField);

                $elements.medicareExpiryMonthWrapper.toggleClass('col-xs-4 allow-for-exp-day', showMedicareDayField);
                $elements.medicareExpiryMonthWrapper.toggleClass('col-xs-6', !showMedicareDayField);

                $elements.medicareExpiryYearWrapper.toggleClass('col-xs-4', showMedicareDayField);
                $elements.medicareExpiryYearWrapper.toggleClass('col-xs-6', !showMedicareDayField);
            })
            .trigger('change');

        if ($elements.paymentMedicareColour.is(":checked")) {
            $('input[name=health_payment_medicare_colour][value=' + $elements.paymentMedicareColour.val() + ']').attr('checked', 'checked').trigger('change');
        }

        $(document.body).on('change', '.selectContainerTitle select', function onTitleChange() {
            var applicant = $(this).closest('.qe-window').find('.health-person-details').hasClass('primary') ? 'primary' : 'partner';

            _toggleSelectGender(applicant);

            if (meerkat.modules.healthDependants.getNumberOfDependants() > 0) {
                for (var i = 1; i <= meerkat.modules.healthDependants.getNumberOfDependants(); i++) {
                    var dependant = 'dependants_dependant' + i;
                    _toggleSelectGender(dependant);
                }
            }

        });

        $elements.genderToggle.on('change', function onGenderToggle() {
            var applicant = $(this).closest('.qe-window').find('.health-person-details')
                                       .hasClass('primary') ? 'primary' : 'partner',
                gender = $(this).val();

            $('#health_application_' + applicant + '_gender').val(gender);
        });

        $unitElements.appPostalUnitType.on('change', function toggleUnitRequiredFields() {
            _changeStreetNoLabel(this.value);
            _toggleRegexValidation(this.value);
        });

        $unitElements.appAddressUnitShop.add($unitElements.appPostalUnitShop).on('change', function toggleUnitShopRequiredFields() {
            _toggleUnitShopRequired(this.id.indexOf('address') !== -1 ? 'Address' : 'Postal', !_.isEmpty(this.value));
        });

        meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function(step) {
            if(step.navigationId === 'apply') {
                var isAHM = Results.getSelectedProduct().info.FundCode === "AHM";
                $elements.primary.previousFundNumber.prop("required", !isAHM);
                $elements.partner.previousFundNumber.prop("required", !isAHM);
                $elements.primary.previousFundExtrasNumber.prop("required", !isAHM);
                $elements.partner.previousFundExtrasNumber.prop("required", !isAHM);

                if(isAHM) {
                    $elements.primary.previousFundNumber.parent().toggleClass('has-error', false);
                    $elements.partner.previousFundNumber.parent().toggleClass('has-error', false);
                    $elements.primary.previousFundExtrasNumber.parent().toggleClass('has-error', false);
                    $elements.partner.previousFundExtrasNumber.parent().toggleClass('has-error', false);

                    $elements.primary.previousFundNumber.parent().find('label').remove();
                    $elements.partner.previousFundNumber.parent().find('label').remove();
                    $elements.primary.previousFundExtrasNumber.parent().find('label').remove();
                    $elements.partner.previousFundExtrasNumber.parent().find('label').remove();

                    $('#applicationDetailsForm .journeyNavButtonError').toggleClass("hidden", true);
                }
            }
        });
    }

    function _applyEventListenersByApplicant(applicant) {

        $elements[applicant].healthApplicationDOB.on('change', function() {
            _toggleCurrentlyHaveAnyKindOfCover(applicant);
            _toggleAgeBasedDiscountQuestion(applicant);
        });

        $elements[applicant].previousFundNumber.on('keyup', function() {
            var input = $(this);
            var value = input.val().replace(/[\W_]+/g, '');
            input.val(value);
        });

        $elements[applicant].currentlyHaveAnyKindOfCoverApplyPage.find(':input').on('change', function() {
            _toggleCurrentlyHaveAnyKindOfCover(applicant);
            _toggleAgeBasedDiscountQuestion(applicant);
        });

        $elements[applicant].everHadPrivateHospitalRow_1.find(':input').on('change', function() {
            _toggleFundHistory(applicant);
            _toggleAgeBasedDiscountQuestion(applicant);

            meerkat.messaging.publish(meerkatEvents.healthPreviousFund['POPULATE_' + applicant.toUpperCase()], ($elements[applicant].everHadPrivateHospital_1.filter(':checked').val() === 'Y' ? 'Y' : 'N' ));
        });

        $elements[applicant].previousCoverSameProvidersCheckboxRow.find(':input').on('change', function() {
            _toggleSameProviders(applicant);
        });

        $elements[applicant].previousCoverTypeRow.find(':input').on('change', function() {
            _toggleSameProvidersCheckbox(applicant);
        });

        $elements[applicant].healthContinuousCoverRow.find(':input').on('change', function() {
            _toggleEverHadPrivateHospitalCover2(applicant);
            _toggleFundHistory(applicant);
        });

        $elements[applicant].everHadPrivateHospitalRow_2.find(':input').on('change', function() {
            _toggleFundHistory(applicant);
        });

        $elements[applicant].iDontKnowMyDateRanges.on('change', function() {
            _toggleFundHistory(applicant);
        });

    }

    function convertDate(date) {
        var dobSplit = date.split('/');
        return new Date(dobSplit[1] + '/' + dobSplit[0] + '/' + dobSplit[2]);
    }

    function _toggleAgeBasedDiscountQuestion(applicant) {
        var dob = convertDate($elements[applicant].healthApplicationDOB.val());

        if(!dob) return;

        var coverDate = convertDate(meerkat.modules.healthCoverStartDate.getVal());

        var curDate = (meerkat.site.serverDate.getTime() !== coverDate.getTime()) ? coverDate : meerkat.site.serverDate;

        var age = new Date(curDate.getTime() - dob.getTime()).getFullYear() - 1970;
        var selectedProduct = Results.getSelectedProduct();

        if((selectedProduct.custom.reform && selectedProduct.custom.reform.yad !== 'R') ||
            ($elements[applicant].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'N')) {
            $elements[applicant].receivesAgeBasedDiscountRow.addClass('hidden');
            $elements[applicant].ageBasedDiscountPolicyStartRow.addClass('hidden');
            return;
        }

        if(age >= 18 && age < 45 && ($elements[applicant].previousCoverType.filter(':checked').val() === 'C' || $elements[applicant].previousCoverType.filter(':checked').val() === 'H')) {
            $elements[applicant].receivesAgeBasedDiscountRow.removeClass('hidden');
            if($elements[applicant].receivesAgeBasedDiscount.find(':checked').val() === 'Y') {
                $elements[applicant].ageBasedDiscountPolicyStartRow.removeClass('hidden');
            } else {
                $elements[applicant].ageBasedDiscountPolicyStartRow.addClass('hidden');
            }
        } else {
            $elements[applicant].receivesAgeBasedDiscountRow.addClass('hidden');
            $elements[applicant].ageBasedDiscountPolicyStartRow.addClass('hidden');
        }
    }

    function _toggleCurrentlyHaveAnyKindOfCover(applicant) {

        var hideRowPrivateHospital1 = true,
            hideRowCoverType1 = false,
            hideRowCoverSameProvidersCheckbox1 = true,
            hideRowContinuousCover = true,
            hideRowPrivateHospital2 = true,
            hideRowFundHistory = true,
            hideDontKnowMyDateRanges = true,
            hideDontKnowMyDateRangesPromptText = true,
            hideNoHospitalAdditionalTextPH1 = true,
            hideNoHospitalAdditionalTextPH2 = true;

        var isLHCPossiblyApplicable = _isLHCPossiblyApplicable(applicant);

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund['POPULATE_' + applicant.toUpperCase()],
                getCurrentCover(applicant));

        if (getCurrentCover(applicant) === 'Y') {
            $elements[applicant].currentlyHaveAnyKindOfCoverPreResultsBtnGroup.find("input[value='Y']").prop('checked',true).trigger('change');

            if ($elements[applicant].previousCoverType.filter(':checked').val() === 'C')
                hideRowCoverSameProvidersCheckbox1 = false;

            if (isLHCPossiblyApplicable) {
                hideRowContinuousCover = false;

                if (($elements[applicant].healthContinuousCover.filter(':checked').val() === 'N')) {
                    hideRowPrivateHospital2 = false;

                    if ($elements[applicant].everHadPrivateHospital_2.filter(':checked').val() === 'Y') {
                        hideDontKnowMyDateRanges = false;

                        if ($elements[applicant].iDontKnowMyDateRanges.is(":checked")) {
                            hideDontKnowMyDateRangesPromptText = false;
                        } else {
                            hideRowFundHistory = false;
                        }
                    } else if ($elements[applicant].everHadPrivateHospital_2.filter(':checked').val() === 'N') {
                        hideNoHospitalAdditionalTextPH2 = false;
                    }
                }
            }
        } else {
            $elements[applicant].currentlyHaveAnyKindOfCoverPreResultsBtnGroup.find("input[value='N']").prop('checked', true).trigger('change');

            if ($elements[applicant].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'N') {
                hideRowCoverType1 = true;
                hideRowPrivateHospital1 = false;

                meerkat.messaging.publish(meerkatEvents.healthPreviousFund['POPULATE_' + applicant.toUpperCase()], ($elements[applicant].everHadPrivateHospital_1.filter(':checked').val() === 'Y' ? 'Y' : 'N' ));


                if (isLHCPossiblyApplicable) {
                    if ($elements[applicant].everHadPrivateHospital_1.filter(':checked').val() === 'Y') {

                        hideDontKnowMyDateRanges = false;

                        if ($elements[applicant].iDontKnowMyDateRanges.is(":checked")) {
                            hideDontKnowMyDateRangesPromptText = false;
                        } else {
                            hideRowFundHistory = false;
                        }

                    } else if ($elements[applicant].everHadPrivateHospital_1.filter(':checked').val() === 'N') {
                        hideNoHospitalAdditionalTextPH1 = false;
                    }
                }
            }
        }

        _toggleSameProviders(applicant);
        _toggleAgeBasedDiscountQuestion(applicant);

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[applicant].previousCoverSameProvidersCheckboxRow,
            hideRowCoverSameProvidersCheckbox1
        );

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[applicant].previousCoverTypeRow,
            hideRowCoverType1
        );

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[applicant].everHadPrivateHospitalRow_1,
            hideRowPrivateHospital1
        );

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[applicant].healthContinuousCoverRow,
            hideRowContinuousCover
        );

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[applicant].everHadPrivateHospitalRow_2,
            hideRowPrivateHospital2
        );

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[applicant].healthFundHistoryRow,
            hideRowFundHistory
        );

        $elements[applicant].iDontKnowMyDateRangesRow.toggleClass('hidden', hideDontKnowMyDateRanges);
        $elements[applicant].iDontKnowMyDateRangesPromptText.toggleClass('hidden', hideDontKnowMyDateRangesPromptText);
        $elements[applicant].publicHospital1NoCoverText.toggleClass('hidden', hideNoHospitalAdditionalTextPH1);
        $elements[applicant].publicHospital2NoCoverText.toggleClass('hidden', hideNoHospitalAdditionalTextPH2);
    }

    function _toggleSelectGender(applicant) {
        var title =  $('#health_application_' + applicant + '_title').val(),
            gender,
            $gender = $('#health_application_' + applicant + '_gender'),
            $genderRow = $('#health_application_' + applicant + '_genderRow'),
            $genderToggle = $('[name=health_application_' + applicant + '_genderToggle]');

        if (title) {
            switch (title) {
                case 'MR':
                case 'MRS':
                case 'MISS':
                case 'MS':
                    gender = title === 'MR' ? 'M' : 'F';
                    $gender.val(gender);
                    $genderRow.slideUp();
                    break;

                default:
                    var genderToggleVal = $genderToggle.filter(':checked').val();

                    if (genderToggleVal) {
                        // if gender toggle has been 'toggled' before then
                        // set hidden gender field to the checked gender
                        $gender.val(genderToggleVal);
                    } else {
                        // otherwise, if hidden gender field has been set, then
                        // toggle the gender
                        if ($gender.val()) {
                            $genderToggle
                                .filter('[value=' + $gender.val() + ']')
                                .prop('checked', true)
                                .attr('checked', 'checked')
                                .change();
                        }
                    }
                    $genderRow.slideDown();
            }
        } else {
            $genderRow.slideUp();
        }
    }

    function _isLookingToPurchasePrivateHospitalCover() {
        return (meerkat.modules.healthChoices.getCoverType() !== 'E');
    }

    /*
    *  Checks to ensure the applicant is not  isLessThan31Or31AndBeforeJuly1 and was born after the 1st of july 1934
    *  NOTE: There is a possibility that this may not work as expected if locale is set to US
    *  it might be better to use the designated websevice for this purpose or explicitly build the date string to ensure the correct format
    */
    function _isOfLhcAge(applicant) {

        return meerkat.modules.age.isAgeLhcApplicable($elements[applicant].healthApplicationDOB.val());
    }

    function _isLHCPossiblyApplicable(applicant) {
        return _isLookingToPurchasePrivateHospitalCover() && _isOfLhcAge(applicant);
    }

    /*
     * Controls visibility for the hospital and extras fund details
     *      Only displayed if all of the following conditions are met:
     *
     *         -  Must be currently holding a private health insurance
     *         -  said currently held cover must be hospital and extras, not just hospital or just extras
     *         -  applicant has 2 different providers for hospital and extras
     *
    */
    function _toggleSameProviders(applicant) {
        var applicantPrefix = ((applicant === 'primary') ? "your" : "your partner's");
        if (getCurrentCover(applicant) === 'Y') {
            $elements[applicant].healthApplicationPreviousFundLabel.html("Who is " + applicantPrefix + " current health fund?");
            if ($elements[applicant].previousCoverType.filter(':checked').val() === 'C' && $elements[applicant].previousCoverSameProvidersCheckboxRow.find(':input').filter(':checked').val() === 'N') {
                $elements[applicant].healthApplicationPreviousFundLabel.html("Who is " + applicantPrefix + " current hospital cover provider?");
                $elements[applicant].hospitalFundHeader.show();
                $elements[applicant].extrasFund.show();
            } else {
                $elements[applicant].hospitalFundHeader.hide();
                $elements[applicant].extrasFund.hide();
            }
        } else {
            $elements[applicant].healthApplicationPreviousFundLabel.html("Who is " + applicantPrefix + " previous health fund?");
            $elements[applicant].hospitalFundHeader.hide();
            $elements[applicant].extrasFund.hide();
        }
    }


    /*
     * Controls visibility for 'I have hospital and extras cover with different providers'
     *      Only displayed if all of the following conditions are met:
     *
     *         -  Must be currently holding a private health insurance
     *         -  said currently held cover must be hospital and extras, not just hospital or just extras
     *
    */
    function _toggleSameProvidersCheckbox(applicant) {

        var hideRowCoverSameProvidersCheckbox = true;

        if ($elements[applicant].previousCoverType.filter(':checked').val() === 'C') {
            hideRowCoverSameProvidersCheckbox = false;
        }

        _toggleAgeBasedDiscountQuestion(applicant);
        _toggleSameProviders(applicant);

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[applicant].previousCoverSameProvidersCheckboxRow,
            hideRowCoverSameProvidersCheckbox
        );

    }

    /*
     * Controls visibility for 'Ever held private hospital cover - 2'
     *      Only displayed if all of the following conditions are met:
     *
     *         -  Must be purchasing health insurance that includes Private hospital cover ( Not an extras only policy)
     *         -  selected person (partner/primary) must be old enough so that LHC is applicable but not too old that it is not applicable
     *         -  Has not already been explicitly asked if the selected person has ever held 'Private Hospital' cover on the about you / insurance preferences pages
     *               (health_healthCover_XXX_cover === 'Y' && health_healthCover_XXX_healthCoverLoading === 'N' )
     *
    */
    function _toggleEverHadPrivateHospitalCover2(applicant) {

        var capitalisePersonDetailType = applicant.charAt(0).toUpperCase() + applicant.slice(1);
        var hideRow = true;
        var hideNoHospitalAdditionalTextPH2 = true;

        if (_isLHCPossiblyApplicable(applicant)) {
            if (meerkat.modules['health' + capitalisePersonDetailType].getNeverExplicitlyAskedIfHeldPrivateHospitalCover() === true) {
                hideRow = false;

                if ($elements[applicant].everHadPrivateHospital_2.filter(':checked').val() === 'N') {
                    hideNoHospitalAdditionalTextPH2 = false;
                }
            }
        }

        $elements[applicant].publicHospital2NoCoverText.toggleClass('hidden', hideNoHospitalAdditionalTextPH2);

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[applicant].everHadPrivateHospitalRow_2,
            hideRow
        );
    }

    /*
     * Controls visibility for 'Private hospital coverage history' widget
     *      Only displayed if all of the following conditions are met:
     *
     *         -  Must be purchasing health insurance that includes Private hospital cover ( Not an extras only policy)
     *         -  selected person (partner/primary) must be old enough so that LHC is applicable
     *         -  Has indicated that they have held Private hospital Cover but not continuously for the entire time required to prevent LHC
     *                This means they have either indicated:
     *
     *                    -- 'they DO NOT currently hold either private hospital or extras cover' && 'they HAVE previously held Private Hospital cover'
     *                         (health_healthCover_XXX_cover === 'N' && health_application_XXX_everHadCoverPrivateHospital1 === 'Y' )
     *
     *                                       OR
     *
     *                    -- 'they DO currently hold either private hospital or extras cover'
     *                       && 'they HAVE NOT continuously held Private Hospital cover for the entire duration to be exempt from LHC'
     *                       && 'they HAVE previously held Private Hospital cover'
     *
     *                         (health_healthCover_XXX_cover === 'Y' && health_healthCover_XXX_healthCoverLoading === 'N' && health_application_XXX_everHadCoverPrivateHospital2 === 'Y')
    */
    function _toggleFundHistory(applicant) {

        var capitalisePersonDetailType = applicant.charAt(0).toUpperCase() + applicant.slice(1);
        var hideRow = true;
        var hideDontKnowMyDateRangesPromptText = true;
        var hideNoHospitalAdditionalTextPH1 = true;
        var hideNoHospitalAdditionalTextPH2 = true;

        if (_isLHCPossiblyApplicable(applicant)) {
            if (meerkat.modules['health' + capitalisePersonDetailType].getHeldPrivateHealthInsuranceBeforeButNotCurrently() === true) {
                hideRow = false;
            } else {
                if (meerkat.modules['health' + capitalisePersonDetailType].getNeverExplicitlyAskedIfHeldPrivateHospitalCover() === true) {

                    if ($elements[applicant].everHadPrivateHospital_2.filter(':checked').val() === 'Y') {
                        hideRow = false;
                    } else if ($elements[applicant].everHadPrivateHospital_2.filter(':checked').val() === 'N') {
                        hideNoHospitalAdditionalTextPH2 = false;
                    }
                }
            }
        }

        $elements[applicant].iDontKnowMyDateRangesRow.toggleClass('hidden', hideRow);

        if (hideRow) {
            if (_isLHCPossiblyApplicable(applicant)) {
                if (hideNoHospitalAdditionalTextPH2) {
                    if (meerkat.modules['health' + capitalisePersonDetailType].getNeverHadPrivateHospital_1() === true) {
                        hideNoHospitalAdditionalTextPH1 = false;
                    }
                }
            }
        } else {
            if ($elements[applicant].iDontKnowMyDateRanges.is(":checked")) {
                hideDontKnowMyDateRangesPromptText = false;
                hideRow = true;
            }
        }

        $elements[applicant].iDontKnowMyDateRangesPromptText.toggleClass('hidden', hideDontKnowMyDateRangesPromptText);
        $elements[applicant].publicHospital1NoCoverText.toggleClass('hidden', hideNoHospitalAdditionalTextPH1);
        $elements[applicant].publicHospital2NoCoverText.toggleClass('hidden', hideNoHospitalAdditionalTextPH2);

        var showHide = hideRow ? 'remove' : 'add';
        meerkat.modules.healthPrivateHospitalHistory[showHide + capitalisePersonDetailType + 'Validation']();

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[applicant].healthFundHistoryRow,
            hideRow
        );
    }

    function _changeStreetNoLabel(unitType) {
        var $label = $unitElements.appPostalStreetNum.closest('.form-group').find('label.control-label'),
            $errorField = $('#health_application_postal_streetNum-error'),
            labelText = 'Street No.',
            msgRequired = 'Please enter a street number';

        if (unitType === 'PO') {
            labelText = 'Box No.';
            msgRequired = 'Please enter a box number';
        }

        $label.text(labelText);
        $unitElements.appPostalStreetNum.attr('data-msg-required', msgRequired);

        if ($errorField.length > 0) {
            $errorField.text(msgRequired);
        }
    }

    function _toggleRegexValidation(unitType) {
        if (unitType === 'PO') {
            $unitElements.appPostalNonStdStreet.removeRule('regex');
            $unitElements.appPostalNonStdStreet.blur();
        } else {
            $unitElements.appPostalNonStdStreet.addRule('regex', _postalNonStdStreetRegexRule);
        }
    }

    function _toggleUnitShopRequired(addressType, isUnitShop) {
        $unitElements['app'+addressType+'UnitType'].setRequired(isUnitShop);

        // blur out of fields to trigger validation when unitShop not empty
        if (!isUnitShop) {
            $unitElements['app'+addressType+'UnitType'].blur();
        }
    }

    function testStatesParity() {
        if ($elements.appState.val() !== $elements.healthSituationState.val()) {
            var suburb = $elements.appSuburbName.val(),
                state = $elements.appState.val();

            if (suburb.length && suburb.indexOf('Please select') < 0 && $elements.appPostcode.val().length == 4 && state.length) {
                $elements.appPostcode.addClass('error');
                $elements.appState.val("");
                return false;
            }
        }

        return true;
    }

    function setHospitalCoverClass() {

        var theSelectedItem = meerkat.modules.healthResults.getSelectedProduct();
        var returnVal = "";

        if ((!_.isEmpty(theSelectedItem.info.situationFilter)) && theSelectedItem.info.situationFilter === 'Y') {
            returnVal = "limited";
        } else {
            if (!_.isEmpty(theSelectedItem.hospital.ClassificationHospital)){
                if (theSelectedItem.hospital.ClassificationHospital === 'Budget' || theSelectedItem.hospital.ClassificationHospital === 'Public') {
                    returnVal = "basic";
                } else {
                    returnVal = theSelectedItem.hospital.ClassificationHospital.toLowerCase();
                }
            }
        }

        $elements.healthProductHospitalClass.val(returnVal);
    }

    function setExtrasCoverClass() {
        var theSelectedItem = meerkat.modules.healthResults.getSelectedProduct();
        var returnVal = "";

        if (!_.isEmpty(theSelectedItem.extras.ClassificationGeneralHealth)) {
            if (theSelectedItem.extras.ClassificationGeneralHealth === "Budget") {
                returnVal = "basic";
            } else {
                returnVal = theSelectedItem.extras.ClassificationGeneralHealth.toLowerCase();
            }
        }

        $elements.healthProductExtrasClass.val(returnVal);
    }

    function getPrimaryFirstname() {
        return $elements.primaryFirstname.val();
    }

	function _prefillPreviousFund(applicant) {
		if (!_.isUndefined($elements[applicant].aboutYouPreviousFund.filter(':selected').val())) {
			// get value if not undefined, '', NONE
			var selectedFieldCurrentVal = (((_.isUndefined($elements[applicant].healthApplicationPreviousFund.filter(':selected').val())) || ($elements[applicant].healthApplicationPreviousFund.filter(':selected').val() === '') || ($elements[applicant].healthApplicationPreviousFund.filter(':selected').val() === 'NONE') || ($elements[applicant].healthApplicationPreviousFund.filter(':selected').val() === 'OTHER')) ? (((_.isUndefined($elements[applicant].aboutYouPreviousFund.filter(':selected').val())) || ($elements[applicant].aboutYouPreviousFund.filter(':selected').val() === '') || ($elements[applicant].aboutYouPreviousFund.filter(':selected').val() === 'NONE') || ($elements[applicant].aboutYouPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements[applicant].aboutYouPreviousFund.filter(':selected').val() ) : $elements[applicant].aboutYouPreviousFund.filter(':selected').val() );
			if (selectedFieldCurrentVal !== ''){
				// if there is matching non duplicate value in drop down on the Application page
				if  ($('select[name=health_previousfund_' + applicant + '_fundName] > option[value="' + selectedFieldCurrentVal +'"]').length === 1) {
					// if there are no duplicate entries on the about you(primary)/insurance preferences(partner) page
					if ($('select[name=health_healthCover_' + applicant + '_fundName] > option[value="' + selectedFieldCurrentVal +'"]').length == 1)  {
						// ensure no other fields are selected
						$('select[name=health_previousfund_' + applicant + '_fundName]').find('option').attr("selected", false);
						//populate field
						$('select[name=health_previousfund_' + applicant + '_fundName]').find('option[value="' + selectedFieldCurrentVal + '"]').attr("selected", true);
						$('input[name=health_previousfund_' + applicant + '_fundNameHidden]').attr('value',selectedFieldCurrentVal);
						$('input[name=health_previousfund_' + applicant + '_fundNameInput]').val($('select[name=health_previousfund_' + applicant + '_fundName] :selected').text());
						$('input[name=health_previousfund_' + applicant + '_fundNameInput]').trigger('keyup');
						$('input[name=health_previousfund_' + applicant + '_fundNameInput]').parent().find('ul').trigger('click');
					}
				}
			}
		}
	}

    function _prefill_currentlyHaveAnyKindOfCover(applicant) {
        if ((!_.isUndefined($elements[applicant].currentlyHaveAnyKindOfCoverPreResults)) && (!_.isUndefined($elements[applicant].currentlyHaveAnyKindOfCoverApplyPage))) {

            if ($elements[applicant].currentlyHaveAnyKindOfCoverPreResults.filter(':checked').val() === 'Y') {
                $elements[applicant].currentlyHaveAnyKindOfCoverApplyPage.find("input[value='Y']").prop('checked',true).trigger('change');
            } else {
                $elements[applicant].currentlyHaveAnyKindOfCoverApplyPage.find("input[value='N']").prop('checked', true).trigger('change');
            }
        }
    }

    function getCurrentCover(applicant) {
        return $elements[applicant].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val();
    }

	function setRabdQuestions() {
		_toggleAgeBasedDiscountQuestion('primary');

        if (meerkat.modules.healthChoices.hasPartner()) {
	        _toggleAgeBasedDiscountQuestion('partner');
	    }
	}

    meerkat.modules.register('healthApplyStep', {
        init: init,
        onBeforeEnter: onBeforeEnter,
        onInitialise: onInitialise,
        testStatesParity: testStatesParity,
        getPrimaryFirstname: getPrimaryFirstname,
        setRabdQuestions: setRabdQuestions
    });

})(jQuery);
