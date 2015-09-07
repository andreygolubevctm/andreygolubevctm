/*

Process:
- Call the iFrame when the pre-criteria is completed (and validated)
- Call the security session key
- iFrame will respond back with the results
- Log the final result details to the external source

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events,
	log = meerkat.logging.info;

	var events = {
		paymentGateway: {
			SUCCESS: 'PAYMENT_GATEWAY_SUCCESS',
			FAIL: 'PAYMENT_GATEWAY_FAIL'
		}
	},
	moduleEvents = events.paymentGateway;

	var $launcher;
	var $success;
	var $fail;
	var $registered;

	var calledBack = false,
		successEventHandlerId = null,
		failEventHandlerId = null,
		_type = '';

	var settings = {
		paymentEngine: null,
		name : '',
		handledType : {
			'credit': false,
			'bank': false
		}
	};

	function hasRegistered() {
		return $registered.val() === '1';
	}

	function resetRegistered() {
		return $registered.val('');
	}

	function success(params) {
		paymentStatusChange();
		$registered.val('1').valid(); // Mark registration as valid
		settings.paymentEngine.success(params);
		hideLauncherPanels();
		showSuccessPanel();
	}

	function fail(_msg) {
		showLauncherPanels();
		showFailPanel();

		if (_msg && _msg.length > 0) {
			paymentStatusChange();
			settings.paymentEngine.fail(_msg);

			meerkat.modules.errorHandling.error({
				message:		_msg,
				page:			'paymentGateway.js',
				description:	'meerkat.modules.paymentGateway.fail()',
				errorLevel:		'silent',
				data:			settings
			});
		}
	}

	function paymentStatusChange() {
		calledBack = true;
		meerkat.modules.dialogs.close(modalId);
	}

	function setTypeFromControl() {
		var type = 'cc';
		if(typeof settings.getSelectedPaymentMethod === 'function') {
			type = settings.getSelectedPaymentMethod();
		}
		if (_type !== type) {
			resetRegistered();
		}
		if ((type == 'cc' && settings.handledType.credit) || (type == 'ba' && settings.handledType.bank)) {
			_type = type;
		} else {
			_type = '';
		}
		togglePanels();
		return (_type !== '');
	}

	function showSuccessPanel(){
		$success.slideDown();
		$fail.slideUp();
	}

	function showFailPanel(){
		$success.slideUp();
		$fail.slideDown();
	}

	function hideStatusesPanels(){
		$success.slideUp();
		$fail.slideUp();
	}

	function showLauncherPanels(){
		$launcher.slideDown();
	}

	function hideLauncherPanels(){
		$launcher.slideUp();
	}

	function togglePanels() {

		if (hasRegistered()) {
			hideLauncherPanels();
			showSuccessPanel();
		} else {
			resetRegistered();
			showLauncherPanels();
			hideStatusesPanels();
		}

		toggleCreditCardFields();
	}

	function toggleCreditCardFields(){
		switch (_type) {
			case 'cc':
				$('.' + settings.name + '-credit').slideDown();
				$registered.rules('add', {required:true, messages:{required:'Please register your credit card details'}});
				break;
			default:
				$('.' + settings.name + '-credit').slideUp('','', function(){ $(this).hide(); });
				clearValidation();
		}
	}

	// Reset settings and unhook
	function reset() {
		settings.handledType = {'credit': false, 'bank': false };
		_type = '';
		togglePanels();

		$('body').removeClass(settings.name + '-active');
		clearValidation();
		resetRegistered();

		// Turn off events
		$('[data-provide="paymentGateway"]').off( "click", '[data-gateway="launcher"]', launch);
		$('#update-premium').off('click.' + settings.name, setTypeFromControl);

		// Reset normal question panels in case user is moving between different products
		if(typeof settings.paymentTypeSelector !== 'undefined') {
			settings.paymentTypeSelector.trigger('change');
		}
		meerkat.messaging.unsubscribe(moduleEvents.SUCCESS, successEventHandlerId);
		meerkat.messaging.unsubscribe(moduleEvents.FAIL, failEventHandlerId);
	}

	function clearValidation() {
		$registered.rules('remove', 'required');
	}

	function init() {
	}

	function setup(instanceSettings) {
		settings = $.extend({}, settings, instanceSettings );
		$('[data-provide="paymentGateway"]').on('click', '[data-gateway="launcher"]', launch);
		if(settings.paymentEngine == null) {
			return false;
		}
		$launcher = $('.' + settings.name + ' .launcher');
		$success = $('.' + settings.name + ' .success');
		$fail = $('.' + settings.name + ' .fail');
		$registered = $('#' + settings.name + '-registered');
		settings.paymentEngine.setup(settings);

		$('body').addClass(settings.name + '-active');

		// Hook into: "update premium" button to determine which panels to display
		$('#update-premium').on('click.' + settings.name, setTypeFromControl);

		if(typeof settings.clearValidationSelectors === 'object' ) {
			settings.clearValidationSelectors.on('change', clearValidation);
		}

		successEventHandlerId = meerkat.messaging.subscribe(moduleEvents.SUCCESS, success);
		failEventHandlerId = meerkat.messaging.subscribe(moduleEvents.FAIL, fail);
	}

	// MODAL
	function launch() {

		calledBack = false;

		meerkat.modules.tracking.recordSupertag('trackCustomPage', 'Payment gateway popup');

		modalId = meerkat.modules.dialogs.show({
			htmlContent: meerkat.modules.loadingAnimation.getTemplate(),
			onOpen: settings.paymentEngine.onOpen,
			onClose: function() {
				if (!calledBack) {
					fail();
				}
			}
		});
	}

	meerkat.modules.register("paymentGateway", {
		init: init,
		events: events,
		reset: reset,
		setup : setup
	});

})(jQuery);