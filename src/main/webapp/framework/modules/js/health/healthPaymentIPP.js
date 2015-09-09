/*

Process:
- Call the iFrame when the pre-criteria is completed (and validated)
- Call the security session key
- iFrame will respond back with the results
- Log the final result details to the external source

*/
;(function($, undefined){

	var meerkat = window.meerkat,
		$maskedNumber = [],
		$token = [],
		$cardtype = [],
		modalId,
		modalContent = '',
		ajaxInProgress = false,
		launchTime = 0,
		initialised = false;


	function initHealthPaymentIPP() {
		if(!initialised) {
			initialised = true;

			$('[data-provide="payment-ipp"]').each(function eachPaymentIPP() {
				var $this = $(this);

				$token = $this.find('.payment-ipp-tokenisation');

				$cardtype = $('#health_payment_credit_type');

				$maskedNumber = $this.find('.payment-ipp-maskedNumber');
				$maskedNumber.prop('readonly', true);
				$maskedNumber.css('cursor', 'pointer');
				$maskedNumber.on('click', function clickMaskedNumber() {
					launch();
				});
			});

		}
	}

	function show() {
		$('[data-provide="payment-ipp"]').removeClass('hidden');
	}

	function hide() {
		$('[data-provide="payment-ipp"]').addClass('hidden');
	}

	function launch() {
		//console.log('launch');

		// Check that the precursor is ok
		if ($maskedNumber.is(':visible') && isValid()) {
			openModal(modalContent);

			if (!isModalCreated()) {
				authorise();
			}
		}
	}

	function authorise() {
		//console.log('authorise');

		if (ajaxInProgress === true || isModalCreated()) {
			return false;
		}

		ajaxInProgress = true;
		$maskedNumber.val('Loading...');
		reset();

		meerkat.modules.comms.post({
			url: "ajax/json/ipp/ipp_payment.jsp?ts=" + (new Date().getTime()),
			dataType: 'json',
			cache: false,
			errorLevel: "silent",
			data:{
				transactionId:meerkat.modules.transactionId.get()
			},
			onSuccess: createModalContent,
			onError: function onIPPAuthError(obj, txt, errorThrown) {
				// Display an error message + log a normal error
				fail('IPP Token Session Request http');
			},
			onComplete: function onIPPAuthComplete() {
				ajaxInProgress = false;
			}
		});
	}

	function createModalContent(data) {
		//console.log('createModalContent');

		if (isModalCreated()) {
			return false;
		}

		if (!data || !data.result || data.result.success !== true) {
			fail('IPP Token Session Request fail');
			return;
		}

		// Create dialog content
		var _url = data.result.url + '?SessionId=' + data.result.refId + '&sst=' + data.result.sst
				+ '&cardType=' + cardType()
				+ '&registerError=false'
				+ '&resultPage=0';

		var _message = '<p class="message"></p>';

		htmlContent = _message + '<iframe width="100%" height="110" frameBorder="0" src="' + _url +'" tabindex="" id="cc-frame"></iframe>';
		meerkat.modules.dialogs.changeContent(modalId, htmlContent);
	}

	function openModal(htmlContent) {
		//console.log('openModal');

		launchTime = new Date().getTime();

		// If no content yet, use a loading animation
		if (typeof htmlContent === 'undefined' || htmlContent.length === 0) {
			htmlContent = meerkat.modules.loadingAnimation.getTemplate();
		}

		modalId = meerkat.modules.dialogs.show({
			htmlContent: htmlContent,
			title: 'Credit Card Number',
			buttons: [{
				label: "Cancel",
				className: 'btn-default',
				closeWindow:true
			}],
			onOpen: function(id) {
				meerkat.modules.tracking.recordSupertag('trackCustomPage', 'Payment gateway popup');
			},
			onClose: function() {
				fail('User closed process');
			}
		});

	}

	// Validate the credit card type
	function isValid() {
		return $cardtype.valid();
	}

	function fail(reason) {
		if ($token.val() === '') {
			// We need to make sure the JS tunnel de-activates this
			meerkat.modules.dialogs.changeContent(modalId, "<p>We're sorry but our system is down and we are unable to process your credit card details right now.</p><p>Continue with your application and we can collect your details after you join.</p>");
			//add the time the whole process lasted
			var failTime = ', ' + Math.round((new Date().getTime() - launchTime) / 1000) + ' seconds';
			//Add reasons: HLT-1111
			$token.val('fail, ' + reason + failTime );
			$maskedNumber.val('Try again or continue');
			modalContent = '';
		}
	}

	function isModalCreated() {
		if (modalContent === '') {
			return false;
		}
		else {
			return true;
		}
	}

	function reset() {
		$token.val('');
		$maskedNumber.val('');
		modalContent = '';
	}

	function cardType() {
		switch ($cardtype.find('option:selected').val())
		{
		case 'v':
			return 'Visa';
		case 'a':
			return 'Amex';
		case 'm':
			return 'Mastercard';
		case 'd':
			return 'Diners';
		default:
			return 'Unknown';
		}
	}

	function register(jsonData) {

		jsonData.transactionId = meerkat.modules.transactionId.get();

		meerkat.modules.comms.post({
			url: "ajax/json/ipp/ipp_log.jsp?ts=" + (new Date().getTime()),
			data: jsonData,
			dataType: 'json',
			cache: false,
			errorLevel: "silent",
			onSuccess: function onRegisterSuccess(data) {
				if (!data || !data.result || data.result.success !== true) {
					fail('IPP Token Log false');
					return
				}

				$token.val(jsonData.sessionid);
				$maskedNumber.val(jsonData.maskedcardno);
				modalContent = '';
				meerkat.modules.dialogs.close(modalId);
			},
			onError: function onRegisterError(obj, txt, errorThrown) {
				fail('IPP Token Log http');
			}
		});
	}



	meerkat.modules.register("healthPaymentIPP", {
		initHealthPaymentIPP: initHealthPaymentIPP,
		show: show,
		hide: hide,
		fail: fail,
		register: register
	});

})(jQuery);