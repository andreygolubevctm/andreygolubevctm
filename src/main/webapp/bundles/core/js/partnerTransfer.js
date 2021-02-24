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
	},
	moduleEvents = {
		partnerTransfer: {
			TRANSFER_TO_PARTNER: 'TRANSFER_TO_PARTNER'
		}
	};

	/**
	 * Builds the handover URL for redirection to the transferring.jsp page
	 */

	function buildURL(settings) {

		// check the handover type from the product
		var product = settings.product,
			handoverType = product.handoverType && product.handoverType.toLowerCase() === "post" ? 'POST' : 'GET',
			brand = settings.brand ? settings.brand : product.provider,
			msg =  settings.msg ? settings.msg : '';

		// Create and cleanup tracking object to ensure brandCode is not passed as brandCode
		// will be renamed while in url and reverted back on transferring page - this is to
		// avoid issues with the F5
		var tracking = _.omit(settings.tracking, 'brandCode');
		tracking.brandXCode = settings.tracking.brandCode;
		tracking = encodeURIComponent(decodeURIComponent(JSON.stringify(tracking)));

        // split test Travel only for the new transferring page
        var transferringPage = meerkat.site.vertical === 'travel' ? 'transferring_v2.jsp' : 'transferring.jsp';

		try {

			// build the initial url
			url = transferringPage + "?transactionId="+meerkat.modules.transactionId.get()+"&trackCode="+product.trackCode+"&brand="+brand+"&msg="+msg+"&vertical="+meerkat.site.vertical+"&productId="+product.productId;

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

		var tracking = _.pick(settings, 'actionStep','brandCode','currentJourney','lastFieldTouch','productBrandCode','productID','productName','quoteReferenceNumber','rootID','trackingKey','transactionID','type','vertical','verticalFilter','handoverQS','simplesUser'),
			originatingTab = (typeof meerkat.modules.coverLevelTabs === 'undefined') ? 'default' : meerkat.modules.coverLevelTabs.getOriginatingTab(),
			departingTab = (typeof meerkat.modules.coverLevelTabs === 'undefined') ? 'default' : meerkat.modules.coverLevelTabs.getDepartingTabJourney();

		meerkat.modules.tracking.updateObjectData(tracking);
		// Guarantee all fields exist in the object
		tracking = $.extend({
			gaclientid:             meerkat.modules.tracking.getGaClientId(),
			actionStep:				null,
			brandCode:				null,
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
			originatingTab:			originatingTab,
			departingTab:			departingTab,
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

		if (url !== null)
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
					productId: settings.product.productId,
					comment:'Apply Online'
				});
			}

			if(_.has(settings, "noSaleLead") && !_.isEmpty(settings.noSaleLead)) {
				meerkat.modules.leadFeed.generate(settings.noSaleLead.data, settings.noSaleLead.settings);
			}

			// finally publish an event
			meerkat.messaging.publish(moduleEvents.partnerTransfer.TRANSFER_TO_PARTNER, {
				transactionID: settings.tracking.transactionID,
				partnerID: settings.product.trackCode,
				productDescription: settings.product.productId
			});
		}

		// last thing to happen no matter if there is an error or not
		if (typeof settings.applyNowCallback == 'function') {
			settings.applyNowCallback(true);
		}


	}

	/**
	 * Private method for tracking handover - this method actually calls the specific tracking methods
	 */
	function trackHandover( trackData, touchData ) {

		touchData = touchData || false;

		// Publish tracking events.
		if(touchData !== false && _.isObject(touchData) && _.has(touchData,'type')) {
			meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
				touchType:		touchData.type,
				touchComment:	_.has(touchData,'comment') ? touchData.comment : '',
				productId: touchData.productId
			});
		}

		var data = _.pick(trackData, 'actionStep','brandCode','currentJourney','departingTab','lastFieldTouch','originatingTab','productBrandCode','productID','productName','quoteReferenceNumber','rootID','trackingKey','transactionID','type','vertical','verticalFilter','handoverQS','simplesUser');

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
	function trackHandoverEvent( trackData, touchData ) {

		trackData = addTrackingDataToSettings(trackData || {});
		touchData = touchData || false;

		trackHandover(trackData, touchData);
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
		buildURL: buildURL,
		events: moduleEvents
	});
})(jQuery);