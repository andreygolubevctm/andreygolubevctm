;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {},
        $unitElements;

    function init(){
        $(document).ready(function () {
            $elements = {
                primaryFirstname: $('#health_application_primary_firstname'),
                paymentMedicareColour: $("#health_payment_medicare_colour"),
                paymentMedicareCover: $("#health_payment_medicare_cover"),
                medicareYellowMessage: $("#health_medicareDetails_yellowCardMessage"),
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
        });
    }

    //TODO ensure that the pre results value for primary vs partner show the correct value  currentlyHaveAnyKindOfCoverPreResults:
    // vs post results
    function _createFieldReferences (applicant) {
        var applicantFields = {
            currentlyHaveAnyKindOfCoverPreResults: $(':input[name=health_healthCover_' + applicant + '_cover]'),
            currentlyHaveAnyKindOfCoverPreResultsBtnGroup: $('#_' + applicant + '_health_cover'),
            currentlyHaveAnyKindOfCoverApplyPage: $('#health_application_' + applicant + '_health_cover'),
            healthFundHistoryRow: $('#' + applicant + 'FundHistory'),
            healthApplicationDOB: $('#health_application_' + applicant + '_dob'),
            aboutYouPreviousFund: $(':input[name=health_healthCover_' + applicant + '_fundName]').children('option'),
            healthApplicationPreviousFundRow: $('#' + applicant + 'previousfund'),
            healthApplicationPreviousFund: $(':input[name=health_previousfund_' + applicant + '_fundName]').children('option'),
            healthApplicationPreviousFundLabel: $('[for=health_previousfund_' + applicant + '_fundName]'),
            everHadPrivateHospitalRow_1: $('#health_healthCover_' + applicant + 'CoverEverHad'),
            everHadPrivateHospitalBtnGroup_1: $('#health_healthCover_' + applicant + '_ever_had_health_cover'),
            everHadPrivateHospital_1: $(':input[name=health_healthCover_' + applicant + '_everHadCover]'),
            everHadPrivateHospitalRow_2: $('#health_application_' + applicant + 'CoverEverHad'),
            everHadPrivateHospitalBtnGroup_2: $('#health_application_' + applicant + '_ever_had_health_cover'),
            everHadPrivateHospital_2: $(':input[name=health_application_' + applicant + '_everHadCover]'),
            healthContinuousCoverRow: $('#health-continuous-cover-' + applicant),
            healthContinuousCoverBtnGroup: $('#_' + applicant + '_health_cover_loading'),
            healthContinuousCover:  $(':input[name=health_healthCover_' + applicant + '_healthCoverLoading]'),
            iDontKnowMyDateRangesRow:  $('#' + applicant + 'LhcDatesUnsureApplyFullLHC'),
            iDontKnowMyDateRanges:  $(':input[name=health_previousfund_' + applicant + '_fundHistory_dates_unsure]'),
            iDontKnowMyDateRangesPromptText: $('#' + applicant + 'LhcDatesUnsureApplyFullLHC .applyFullLHCAdditionalText')
        };

        if (applicant === 'primary') {
            applicantFields['currentlyHaveAnyKindOfCoverPreResultsBtnGroup'] = $('#health_healthCover_health_cover');
            applicantFields['currentlyHaveAnyKindOfCoverApplyPage'] = $('#health_application_health_cover');
            applicantFields['healthApplicationPreviousFundRow'] = $('#yourpreviousfund');
            applicantFields['everHadPrivateHospitalBtnGroup_1'] = $('#health_healthCover_ever_had_health_cover');
            applicantFields['everHadPrivateHospitalBtnGroup_2'] = $('#health_application_ever_had_health_cover');
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
            getCurrentCover('primary'));

        if (meerkat.modules.healthChoices.hasPartner()) {
            _prefill_currentlyHaveAnyKindOfCover('partner');
            _prefillPreviousFund('partner');
        }

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PARTNER,
            getCurrentCover('partner'));

        _toggleSelectGender('primary');
        _toggleCurrentlyHaveAnyKindOfCover('primary');

        if (meerkat.modules.healthChoices.hasPartner()) {
            _toggleSelectGender('partner');
            _toggleCurrentlyHaveAnyKindOfCover('partner');
        }

        setHospitalCoverClass();
        setExtrasCoverClass();
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
                var value = $(this).val();
                // set hidden Medicare cover value
                $elements.paymentMedicareCover.val(value === 'none' ? 'N' : 'Y');

                // toggle message for Yellow card holders
                $elements.medicareYellowMessage.toggleClass('hidden', value !== 'yellow');
            })
            .trigger('change');

        $(document.body).on('change', '.selectContainerTitle select', function onTitleChange() {
            var personDetailType = $(this).closest('.qe-window').find('.health-person-details')
                                       .hasClass('primary') ? 'primary' : 'partner';

            _toggleSelectGender(personDetailType);
        });

        $elements.genderToggle.on('change', function onGenderToggle() {
            var personDetailType = $(this).closest('.qe-window').find('.health-person-details')
                                       .hasClass('primary') ? 'primary' : 'partner',
                gender = $(this).val();

            $('#health_application_' + personDetailType + '_gender').val(gender);
        });

        $unitElements.appPostalUnitType.on('change', function toggleUnitRequiredFields() {
            _changeStreetNoLabel(this.value);
        });

        $unitElements.appAddressUnitShop.add($unitElements.appPostalUnitShop).on('change', function toggleUnitShopRequiredFields() {
            _toggleUnitShopRequired(this.id.indexOf('address') !== -1 ? 'Address' : 'Postal', !_.isEmpty(this.value));
        });

    }

    function _applyEventListenersByApplicant(applicant) {

        $elements[applicant].healthApplicationDOB.on('change', function() {
            _toggleCurrentlyHaveAnyKindOfCover(applicant);
        });

        $elements[applicant].currentlyHaveAnyKindOfCoverApplyPage.find(':input').on('change', function() {
            _toggleCurrentlyHaveAnyKindOfCover(applicant);
        });

        $elements[applicant].everHadPrivateHospitalBtnGroup_1.find(':input').on('change', function() {
            _toggleEverHadPrivateHospital_1(applicant);
        });

        $elements[applicant].everHadPrivateHospitalBtnGroup_2.find(':input').on('change', function() {
            _toggleEverHadPrivateHospital_2(applicant);
        });

        $elements[applicant].healthContinuousCoverBtnGroup.find(':input').on('change', function() {
            _toggleContinuousCover(applicant);
        });

        $elements[applicant].iDontKnowMyDateRanges.on('change', function() {
            _toggleDontKnowMyDateRanges(applicant);
        });

    }

    function _toggleDontKnowMyDateRanges(personDetailType) {
        var hideRowFundHistory = true,
            hideDontKnowMyDateRanges = true,
            hideDontKnowMyDateRangesPromptText = true;

        if (_isLHCPossiblyApplicable(personDetailType)) {
            if ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'N') {
                if ($elements[personDetailType].everHadPrivateHospital_1.filter(':checked').val() === 'Y') {
                    hideDontKnowMyDateRanges = false;

                    if ($elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                        hideDontKnowMyDateRangesPromptText = false;
                    } else {
                        hideRowFundHistory = false;
                    }
                }
            } else if ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'Y') {
                if (($elements[personDetailType].healthContinuousCover.filter(':checked').val() === 'N') && ($elements[personDetailType].everHadPrivateHospital_2.filter(':checked').val() === 'Y')) {
                    hideDontKnowMyDateRanges = false;

                    if ($elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                        hideDontKnowMyDateRangesPromptText = false;
                    } else {
                        hideRowFundHistory = false;
                    }
                }
            }
        }

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].healthFundHistoryRow,
            hideRowFundHistory
        );

        $elements[personDetailType].iDontKnowMyDateRangesRow.toggleClass('hidden', hideDontKnowMyDateRanges);
        $elements[personDetailType].iDontKnowMyDateRangesPromptText.toggleClass('hidden', hideDontKnowMyDateRangesPromptText);
    }

    function _toggleEverHadPrivateHospital_1(personDetailType) {
        var hideRowFundHistory = true,
            hideDontKnowMyDateRanges = true,
            hideDontKnowMyDateRangesPromptText = true;

        if (_isLHCPossiblyApplicable(personDetailType) && ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'N')) {
            if ($elements[personDetailType].everHadPrivateHospital_1.filter(':checked').val() === 'Y') {
                hideDontKnowMyDateRanges = false;

                if ($elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                    hideDontKnowMyDateRangesPromptText = false;
                } else {
                    hideRowFundHistory = false;
                }
            }
        }

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].healthFundHistoryRow,
            hideRowFundHistory
        );

        $elements[personDetailType].iDontKnowMyDateRangesRow.toggleClass('hidden', hideDontKnowMyDateRanges);
        $elements[personDetailType].iDontKnowMyDateRangesPromptText.toggleClass('hidden', hideDontKnowMyDateRangesPromptText);
    }

    function _toggleEverHadPrivateHospital_2(personDetailType) {
        var hideRowFundHistory = true,
            hideDontKnowMyDateRanges = true,
            hideDontKnowMyDateRangesPromptText = true;

        if (_isLHCPossiblyApplicable(personDetailType) && ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'Y')) {
            if (($elements[personDetailType].healthContinuousCover.filter(':checked').val() === 'N') && ($elements[personDetailType].everHadPrivateHospital_2.filter(':checked').val() === 'Y')) {
                hideDontKnowMyDateRanges = false;

                if ($elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                    hideDontKnowMyDateRangesPromptText = false;
                } else {
                    hideRowFundHistory = false;
                }
            }
        }

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].healthFundHistoryRow,
            hideRowFundHistory
        );

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].iDontKnowMyDateRangesRow,
            hideDontKnowMyDateRanges
        );

        $elements[personDetailType].iDontKnowMyDateRangesRow.toggleClass('hidden', hideDontKnowMyDateRanges);
        $elements[personDetailType].iDontKnowMyDateRangesPromptText.toggleClass('hidden', hideDontKnowMyDateRangesPromptText);
    }

    function _toggleContinuousCover(personDetailType) {
        var hideRowPrivateHospital2 = true,
            hideRowFundHistory = true,
            hideDontKnowMyDateRanges = true,
            hideDontKnowMyDateRangesPromptText = true;

        if (_isLHCPossiblyApplicable(personDetailType) && ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'Y')) {
            if (($elements[personDetailType].healthContinuousCover.filter(':checked').val() === 'N')) {
                hideRowPrivateHospital2 = false;

                if ($elements[personDetailType].everHadPrivateHospital_2.filter(':checked').val() === 'Y') {
                    hideDontKnowMyDateRanges = false;

                    if ($elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                        hideDontKnowMyDateRangesPromptText = false;
                    } else {
                        hideRowFundHistory = false;
                    }
                }

                //todo create a hidden xpath for the private hospital field and set at the time that the backend lhc service is called!!!
            }
        }

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].everHadPrivateHospitalRow_2,
            hideRowPrivateHospital2
        );

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].healthFundHistoryRow,
            hideRowFundHistory
        );

        $elements[personDetailType].iDontKnowMyDateRangesRow.toggleClass('hidden', hideDontKnowMyDateRanges);
        $elements[personDetailType].iDontKnowMyDateRangesPromptText.toggleClass('hidden', hideDontKnowMyDateRangesPromptText);
    }

    function _isLHCPossiblyApplicable(applicant) {
        return (_isLookingToPurchasePrivateHospitalCover() && _isOfLhcAge(applicant));
    }


    function _toggleCurrentlyHaveAnyKindOfCover(personDetailType) {
        var hideRowPrivateHospital1 = true,
            hideRowContinuousCover = true,
            changeCurrentFundLabelToPreviousFund = true,
            hideRowPrivateHospital2 = true,
            hideRowFundHistory = true,
            hideDontKnowMyDateRanges = true,
            hideDontKnowMyDateRangesPromptText = true;

        var applicantPrefix = ((personDetailType === 'primary') ? "Your" : "Partner's");
        var isLHCPossiblyApplicable = _isLHCPossiblyApplicable(personDetailType);

        //meerkat.messaging.publish(meerkatEvents.healthPreviousFund['POPULATE_' + personDetailType.toUpperCase()],
        //        getCurrentCover(personDetailType));

        if ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'Y') {

            // set pre results value with new value
            // TODO this sometimes triggers a 500 error from health_rebate.jsp followed by - failed to fetch health rebate rates....
            $elements[personDetailType].currentlyHaveAnyKindOfCoverPreResultsBtnGroup.find("input[value='Y']").prop('checked',true).trigger('change');

            changeCurrentFundLabelToPreviousFund = false;
            if (isLHCPossiblyApplicable) {
                hideRowContinuousCover = false;

                if (($elements[personDetailType].healthContinuousCover.filter(':checked').val() === 'N')) {
                    hideRowPrivateHospital2 = false;

                    if ($elements[personDetailType].everHadPrivateHospital_2.filter(':checked').val() === 'Y') {
                        hideDontKnowMyDateRanges = false;

                        if ($elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                            hideDontKnowMyDateRangesPromptText = false;
                        } else {
                            hideRowFundHistory = false;
                        }
                    }
                }
            }
        } else {
            // set pre results value with new value
            // TODO this sometimes triggers a 500 error from health_rebate.jsp followed by - failed to fetch health rebate rates.... maybe there is a better way to do this - it may only be happening when there is a partner?
            // it could be cause due to non unique IDs
            // it might be better to call an existing meerkat get or set method to do it?
            // it also may have something to do with the code that lives in health primary /health partner that still may need to be removed
            // need to look at the rebate code and see how that works!!!  /ctm/ajax/json/health_rebate.jsp
            // also need to rip out the existing LHC calc stuff
            $elements[personDetailType].currentlyHaveAnyKindOfCoverPreResultsBtnGroup.find("input[value='N']").prop('checked', true).trigger('change');

            if ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'N') {
                hideRowPrivateHospital1 = false;

                if ($elements[personDetailType].everHadPrivateHospital_1.filter(':checked').val() === 'Y') {

                    if (isLHCPossiblyApplicable) {
                        hideDontKnowMyDateRanges = false;

                        if ($elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                            hideDontKnowMyDateRangesPromptText = false;
                        } else {
                            hideRowFundHistory = false;
                        }
                    }
                }
            }
        }

        if (changeCurrentFundLabelToPreviousFund) {
            $elements[personDetailType].healthApplicationPreviousFundLabel.html(applicantPrefix + " Previous Health Fund");
        } else {
            $elements[personDetailType].healthApplicationPreviousFundLabel.html(applicantPrefix + " Current Health Fund");
        }

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].everHadPrivateHospitalRow_1,
            hideRowPrivateHospital1
        );

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].healthContinuousCoverRow,
            hideRowContinuousCover
        );

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].everHadPrivateHospitalRow_2,
            hideRowPrivateHospital2
        );

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].healthFundHistoryRow,
            hideRowFundHistory
        );

        $elements[personDetailType].iDontKnowMyDateRangesRow.toggleClass('hidden', hideDontKnowMyDateRanges);
        $elements[personDetailType].iDontKnowMyDateRangesPromptText.toggleClass('hidden', hideDontKnowMyDateRangesPromptText);
    }

    function _toggleSelectGender(personDetailType) {
        var title =  $('#health_application_' + personDetailType + '_title').val(),
            gender,
            $gender = $('#health_application_' + personDetailType + '_gender'),
            $genderRow = $('#health_application_' + personDetailType + '_genderRow'),
            $genderToggle = $('[name=health_application_' + personDetailType + '_genderToggle]');

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
    *  Checks if isLessThan31Or31AndBeforeJuly1 && if is born on or before 1/07/1934
    *  NOTE: There is a possibility that this may not work as expected if locale is set to US
    *  it might be better to use the designated websevice for this purpose or explicitly build the date string to ensure the correct format
    */
    function _isOfLhcAge(personDetailType) {
        return meerkat.modules.age.isAgeLhcApplicable($elements[personDetailType].healthApplicationDOB.val());
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

    // this only pre fills the field if it has not already been populated.
    // the fields on the about you/insurance preferences page only contains current funds as it is geared towards the user's CURRENT fund
    // the fields on the Application page are geared to capture the users previous fund or current fund for the purposes of clearance certificates or for getting information concerning pre served waiting periods
    // it will only forward populate the field if the selected item does not have a duplicate value (eg CBHS) and it must exist in the second list
    function _prefillPreviousFund(applicant) {

        if (!_.isUndefined($elements[applicant].healthApplicationPreviousFund.filter(':selected').val())) {

            // get value if not undefined, '', NONE
            var appPageSelectedVal = (((_.isUndefined($elements[applicant].healthApplicationPreviousFund.filter(':selected').val())) || ($elements[applicant].healthApplicationPreviousFund.filter(':selected').val() === '') || ($elements[applicant].healthApplicationPreviousFund.filter(':selected').val() === 'NONE') || ($elements[applicant].healthApplicationPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements[applicant].healthApplicationPreviousFund.filter(':selected').val() );

            if (appPageSelectedVal === ''){
                if (!_.isUndefined($elements[applicant].aboutYouPreviousFund.filter(':selected').val())) {

                    // get value if not undefined, '', NONE
                    var selectedFieldCurrentVal = (((_.isUndefined($elements[applicant].healthApplicationPreviousFund.filter(':selected').val())) || ($elements[applicant].healthApplicationPreviousFund.filter(':selected').val() === '') || ($elements[applicant].healthApplicationPreviousFund.filter(':selected').val() === 'NONE') || ($elements[applicant].healthApplicationPreviousFund.filter(':selected').val() === 'OTHER')) ? (((_.isUndefined($elements[applicant].aboutYouPreviousFund.filter(':selected').val())) || ($elements[applicant].aboutYouPreviousFund.filter(':selected').val() === '') || ($elements[applicant].aboutYouPreviousFund.filter(':selected').val() === 'NONE') || ($elements[applicant].aboutYouPreviousFund.filter(':selected').val() === 'OTHER')) ? '' : $elements[applicant].aboutYouPreviousFund.filter(':selected').val() ) : $elements[applicant].healthApplicationPreviousFund.filter(':selected').val() );
                    if (selectedFieldCurrentVal !== ''){

                        // if there is matching non duplicate value in drop down on the Application page
                        if  ($(':input[name=health_previousfund_' + applicant + '_fundName] > option[value="' + selectedFieldCurrentVal +'"]').length === 1) {
                            // if there are no duplicate entries on the about you(primary)/insurance preferences(partner) page
                            if ($(':input[name=health_healthCover_' + applicant + '_fundName] > option[value="' + selectedFieldCurrentVal +'"]').length == 1)  {

                                //populate field
                                $(':input[name=health_previousfund_' + applicant + '_fundName]').find('option[value="' + selectedFieldCurrentVal + '"]').attr("selected", true);
                            }
                        }
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

    //Apply Max LHC
    // iff true, the applicant has never held 'Private Hospital Cover' or has indicated that the don't know there previous health cover date ranges
    function getNeverHadCoverBeforeOrDoesNotKnowPreviousCoverPeriods(applicant) {
        var returnVal = false;

        if ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'Y') {
            if (isLHCPossiblyApplicable) {
                if (($elements[personDetailType].healthContinuousCover.filter(':checked').val() === 'N')) {
                    if ($elements[personDetailType].everHadPrivateHospital_2.filter(':checked').val() === 'Y') {
                        if ($elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                            returnVal = true;
                        }
                    } else if ($elements[personDetailType].everHadPrivateHospital_2.filter(':checked').val() === 'N') {
                        returnVal = true;
                    }
                }
            }
        } else {
            if ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'N') {
                if ($elements[personDetailType].everHadPrivateHospital_1.filter(':checked').val() === 'Y') {
                    if (isLHCPossiblyApplicable) {
                        if ($elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                            returnVal = true;
                        }
                    }
                } else if (isLHCPossiblyApplicable && $elements[personDetailType].everHadPrivateHospital_1.filter(':checked').val() === 'N') {
                    returnVal = true;
                }
            }
        }

        return returnVal;
    }

    // 0% LHC
    // iff true, the applicant has indicated that they have had 'Private Hospital Cover' continuously for the required period of time
    function getHeldContinuousPrivateHospitalCover(applicant) {
        var returnVal = false;

        if (isLHCPossiblyApplicable) {
            if ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'Y') {
                if (($elements[personDetailType].healthContinuousCover.filter(':checked').val() === 'Y')) {
                    returnVal = true;
                }
            }
        } else {
            returnVal = true;
        }

        return returnVal;
    }

    // Further LHC Calculation required
    // iff true, the applicant has indicated that they have not held 'Private Hospital Cover' continuously for the required period of time and have
    // supplied their previous private health insurance cover periods to calculate/estimate their current LHC %
    function getHeldPrivateHealthInsuranceBeforeButNotContinuously(applicant) {
        var returnVal = false;

        if ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'Y') {
            if (isLHCPossiblyApplicable) {
                if (($elements[personDetailType].healthContinuousCover.filter(':checked').val() === 'N')) {
                    if ($elements[personDetailType].everHadPrivateHospital_2.filter(':checked').val() === 'Y') {
                        if (!$elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                            returnVal = true;
                        }
                    }
                }
            }
        } else {
            if ($elements[personDetailType].currentlyHaveAnyKindOfCoverApplyPage.find('input').filter(':checked').val() === 'N') {
                if ($elements[personDetailType].everHadPrivateHospital_1.filter(':checked').val() === 'Y') {
                    if (isLHCPossiblyApplicable) {
                        if (!$elements[personDetailType].iDontKnowMyDateRanges.is(":checked")) {
                            returnVal = true;
                        }
                    }
                }
            }
        }

        return returnVal;
    }

    meerkat.modules.register('healthApplyStep', {
        init: init,
        onBeforeEnter: onBeforeEnter,
        onInitialise: onInitialise,
        testStatesParity: testStatesParity,
        getPrimaryFirstname: getPrimaryFirstname,
        getCurrentCover: getCurrentCover,
        getNeverHadCoverBeforeOrDoesNotKnowPreviousCoverPeriods: getNeverHadCoverBeforeOrDoesNotKnowPreviousCoverPeriods,
        getHeldContinuousPrivateHospitalCover: getHeldContinuousPrivateHospitalCover,
        getHeldPrivateHealthInsuranceBeforeButNotContinuously: getHeldPrivateHealthInsuranceBeforeButNotContinuously
    });

})(jQuery);