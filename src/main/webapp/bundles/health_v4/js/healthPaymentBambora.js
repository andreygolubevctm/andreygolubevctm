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


	function initHealthPaymentBambora() {
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
				loadBamboraIframe();
			}
		}
	}

	function loadBamboraIframe() {

		ajaxInProgress = true;
		$maskedNumber.val('Loading...');
		reset();

		createModalContent();
	}

	function createModalContent() {

		if (isModalCreated()) {
			return false;
		}

		htmlContent = '<meta name="viewport" content="width=device-width, initial-scale=1">\n' +
			'\n' +
			'\n' +
			'<div class="bambora-iframe">\n' +
				'<div class="bambora-container">\n' +
				'    <div class="row">\n' +
				'        <!-- Add form -->\n' +
				'        <form id="checkout-form" class="form-inline text-center">\n' +
				'            <div class="row">\n' +
					'            <div class="form-group col-md-4 mb-4 has-feedback" id="card-number-bootstrap">\n' +
					'                <div id="card-number" class="form-control"></div>\n' +
					'                <label class="help-block" for="card-number" id="card-number-error"></label>\n' +
					'            </div>\n' +
					'            <div class="form-group col-md-4 mb-4 has-feedback" id="card-cvv-bootstrap">\n' +
					'                <div id="card-cvv" class="form-control"></div>\n' +
					'                <label class="help-block" for="card-cvv" id="card-cvv-error"></label>\n' +
					'            </div>\n' +
					'            <div class="form-group col-md-4 mb-4 has-feedback" id="card-expiry-bootstrap">\n' +
					'                <div id="card-expiry" class="form-control"></div>\n' +
					'                <label class="help-block" for="card-expiry" id="card-expiry-error"></label>\n' +
					'            </div>\n' +
					'            <span class="sr-only"></span>\n' +
				'            </div>\n' +
				'            <div class="row bambora-add-button">\n' +
					'            <div class="form-group text-center pay-button-wrapper">\n' +
					'                <button id="pay-button" type="submit" class="btn btn-block" disabled="true">Add</button>\n' +
					'            </div>\n' +
				'            </div>\n' +
				'        </form>\n' +
				'    </div>\n' +
				'</div>\n' +
				'\n' +
				'<div class="row">\n' +
				'    <div class="col-lg-12 text-center">\n' +
				'        <div id="feedback"></div>\n' +
				'    </div>\n' +
				'</div>\n' +
			'</div>\n';
		meerkat.modules.dialogs.changeContent(modalId, htmlContent);

		initBamboraModal();
	}

	function openModal(htmlContent) {
		launchTime = new Date().getTime();

		// If no content yet, use a loading animation
		if (typeof htmlContent === 'undefined' || htmlContent.length === 0) {
			htmlContent = meerkat.modules.loadingAnimation.getTemplate();
		}

		modalId = meerkat.modules.dialogs.show({
			htmlContent: htmlContent,
			title: 'Credit Card Details',
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
			$maskedNumber.val('');
			modalContent = '';
		}
	}

	function isModalCreated() {
		return modalContent !== '';
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

	// the whole function is from https://dev-apac.bambora.com/checkout/guides/custom-checkout/demos
	// with console logs removed
	function initBamboraModal() {
		$maskedNumber.val('');
		var customCheckout = customcheckout();

		var isCardNumberComplete = false;
		var isCVVComplete = false;
		var isExpiryComplete = false;

		var customCheckoutController = {
			init: function() {
				this.createInputs();
				this.addListeners();
			},
			createInputs: function() {
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
				});

				customCheckout.on('focus', function(event) {
				});

				customCheckout.on('empty', function(event) {
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

				event.preventDefault();
				self.setPayButton(false);
				self.toggleProcessingScreen();

				var callback = function(result) {

					if (result.error) {
						self.processTokenError(result.error);
					} else {
						self.processTokenSuccess(result.token);
					}
				};

				//test token provided by bambora 10e9aa9c-6da2-46c9-948f-efabe3eb2c6b
				customCheckout.createOneTimeToken(meerkat.site.bupaBamboraMerchantId, callback);
			},
			hideErrorForId: function(id) {
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
					console.error('showErrorForId: Could not find ' + id);
				}
			},
			showErrorForId: function(id, message) {
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
					console.error('showErrorForId: Could not find ' + id);
				}
			},
			setPayButton: function(enabled) {

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

				this.showErrorFeedback(
					'Error creating token: </br>' + JSON.stringify(error, null, 4)
				);
				this.setPayButton(true);
				this.toggleProcessingScreen();
			},
			processTokenSuccess: function(token) {
				$token.val(token);
				$maskedNumber.prop('required',false);
				$maskedNumber.val('Success');
				$maskedNumber.valid();
				this.showSuccessFeedback('Success!');
				this.setPayButton(true);
				this.toggleProcessingScreen();
				meerkat.modules.dialogs.close(modalId);
			},
		};

		customCheckoutController.init();
	}


	meerkat.modules.register("healthPaymentBambora", {
		initHealthPaymentBambora: initHealthPaymentBambora,
		show: show,
		hide: hide,
		fail: fail,
		reset: reset
	});

})(jQuery);
