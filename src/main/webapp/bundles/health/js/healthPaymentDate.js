;(function($, undefined){

	var meerkat = window.meerkat;

	var moduleEvents = {
		POLICY_DATE_CHANGE: 'POLICY_DATE_CHANGE'
	};
	var $paymentDay,
		$policyDateHiddenField,
		initialised = false;

	function initPaymentDate() {

		if(!initialised){
			initialised = true;
			$paymentDay = $('.health_payment_day');
			$policyDateHiddenField = $('.health_details-policyDate');
			$paymentDay.on('change', function paymentDayChange() {
				meerkat.messaging.publish(moduleEvents.POLICY_DATE_CHANGE,$(this).val());
			});
		}
	}

	// Reset the step
	function paymentDaysRenderEarliestDay($message , euroDate, daysMatch, exclusion) {
		if (typeof exclusion === "undefined") exclusion = 7;
		if (typeof daysMatch === "undefined" || daysMatch.length < 1) daysMatch = [ 1 ];

		var earliestDate = null;
		if (typeof euroDate === "undefined" || euroDate === "") {
			earliestDate = new Date();
		} else {
			earliestDate = meerkat.modules.dateUtils.returnDate(euroDate);
		}

		// creating the base date from the exclusion
		earliestDate = new Date( earliestDate.getTime() + (exclusion * 24 * 60 * 60 * 1000));

		// Loop through 31 attempts to match the next date
		var i = 0;
		var foundMatch = false;
		while (i < 31 && !foundMatch) {
			earliestDate = new Date( earliestDate.getTime() + (1 * 24 * 60 * 60 * 1000));
			foundMatch = _.contains(daysMatch, earliestDate.getDate());
			i++;
		}
		$policyDateHiddenField.val(meerkat.modules.dateUtils.dateValueServerFormat(earliestDate));
		$message.text( 'Your payment will be deducted on: ' + meerkat.modules.dateUtils.dateValueLongFormat(earliestDate) );

	}
	/*
	 * Updates the payment days to be the following month
	 * Param euroDate String in the format dd/MM/yyyy to count from
	 * Param exclusion a buffer (in days) from euroDate to start counting from
	 * Param excludeWeekend, true to exclude weekend from the buffer, false for otherwise
	 * Param isBank, true for bank payment, otherwise cc payment
	 */
	function populateFuturePaymentDays(euroDate, exclusion, excludeWeekend, isBank, maxDayOfTheMonth) {
		var startDate,
			minimumDate,
			$paymentDays;

		if (typeof euroDate === "undefined" || euroDate === "") {
			startDate = new Date(); // default to use today
		} else {
			startDate = meerkat.modules.dateUtils.returnDate(euroDate);
		}

		if (typeof exclusion === "undefined") exclusion = 7; // default a week buffer
		if (typeof excludeWeekend === "undefined") excludeWeekend = false; // default not to exclude weekend
		if (typeof isBank === "undefined") isBank = true; // default as bank payment

        var baseId = "";

		if (isBank) {
            baseId = '#health_payment_bank_paymentDay';
		} else {
            baseId = '#health_payment_credit_paymentDay';
        }

        $paymentDays = $(baseId);

		minimumDate = new Date(startDate);
		if (excludeWeekend) {
			minimumDate = meerkat.modules.utils.calcWorkingDays(minimumDate, exclusion);
		} else {
			minimumDate.setDate(minimumDate.getDate() + exclusion);
		}
        var html;
        if (_.isNumber(maxDayOfTheMonth)) {
            html = meerkat.modules.healthPaymentDay.paymentDaysOfTheMonth(minimumDate, maxDayOfTheMonth);
        } else {
            html = meerkat.modules.healthPaymentDay.paymentDays( minimumDate );
        }
		$paymentDays.html(html);

		meerkat.modules.healthApplicationDynamicScripting.setPaymentDayTextForDialogue($paymentDays.find(":selected").text());
		meerkat.modules.healthApplicationDynamicScripting.performUpdatePaymentDayDynamicDialogueBox();
	}

	meerkat.modules.register("healthPaymentDate", {
		initPaymentDate: initPaymentDate,
		events: moduleEvents,
		paymentDaysRenderEarliestDay: paymentDaysRenderEarliestDay,
		populateFuturePaymentDays: populateFuturePaymentDays
	});

})(jQuery);