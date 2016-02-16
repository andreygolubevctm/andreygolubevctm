;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var $frequencyWarning,
		frequencyWarningOriginalText,
		$paymentDetailsFrequency,
		$paymentDetailsSelection,
		currentProduct;

	function initHealthCutOffDate(){
		$paymentDetailsSelection = $('#health_payment_details-selection');
		$frequencyWarning = $paymentDetailsSelection.find('.frequencyWarning');
		frequencyWarningOriginalText = $frequencyWarning.html(),
		$paymentDetailsFrequency = $paymentDetailsSelection.find('#health_payment_details_frequency');

		applyEventListeners();
	}

	function setProduct(product) {
		currentProduct = product;
	}

	function applyEventListeners() {
		$paymentDetailsFrequency.on('change', function updateWarningLabel(){

			if ($(this).val().toLowerCase() == 'annually') {
				$frequencyWarning.slideUp().html("");
			} else {
				var updatedText = frequencyWarningOriginalText.replace('[COD]', currentProduct.cutOffDate);
				$frequencyWarning.html(updatedText).removeClass("hidden").slideDown();
			}
		});
	}

	meerkat.modules.register('healthCutOffDate', {
		initHealthCutOffDate: initHealthCutOffDate,
		setProduct: setProduct
	});

})(jQuery);
