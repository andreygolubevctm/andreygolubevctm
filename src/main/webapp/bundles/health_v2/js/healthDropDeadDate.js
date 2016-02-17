;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var $frequencyWarning,
		frequencyWarningOriginalText,
		$paymentDetailsFrequency,
		$paymentDetailsSelection,
		$whyPriceRiseTemplate,
		$whyPriceRiseLink,
		$priceFrequencyTemplate,
		obj = {};

	function initHealthDropDeadDate(){
		$paymentDetailsSelection = $('#health_payment_details-selection');
		$frequencyWarning = $paymentDetailsSelection.find('.frequencyWarning');
		frequencyWarningOriginalText = $frequencyWarning.html(),
		$paymentDetailsFrequency = $paymentDetailsSelection.find('#health_payment_details_frequency'),
		$whyPriceRiseTemplate = $('#more-info-why-price-rise-template'),
		$whyPriceRiseLink = $('#resultsPage .whyPriceRises'),
		$priceFrequencyTemplate = $('#price-frequency-template');

		applyEventListeners();
	}

	function setDropDeadDate(product) {
		obj.dropDeadDate = product.dropDeadDate;
	}

	function applyEventListeners() {
		$paymentDetailsFrequency.on('change', function updateWarningLabel(){
			if ($(this).val().toLowerCase() == 'annually') {
				$frequencyWarning.slideUp().html("");
			} else {
				$frequencyWarning.html(generateHTMLContent($priceFrequencyTemplate)).removeClass("hidden").slideDown();
			}
		});

		$whyPriceRiseLink.on('click', function updateWhyPricesRisePopUp() {
			$(this).html(generateHTMLContent($whyPriceRiseTemplate));
		});
	}

	function generateHTMLContent($template) {
		var template = _.template($template.html());
		return template(obj);
	}

	meerkat.modules.register('healthDropDeadDate', {
		initHealthDropDeadDate: initHealthDropDeadDate,
		setDropDeadDate: setDropDeadDate
	});

})(jQuery);
