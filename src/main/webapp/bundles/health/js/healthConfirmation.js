//
// Health Confirmation Module
//
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var confirmationProduct = null;

	function init(){

		jQuery(document).ready(function($) {

			if (typeof meerkat.site === 'undefined') return;
			if (meerkat.site.pageAction !== "confirmation") return;

			meerkat.modules.coupon.renderCouponBanner();

			meerkat.modules.health.initProgressBar(true);

			meerkat.modules.journeyProgressBar.setComplete();
			meerkat.modules.journeyProgressBar.disable();

			// Handle error display
			// 'results' is a global object added by slide_confirmation.tag
			if (result.hasOwnProperty('data') === false || result.data.status != 'OK' || result.data.product === '') {
				meerkat.modules.errorHandling.error({
					message: result.data.message,
					page: "healthConfirmation.js module",
					description: "Trying to load the confirmation page failed",
					data: null,
					errorLevel: "warning"
				});

				// Handle normal display
			} else {

				// prepare data
				confirmationProduct = $.extend({},result.data);

				// if confirmation has been loaded from the confirmations table in the db, confirmationProduct.product should exist
				if( confirmationProduct.product ){

					confirmationProduct.pending = false;
					confirmationProduct.product = $.parseJSON(confirmationProduct.product);
					if( confirmationProduct.product.price && _.isArray(confirmationProduct.product.price) ){
						confirmationProduct.product = confirmationProduct.product.price[0];
					}

					// merge the product info at the root of the object and clean up
					$.extend(confirmationProduct, confirmationProduct.product);
					delete confirmationProduct.product;

					// if confirmationProduct.product does not exist, it might be a pending order.
					// If the order has just been passed, this means we can find the product info in the session
					// this should have been made available on the page by health-layout:slide_confirmation.tag

				} else if( typeof sessionProduct === "object" ){

					if( sessionProduct.price && _.isArray(sessionProduct.price) ){
						sessionProduct = sessionProduct.price[0];
					}

					if(confirmationProduct.transID === sessionProduct.transactionId){
						// merge the product info at the root of the object and clean up
						$.extend(confirmationProduct, sessionProduct);
					} else {
						sessionProduct = undefined;
					}

					confirmationProduct.pending = true;
				} else {
					// otherwise, well we just won't display the info we could not find
					confirmationProduct.pending = true;
				}

				fillTemplate();

				/// TODO: Fix this -why is it needed though?
				//meerkat.modules.healthMoreInfo.applyEventListeners();

				var tracking = {
					productID: confirmationProduct.productId,
					productBrandCode: confirmationProduct.info.provider,
					productName: confirmationProduct.info.productTitle,
					quoteReferenceNumber: confirmationProduct.transactionId,
					reedemedCouponID: $('.coupon-confirmation').data('couponId')
				};

				meerkat.modules.tracking.updateObjectData(tracking);

				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method:'completedApplication',
					object:tracking
				});
			}

		});

	}

	function fillTemplate(){

		var confirmationTemplate = $("#confirmation-template").html();
		var htmlTemplate = _.template(confirmationTemplate);
		var htmlString = htmlTemplate(confirmationProduct);
		$("#confirmation").html(htmlString);

		// hide the sidebar frequncy. only needed for payment page
		$('.hasDualPricing .sidebarFrequency').hide();
	}

	meerkat.modules.register('healthConfirmation', {
		init: init
	});

})(jQuery);