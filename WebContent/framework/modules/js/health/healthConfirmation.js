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
				confirmationProduct.mode = "lhcInc";

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

				// prepare hospital and extras covers inclusions, exclusions and restrictions
				meerkat.modules.healthMoreInfo.setProduct(confirmationProduct);
				
				//Now prepare cover.
				meerkat.modules.healthMoreInfo.prepareCover();

				// prepare necessary frequency values
				if( confirmationProduct.frequency.length == 1) { // if found frequency is a letter code, translate it to full word
					confirmationProduct.frequency = meerkat.modules.healthResults.getFrequencyInWords(confirmationProduct.frequency);
				}
				confirmationProduct._selectedFrequency = confirmationProduct.frequency;

				fillTemplate();

				meerkat.modules.healthMoreInfo.applyEventListeners();

				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method:'completedApplication',
					object:{
						productID: confirmationProduct.productId,
						vertical: meerkat.site.vertical,
						productBrandCode: confirmationProduct.info.provider,
						productName: confirmationProduct.info.productTitle,
						quoteReferenceNumber: confirmationProduct.transactionId,
						simplesUser: meerkat.site.isCallCentreUser
					}
				});

			}

		});

	}

	function fillTemplate(){

		var confirmationTemplate = $("#confirmation-template").html();
		var htmlTemplate = _.template(confirmationTemplate);
		var htmlString = htmlTemplate(confirmationProduct);
		$("#confirmation").html(htmlString);

		meerkat.messaging.subscribe(meerkatEvents.healthPriceComponent.INIT, function(selectedProduct){
			// inject the price and product summary
			meerkat.modules.healthPriceComponent.updateProductSummaryHeader(confirmationProduct, confirmationProduct.frequency, true);
			meerkat.modules.healthPriceComponent.updateProductSummaryDetails(confirmationProduct, confirmationProduct.startDate, false);
		});

		// if pending, it might not have the aboud fund info so let's get it
		if(confirmationProduct.about === ""){
			meerkat.modules.healthMoreInfo.prepareExternalCopy(function confirmationExternalCopySuccess(){
				$(".aboutFund").append(confirmationProduct.aboutFund).parents(".displayNone").first().removeClass("displayNone");
			});
		}

	}

	meerkat.modules.register('healthConfirmation', {
		init: init
	});

})(jQuery);