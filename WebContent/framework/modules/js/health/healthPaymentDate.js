;(function($, undefined){

	var meerkat = window.meerkat;

	var moduleEvents = {
		POLICY_DATE_CHANGE: 'POLICY_DATE_CHANGE'
	};
	var $paymentDay;

	function init() {

		$(document).ready(function(){
			$paymentDay = $('.health_payment_day');
			$paymentDay.on('change', function paymentDayChange() {
				meerkat.messaging.publish(moduleEvents.POLICY_DATE_CHANGE,$(this).val());
			});

		});
	}

	// Reset the step
	function paymentDaysRenderEarliestDay($object , $message , euroDate, dayMatch, exclusion) {
		var date = "";
		var displayDate = "";
		if( typeof dayMatch === 'undefined' || euroDate === ''  || dayMatch < 1) {
			return false;
		}
		// creating the base date from the exclusion
		var _now = returnDate(euroDate);
		var _date = new Date( _now.getTime() + (exclusion * 24 * 60 * 60 * 1000));
		// Loop through 31 attempts to match the next date
		for (var i=0; i < 31; i++) {
			_date = new Date( _date.getTime() + (1 * 24 * 60 * 60 * 1000));
			// Loop through the selected days and attempt a match
			if(dayMatch === _date.getDate() ) {
				var _dayString = leadingZero( _date.getDate() );
				var _monthString = leadingZero( _date.getMonth() + 1 );
				date = _date.getFullYear() +'-'+ _monthString +'-'+ _dayString;
				displayDate = healthFunds._getNiceDate(_date);
				match = true;
				break;
			}
		}

		$object.val(date);
		$message.text( 'Your payment will be deducted on: ' + displayDate );

	}


	meerkat.modules.register("healthPaymentDate", {
		init: init,
		events: moduleEvents,
		paymentDaysRenderEarliestDay: paymentDaysRenderEarliestDay
	});

})(jQuery);