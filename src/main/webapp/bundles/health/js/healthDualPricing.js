;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		$logoPriceTemplate,
		$dualPricingTemplate,
		$displayedFrequency,
		$whyPremiumsRiseLink,
		$whyPremiumsRiseTemplate,
		selectedProduct,
		modalId = null;

	function initHealthDualPricing() {
		$logoPriceTemplate = $('#logo-price-template'),
		$dualPricingTemplate = $('#dual-pricing-template'),
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

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function editDetailsEnterXsState() {
			hideModal();
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function editDetailsLeaveXsState() {
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
				var $editDetails = $('.'+modalName+'-wrapper', $('#' + modalId));
				$editDetails.html(htmlContent);
				meerkat.modules.contentPopulation.render('#' + modalId + ' .edit-details-wrapper');
				$('.accordion-collapse').on('show.bs.collapse', function(){
					$(this).prev('.accordion-heading').addClass("active-panel");
				}).on('hide.bs.collapse',function(){
					$(this).prev('.accordion-heading').removeClass("active-panel");
				});
				$editDetails.show();
			}
		});
		return modalId;
	}

	function hideModal() {
		if(modalId !== null) {
			$('#'+modalId).modal('hide');
		}
	}

	function renderTemplate(target, product, returnTemplate) {
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

		var dualPriceTemplate = _.template($dualPricingTemplate.html());

		if (returnTemplate === true) {
			return dualPriceTemplate(product);
		} else {
			$(target).html(dualPriceTemplate(product));
		}
	}

	meerkat.modules.register("healthDualPricing", {
		initHealthDualPricing: initHealthDualPricing,
		renderTemplate: renderTemplate
	});

})(jQuery);