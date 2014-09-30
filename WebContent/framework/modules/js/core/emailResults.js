;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {
		emailResults: {

		}
	},
	moduleEvents = events.emailResults;

	var $dropdown = null;
	var $form = null;
	var $instructions = null;
	var $email = null;
	var $password = null;
	var $passwordConfirm = null;
	var $marketing = null;
	var $submitButton = null;
	var $passwords = null;
	var $emailResultsSuccess = null;
	var $emailResultsFields = null;

	var submitButtonClass = ".btn-email-results";

	var lastEmailChecked = null;

	var emailTypingTimer = null;

	var checkUserAjaxObject = null;
	var userExists = null;

	var emailresultsAjaxObject = null;

	var isConfirmed = false;

	var isEnabled = false;


	function init(){

		jQuery(document).ready(function($) {

			$dropdown = $("#email-results-dropdown");
			$form = $("#email-results-component");
			$instructions = $(".emailResultsInstructions");
			$email = $("#emailresults_email");
			$marketing = $("#emailresults_marketing");
			$submitButton = $(submitButtonClass);
			$emailResultsSuccess = $("#emailResultsSuccess");
			$emailResultsFields = $(".emailResultsFields");

			$email.on("keyup change", emailKeyChange);
			$email.on('blur', function() { $(this).val( $.trim( $(this).val() ) ); }) ;

			$form.on("click", ".btn-email-results", emailResults);
			$dropdown.find(".activator").on("click", onDropdownOpen);

			$dropdown.on("click", ".btn-cancel", close);

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
			$emailResultsSuccess.hide();
			$form.show();
			$emailResultsFields.hide();
		} else {
			// trigger extra change event if the email is not empty, the submit button is disabled and password fields are not visible
			// should literally not happen but should avoid the user bein frustrated because his email is in the field but he cannot click the button unless he makes a change
			// this could happen if the previous ajax call from a prefill from the main form did not succeed
			if( $email.val() !== "" && $submitButton.hasClass("disabled") ){
				$email.trigger("change");
			}
		}
	}


	function setValidation(){

		if ($form === null || $form.length === 0) {
			// Save quote form does not exist...
			return;
		}

		setupDefaultValidationOnForm( $form );
	}

	function emailKeyChange(event){

		if (event.keyCode == 13 || event.keyCode == 9) {
			emailChanged();
		} else {
			if (lastEmailChecked != $email.val()) {

				disableSubmitButton();

				clearInterval(emailTypingTimer);
				emailTypingTimer = setTimeout(emailChanged, 800);

			} else {
				enableSubmitButton();
			}
		}

	}

	function emailChanged() {

		var valid = $email.valid();
		if(valid) {
			checkUserExists();
		}

	}

	function checkUserExists(){

		var emailAddress = $email.val();
		lastEmailChecked = emailAddress;

		if (checkUserAjaxObject && checkUserAjaxObject.state() === "pending") {
			if (typeof checkUserAjaxObject.abort === 'function') {
				checkUserAjaxObject.abort();
			}
		}

		disableSubmitButton();
		meerkat.modules.loadingAnimation.showAfter( $email );

		var emailInfo = {
			returnAjaxObject: true, // This is required so we can store the ajax object and can do an abort() if necessary.
			data: {
				type: "email",
				value: emailAddress
			},
			onComplete: function(){
				enableSubmitButton();
				meerkat.modules.loadingAnimation.hide( $email );
			},
			onSuccess:  function checkUserExistsSuccess(result){

				if( result.optInMarketing ) {
					hideMarketingCheckbox();
					$marketing.prop('checked', true);
				} else {
					showMarketingCheckbox();
				}

				updateInstructions('emailresultsReady');
			},
			onError: function checkUserExistsError(){

				userExists = false;
				updateInstructions();
			}
		};

		checkUserAjaxObject = meerkat.modules.optIn.fetch( emailInfo );
	}


	function updateInstructions(instructionsType){
		var text = "Please enter the email you want your results sent to.";
		switch(instructionsType){
		case 'emailresultsAgain':
				text = 'Click the button to send an email of these results.  <a href="javascript:;" class="btn btn-save btn-email-results">Email Results</a>';
				break;
		case 'emailresultsReady':
			text = 'Click the button to send the results to this email address.';
			break;
		default:
				text = 'Please enter the email address you want these results sent to.';
				break;
		}
		$instructions.html(text);
		if( instructionsType === "emailresultsAgain") {
			$submitButton = $(submitButtonClass);
			$submitButton.html("Email Results");
		}
	}

	function emailResults(){

		if ( $form.valid() ) {

			// do not email results again if in progress of emailing
			if ( emailresultsAjaxObject && emailresultsAjaxObject.state() === "pending" ) {
				return;
			}

			disableSubmitButton();

			// prepare data
			var dat = [];
			dat.push( "emailresults_email=" + encodeURIComponent($email.val()) );
			dat.push( "transactionId=" + meerkat.modules.transactionId.get() );

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

			// ajax call to email results
			meerkat.modules.comms.post({
				url: "bestprice/send/email.json",
				data: dat,
				dataType: 'json',
				cache: false,
				errorLevel: "silent",
				onSuccess:  function emailResultsSuccess(result){
					emailresultsSuccess(result.success, result.transactionId);

				},
				onError: function emailResultsError(){
					enableSubmitButton();
				},
				onComplete: function(){
					meerkat.modules.loadingAnimation.hide( $submitButton );
				}
			});
		}

	}

	function emailresultsSuccess(success, transactionId){

		enableSubmitButton();
		meerkat.modules.loadingAnimation.hide( $submitButton );

		if(success){

			$form.hide();
			$emailResultsSuccess.fadeIn();

			if(!isConfirmed){
				isConfirmed = true;
				updateInstructions('emailresultsAgain');
				$dropdown.find(".activator span:not([class])").html("Email Results");
				//only update the text, not the icon, on mobile.
			}

			if(typeof transactionId !== 'undefined') {
				meerkat.modules.transactionId.set(transactionId);
			}

		} else {
			// @todo = display error message and offer to try again
		}


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



	meerkat.modules.register("emailResults", {
		init: init,
		events: events,
		close: close,
		enable: enable,
		disable: disable,
		enableSubmitButton: enableSubmitButton,
		disableSubmitButton: disableSubmitButton
	});

})(jQuery);