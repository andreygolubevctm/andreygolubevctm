;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $paymentDetailsStart,
        $paymentMedicareColour,
        $paymentMedicareCover,
        $medicareYellowMessage,

        genderElems = {
            primary: {},
            partner: {}
        },

        $titleSelect,
        $genderToggle;

    function init(){
        $(document).ready(function () {
            $paymentDetailsStart = $("#health_payment_details_start");
            $paymentMedicareColour = $("#health_payment_medicare_colour");
            $paymentMedicareCover = $("#health_payment_medicare_cover");
            $medicareYellowMessage = $("#health_medicareDetails_yellowCardMessage");

            genderElems.primary = {
                $title: $('#health_application_primary_title'),
                $gender: $('#health_application_primary_gender'),
                $genderRow: $('#health_application_primary_genderRow'),
                $genderToggle: $('[name=health_application_primary_genderToggle]')
            };

            $titleSelect = $('.selectContainerTitle select');
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
            meerkat.modules.healthAboutYou.getPartnerCurrentCover());

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PRIMARY,
            meerkat.modules.healthAboutYou.getPrimaryCurrentCover());
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


        $titleSelect.on('change', function onTitleChange() {
            var personDetailType = $(this).closest('.qe-window').find('.health-person-details')
                                       .hasClass('primary') ? 'primary' : 'partner';

            toggleSelectGender(personDetailType);
        });

        $genderToggle.on('change', function onGenderToggle() {
            var personDetailType = $(this).closest('.qe-window').find('.health-person-details')
                                       .hasClass('primary') ? 'primary' : 'partner',
                gender = $(this).val();

            genderElems[personDetailType].$gender.val(gender);
        });

        toggleSelectGender('primary');

        if (meerkat.modules.health.hasPartner()) {
            genderElems.partner = {
                $title: $('#health_application_partner_title'),
                $gender: $('#health_application_partner_gender'),
                $genderRow: $('#health_application_partner_genderRow'),
                $genderToggle: $('[name=health_application_partner_genderToggle]')
            };

            toggleSelectGender('partner');
        }
    }

    function toggleSelectGender(personDetailType) {
        var title = genderElems[personDetailType].$title.val(),
            gender;

        switch (title) {
            case 'DR':
                var genderToggleVal = genderElems[personDetailType].$genderToggle.filter(':checked').val();

                if (genderToggleVal) {
                    // if gender toggle has been 'toggled' before then
                    // set hidden gender field to the checked gender
                    genderElems[personDetailType].$gender.val(genderToggleVal);
                } else {
                    // otherwise, if hidden gender field has been set, then
                    // toggle the gender
                    if (genderElems[personDetailType].$gender.val()) {
                        genderElems[personDetailType].$genderToggle
                            .filter('[value=' + genderElems[personDetailType].$gender.val() + ']')
                            .prop('checked', true)
                            .attr('checked', 'checked')
                            .change();
                    }
                }
                genderElems[personDetailType].$genderRow.slideDown();
                break;

            case 'MR':
            case 'MRS':
            case 'MISS':
            case 'MS':
                gender = title === 'MR' ? 'M' : 'F';
                genderElems[personDetailType].$gender.val(gender);
                genderElems[personDetailType].$genderRow.slideUp();
                break;

            default:
                genderElems[personDetailType].$genderRow.slideUp();
        }
    }

    meerkat.modules.register('healthApplyStep', {
        init: init,
        onBeforeEnter: onBeforeEnter,
        onInitialise: onInitialise
    });

})(jQuery);