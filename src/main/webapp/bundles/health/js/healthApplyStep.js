;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $paymentDetailsStart,
        $paymentMedicareColour,
        $paymentMedicareCover,
        $medicareYellowMessage,
        $genderToggle,
        $unitElements;

    function init(){
        $(document).ready(function () {
            $paymentDetailsStart = $("#health_payment_details_start");
            $paymentMedicareColour = $("#health_payment_medicare_colour");
            $paymentMedicareCover = $("#health_payment_medicare_cover");
            $medicareYellowMessage = $("#health_medicareDetails_yellowCardMessage");
            $genderToggle = $('.person-gender-toggle input[type=radio]');
            $unitElements = {
                appAddressUnitShop: $('#health_application_address_unitShop'),
                appAddressStreetNum: $('#health_application_address_streetNum'),
                appAddressUnitType: $('#health_application_address_unitType'),
                appPostalUnitShop: $('#health_application_postal_unitShop'),
                appPostalStreetNum: $('#health_application_postal_streetNum'),
                appPostalUnitType: $('#health_application_postal_unitType')
            }
        });
    }

    // Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
    function onBeforeEnter(){
        // Change min and max dates for start date picker based on current stored values from healthPaymentStep module which can change based on selected fund
        var min = meerkat.modules.healthPaymentStep.getSetting('minStartDate');
        var max = meerkat.modules.healthPaymentStep.getSetting('maxStartDate');

        $paymentDetailsStart
            .removeRule('earliestDateEUR')
            .removeRule('latestDateEUR')
            .addRule('earliestDateEUR', min, 'Please enter a date on or after ' + min)
            .addRule('latestDateEUR', max, 'Please enter a date on or before ' + max)
            .datepicker('setStartDate', min)
            .datepicker('setEndDate', max);

        // validate at least 1 contact number is entered
        $('#health_application_mobileinput').addRule('requireOneContactNumber', true, 'Please include at least one phone number');

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PARTNER,
            meerkat.modules.healthAboutYou.getPartnerCurrentCover());

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PRIMARY,
            meerkat.modules.healthAboutYou.getPrimaryCurrentCover());

        toggleSelectGender('primary');

        if (meerkat.modules.health.hasPartner()) {
            toggleSelectGender('partner');
        }

        $unitElements.appAddressUnitType.add($unitElements.appPostalUnitType).on('change', function toggleUnitRequiredFields() {
            _toggleUnitRequired(this.id.includes('address') ? 'Address' : 'Postal', this.value === 'UN');
        });
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

        $(document.body).on('change', '.selectContainerTitle select', function onTitleChange() {
            var personDetailType = $(this).closest('.qe-window').find('.health-person-details')
                                       .hasClass('primary') ? 'primary' : 'partner';

            toggleSelectGender(personDetailType);
        });

        $genderToggle.on('change', function onGenderToggle() {
            var personDetailType = $(this).closest('.qe-window').find('.health-person-details')
                                       .hasClass('primary') ? 'primary' : 'partner',
                gender = $(this).val();

            $('#health_application_' + personDetailType + '_gender').val(gender);
        });
    }

    function toggleSelectGender(personDetailType) {
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

    function _toggleUnitRequired(addressType, isUnit) {
        var $fields = $unitElements['app'+addressType+'UnitShop'].add($unitElements['app'+addressType+'StreetNum']);

        $fields.setRequired(isUnit);

        // blur out of fields to trigger validation when unitType not equal to 'UN'
        if (!isUnit) {
            $fields.blur();
        }
    }

    meerkat.modules.register('healthApplyStep', {
        init: init,
        onBeforeEnter: onBeforeEnter,
        onInitialise: onInitialise
    });

})(jQuery);