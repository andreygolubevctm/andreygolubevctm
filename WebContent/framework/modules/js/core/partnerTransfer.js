////////////////////////////////////////////////////////////
//// partnerTransfer									////
////----------------------------------------------------////
//// This allows you to transfer a user to a partner	////
//// when they click on the Buy Now link				////
////////////////////////////////////////////////////////////

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;
	var log = meerkat.logging.info,
		url = null;


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
			tracking = encodeURIComponent(JSON.stringify(settings.tracking));

		try {

			// build the initial url
			url = "transferring.jsp?transactionId="+meerkat.modules.transactionId.get()+"&trackCode="+product.trackCode + "&brand="+brand+"&msg="+msg+"&url=";

			// this will avoid affecting other handover urls from other verticals
			url += (product.encodeUrl === 'Y' || settings.encodeTransferURL === true) ? encodeURIComponent(product.quoteUrl) : product.quoteUrl;

			url += "&tracking=" + tracking;

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

	function getQueryStringFromURL(url) {
		var qs = null;
		if(!_.isUndefined(url) && _.isString(url)) {
			var pieces = url.split("?");
			if(pieces.length == 2) {
				qs = pieces[1];
			}
		}
		return qs;
	}

	function addTrackingDataToSettings(settings) {

		var tracking = _.pick(settings, 'actionStep','brandCode','currentJourney','lastFieldTouch','productBrandCode','productID','productName','quoteReferenceNumber','rootID','trackingKey','transactionID','type','vertical','verticalFilter','handoverQS','simplesUser');
		meerkat.modules.tracking.updateObjectData(tracking);
		// Guarantee all fields exist in the object
		tracking = $.extend({
			actionStep:				null,
			brandValueCode:				null,
			currentJourney:			null,
			lastFieldTouch:			null,
			productBrandCode:		settings.product.provider,
			productID:				settings.product.productId,
			productName:			settings.product.name,
			quoteReferenceNumber:	typeof settings.product.leadNo !== 'undefined' ? settings.product.leadNo : tracking.transactionID,
			rootID:					null,
			transactionID:			null,
			type:					'ONLINE',
			vertical:				null,
			verticalFilter:			null,
			handOverQS:				getQueryStringFromURL(settings.product.quoteUrl),
			simplesUser:			meerkat.site.isCallCentreUser
		},tracking);

		if(_.isEmpty(tracking.actionStep)) {
			tracking.actionStep = $.trim(tracking.vertical + " transfer " + tracking.type);
		}

		return tracking;
	}

	function transferToPartner(options){
		var settings = $.extend({}, defaultSettings, options),
			product = settings.product;

		// Add standard tracking variables
		settings.tracking = addTrackingDataToSettings(settings);

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
				trackHandover(settings.tracking, {
					type:'A',
					comment:'Apply Online'
				}, true);
			}
		}

		// last thing to happen no matter if there is an error or not
		if (typeof settings.applyNowCallback == 'function') {
			settings.applyNowCallback(true);
		}
	}

	/**
	 * Private method for tracking handover - this method actually calls the specific tracking methods
	 */
	function trackHandover( trackData, touchData, doOldTrackCall ) {

		touchData = touchData || false;
		doOldTrackCall = doOldTrackCall || false;

		// Publish tracking events.
		if(touchData !== false && _.isObject(touchData) && _.has(touchData,'type')) {
			meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
				touchType:		touchData.type,
				touchComment:	_.has(touchData,'comment') ? touchData.comment : ''
			});
		}

		var data = _.pick(trackData, 'actionStep','brandCode','currentJourney','lastFieldTouch','productBrandCode','productID','productName','quoteReferenceNumber','rootID','trackingKey','transactionID','type','vertical','verticalFilter','handoverQS','simplesUser');

		// OLD tracking method
		if(doOldTrackCall === true) {
			meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
				method:	'trackHandoverType',
				object:	data
			});
		}

		// NEW combined tracking method
		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteHandoverClick',
			object:	data
		});

		meerkat.modules.session.poke();
	}

	/**
	 * Public method for tracking handover events - called by individual verticals which need to record
	 * a handover but don't actually redirect to a 3rd party
	 */
	function trackHandoverEvent( trackData, touchData, doOldTrackCall ) {

		doOldTrackCall = doOldTrackCall || false;

		trackData = addTrackingDataToSettings(trackData || {});
		touchData = touchData || false;

		trackHandover(trackData, touchData, doOldTrackCall);
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
		trackHandoverEvent: trackHandoverEvent,
		buildURL: buildURL
	});
})(jQuery);