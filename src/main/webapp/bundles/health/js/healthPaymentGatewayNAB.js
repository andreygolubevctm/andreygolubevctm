/*

Process:
- Call the iFrame when the pre-criteria is completed (and validated)
- Call the security session key
- iFrame will respond back with the results
- Log the final result details to the external source

*/
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
		healthPaymentGatewayNAB: {

		}
	},
	moduleEvents = events.healthPaymentGatewayNAB;

	var $cardNumber;
	var $cardName;
	var $crn;
	var $rescode;
	var $restext;
	var $expiryMonth;
	var $expiryYear;
	var $cardType;

	var timeout = false;

	var settings;


	function onMessage(e) {
		meerkat.logging.debug("healthPaymentGatewayNAB: NAB IFrame onMessage window event triggered");
		if (e.origin !== settings.origin){
			meerkat.logging.error("domain name mismatch");
			meerkat.logging.debug("healthPaymentGatewayNAB: NAB domain Origin " + e.origin + "\nNAB origin settings settings " + settings.origin);
			return;
		} else {
			// we are expecting the iframe to return a load success message
			// if we get it, we kill the timeout interval that would trigger he fail after a while
			if(typeof e.data === "string" && e.data === "page loaded"){
				meerkat.logging.debug("healthPaymentGatewayNAB: NAB IFrame page Loaded");
				clearTimeout(timeout);
			} else {
				onPaymentResponse(e.data);
			}
		}
	}

	function init() {
	}

	function setup(instanceSettings) {
		settings = instanceSettings;
		$cardNumber = $('#' + settings.name + '_nab_cardNumber');
		$cardName = $('#' + settings.name + '_nab_cardName');
		$crn = $('#' + settings.name + '_nab_crn');
		$rescode = $('#' + settings.name + '_nab_rescode');
		$restext = $('#' + settings.name + '_nab_restext');
		$expiryMonth = $('#' + settings.name + '_nab_expiryMonth');
		$expiryYear = $('#' + settings.name + '_nab_expiryYear');
		$cardType = $('#' + settings.name + '_nab_cardType');
		$('.gatewayProvider').text('NAB');
	}

	function onPaymentResponse(data) {

		meerkat.logging.debug("healthPaymentGatewayNAB: Raw payment response: \n" + data + "\n\nAttempting to parse response into a JSON Object");

		var json = JSON.parse(data);

		meerkat.logging.debug("healthPaymentGatewayNAB: Response parsed into JSON Object");

		if (validatePaymentResponse(json)) {
			meerkat.logging.debug("healthPaymentGatewayNAB: Publish meerkat.modules.events.paymentGateway.SUCCESS");
			meerkat.messaging.publish(meerkat.modules.events.paymentGateway.SUCCESS,json);
		} else {
			meerkat.logging.debug("healthPaymentGatewayNAB: Publish meerkat.modules.events.paymentGateway.FAIL");
			meerkat.messaging.publish(meerkat.modules.events.paymentGateway.FAIL,json);
		}
	}

	function validatePaymentResponse(response) {
		meerkat.logging.debug("healthPaymentGatewayNAB: Payment response validation tests");

		var valid = response && response.CRN && response.CRN !== '';
		valid = valid && response.rescode == "00";

		meerkat.logging.debug("healthPaymentGatewayNAB: Payment response CRN: " + response.CRN + "\nPayment response CRN Valid: " + valid + "\nPayment response rescode: " + response.rescode + "\nPayment response valid: " + valid);

		return valid;
	}

	function success(params) {

		meerkat.logging.debug("healthPaymentGatewayNAB: Success function called");

		$cardNumber.val(params.pan);
		$cardName.val(params.cardName);
		$crn.val(params.CRN);
		$rescode.val(params.rescode);
		$restext.val(params.restext);
		$expiryMonth.val(params.expMonth);
		$expiryYear.val(params.expYear);
		$cardType.val(params.cardType);
		return true;
	}

	function fail(params) {

		meerkat.logging.debug("healthPaymentGatewayNAB: Fail function called");

		if(typeof params !== 'undefined') {
			$rescode.val(params.rescode);
			$restext.val(params.restext);
		}
		$cardNumber.val('');
		$cardName.val('');
		$crn.val('');
		$rescode.val('');
		$restext.val('');
		$expiryMonth.val('');
		$expiryYear.val('');
		$cardType.val('');
	}

	function onOpen(id) {

		clearTimeout(timeout);
		timeout = _.delay(function onOpenTimout() {
			meerkat.logging.debug("healthPaymentGatewayNAB: NAB IFrame timed out\nPublish meerkat.modules.events.paymentGateway.FAIL");
			meerkat.messaging.publish(meerkatEvents.paymentGateway.FAIL);
		}, 45000);

		// local alternative to bypass HAMBS' iframe for testing purposes
		//settings.hambsIframe.src = 'http://localhost:8080/ctm/external/hambs/mockPaymentGateway.html'; settings.hambsIframe.remote = 'http://localhost:8080';

		var iframe = '<iframe width="100%" height="390" frameBorder="0" src="'+ settings.src + 'external/hambs/nab_ctm_iframe.jsp?providerCode=' + settings.providerCode + '&b=' + settings.brandCode + '"></iframe>';
		meerkat.modules.dialogs.changeContent(id, iframe);

		if (window.addEventListener) {
			window.addEventListener("message", onMessage, false);
		} else if (window.attachEvent) { // IE8
			window.attachEvent("onmessage", onMessage);
		}

	}

	function disable() {
        $cardNumber.prop('disabled', true);
        $cardName.prop('disabled', true);
        $crn.prop('disabled', true);
        $rescode.prop('disabled', true);
        $restext.prop('disabled', true);
        $expiryMonth.prop('disabled', true);
        $expiryYear.prop('disabled', true);
        $cardType.prop('disabled', true);
	}

    function enable() {
        $cardNumber.prop('disabled', false);
        $cardName.prop('disabled', false);
        $crn.prop('disabled', false);
        $rescode.prop('disabled', false);
        $restext.prop('disabled', false);
        $expiryMonth.prop('disabled', false);
        $expiryYear.prop('disabled', false);
        $cardType.prop('disabled', false);
    }

	meerkat.modules.register("healthPaymentGatewayNAB", {
		init : init,
		success: success,
		fail: fail,
		onOpen : onOpen,
		setup : setup,
		disable: disable,
		enable: enable
	});

})(jQuery);