;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			healthPriceComponent: {
				INIT: 'PRICE_COMPONENT_INITED'
			}
		},
		moduleEvents = events.healthPriceComponent;

	var logoPriceTemplate;

	var $policySummaryContainer;
	var $policySummaryTemplateHolder;
	var $policySummaryDetailsComponents;
	var $policySummaryDualPricing = [];

	var $displayedFrequency;
	var $startDateInput;



	function init(){

		jQuery(document).ready(function($) {

			if(meerkat.site.vertical !== "health") return false;

			logoPriceTemplate = $("#logo-price-template").html();

			$policySummaryContainer = $(".policySummaryContainer");
			$policySummaryTemplateHolder = $(".policySummaryTemplateHolder");
			$policySummaryDetailsComponents = $(".productSummaryDetails");
			$policySummaryDualPricing = $('.policySummary.dualPricing .productSummary');

			if(VerticalSettings.pageAction != "confirmation"){

				$displayedFrequency = $("#health_payment_details_frequency");
				$startDateInput = $("#health_payment_details_start");

				meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_CHANGED, function(selectedProduct){
					// This should be called when the user selects a product on the results page.
					onProductPremiumChange(selectedProduct, false);
				});

				meerkat.messaging.subscribe(meerkatEvents.healthResults.PREMIUM_UPDATED, function(selectedProduct){
					// This should be called when the user updates their premium on the payment step.
					onProductPremiumChange(selectedProduct, true)
				});

				meerkat.messaging.subscribe(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM, function(selectedProduct){
					$policySummaryContainer.find(".policyPriceWarning").show();
				});

			}

			meerkat.messaging.publish(moduleEvents.INIT);

		});
	}

	function onProductPremiumChange(selectedProduct, showIncPrice){
		// Use the frequency selected on the payment step - if that is not set, refer to the results page frequency.
		var displayedFrequency = $displayedFrequency.val();
		if(displayedFrequency === "") displayedFrequency = Results.getFrequency();
		updateProductSummaryHeader(selectedProduct, displayedFrequency, showIncPrice);

		// Update product summary
		var startDateString = "Please confirm";
		if($startDateInput.val() !== ""){
			startDateString = $startDateInput.val();
		}

		updateProductSummaryDetails(selectedProduct, startDateString);
	}

	function updateProductSummaryHeader(product, frequency, showIncPrice){
		product._selectedFrequency = frequency;

		// Reset any settings for rendering
		if(showIncPrice){
			product.mode = 'lhcInc';
		}else{
			product.mode = '';
		}
		//console.log("UPDATE", showIncPrice,product.mode)
		product.showAltPremium = false;

		var htmlTemplate = _.template(logoPriceTemplate);
		var htmlString = htmlTemplate(product);
		$policySummaryTemplateHolder.html(htmlString);
		$policySummaryContainer.find(".policyPriceWarning").hide();

		if ($policySummaryDualPricing.length > 0) {
			product.showAltPremium = true;
			htmlString = htmlTemplate(product);
			$policySummaryDualPricing.html(htmlString);
		}
	}

	function updateProductSummaryDetails(product, startDateString, displayMoreInfoLink){
		$policySummaryDetailsComponents.find(".name").text(product.info.providerName+" "+product.info.name);
		$policySummaryDetailsComponents.find(".startDate").text(startDateString);
		if (typeof product.hospital.inclusions !== 'undefined') {
			$policySummaryDetailsComponents.find(".excess").html(product.hospital.inclusions.excess);
			$policySummaryDetailsComponents.find(".excessWaivers").html(product.hospital.inclusions.waivers);
			$policySummaryDetailsComponents.find(".copayment").html(product.hospital.inclusions.copayment);
		}

		$policySummaryDetailsComponents.find(".footer").removeClass('hidden');
		$policySummaryDetailsComponents.find(".excess").parent().removeClass('hidden');
		$policySummaryDetailsComponents.find(".excessWaivers").parent().removeClass('hidden');
		$policySummaryDetailsComponents.find(".copayment").parent().removeClass('hidden');

		// hide more info link on request (i.e. confirmation page)
		if (typeof(displayMoreInfoLink) != "undefined" && displayMoreInfoLink === false) {
			$policySummaryDetailsComponents.find(".footer").addClass('hidden');
		}

		// hide some info if it's empty
		if (typeof product.hospital.inclusions === 'undefined' || product.hospital.inclusions.excess === "") {
			$policySummaryDetailsComponents.find(".excess").parent().addClass('hidden');
		}
		if (typeof product.hospital.inclusions === 'undefined' || product.hospital.inclusions.waivers === "") {
			$policySummaryDetailsComponents.find(".excessWaivers").parent().addClass('hidden');
		}
		if (typeof product.hospital.inclusions === 'undefined' || product.hospital.inclusions.copayment === "") {
			$policySummaryDetailsComponents.find(".copayment").parent().addClass('hidden');
		}
	}

	meerkat.modules.register('healthPriceComponent', {
		init: init,
		events: events,
		updateProductSummaryHeader: updateProductSummaryHeader,
		updateProductSummaryDetails: updateProductSummaryDetails
	});

})(jQuery);
