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
				$cardtype = $('.health-credit_card_details-type input');
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

		// Check that the precursor is ok
		if ($maskedNumber.is(':visible') && isValid()) {
			openModal(modalContent);

			if (!isModalCreated()) {
				authorise();
			}
		}
	}

	function authorise() {

		if (ajaxInProgress === true || isModalCreated()) {
			return false;
		}

		ajaxInProgress = true;
		$maskedNumber.val('Loading...');
		reset();

		var authoriseUrl = '/' + meerkat.site.urls.context + "ajax/json/ipp/ipp_payment.jsp?ts=" + (new Date().getTime());
		if (meerkat.modules.splitTest.isActive(401) || meerkat.site.isDefaultToHealthApply) {
			authoriseUrl = '/' + meerkat.site.urls.context + "spring/rest/health/payment/authorise.json";
		}

		var authoriseJsonData = {
			transactionId:meerkat.modules.transactionId.get(),
			providerId: $("#health_application_provider").val()
		};

		if (meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi') {
			authoriseJsonData.environmentOverride = $("#developmentApplicationEnvironment").val();
		}


		meerkat.modules.comms.post({
			url: authoriseUrl,
			dataType: 'json',
			cache: false,
			errorLevel: "silent",
			data: authoriseJsonData,
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

		if (isModalCreated()) {
			return false;
		}

		if (!data || !data.result || data.result.success !== true) {
			fail('IPP Token Session Request fail');
			return;
		}

		// Create dialog content
		var _url = data.result.url + '?SessionId=' + data.result.refId + '&sst=' + data.result.sst;
		_url += '&cardType=' + cardType() + '&registerError=false' + '&resultPage=0';

		var _message = '<p class="message"></p>';

		htmlContent = '<meta name="viewport" content="width=device-width, initial-scale=1">\n' +
			'\n' +
			'\n' +
			'<div class="container">\n' +
			'    <div class="row">\n' +
			'        <!-- Add form -->\n' +
			'        <form id="checkout-form" class="form-inline  text-center">\n' +
			'            <div class="form-group col-md-4 mb-4 has-feedback" id="card-number-bootstrap">\n' +
			'                <div id="card-number" class="form-control"></div>\n' +
			'                <label class="help-block" for="card-number" id="card-number-error"></label>\n' +
			'            </div>\n' +
			'            <div class="form-group col-md-3 mb-3 has-feedback" id="card-cvv-bootstrap">\n' +
			'                <div id="card-cvv" class="form-control"></div>\n' +
			'                <label class="help-block" for="card-cvv" id="card-cvv-error"></label>\n' +
			'            </div>\n' +
			'            <div class="form-group col-md-3 mb-3 has-feedback" id="card-expiry-bootstrap">\n' +
			'                <div id="card-expiry" class="form-control"></div>\n' +
			'                <label class="help-block" for="card-expiry" id="card-expiry-error"></label>\n' +
			'            </div>\n' +
			'            <span class="sr-only"></span>\n' +
			'            <div class="col-md-2 mb-2 text-center">\n' +
			'                <button id="pay-button" type="submit" class="btn btn-primary disabled" disabled="true">Pay</button>\n' +
			'            </div>\n' +
			'        </form>\n' +
			'    </div>\n' +
			'</div>\n' +
			'\n' +
			'<div class="row">\n' +
			'    <div class="col-lg-12 text-center">\n' +
			'        <div id="feedback"></div>\n' +
			'    </div>\n' +
			'</div>\n';
		meerkat.modules.dialogs.changeContent(modalId, htmlContent);

		// setTimeout(function() {
		// 	initBamboraModal();
		// }, 5000);

		initBamboraModal();
	}

	function initBamboraModal() {
		var customCheckout = customcheckout();

		var isCardNumberComplete = false;
		var isCVVComplete = false;
		var isExpiryComplete = false;

		var customCheckoutController = {
			init: function() {
				console.log('checkout.init()');
				this.createInputs();
				this.addListeners();
			},
			createInputs: function() {
				console.log('checkout.createInputs()');
				var options = {};

				// Create and mount the inputs
				options.placeholder = 'Card number';
				customCheckout.create('card-number', options).mount('#card-number');

				options.placeholder = 'CVV';
				customCheckout.create('cvv', options).mount('#card-cvv');

				options.placeholder = 'MM / YY';
				customCheckout.create('expiry', options).mount('#card-expiry');
			},
			addListeners: function() {
				var self = this;

				// listen for submit button
				if (document.getElementById('checkout-form') !== null) {
					document
						.getElementById('checkout-form')
						.addEventListener('submit', self.onSubmit.bind(self));
				}

				customCheckout.on('brand', function(event) {
					console.log('brand: ' + JSON.stringify(event));

					var cardLogo = 'none';
					if (event.brand && event.brand !== 'unknown') {
						var filePath =
							'https://cdn.na.bambora.com/downloads/images/cards/' +
							event.brand +
							'.svg';
						cardLogo = 'url(' + filePath + ')';
					}
					document.getElementById('card-number').style.backgroundImage = cardLogo;
				});

				customCheckout.on('blur', function(event) {
					console.log('blur: ' + JSON.stringify(event));
				});

				customCheckout.on('focus', function(event) {
					console.log('focus: ' + JSON.stringify(event));
				});

				customCheckout.on('empty', function(event) {
					console.log('empty: ' + JSON.stringify(event));

					if (event.empty) {
						if (event.field === 'card-number') {
							isCardNumberComplete = false;
						} else if (event.field === 'cvv') {
							isCVVComplete = false;
						} else if (event.field === 'expiry') {
							isExpiryComplete = false;
						}
						self.setPayButton(false);
					}
				});

				customCheckout.on('complete', function(event) {
					console.log('complete: ' + JSON.stringify(event));

					if (event.field === 'card-number') {
						isCardNumberComplete = true;
						self.hideErrorForId('card-number');
					} else if (event.field === 'cvv') {
						isCVVComplete = true;
						self.hideErrorForId('card-cvv');
					} else if (event.field === 'expiry') {
						isExpiryComplete = true;
						self.hideErrorForId('card-expiry');
					}

					self.setPayButton(
						isCardNumberComplete && isCVVComplete && isExpiryComplete
					);
				});

				customCheckout.on('error', function(event) {
					console.log('error: ' + JSON.stringify(event));

					if (event.field === 'card-number') {
						isCardNumberComplete = false;
						self.showErrorForId('card-number', event.message);
					} else if (event.field === 'cvv') {
						isCVVComplete = false;
						self.showErrorForId('card-cvv', event.message);
					} else if (event.field === 'expiry') {
						isExpiryComplete = false;
						self.showErrorForId('card-expiry', event.message);
					}
					self.setPayButton(false);
				});
			},
			onSubmit: function(event) {
				var self = this;

				console.log('checkout.onSubmit()');

				event.preventDefault();
				self.setPayButton(false);
				self.toggleProcessingScreen();

				var callback = function(result) {
					console.log('token result : ' + JSON.stringify(result));

					if (result.error) {
						self.processTokenError(result.error);
					} else {
						self.processTokenSuccess(result.token);
					}
				};

				console.log('checkout.createToken()');
				customCheckout.createOneTimeToken('10e9aa9c-6da2-46c9-948f-efabe3eb2c6b', callback);

			},
			hideErrorForId: function(id) {
				console.log('hideErrorForId: ' + id);

				var element = document.getElementById(id);

				if (element !== null) {
					var errorElement = document.getElementById(id + '-error');
					if (errorElement !== null) {
						errorElement.innerHTML = '';
					}

					var bootStrapParent = document.getElementById(id + '-bootstrap');
					if (bootStrapParent !== null) {
						bootStrapParent.classList.remove('has-error');
						bootStrapParent.classList.add('has-success');
					}
				} else {
					console.log('showErrorForId: Could not find ' + id);
				}
			},
			showErrorForId: function(id, message) {
				console.log('showErrorForId: ' + id + ' ' + message);

				var element = document.getElementById(id);

				if (element !== null) {
					var errorElement = document.getElementById(id + '-error');
					if (errorElement !== null) {
						errorElement.innerHTML = message;
					}

					var bootStrapParent = document.getElementById(id + '-bootstrap');
					if (bootStrapParent !== null) {
						bootStrapParent.classList.add('has-error');
						bootStrapParent.classList.remove('has-success');
					}
				} else {
					console.log('showErrorForId: Could not find ' + id);
				}
			},
			setPayButton: function(enabled) {
				console.log('checkout.setPayButton() disabled: ' + !enabled);

				var payButton = document.getElementById('pay-button');
				if (enabled) {
					payButton.disabled = false;
					payButton.className = 'btn btn-primary';
					document.getElementsByClassName('sr-only')[0].textContent = '';
				} else {
					payButton.disabled = true;
					payButton.className = 'btn btn-primary disabled';
					document.getElementsByClassName('sr-only')[0].textContent = 'The pay button remains unavailable until all fields are correctly filled out. Error messages will be displayed below each field.';
				}
			},
			toggleProcessingScreen: function() {
				var processingScreen = document.getElementById('processing-screen');
				if (processingScreen) {
					processingScreen.classList.toggle('visible');
				}
			},
			showErrorFeedback: function(message) {
				var xMark = '\u2718';
				this.feedback = document.getElementById('feedback');
				this.feedback.innerHTML = xMark + ' ' + message;
				this.feedback.classList.add('error');
			},
			showSuccessFeedback: function(message) {
				var checkMark = '\u2714';
				this.feedback = document.getElementById('feedback');
				this.feedback.innerHTML = checkMark + ' ' + message;
				this.feedback.classList.add('success');
			},
			processTokenError: function(error) {
				error = JSON.stringify(error, undefined, 2);
				console.log('processTokenError: ' + error);

				this.showErrorFeedback(
					'Error creating token: </br>' + JSON.stringify(error, null, 4)
				);
				this.setPayButton(true);
				this.toggleProcessingScreen();
			},
			processTokenSuccess: function(token) {
				console.log('processTokenSuccess: ' + token);

				this.showSuccessFeedback('Success! Created token: ' + token);
				this.setPayButton(true);
				this.toggleProcessingScreen();

				// Use token to call payments api
				// this.makeTokenPayment(token);
			},
		};

		customCheckoutController.init();
	}

	function openModal(htmlContent) {

		console.log('==================== open ipp modal v1');

		debugger;
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
		var valid = false;
		try {
			valid = $cardtype.valid();
		} catch(e) {
			$cardtype = $('.health-credit_card_details-type input');
			valid = $cardtype.valid();
		}
		return valid;
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
		if (initialised) {
			$token.val('');
			$maskedNumber.val('');
			modalContent = '';
		}
	}

	function cardType() {
		var cardVal = $cardtype.find(':checked').val();
		switch (cardVal)
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
		jsonData.providerId = $("#health_application_provider").val();

		if (meerkat.site.environment === 'localhost' || meerkat.site.environment === 'nxi') {
			jsonData.environmentOverride = $("#developmentApplicationEnvironment").val();
		}

		var registerUrl = '/' + meerkat.site.urls.context + "ajax/json/ipp/ipp_log.jsp?ts=" + (new Date().getTime());
		if (meerkat.modules.splitTest.isActive(401) || meerkat.site.isDefaultToHealthApply) {
			registerUrl = '/' + meerkat.site.urls.context + "spring/rest/health/payment/register.json";
		}

		meerkat.modules.comms.post({
			url: registerUrl,
			data: jsonData,
			dataType: 'json',
			cache: false,
			errorLevel: "silent",
			onSuccess: function onRegisterSuccess(data) {
				if (!data || !data.result || data.result.success !== true) {
					fail('IPP Token Log false');
					return;
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
		register: register,
		reset: reset
	});

})(jQuery);
