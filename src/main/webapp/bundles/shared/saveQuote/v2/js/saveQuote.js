
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {
		saveQuote: {
			QUOTE_SAVED:"SAVE_QUOTE_SAVED"
		}
	},
	moduleEvents = events.saveQuote;

	var email = false,
		userExists = false,
		lastEmailChecked = false,
		emailTypingTimer = null,
		status = 'start',
		statuss = ['start','return','new','saved'],
		checkUserAjaxObject = null,
		saveAjaxObject = null,
		isConfirmed = false,
		$template = null,
		$modalTriggers = null,
		$formElements = {
			form : null,
			email : null,
			password : null,
			passwordConfirm : null,
			marketing : null,
			submitButton : null,
			optinRow : null
	};

	function init(){
		addEventListeners();
		jQuery(document).ready(function($) {
			$template = _.template($('#save-quote-component-template').html());
			updateModalTriggerListeners();
		});
	}

	// Re-apply the open modal trigger to dynamic content eg more-info modal
	function updateModalTriggerListeners() {
		$modalTriggers = $('[data-opensavequote=true]');
		$modalTriggers.off('click').on('click', function(event) {
			event.preventDefault();
			openAsModal();
		});
	}

	function addEventListeners() {
		// Update local email value if empty and journey email value changed
		msg.subscribe( meerkat.modules.events.contactDetails.email.FIELD_CHANGED, function(fieldDetails){
			var journeyEmail = fieldDetails.$field.val();
			if (_.isEmpty(email) && !_.isEmpty(journeyEmail)) {
				email = $.trim(journeyEmail);
				$formElements.email.val(email);
			}
		});
		// Update modal listener event when more info opened
		msg.subscribe( meerkat.modules.events.moreInfo.bridgingPage.SHOW, updateModalTriggerListeners);
		// On application lockdown/unlock, disable/enable the form
		msg.subscribe(meerkatEvents.WEBAPP_LOCK, disable);
		msg.subscribe(meerkatEvents.WEBAPP_UNLOCK, enable);
	}

	/**
	 * Updates the status of the form. The status class drives what
	 * content is visible in the form.
	 * @param statusIn
     */
	function updateStatus(statusIn) {
		for (var i = 0; i < statuss.length; i++) {
			var match = statusIn === statuss[i];
			if (match) {
				status = statusIn;
			}
			$formElements.form[match ? "addClass" : "removeClass"](statuss[i]);
		}
		toggleSubmitButton(userExists);
	}

	/**
	 * Opens the save quote modal, pushes in the content and adds listeners/validation
	 */
	function openAsModal() {
		var htmlContent = $template();
		meerkat.modules.dialogs.show({
			htmlContent: htmlContent,
			hashId: 'save-quote',
			closeOnHashChange: true,
			onOpen: function(dialogId) {
				// Gather elements
				$formElements.form = $("#save-quote-component");
				$formElements.email = $("#save_email");
				$formElements.password = $("#save_password");
				$formElements.passwordConfirm = $("#save_confirm");
				$formElements.marketing = $("#save_marketing");
				$formElements.submitButton = $formElements.form.find('.btn.save,.btn.signup');
				$formElements.optinRow = $formElements.form.find('.optin-row');
				// Events
				$formElements.email.on("keyup change", emailKeyChange);
				$formElements.email.on("blur", function() { $(this).val( $.trim( $(this).val() ) ); }) ;
				$formElements.passwordConfirm.on("keyup change", passwordConfirmKeyChange);
				$formElements.password.on("keyup change", passwordConfirmKeyChange);
				$formElements.submitButton.on("click", save);
				$formElements.form.find(".btn-retrieve,.btn-reset").each(function(){
					$(this).attr("href",meerkat.site.urls.base + 'retrieve_quotes.jsp');
				});
				// Setup
				setValidation();
				toggleMarketingCheckbox(false);
				// Prepop (to handle re-saving)
				lastEmailChecked = false;
				$formElements.email.val(_.isEmpty(email) ? "" : email).change();
				// Only make visible after updates
				$formElements.form.removeClass("hidden");
			},
			onClose: function(dialogId) {
				// Relax, nothing to do here
			}
		});
	}


	/**
	 * Adds functionality for password field validation
	 */
	function setValidation(){
		meerkat.modules.jqueryValidate.setupDefaultValidationOnForm( $formElements.form );
		// We do this because its false by default, for people who already exist.
		if ($formElements.password.length > 0) {
			$formElements.password.setRequired(true, "Please enter a password");
		}
		if ($formElements.passwordConfirm.length > 0) {
			$formElements.passwordConfirm.setRequired(true, "Please confirm your password");
		}
	}

	/**
	 * Handles email being typed in order to trigger change event
	 * @param event
     */
	function emailKeyChange(event){
		if (event.keyCode == 13 || event.keyCode == 9) {
			emailChanged();
		} else {
			var email = $.trim($formElements.email.val());
			if (lastEmailChecked != email) {
				clearInterval(emailTypingTimer);
				emailTypingTimer = setTimeout(emailChanged, 800);
			}
		}
	}

	/**
	 * When email recognised as change - confirm it's valid and if so
	 * then trigger call to get user details
	 */
	function emailChanged() {
		var valid = $formElements.email.valid();
		if(valid) {
			checkUserExists();
		}
	}

	/**
	 * Make ajax call to retrieve user details - exists and optin status
	 */
	function checkUserExists(){
		var emailAddress = $.trim($formElements.email.val());
		lastEmailChecked = emailAddress;
		userExists = false;

		if (checkUserAjaxObject && checkUserAjaxObject.state() === "pending") {
			if (typeof checkUserAjaxObject.abort === 'function') {
				checkUserAjaxObject.abort();
			}
		}

		meerkat.modules.loadingAnimation.showAfter( $formElements.email );

		var emailInfo = {
			returnAjaxObject: true, // This is required so we can store the ajax object and can do an abort() if necessary.
			data: {
				type: "email",
				value: emailAddress
			},
			onComplete: function(){
				email = lastEmailChecked;
				meerkat.modules.loadingAnimation.hide( $formElements.email );
			},
			onSuccess:  function checkUserExistsSuccess(result){
				userExists = result.exists;
				toggleMarketingCheckbox(result.optInMarketing);
				if( result.optInMarketing ) {
					$formElements.marketing.prop('checked', true);
				}

				updateStatus(userExists ? 'return' : 'new');
			},
			onError: function checkUserExistsError(){
				updateStatus('new');
			}
		};
		checkUserAjaxObject = meerkat.modules.optIn.fetch( emailInfo );
	}

	/**
	 * Update state of submit button based on password fields being valid
	 */
	function passwordConfirmKeyChange() {
		toggleSubmitButton($formElements.password.valid() && $formElements.passwordConfirm.valid());
	}

	/**
	 * Saves the quote - validates the form, gathers data and sends
	 */
	function save(){
		if ( $formElements.form.valid() ) {
			if($formElements.submitButton.hasClass("disabled") === false) {
				// do not save again if in progress of saving
				if (saveAjaxObject && saveAjaxObject.state() === "pending") {
					return;
				}

				var $mainForm = $('#mainform');
				// save the values against the form (email, marketing and current journey step id)
				if ($('#saved_email').length === 0) {
					meerkat.modules.form.appendHiddenField($mainForm, "saved_email", $formElements.email.val());
				}
				if ($('#saved_marketing').length === 0) {
					meerkat.modules.form.appendHiddenField($mainForm, "saved_marketing", $formElements.marketing.val());
				}

				// prepare data
				var dat = [];
				var sendConfirm;
				// @FIXME = the list of vertical that have a send confirmation should be a setting against each vertical, not a list stored here
				if ($.inArray(meerkat.site.vertical, ['home', 'car', 'ip', 'life']) !== -1) {
					sendConfirm = "no";
				} else {
					sendConfirm = "yes";
				}
				// gather save quote form data (from the "Email Quote/Save Quote" dropdown)
				var quoteForm = meerkat.modules.form.getData($formElements.form);
				// gather journey form data
				var jeForm = meerkat.modules.journeyEngine.getFormData();
				// merges the 2 arrays together
				dat = quoteForm.concat(jeForm);
				dat.push({
					name: 'quoteType',
					value: meerkat.site.vertical
				});
				dat.push({
					name: 'vertical',
					value: meerkat.site.vertical
				});
				dat.push({
					name: 'sendConfirm',
					value: sendConfirm
				});

				meerkat.modules.loadingAnimation.showInside($formElements.submitButton.filter(":visible"));

				if (isConfirmed) {
					meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
						touchType: 'S',
						touchComment: null,
						includeFormData: true,
						callback: function saveQuoteTouchSuccess(result) {
							saveSuccess(result.result.success, result.result.transactionId);
						}
					});
				} else {
					// ajax call to save
					meerkat.modules.comms.post({
						url: "ajax/json/save_email_quote.jsp",
						data: dat,
						dataType: 'json',
						cache: false,
						errorLevel: "silent",
						onSuccess: function saveQuoteSuccess(result) {
							saveSuccess(result.result === "OK", result.transactionId);
						},
						onError: function saveQuoteError() {
							if (meerkat.site.isCallCentreUser || (!_.isEmpty($formElements.password.val()) && !_.isEmpty($formElements.passwordConfirm.val()))) {
								toggleSubmitButton(true);
							}
						},
						onComplete: function () {
							meerkat.modules.loadingAnimation.hide($formElements.submitButton.filter(":visible"));
						}
					});
				}
			}
		}
	}

	/**
	 * Handles the saves quote response and updates the page
	 * @param success
	 * @param transactionId
     */
	function saveSuccess(success, transactionId){
		meerkat.modules.loadingAnimation.hide( $formElements.submitButton.filter(":visible") );

		if(success){
			updateStatus('saved');

			if(!isConfirmed){
				isConfirmed = true;
			}

			if(typeof transactionId !== 'undefined') {
				meerkat.modules.transactionId.set(transactionId);
			}

			if( $.inArray(meerkat.site.vertical, ['car', 'ip', 'life', 'health', 'home']) !== -1) {
				// Previous HNC journey used Home_Contents, so we cannot get away from it at this stage.
				var verticalCode = meerkat.site.vertical === 'home' ? 'Home_Contents' : meerkat.site.vertical;
				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method:'trackQuoteEvent',
					object: {
						action: 'Save',
						transactionID: transactionId,
						vertical: verticalCode,
						simplesUser: meerkat.site.isCallCentreUser
					}
				});
			}
			meerkat.messaging.publish(moduleEvents.QUOTE_SAVED);
		} else {
			// @todo = display error message and offer to try again
		}
	}

	/**
	 * Show/hide the marketing optin copy
	 * @param enable
     */
	function toggleMarketingCheckbox(enable){
		enable = enable || false;
		$formElements.optinRow[enable === false ? "hide" : "show"]();
	}

	/**
	 * Enables all the fields in the form
	 */
	function enable() {
		if(!_.isEmpty($formElements.form) && $formElements.form.length) {
			$formElements.email.prop('disabled',false).removeClass("disabled");
			$formElements.password.prop('disabled',false).removeClass("disabled");
			$formElements.passwordConfirm.prop('disabled',false).removeClass("disabled");
			$formElements.marketing.prop('disabled',false).removeClass("disabled");
			toggleSubmitButton(true);
		}
	}

	/**
	 * Disables all the fields in the form
	 */
	function disable() {
		if(!_.isEmpty($formElements.form) && $formElements.form.length) {
			$formElements.email.prop('disabled',true).addClass("disabled");
			$formElements.password.prop('disabled',true).addClass("disabled");
			$formElements.passwordConfirm.prop('disabled',true).addClass("disabled");
			$formElements.marketing.prop('disabled',true).addClass("disabled");
			toggleSubmitButton(false);
		}
	}

	/**
	 * Toggles the disabled state of the submit button
	 * @param enable
     */
	function toggleSubmitButton(enable){
		enable = enable || false;
		$formElements.submitButton[enable === false ? "addClass" : "removeClass"]("disabled");
	}

	meerkat.modules.register("saveQuote", {
		init: init,
		events: events
	});

})(jQuery);