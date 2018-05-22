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
                healthPrimaryCoverEverHadRow: $('#health_application_primaryCoverEverHad'),
                healthApplicationPrimaryCoverEverHad: $(':input[name=health_application_primary_everHadCover]'),
                healthPartnerCoverEverHadRow: $('#health_application_partnerCoverEverHad'),
                healthApplicationPartnerCoverEverHad: $(':input[name=health_application_partner_everHadCover]'),
                healthPrimaryFundHistoryRow: $('#primaryFundHistory'),
                healthPartnerFundHistoryRow: $('#partnerFundHistory'),
                healthApplicationPrimaryDOB: $('#health_application_primary_dob'),
                healthApplicationPartnerDOB: $('#health_application_partner_dob'),
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

    // Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
    function onBeforeEnter() {
        // validate at least 1 contact number is entered
        $elements.appMobile.addRule('requireOneContactNumber', true, 'Please include at least one phone number');

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PRIMARY,
            meerkat.modules.healthPrimary.getCurrentCover());

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

        $elements.healthPrimaryCoverEverHadRow.find(':input').on('change', function() {
            _toggleFundHistory('primary');
        });

        $elements.healthPartnerCoverEverHadRow.find(':input').on('change', function() {
            _toggleFundHistory('partner');
        });

        $unitElements.appPostalUnitType.on('change', function toggleUnitRequiredFields() {
            _changeStreetNoLabel(this.value);
        });

        $unitElements.appAddressUnitShop.add($unitElements.appPostalUnitShop).on('change', function toggleUnitShopRequiredFields() {
            _toggleUnitShopRequired(this.id.indexOf('address') !== -1 ? 'Address' : 'Postal', !_.isEmpty(this.value));
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

        if (personDetailType === 'primary') {
            if (!meerkat.modules.age.isLessThan31Or31AndBeforeJuly1($elements.healthApplicationPrimaryDOB.val())) {
                isOfLhcAge = true;
            }
        } else {
            if (!meerkat.modules.age.isLessThan31Or31AndBeforeJuly1($elements.healthApplicationPartnerDOB.val())) {
                isOfLhcAge = true;
            }
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

        var captializePersonDetailType = personDetailType.charAt(0).toUpperCase() + personDetailType.slice(1);
        var hideRow = true;

        if (_isLookingToPurchasePrivateHospitalCover()) {
            if (_isOfLhcAge(personDetailType)) {
                if (personDetailType === 'primary') {
                    if (meerkat.modules.healthPrimary.getNeverExplicitlyAskedIfHeldPrivateHospitalCover() === true) {
                        hideRow = false;
                    }
                } else {
                    if (meerkat.modules.healthPartner.getNeverExplicitlyAskedIfHeldPrivateHospitalCover() === true) {
                        hideRow = false;
                    }
                }
            }
        }

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements['health' + captializePersonDetailType + 'CoverEverHadRow'],
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

        var captializePersonDetailType = personDetailType.charAt(0).toUpperCase() + personDetailType.slice(1);
        var hideRow = true;

        if (_isLookingToPurchasePrivateHospitalCover()) {
            if (_isOfLhcAge(personDetailType)) {
                if (personDetailType === 'primary') {
                    if (meerkat.modules.healthPrimary.getHeldPrivateHealthInsuranceBeforeButNotCurrently() === true) {
                        hideRow = false;
                    } else {
                        if (meerkat.modules.healthPrimary.getNeverExplicitlyAskedIfHeldPrivateHospitalCover() === true) {
                            if ($elements.healthApplicationPrimaryCoverEverHad.filter(':checked').val() === 'Y') {
                                hideRow = false;
                            }
                        }
                    }
                } else {
                    if (meerkat.modules.healthPartner.getHeldPrivateHealthInsuranceBeforeButNotCurrently() === true) {
                        hideRow = false;
                    } else {
                        if (meerkat.modules.healthPartner.getNeverExplicitlyAskedIfHeldPrivateHospitalCover() === true) {
                            if ($elements.healthApplicationPartnerCoverEverHad.filter(':checked').val() === 'Y') {
                                hideRow = false;
                            }
                        }
                    }
                }
            }
        }

        if (!hideRow) {
            if (personDetailType === 'primary') {
                meerkat.modules.healthPrivateHospitalHistory.addPrimaryValidation();
            } else {
                meerkat.modules.healthPrivateHospitalHistory.addPartnerValidation();
            }
        } else {
            if (personDetailType === 'primary') {
                meerkat.modules.healthPrivateHospitalHistory.removePrimaryValidation();
            } else {
                meerkat.modules.healthPrivateHospitalHistory.removePartnerValidation();
            }
        }

        meerkat.modules.fieldUtilities.toggleVisible(
            $elements['health' + captializePersonDetailType + 'FundHistoryRow'],
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

    meerkat.modules.register('healthApplyStep', {
        init: init,
        onBeforeEnter: onBeforeEnter,
        onInitialise: onInitialise,
        testStatesParity: testStatesParity,
        getPrimaryFirstname: getPrimaryFirstname
    });

})(jQuery);