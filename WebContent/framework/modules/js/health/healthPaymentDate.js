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

	meerkat.modules.register("healthPaymentDate", {
		init: init,
		events: moduleEvents,
		paymentDaysRenderEarliestDay: paymentDaysRenderEarliestDay
	});

})(jQuery);