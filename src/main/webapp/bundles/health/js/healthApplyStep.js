;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $paymentDetailsStart;

    function init(){
        $(document).ready(function () {
            $paymentDetailsStart = $("#health_payment_details_start");
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

        // validate at least 1 contact number is entered (simples)
        if(meerkat.site.isCallCentreUser === true) {
            $('#health_application_mobileinput').addRule('requireOneContactNumber', true, 'Please include at least one phone number');
        }

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PARTNER,
            meerkat.modules.healthAboutYou.getPartnerCurrentCover());

        meerkat.messaging.publish(meerkatEvents.healthPreviousFund.POPULATE_PRIMARY,
            meerkat.modules.healthAboutYou.getPrimaryCurrentCover());
    }

    function onInitialise() {
        // initialise start date datepicker from payment step as it will be used by selected fund
        $paymentDetailsStart
            .datepicker({ clearBtn:false, format:"dd/mm/yyyy" })
            .on("changeDate", function updateStartCoverDateHiddenField(e) {
                // fill the hidden field with selected value
                $("#health_payment_details_start").val( e.format() );
                meerkat.messaging.publish(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM);
            });

    }

    meerkat.modules.register('healthApplyStep', {
        init: init,
        onBeforeEnter: onBeforeEnter,
        onInitialise: onInitialise
    });

})(jQuery);