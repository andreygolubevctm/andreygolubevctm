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

			if(_.isObject(result) && _.has(result,'ConfirmationData')) {
				result.data = result.ConfirmationData;
				result = _.pick(result,'data');
			}

			// Handle error display
			// 'results' is a global object added by slide_confirmation.tag
			if (result.hasOwnProperty('data') === false || result.data.status != 'OK' || result.data.product === '') {
				meerkat.modules.errorHandling.error({
					message: result.hasOwnProperty('data') ? result.data.message : 'Failed to load confirmation data',
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
				meerkat.modules.moreInfo.setProduct(confirmationProduct);

				//Now prepare cover.
				meerkat.modules.healthMoreInfo.prepareCover();

				// prepare necessary frequency values
				if( confirmationProduct.frequency.length == 1) { // if found frequency is a letter code, translate it to full word
					confirmationProduct.frequency = meerkat.modules.healthResults.getFrequencyInWords(confirmationProduct.frequency);
				}
				confirmationProduct._selectedFrequency = confirmationProduct.frequency;
				meerkat.modules.healthPaymentStep.initFields(); // not sure why this works to allow the next call to work but it seems to be the only way to figure out what payment type they selected

				// prep the coverType since we can't access  meerkat.modules.health.getCoverType()
				// info.ProductType doesn't exist if it's a failed join
				if (!_.isEmpty(confirmationProduct.info.ProductType)) {
					switch (confirmationProduct.info.ProductType.toLowerCase()) {
						case 'combined':
							confirmationProduct.promo.coverType = 'C';
							break;
						case 'hospital':
							confirmationProduct.promo.coverType = 'H';
							break;
						default:
							confirmationProduct.promo.coverType = 'E';
							break;
					}
				}

				if(!confirmationProduct.hasOwnProperty('premium')) {
					if (confirmationProduct.paymentType) {
						var paymentType;
						switch (confirmationProduct.paymentType) {
							case 'cc':
								paymentType = 'CreditCard';
								break;
							case 'ba':
								paymentType = 'BankAccount';
								break;

						}
						confirmationProduct.premium = confirmationProduct.paymentTypePremiums[paymentType];
					}
				}

				fillTemplate();
				meerkat.modules.healthPriceComponent.initHealthPriceComponent();

				/// TODO: Fix this -why is it needed though?
				//meerkat.modules.healthMoreInfo.applyEventListeners();

				// add the brochure if it's not a failed join
				if (!_.isEmpty(confirmationProduct.info.ProductType)) {
					var brochureTemplate = meerkat.modules.templateCache.getTemplate($("#brochure-download-template"));
					$('.brochurePlaceholder').html(brochureTemplate(confirmationProduct));
				}

				var tracking = {
					productID: confirmationProduct.productId,
					productBrandCode: confirmationProduct.info.provider,
					productName: confirmationProduct.info.productTitle,
					quoteReferenceNumber: confirmationProduct.transactionId,
					reedemedCouponID: $('.coupon-confirmation').data('couponId'),
					saleChannel: 'health ' +
						(meerkat.site.isCallCentreUser ?
							(meerkat.site.isContactTypeTrialCampaign ? 'trial campaign' : meerkat.site.contactType) :
							'online'
						)
				};

				meerkat.modules.tracking.updateObjectData(tracking);

				// Only track on first view of page
				if(confirmationProduct.hasOwnProperty("viewed") && confirmationProduct.viewed === false) {
					meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
						method: 'completedApplication',
						object: tracking
					});
					meerkat.modules.tracking.recordTouch('CONF','Confirmation Viewed');

					// Call center joins to be posted to Google
					if(meerkat.site.isCallCentreUser) {
						// Allow small delay to allow page objects to load in
						_.delay(registerSaleWithGA,500);
					}
				}
			}

		});

	}

	function registerSaleWithGA() {
		var data = {
			v :		1,
			t :		'event',
			ec :	'health journey conversions',
			ea :	'health completed application',
			el :	'health cc sale',
			ds :	'call center',
			dp :	'/ctm/health_confirmation_v2.jsp',
			cd104 :	meerkat.site.contactType,
			cd105 :	meerkat.site.userId,
			cd28 :	meerkat.modules.transactionId.get(),
		};
		meerkat.modules.tracking.sendSaleDataToGoogleMeasurementProtocol(data);
	}

	function adjustLayout() {
		var $mainForm = $('#mainform');

		// widen the side bars so we're now 12 cols across
		$mainForm.find('.fieldset-column-side.col-sm-3').removeClass('col-sm-3').addClass('col-sm-4');

		// move the footer to match design
		$mainForm.find('.confirmation-other-products').appendTo('#confirmation');
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

		adjustLayout();

		if (meerkat.modules.healthDualPricing.isDualPricingActive() && _.has(confirmationProduct, 'paymentTypeAltPremiums')) {
			// render dual pricing
			meerkat.modules.healthDualPricing.initDualPricing();
			confirmationProduct.altPremium = confirmationProduct.paymentTypeAltPremiums[meerkat.modules.healthPaymentStep.getPaymentMethodNode(confirmationProduct.paymentType)];
			meerkat.modules.healthDualPricing.renderTemplate('.policySummary.dualPricing', confirmationProduct, false, true);
		}

		// hide the sidebar frequncy. only needed for payment page
		$('.hasDualPricing .sidebarFrequency').hide();
	}

	/**
	 * Public access point to get the product's premium - needed for external tracking
	 * @param freq
	 * @returns {*}
     */
	function getPremium(freq) {
		freq = freq || 'annually';
		if(_.has(confirmationProduct.premium,freq)) {
			return confirmationProduct.premium[freq].lhcfreevalue;
		} else {
			return null;
		}
	}

	meerkat.modules.register('healthConfirmation', {
		init: init,
		getPremium: getPremium
	});

})(jQuery);