;(function($, undefined){

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events,
	moduleEvents = {},
	callCentreNumber = '.callCentreNumber',
	applicationSteps = ['apply','payment']; // Confirmation page is its own page and just uses the Application Number

	function init() {
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChangeChangePhone(step){
			_.defer(function() {
				changePhoneNumber(false);
			});
		});
	}

	function changePhoneNumber (isModal) {
		var $callCentreFields = $(callCentreNumber),
		$callCentreHelpFields = $('.callCentreHelpNumber');

		var navigationId = meerkat.modules.address.getWindowHash().split("/")[0];
		if(isModal === true) {
			$callCentreFields = $(".more-info-content").find(callCentreNumber);
		}
		if (applicationSteps.indexOf(navigationId) > -1){
			$callCentreFields.text(meerkat.site.content.callCentreNumberApplication);
			$callCentreFields.closest('.callCentreNumberClick').attr("href", "tel:"+meerkat.site.content.callCentreNumberApplication); // Need to change mobile clicks
			$callCentreHelpFields.text(meerkat.site.content.callCentreHelpNumberApplication);
		}else{
			$callCentreFields.text(meerkat.site.content.callCentreNumber);
			$callCentreFields.closest('.callCentreNumberClick').attr("href", "tel:"+meerkat.site.content.callCentreNumber); // Need to change mobile clicks
			$callCentreHelpFields.text(meerkat.site.content.callCentreHelpNumber);
		}
	}

	meerkat.modules.register("healthPhoneNumber", {
		init: init,
		events: moduleEvents,
		changePhoneNumber: changePhoneNumber
	});

})(jQuery);