;(function($, undefined){

	var meerkat = window.meerkat;

	var moduleEvents = {
		POLICY_DATE_CHANGE: 'POLICY_DATE_CHANGE'
	};
	var $paymentDay,
	$policyDateHiddenField;

	function init() {

		$(document).ready(function(){
			$paymentDay = $('.health_payment_day');
			$policyDateHiddenField = $('.health_details-policyDate');
			$paymentDay.on('change', function paymentDayChange() {
				meerkat.messaging.publish(moduleEvents.POLICY_DATE_CHANGE,$(this).val());
			});

		});
	}

	// Reset the step
	function paymentDaysRenderEarliestDay($message , euroDate, daysMatch, exclusion) {
		if (typeof exclusion === "undefined") exclusion = 7;
		if (typeof daysMatch === "undefined" || daysMatch.length < 1) daysMatch = [ 1 ];

		var earliestDate = null;
		if (typeof euroDate === "undefined" || euroDate === "") {
			earliestDate = new Date();
		} else {
			earliestDate = meerkat.modules.utilities.returnDate(euroDate);
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
		$policyDateHiddenField.val(meerkat.modules.utilities.returnDateValue(earliestDate));
		$message.text( 'Your payment will be deducted on: ' + healthFunds._getNiceDate(earliestDate) );

	}
	/*
	 * Updates the payment days to be the following month
	 * Param euroDate String in the format dd/MM/yyyy to count from
	 * Param exclusion a buffer (in days) from euroDate to start counting from
	 * Param excludeWeekend, true to exclude weekend from the buffer, false for otherwise
	 * Param isBank, true for bank payment, otherwise cc payment
	 */
	function populateFuturePaymentDays(euroDate, exclusion, excludeWeekend, isBank) {
		var startDate,
			minimumDate,
			childDateOriginal,
			childDateNew,
			$paymentDays;

		if (typeof euroDate === "undefined" || euroDate === "") {
			startDate = new Date(); // default to use today
		} else {
			startDate = meerkat.modules.utilities.returnDate(euroDate);
			}

		if (typeof exclusion === "undefined") exclusion = 7; // default a week buffer
		if (typeof excludeWeekend === "undefined") excludeWeekend = false; // default not to exclude weekend
		if (typeof isBank === "undefined") isBank = true; // default as bank payment

		if (isBank) {
			$paymentDays = $('#health_payment_bank_paymentDay');
		} else {
			$paymentDays = $('#health_payment_credit_paymentDay');
			}

		minimumDate = new Date(startDate);
		if (excludeWeekend) {
			minimumDate = meerkat.modules.utilities.calcWorkingDays(minimumDate, exclusion);
		} else {
			minimumDate.setDate(minimumDate.getDate() + exclusion);
		}
		
		$paymentDays.children().each(function playWithChildren () {
			childDateOriginal = new Date($(this).val());
			childDateNew = compareAndAddMonth(childDateOriginal, minimumDate);
			$(this).val(meerkat.modules.utilities.returnDateValue(childDateNew));
		});
	}

	function compareAndAddMonth(oldDate, minDate) {
		if (oldDate < minDate){
			var newDate = new Date(oldDate.setMonth(oldDate.getMonth() +  1 ));
			return compareAndAddMonth(newDate, minDate)
		}else{
			return oldDate;
		}
	}

	meerkat.modules.register("healthPaymentDate", {
		init: init,
		events: moduleEvents,
		paymentDaysRenderEarliestDay: paymentDaysRenderEarliestDay,
		populateFuturePaymentDays: populateFuturePaymentDays
	});

})(jQuery);