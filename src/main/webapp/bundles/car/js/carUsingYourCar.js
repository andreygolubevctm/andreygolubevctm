/**
 * Brief explanation of the module and what it achieves. <example: Example
 * pattern code for a meerkat module.> Link to any applicable confluence docs:
 * <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined) {

	var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;

	var events = {
		carEditDetails : {}
	}, moduleEvents = events.carUsingYourCar;

	/* Variables */
	var $carUseDropdown = $('#quote_vehicle_use'),
		$vehicleFieldSet = $('#quote_vehicleFieldSet'),
		$passengerPaymentRadio = $vehicleFieldSet.find('.passengerPayment'),
		$goodsPaymentRadio = $vehicleFieldSet.find('.goodsPayment');

	/* main entrypoint for the module to run first */
	function initUsingYourCar() {
		applyEventListeners();
	}

	function applyEventListeners() {
		$carUseDropdown.on('change', function changeCarUse(){
			if ($(this)[0].selectedIndex > (meerkat.modules.carExotic.isExotic() ? 2 : 1)){
				$passengerPaymentRadio.slideDown();
				$goodsPaymentRadio.slideDown();
			} else {
				$passengerPaymentRadio.slideUp();
				$goodsPaymentRadio.slideUp();
			}
		});
	}
	meerkat.modules.register('carUsingYourCar', {
		initUsingYourCar : initUsingYourCar // main entrypoint to be called.
	});

})(jQuery);