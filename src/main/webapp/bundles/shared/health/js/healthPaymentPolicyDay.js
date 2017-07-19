;(function ($, undefined) {

    var meerkat = window.meerkat;
	var $policyDayCredit,
		$policyDayBank,
		$policyDayMessageCredit,
		$policyDayMessageBank,
		initialised = false;

	function init() {
		initialised = true;
        $policyDayCredit = $('.health_payment_credit_details-policyDay');
        $policyDayBank = $('.health_payment_bank_details-policyDay');
        $policyDayMessageCredit = $('.health_payment_credit-details_policyDay-message');
        $policyDayMessageBank =$('.health_payment_bank-details_policyDay-message');
	}
	
	/*
	 * Param messageText message to display about deduction date
	 */
	function populatePaymentDay( messageText) {
        if(!initialised) init();
        meerkat.modules.healthFunds.setPayments({ 
            'min':6, 
            'max':7, 
            'weekends':false 
        });
		meerkat.modules.healthPaymentStepView
            .getPaymentStartDate()
			.datepicker('setDaysOfWeekDisabled', '0,6');
		var date = new Date();
		var _html = meerkat.modules.healthPaymentDay
			.paymentDays(meerkat.modules.dateUtils
                .dateValueFormFormat(date)
            );
		meerkat.modules.healthPaymentDay
            .paymentDaysRender( $policyDayBank, _html);
		meerkat.modules.healthPaymentDay
            .paymentDaysRender( $policyDayCredit, _html);

		//Select the only option
		$policyDayCredit.prop('selectedIndex',1);
		$policyDayBank.prop('selectedIndex',1);
		
        // Change the deduction rate message
		setPaymentDayMessage( messageText);
	}

	// Change the deduction date message
	function setPaymentDayMessage( messageText) {
        if(!initialised) init();
		if(meerkat.modules.healthPaymentStep
                .getSelectedPaymentMethod() == 'cc'){
			$policyDayMessageCredit.text(messageText);
		} else {
			$policyDayMessageBank.text(messageText);
		}
	}

	function updatePaymentEventListeners(functionToCall, name){
		meerkat.modules.healthPaymentStepView.getPaymentTypeInput().on('click.' + name, functionToCall);
		meerkat.modules.healthPaymentStepView.getPaymentFrequencyInput().on('change.' + name, functionToCall);
		meerkat.modules.healthCoverStartDateView.updateEventListeners(functionToCall, name);
	}

	function resetPaymentEventListeners( name ){
		meerkat.modules.healthPaymentStepView.getPaymentTypeInput().off('click.' + name);
		meerkat.modules.healthPaymentStepView.getPaymentFrequencyInput().off('change.' + name);
		meerkat.modules.healthCoverStartDateView.resetEventListeners(name);
	}

    /*
    reset selections for payment date 
    */
    function reset(providerName) {
        if(!initialised) init();
       //reset selections for payment date
        meerkat.modules.healthPaymentDay.paymentDaysRender( $policyDayBank, false);
		meerkat.modules.healthPaymentDay.paymentDaysRender( $policyDayCredit, false);
		resetPaymentEventListeners(providerName);
    }

	meerkat.modules.register("healthPaymentPolicyDay", {
		updatePaymentEventListeners : updatePaymentEventListeners,
		populatePaymentDay: populatePaymentDay,
		setPaymentDayMessage : setPaymentDayMessage,
        reset: reset
	});

})(jQuery);