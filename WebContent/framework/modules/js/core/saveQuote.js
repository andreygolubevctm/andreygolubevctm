;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {
		saveQuote: {
			
		}
	},
	moduleEvents = events.saveQuote;

	var $dropdown = null;
	var $form = null;
	var $instructions = null;
	var $email = null;
	var $password = null;
	var $passwordConfirm = null;
	var $marketing = null;
	var $submitButton = null;
	var $passwords = null;
	var $saveQuoteSuccess = null;
	var $saveQuoteFields = null;
	var $callMeBackForm = null;

	var submitButtonClass = ".btn-save-quote";

	var lastEmailChecked = null;

	var emailTypingTimer = null;

	var checkUserAjaxObject = null;
	var userExists = null;

	var saveAjaxObject = null;

	var isConfirmed = false;

	var isEnabled = false;


	function init(){

		jQuery(document).ready(function($) {

			$dropdown = $("#email-quote-dropdown");
			$form = $("#email-quote-component");
			$callMeBackForm = $("#callmeback-save-quote-dropdown");
			$instructions = $(".saveQuoteInstructions");
			$email = $("#save_email");
			$password = $("#save_password");
			$passwordConfirm = $("#save_confirm");
			$marketing = $("#save_marketing");
			$submitButton = $(submitButtonClass);
			$passwords = $(".saveQuotePasswords");
			$saveQuoteSuccess = $("#saveQuoteSuccess");
			$saveQuoteFields = $(".saveQuoteFields");

			$email.on("keyup change", emailKeyChange);
			$email.on('blur', function() { $(this).val( $.trim( $(this).val() ) ); }) ;
			$passwordConfirm.on("keyup change", passwordConfirmKeyChange);

			$form.on("click", ".btn-save-quote", save);
			$dropdown.find(".activator").on("click", onDropdownOpen);

			setValidation();
			updateInstructions();
			hideMarketingCheckbox();


			// On application lockdown/unlock, disable/enable the dropdown
			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, disable);

			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, enable);
		});

		msg.subscribe( meerkat.modules.events.contactDetails.email.FIELD_CHANGED, function(fieldDetails){
			if($email.val() === ""){
				$email.val(fieldDetails.$field.val()).trigger("change");
			}
		});
	}

	function onDropdownOpen(){
		if(isConfirmed){
			$callMeBackForm.hide();
			$saveQuoteSuccess.hide();
			$form.show();
			$saveQuoteFields.hide();
		} else {
			$callMeBackForm.hide();
			// trigger extra change event if the email is not empty, the submit button is disabled and password fields are not visible
			// should literally not happen but should avoid the user bein frustrated because his email is in the field but he cannot click the button unless he makes a change
			// this could happen if the previous ajax call from a prefill from the main form did not succeed
			if( $email.val() !== "" && $submitButton.hasClass("disabled") && !$(".saveQuotePasswords").is(":visible") ){
				$email.trigger("change");
			}
		}
		if( $callMeBackForm.length !== 0 ) {
			$dropdown.find(".callmeback-feedback").remove(); // might be appended by the callMeBack module if a call back has already been requested
		}
	}


	function setValidation(){

		if ($form === null || $form.length === 0) {
			// Save quote form does not exist...
			return;
		}

		setupDefaultValidationOnForm( $form );

		if ($password.length > 0) {
			$password.rules('add', {
				required:true,
				minlength: 6,
				messages:{
					required: "Please enter a password",
					minlength: jQuery.format("Password must be at least {0} characters")
				}
			});
		}

		if ($passwordConfirm.length > 0) {
			$passwordConfirm.rules('add', {
				required:true,
				equalTo: "#" + $password.attr("id"),
				messages:{
					required: "Please confirm your password",
					equalTo: jQuery.format("Password and confirmation password must match")
				}
			});
		}
	}

	function emailKeyChange(event){

		if (event.keyCode == 13 || event.keyCode == 9) {
			emailChanged();
		} else {
			if (lastEmailChecked != $email.val()) {

				disableSubmitButton();

				clearInterval(emailTypingTimer);
				emailTypingTimer = setTimeout(emailChanged, 800);

			} else if($password.val() !== "" && $password.val() !== "") {
				enableSubmitButton();
			}
		}

	}

	function passwordConfirmKeyChange(event){

		if( $password.valid() && $passwordConfirm.valid() ) {
			enableSubmitButton();
		} else {
			disableSubmitButton();
		}

	}

	function emailChanged() {

		var valid = $email.valid();
		if(valid) {
			// $('#save_marketing').prop('checked', SaveQuote.optInSelected); // @todo = necessary?
			checkUserExists();
		}

	}

	function checkUserExists(){

		/* necessary?
		if (lastEmailChecked == $email.val()) {
			if (checkUserAjaxObject && checkUserAjaxObject.state() !== "pending") {
				if(meerkat.site.isCallCentreUser || ($password.val() != '' && $passwordConfirm.val() != '')) {
					enableSubmitButton();
				}
			}
			return;
		}
		*/

		var emailAddress = $email.val();
		lastEmailChecked = emailAddress;

		if (checkUserAjaxObject && checkUserAjaxObject.state() === "pending" && checkUserAjaxObject) {
			checkUserAjaxObject.abort();
		}

		disableSubmitButton();
		meerkat.modules.loadingAnimation.showAfter( $email );

		var emailInfo = {
			data: {
				type: "email",
				value: emailAddress
			},
			dataType: 'json',
			cache: true,
			isFatalError: false,
			onComplete: function(){
				meerkat.modules.loadingAnimation.hide( $email );
			},
			onSuccess:  function checkUserExistsSuccess(result){

				userExists = result.exists;

				if( result.optInMarketing ) {
					hideMarketingCheckbox();
					$marketing.prop('checked', true);
				} else {
					showMarketingCheckbox();
				}

				if(!meerkat.site.isCallCentreUser) {
					if(result.exists) {
						updateInstructions('clickSubmit');
						hidePasswords();
					} else {
						updateInstructions('createLogin');
						showPasswords();
					}
				}

				enableSubmitButton();
			},
			onError: function checkUserExistsError(){
				
				userExists = false;

				if(!meerkat.site.isCallCentreUser) {
					updateInstructions('createLogin');
					showPasswords();
				}

				if(meerkat.site.isCallCentreUser) {
					enableSubmitButton();
				} else if($password.val() !== '' && $passwordConfirm.val() !== '') {
					if( $passwordConfirm.valid() ) {
						enableSubmitButton();
					}
				}

			}
		}

		checkUserAjaxObject = meerkat.modules.optIn.fetch( emailInfo );

	}


	function updateInstructions(instructionsType){
		var text = "";
		switch(instructionsType){
			case 'clickSubmit':
				text = "Click 'Email quote' to have your quote emailed";
				break;
			case 'createLogin':
				text = "Please create a login to have your quote emailed";
				break;
			case 'saveAgain':
				text= 'Click \'Save Quote\' to update your saved quote <a href="javascript:;" class="btn btn-primary btn-save-quote">Email Quote</a>';
				break;
			default:
				if(meerkat.site.isCallCentreUser){
					text = "Please enter the email you want the quote sent to.";
				}else {
					text = "We will check if you have an existing login or create a new one for you.";
				}
				break;
		}
		$instructions.html(text);
		if( instructionsType === "saveAgain") {
			$submitButton = $(submitButtonClass);
			$submitButton.html("Save Quote");
		}
	}

	function save(){

		if ( $form.valid() ) {

			// do not save again if in progress of saving
			if ( saveAjaxObject && saveAjaxObject.state() === "pending" ) {
				return;
			}

			disableSubmitButton();

			var $mainForm = $('#mainform');
			// save the values against the form (email, marketing and current journey step id)
			if($('#saved_email').length === 0) {
				meerkat.modules.form.appendHiddenField( $mainForm, "saved_email", $email.val() );
			}
			if($('#saved_marketing').length === 0) {
				meerkat.modules.form.appendHiddenField( $mainForm, "saved_marketing", $marketing.val() );
			}

			// prepare data
			var dat = [];
			var sendConfirm;
			// @FIXME = the list of vertical that have a send confirmation should be a setting against each vertical, not a list stored here
			if( $.inArray(meerkat.site.vertical, ['car','ip','life']) != -1 ){
				sendConfirm = "no";
			} else {
				sendConfirm = "yes";
			}

			dat.push( meerkat.modules.form.getSerializedData( $form ) );
			dat.push( meerkat.modules.journeyEngine.getSerializedFormData() );
			dat.push("quoteType=" + meerkat.site.vertical );
			dat.push("brand=" + meerkat.site.brand );
			dat.push("vertical=" + meerkat.site.vertical);
			dat.push("sendConfirm=" + sendConfirm);

			dat = dat.join("&");

			switch(Track._type) {
				case "Health":
					if( Health._rates !== false ) {
						dat += Health._rates;
					}
					break;
				default:
					break;
			}

			meerkat.modules.loadingAnimation.showAfter( $submitButton );

			if( isConfirmed ){

				meerkat.messaging.publish(meerkatEvents.tracking.TOUCH, {
					touchType:'S',
					touchComment: null,
					includeFormData: true,
					callback: function saveQuoteTouchSuccess(result){
						saveSuccess(result.result.success, result.result.transactionId);
					}
				});

			} else {

				// ajax call to save
				meerkat.modules.comms.post({
					url: "ajax/json/save_email_quote_mysql.jsp",
					data: dat,
					dataType: 'json',
					cache: false,
					isFatalError: false,
					onSuccess:  function saveQuoteSuccess(result){

						saveSuccess(result.result === "OK", result.transactionId);

					},
					onError: function saveQuoteError(){
						/* @todo = adapt/correct/handle the error*/
						/*
						try {
							var errors = eval(obj.responseText);
							if(typeof errors == "object" && errors.length > 0 && errors[0].error == "Authentication Failed") {
								SaveQuote.show(SaveQuote._AUTH_ERROR);
							} else {
								SaveQuote.updateErrorFeedback(errors);
								SaveQuote.show(SaveQuote._ERROR);
							}
						} catch(e) {
							SaveQuote.updateErrorFeedback();
							SaveQuote.show(SaveQuote._ERROR);
						}
						*/
						if ( meerkat.site.isCallCentreUser || ($password.val() !== '' && $passwordConfirm.val() !== '') ) {
							enableSubmitButton();
						}
					},
					onComplete: function(){
						meerkat.modules.loadingAnimation.hide( $submitButton );
					}
				});
			}

		}

	}

	function saveSuccess(success, transactionId){

		enableSubmitButton();
		meerkat.modules.loadingAnimation.hide( $submitButton );

		if(success){

			$form.hide();
			$saveQuoteSuccess.fadeIn();

			if($callMeBackForm.length !== 0 && !isConfirmed && !meerkat.modules.callMeBack.hasCallbackBeenRequested() && !meerkat.site.isCallCentreUser){
				meerkat.modules.callMeBack.prefillForm( $callMeBackForm );
				$callMeBackForm.fadeIn();
			}

			if(!isConfirmed){
				isConfirmed = true;
				updateInstructions('saveAgain');
				$dropdown.find('.activator').html('Save Quote');
			}

			if(typeof referenceNo !== "undefined" && typeof transactionId !== 'undefined') {
				referenceNo.setTransactionId(transactionId);
			}

			if( meerkat.site.vertical == 'car') {
				Track.startSaveRetrieve(referenceNo.getTransactionID(false) , 'Save');
			} else if( $.inArray(meerkat.site.vertical, ['ip','life','health']) !== -1) {
				
				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method:'trackQuoteEvent',
					object: {
						action: 'Save',
						transactionID: transactionId
					}
				});
			}

		} else {
			// @todo = display error message and offer to try again
		}


	}

	function showPasswords(){
		$passwords.slideDown();
	}

	function hidePasswords(){
		$passwords.slideUp();
	}

	function hideMarketingCheckbox(){
		$marketing.parents(".row").first().hide();
	}

	function showMarketingCheckbox(){
		$marketing.parents(".row").first().show();
	}

	function enableSubmitButton(){
		$submitButton.removeClass("disabled");
	}

	function disableSubmitButton(){
		$submitButton.addClass("disabled");
	}

	function enable(obj) {
		$dropdown.children('.activator').removeClass('inactive').removeClass('disabled');
	}

	function disable(obj) {
		close();
		$dropdown.children('.activator').addClass('inactive').addClass('disabled');
	}

	// Close the drop down with code (public method).
	function close() {
		if ($dropdown.hasClass('open')) {
			$dropdown.find('.activator').dropdown('toggle');
		}
	}



	meerkat.modules.register("saveQuote", {
		init: init,
		events: events,
		close: close,
		enable: enable,
		disable: disable,
		enableSubmitButton: enableSubmitButton,
		disableSubmitButton: disableSubmitButton
	});

})(jQuery);