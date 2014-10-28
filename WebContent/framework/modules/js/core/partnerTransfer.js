////////////////////////////////////////////////////////////
//// partnerTransfer									////
////----------------------------------------------------////
//// This allows you to transfer a user to a partner	////
//// when they click on the Buy Now link				////
////////////////////////////////////////////////////////////

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;
	var log = meerkat.logging.info;


	var defaultSettings = {
		product: null,
		trackHandover: true,
		applyNowCallback: null,
		errorMessage : "An error occurred. Sorry about that!",
		errorDescription : 'There is an issue with the handover url.',
		closeBridgingModalDialog : true
	};

	/**
	 * Builds the handover URL for redirection to the transferring.jsp page
	 */

	function buildURL(settings) {

		// check the handover type from the product
		var product = settings.product,
			handoverType = product.handoverType && product.handoverType.toLowerCase() === "post" ? 'POST' : 'GET',
			brand = settings.brand ? settings.brand : product.provider,
			msg =  settings.msg ? settings.msg : '',
			url = null;

		try {
			
			// build the initial url
			url = "transferring.jsp?transactionId="+meerkat.modules.transactionId.get()+"&trackCode="+product.trackCode + "&brand="+brand+"&msg="+msg+"&url=";

			// this will avoid affecting other handover urls from other verticals
			url += (product.encodeUrl === 'Y') ? encodeURIComponent(product.quoteUrl) : product.quoteUrl;
			
			if (handoverType.toLowerCase() === "post")
			{
				url += "&handoverType="+product.handoverType+"&handoverData="+encodeURIComponent(product.handoverData)+"&handoverURL="+encodeURIComponent(product.handoverUrl)+"&handoverVar="+(product.handoverVar);
			}

			// append any extra params
			if (!$.isEmptyObject(settings.extraParams))
			{
				$.each(settings.extraParams, function transferExtraParam(key, value){
					url += "&"+key +"="+ escape(value);
				}); 
			}

			return url;
		}  catch (e) {
			meerkat.modules.errorHandling.error({
				errorLevel:		'warning',
				message:		settings.errorMessage,
				page:			'partnerTransfer.js:buildURL',
				description:	settings.errorDescription,
				data:			product
			});
			return null;
		}
	}

	function transferToPartner(options){

		var settings = $.extend({}, defaultSettings, options),
			product = settings.product,
			url = buildURL(settings);	
 
		if (url != null)
		{
			// close the modal if it's open
			if (settings.closeBridgingModalDialog === true && (meerkat.modules.moreInfo.isBridgingPageOpen() || meerkat.modules.moreInfo.isModalOpen())) {
				meerkat.modules.moreInfo.close();
			}

			// add popup options if it's IE
			if ($('html').hasClass('ie')) {
				var popOptions="location=1,menubar=1,resizable=1,scrollbars=1,status=1,titlebar=1,toolbar=1,top=0,left=0,height="+screen.availHeight+",width="+screen.availWidth;
				window.open(url , "_blank", popOptions);
			} else {
				window.open(url , "_blank");
			}

			// legacy
			if ($("#transferring-popup").length > 0)
			{
				$("#transferring-popup")
					.delay(4000)
					.queue(function(next) {
						next();
				});	
			}

			// track the handover. This allows for custom handover tracking if this module is insufficient
			if (settings.trackHandover === true) {
				trackHandover(product);	
			}
		}

		// last thing to happen no matter if there is an error or not
		if (typeof settings.applyNowCallback == 'function') {
			
			settings.applyNowCallback(true);	
		}
	}

	/**
	 * Supertag tracking
	 */
	function trackHandover( product ) {

		var transaction_id = meerkat.modules.transactionId.get(),
			referenceNumber = typeof product.leadNo !== 'undefined' ? product.leadNo : transaction_id;

		// Publish tracking events.
		meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
			touchType:'A',
			touchComment: 'Apply Online'
		});

		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method: 'trackHandoverType',
			object: {
				type: "ONLINE",
				quoteReferenceNumber: referenceNumber,
				transactionID: transaction_id,
				productID: product.productId,
				brandCode: product.brandCode,
				vertical: meerkat.site.vertical,
				verticalFilter: $("input[name=travel_policyType]:checked").val() == 'S' ? 'Single Trip' : 'Multi Trip'
			}
		});
	}

	function applyEventListeners() {
		// if not done this way, clicking on the btn-apply will create a popup error on the first click
		$(document.body).on('click', '.btn-apply', function(e) { 
			e.preventDefault();
			var product = Results.getResultByProductId($(this).attr('data-productid'));
			
			var options = {
				product: product
			};

			transferToPartner(options);
		});
	}

	function initTransfer()	{
		$(document).ready(function(){
			applyEventListeners();
		});
	}

	meerkat.modules.register('partnerTransfer', {
		initTransfer: initTransfer,
		transferToPartner: transferToPartner,
		trackHandover: trackHandover,
		buildURL: buildURL
	});
})(jQuery);