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

    function _createFieldReferences (applicant) {
        return {
            healthCoverEverHadRow: $('#health_application_' + applicant + 'CoverEverHad'),
            healthApplicationCoverEverHad: $(':input[name=health_application_' + applicant + '_everHadCover]'),
            healthFundHistoryRow: $('#' + applicant + 'FundHistory'),
            healthApplicationDOB: $('#health_application_' + applicant + '_dob'),
            aboutYouPreviousFund: $(':input[name=health_healthCover_' + applicant + '_fundName]').children('option'),
            healthApplicationPreviousFund: $(':input[name=health_previousfund_' + applicant + '_fundName]').children('option')
        };
    }

    // Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
    function onBeforeEnter() {
        // validate at least 1 contact number is entered
        $elements.appMobile.addRule('requireOneContactNumber', true, 'Please include at least one phone number');

        _prefillPreviousFund('primary');
        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PRIMARY,
            meerkat.modules.healthPrimary.getCurrentCover());

        if (meerkat.modules.healthChoices.hasPartner()) {
            _prefillPreviousFund('partner');
        }
        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PARTNER,
            meerkat.modules.healthPartner.getCurrentCover());

        _toggleSelectGender('primary');
        _toggleEverHad('primary');
        _toggleFundHistory('primary');

        if (meerkat.modules.healthChoices.hasPartner()) {
            _toggleSelectGender('partner');
            _toggleEverHad('partner');
            _toggleFundHistory('partner');
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
            _toggleFundHistory(applicant);
        });

        $elements[applicant].healthCoverEverHadRow.find(':input').on('change', function() {
            _toggleFundHistory(applicant);
        });

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
    *  Outputs the negated value of isLessThan31Or31AndBeforeJuly1
    *  NOTE: There is a possibility that this may not work as expected if locale is set to US
    *  it might be better to use the designated websevice for this purpose or explicitly build the date string to ensure the correct format
    */
    function _isOfLhcAge(personDetailType) {

        var isOfLhcAge = false;

        if (!meerkat.modules.age.isLessThan31Or31AndBeforeJuly1($elements[personDetailType].healthApplicationDOB.val())) {
            isOfLhcAge = true;
        }

        return isOfLhcAge;
    }

    /*
     * Controls visibility for 'Ever held private hospital cover'
     *      Only displayed if all of the following conditions are met:
     *
     *         -  Must be purchasing health insurance that includes Private hospital cover ( Not an extras only policy)
     *         -  selected person (partner/primary) must be old enough so that LHC is applicable
     *         -  Has not already been explicitly asked if the selected person has ever held 'Private Hospital' cover on the about you / insurance preferences pages
     *               (health_healthCover_XXX_cover === 'Y' && health_healthCover_XXX_healthCoverLoading === 'N' )
     *
    */
    function _toggleEverHad(personDetailType) {

        var capitalisePersonDetailType = personDetailType.charAt(0).toUpperCase() + personDetailType.slice(1);
        var hideRow = true;

        if (_isLookingToPurchasePrivateHospitalCover() && _isOfLhcAge(personDetailType)) {
            if (meerkat.modules['health' + capitalisePersonDetailType].getNeverExplicitlyAskedIfHeldPrivateHospitalCover() === true) {
                hideRow = false;
            }
        }

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].healthCoverEverHadRow,
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
     *                         (health_healthCover_XXX_cover === 'N' && health_healthCover_XXX_everHadCover === 'Y' )
     *
     *                                       OR
     *
     *                    -- 'they DO currently hold either private hospital or extras cover'
     *                       && 'they HAVE NOT continuously held Private Hospital cover for the entire duration to be exempt from LHC'
     *                       && 'they HAVE previously held Private Hospital cover'
     *
     *                         (health_healthCover_XXX_cover === 'Y' && health_healthCover_XXX_healthCoverLoading === 'N' && health_application_XXX_everHadCover === 'Y')
    */
    function _toggleFundHistory(personDetailType) {

        var capitalisePersonDetailType = personDetailType.charAt(0).toUpperCase() + personDetailType.slice(1);
        var hideRow = true;

        if (_isLookingToPurchasePrivateHospitalCover() && _isOfLhcAge(personDetailType)) {
            if (meerkat.modules['health' + capitalisePersonDetailType].getHeldPrivateHealthInsuranceBeforeButNotCurrently() === true) {
                hideRow = false;
            } else {
                if (meerkat.modules['health' + capitalisePersonDetailType].getNeverExplicitlyAskedIfHeldPrivateHospitalCover() === true) {

                    if ($elements[personDetailType].healthApplicationCoverEverHad.filter(':checked').val() === 'Y') {
                        hideRow = false;
                    }
                }
            }
        }

        var showHide = hideRow ? 'remove' : 'add';
        meerkat.modules.healthPrivateHospitalHistory[showHide + capitalisePersonDetailType + 'Validation']();

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements[personDetailType].healthFundHistoryRow,
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

    meerkat.modules.register('healthApplyStep', {
        init: init,
        onBeforeEnter: onBeforeEnter,
        onInitialise: onInitialise,
        testStatesParity: testStatesParity,
        getPrimaryFirstname: getPrimaryFirstname
    });

})(jQuery);