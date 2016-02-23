;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		$logoPriceTemplate,
		$mainDualPricingTemplate,
		$dualPricingTemplate,
		$dualPricingTemplateSM,
		$dualPricingTemplateXS,
		$displayedFrequency,
		$whyPremiumsRiseLink,
		$whyPremiumsRiseTemplate,
		selectedProduct,
		modalId = null;

	function initHealthDualPricing() {
		$logoPriceTemplate = $('#logo-price-template'),
		$dualPricingTemplate = $('#dual-pricing-template'),
		$dualPricingTemplateSM = $('#dual-pricing-template-sm'),
		$dualPricingTemplateXS = $('#dual-pricing-template-xs'),
		$displayedFrequency = $("#health_payment_details_frequency"),
		$whyPremiumsRiseLink = $('a.why-rising-premiums'),
		$whyPremiumsRiseTemplate = $('#more-info-why-price-rise-template'),
		selectedProduct = {};

		applyListenerEvents();
	}

	function applyListenerEvents() {
		$(document).on('click', 'a.why-rising-premiums', function showWhyModal(){
			showModal();
		});

		meerkat.messaging.subscribe(meerkatEvents.device.DEVICE_MEDIA_STATE_CHANGE, function editDetailsEnterXsState() {
			hideModal();
		});

	}

	/**
	 * Shows the modal in a wrapper, scoped to the modal (otherwise collapse
	 * won't work).
	 */
	function showModal() {
		selectedProduct.callCentreNumber = meerkat.site.content.callCentreHelpNumber;

		var htmlTemplate = _.template($whyPremiumsRiseTemplate.html()),
			htmlContent = htmlTemplate(selectedProduct),
			modalName = 'why-premiums-rising';

		modalId = meerkat.modules.dialogs.show({
			htmlContent : '<div class="'+modalName+'-wrapper"></div>',
			hashId : modalName,
			className: modalName,
			closeOnHashChange : true,
			onOpen : function(modalId) {
				var $premiumsRising = $('.'+modalName+'-wrapper', $('#' + modalId));
				$premiumsRising.html(htmlContent).show();
			}
		});
		return modalId;
	}

	function hideModal() {
		if(modalId !== null) {
			$('#'+modalId).modal('hide');
		}
	}

	function renderTemplate(target, product, returnTemplate, isForSidebar) {
		selectedProduct = product;

		product._selectedFrequency = typeof product._selectedFrequency === 'undefined' !== '' ? Results.getFrequency() : product._selectedFrequency;
		product.mode = product.mode !== '' ? product.mode : '';
		product.showAltPremium = false;
		product.displayLogo = false;
		product.showRoundingText = false;

		var htmlTemplate = _.template($logoPriceTemplate.html());
		product.renderedPriceTemplate = htmlTemplate(product);

		product.showAltPremium = true;
		htmlTemplate = _.template($logoPriceTemplate.html());
		product.renderedAltPriceTemplate = htmlTemplate(product);

		$mainDualPricingTemplate = getTemplate(isForSidebar);

		var dualPriceTemplate = _.template($mainDualPricingTemplate.html());

		if (returnTemplate === true) {
			return dualPriceTemplate(product);
		} else {
			$(target).html(dualPriceTemplate(product));
		}
	}

	function getTemplate(isForSidebar) {

		if (isForSidebar) {
			return $dualPricingTemplate;
		}

		switch (meerkat.modules.deviceMediaState.get()) {
			case 'xs':
				return $dualPricingTemplateXS;
				break;
			case 'sm':
				return $dualPricingTemplateSM;
				break;
			default:
				return $dualPricingTemplate;
		}
	}

	meerkat.modules.register("healthDualPricing", {
		initHealthDualPricing: initHealthDualPricing,
		renderTemplate: renderTemplate
	});

})(jQuery);