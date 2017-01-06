;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $paymentDetailsStart,
        $paymentMedicareColour,
        $paymentMedicareCover,
        $medicareYellowMessage,
        $genderToggle;

    function init(){
        $(document).ready(function () {
            $paymentDetailsStart = $("#health_payment_details_start");
            $paymentMedicareColour = $("#health_payment_medicare_colour");
            $paymentMedicareCover = $("#health_payment_medicare_cover");
            $medicareYellowMessage = $("#health_medicareDetails_yellowCardMessage");
            $genderToggle = $('.person-gender-toggle input[type=radio]');
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
            meerkat.modules.healthPartner.getCurrentCover());

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PRIMARY,
            meerkat.modules.healthPrimary.getCurrentCover());

        toggleSelectGender('primary');

        if (meerkat.modules.health.hasPartner()) {
            toggleSelectGender('partner');
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

    function testStatesParity() {
        var $applicationState = $('#health_application_address_state');

        if ($applicationState.val() !== $('#health_situation_state').val()) {
            var suburb = $('#health_application_address_suburbName').val(),
                $applicationPostcode = $('#health_application_address_postCode'),
                state = $applicationState.val();

            if (suburb.length && suburb.indexOf('Please select') < 0 && $applicationPostcode.val().length == 4 && state.length) {
                $applicationPostcode.addClass('error');
                return false;
            }
        }

        return true;
    }

    meerkat.modules.register('healthApplyStep', {
        init: init,
        onBeforeEnter: onBeforeEnter,
        onInitialise: onInitialise,
        testStatesParity: testStatesParity
    });

})(jQuery);