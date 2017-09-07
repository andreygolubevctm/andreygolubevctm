;(function($, undefined){
    var $paymentCalendar,
        $paymentTypeInput,
        $paymentFrequencyInput,
	 meerkat = window.meerkat,
     initialised = false;

    function init(){
        initialised = true;
        $paymentCalendar = $('#health_payment_details_start');
        $paymentTypeInput = $('#health_payment_details_type input');
        $paymentFrequencyInput = $('#health_payment_details_frequency');
    }

	function getPaymentStartDate(){
        if(!initialised) init();
		return $paymentCalendar;
	}

    function getPaymentTypeInput(){
        if(!initialised) init();
        return $paymentTypeInput;
    }

    function getPaymentFrequencyInput(){
        if(!initialised) init();
        return $paymentFrequencyInput;
    }

	meerkat.modules.register("healthPaymentStepView", {
        getPaymentStartDate : getPaymentStartDate,
        getPaymentTypeInput : getPaymentTypeInput,
        getPaymentFrequencyInput : getPaymentFrequencyInput

	});

})(jQuery);