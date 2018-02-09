/*

Process:
- Call the iFrame when the pre-criteria is completed (and validated)
- Call the security session key
- iFrame will respond back with the results
- Log the final result details to the external source

*/
;(function($, undefined){

	var meerkat = window.meerkat;

	var $registered;
	var $number;
	var $type;
	var $expiry;
	var $name;

	var _type;

	var settings;

	var timeout = false;

	function init() {
	}

	function setup(instanceSettings) {
		settings = instanceSettings;
		$registered = $('#' + settings.name + '-registered');
		$number = $('#' + settings.name + '_number');
		$type = $('#' + settings.name + '_type');
		$expiry = $('#' + settings.name + '_expiry');
		$name = $('#' + settings.name + '_name');
		$('.gatewayProvider').text('Westpac');
	}

	function success(params) {
		if (!params || !params.number || !params.type || !params.expiry || !params.name) {
			meerkat.messaging.publish(meerkat.modules.events.paymentGateway.FAIL,'Registration response parameters invalid');
			return false;
		}
		$number.val(params.number); // Populate hidden fields with values returned by Westpac
		$type.val(params.type);
		$expiry.val(params.expiry);
		$name.val(params.name);
	}

	function fail(_msg) {
		$registered.val(''); // Reset hidden fields
		$number.val('');
		$type.val('');
		$expiry.val('');
		$name.val('');
	}

	function onOpen(id) {
		clearTimeout(timeout);
		timeout = setTimeout(function() {
			// Switch content to the iframe
			var loadSource = meerkat.site.loadSource ? '&loadSource=' + meerkat.site.loadSource : '';
			meerkat.modules.dialogs.changeContent(id, '<iframe width="100%" height="340" frameBorder="0" src="' + settings.src + '?transactionId=' + meerkat.modules.transactionId.get() + loadSource + '"></iframe>');
		}, 1000);
	}

	function disable() {
        $number.prop('disabled', true);
        $type.prop('disabled', true);
        $expiry.prop('disabled', true);
        $name.prop('disabled', true);
	}

    function enable() {
        $number.prop('disabled', false);
        $type.prop('disabled', false);
        $expiry.prop('disabled', false);
        $name.prop('disabled', false);
    }

	meerkat.modules.register("healthPaymentGatewayWestpac", {
		success: success,
		fail: fail,
		onOpen : onOpen,
		init: init,
		setup : setup,
		disable: disable,
		enable: enable
	});

})(jQuery);