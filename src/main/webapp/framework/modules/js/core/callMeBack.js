;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {
		callMeBack: {
			REQUESTED: "CALL_ME_BACK_REQUESTED",
			VALID: "CALL_ME_BACK_VALID",
			INVALID: "CALL_ME_BACK_INVALID"
		}
	},
	moduleEvents = events.callMeBack;

	var $name = null;
	var nameSelector = ".callmeback_name";
	var $phone = null;
	var phoneSelector = ".callmeback_phone";
	var $time = null;
	var timeSelector = ".callmeback_timeOfDay";
	var $optin = null;
	var optinSelector = ".callmeback_optin";

	var $submitButton = null;
	var $currentForm = null;

	var $forms = null;

	var callbackAjaxObject = null;

	var isRequested = false;

	var formName = null;
	var formMobileNumber = null;
	var formOtherNumber = null;

	function init(){

		jQuery(document).ready(function($) {
			
			updateSelectedElements();

		});

		msg.subscribe( meerkat.modules.events.contactDetails.name.FIELD_CHANGED, function(fieldDetails){
			if( typeof fieldDetails.$otherField !== "undefined" ){
				if( fieldDetails.fieldIndex === 1 ){
					formName = $.trim(fieldDetails.$field.val() + " " + fieldDetails.$otherField.val());
				} else {
					formName = $.trim(fieldDetails.$otherField.val() + " " + fieldDetails.$field.val());
				}
			} else {
				formName = fieldDetails.$field.val();
			}
		});

		msg.subscribe( meerkat.modules.events.contactDetails.mobile.FIELD_CHANGED, function(fieldDetails){
			formMobileNumber = fieldDetails.$field.val();
		});

		msg.subscribe( meerkat.modules.events.contactDetails.otherPhone.FIELD_CHANGED, function(fieldDetails){
			formOtherNumber = fieldDetails.$field.val();
		});

		msg.subscribe( moduleEvents.VALID, enableSubmitButton );
		msg.subscribe( moduleEvents.INVALID, disableSubmitButton );

	}

	function updateSelectedElements(){
		$name = $(nameSelector);
		$phone = $(phoneSelector);
		$time = $(timeSelector);
		$optin = $(optinSelector);

		$name.off("keyup").on("keyup", checkFormValid);
		$phone.off("keyup").on("keyup", checkFormValid);
		$phone.off("focusout").on("focusout", function(){ $(this).siblings("[type=hidden]").val( $(this).val().replace(/[^0-9]+/g, '') ); });
		$time.off("change").on("change", checkFormValid);

		$submitButton = $(".call-me-back-submit");
		$forms = $(".call-me-back-form");

		$submitButton.off("click").on("click", function(){ submitCallMeBack( $(this).parents("form").first() ) } );

		setValidation();
	}

	function prefillForm( $form ){

		if(formName !== null){
			$form.find(nameSelector).val(formName);
		}

		if(formMobileNumber !== null){
			$form.find(phoneSelector).val(formMobileNumber);
		} else if(formOtherNumber !== null) {
			$form.find(phoneSelector).val(formOtherNumber);
		}

	}

	function checkFormValid(){
		
		setCurrentForm( $(this).parents("form").first() );

		var notEmptyName = $currentForm.find( $name ).val() !== '';
		var notEmptyPhone = $currentForm.find( $phone ).val() !== '';
		var notEmptyTime = $currentForm.find( $time ).val() !== '';

		if( notEmptyName && notEmptyPhone && notEmptyTime && $currentForm.valid() ){
			msg.publish( moduleEvents.VALID );
		} else {
			msg.publish( moduleEvents.INVALID );
		}

	}

	function submitCallMeBack( $form ){

		setCurrentForm( $form );

		if( callbackAjaxObject && callbackAjaxObject.state() === "pending" )
			return;

		if(!$currentForm.valid())
			return;

		if(isRequested)
			return;

		$currentForm.find(optinSelector).val("Y");

		var dat = [];

		var quoteForm = meerkat.modules.form.getData( $currentForm )
		var jeForm =  meerkat.modules.journeyEngine.getFormData()
		dat = quoteForm.concat(jeForm);
		dat.push({
			name:'quoteType',
			value: meerkat.site.vertical
		});

		msg.publish( moduleEvents.INVALID );
		meerkat.modules.loadingAnimation.showAfter( $submitButton );

		callbackAjaxObject = meerkat.modules.comms.post({
		url: "ajax/write/request_callback.jsp",
			data: dat,
			dataType: 'json',
			cache: false,
			errorLevel: "silent",
			onSuccess:  function submitCallMeBackSuccess(result){

				isRequested = true;

				meerkat.messaging.publish( moduleEvents.REQUESTED, {
					phone: $currentForm.find($phone).val(),
					name: $currentForm.find($name).val()
				});

				hideForms();
				showThanks();

				var $mainForm = $('#mainform');

				// append all values to main form as hidden fields, required because on next Save Quote or S touch, the fields would be wiped from DB otherwise
				$currentForm.find(":input").each(function(){
					$this = $(this);
					meerkat.modules.form.appendHiddenField( $mainForm, $this.attr("name"), $this.val() );
				});

				// only reproducing the existing here, not sure if useful at all
				meerkat.modules.form.appendHiddenField( $mainForm, meerkat.site.vertical + "_callmeback_time", result.time );
				meerkat.modules.form.appendHiddenField( $mainForm, meerkat.site.vertical + "_callmeback_date", result.date );

				if($('#requested_callmeback_time').length === 0) {
					meerkat.modules.form.appendHiddenField( $mainForm, "requested_callmeback_time", result.time );
				}
				if($('#requested_callmeback_date').length === 0) {
					meerkat.modules.form.appendHiddenField( $mainForm, "requested_callmeback_date", result.date );
				}

			},
			onError: function submitCallMeBackError(){

				hideForms();
				showErrors();

				msg.publish( moduleEvents.VALID );
			},
			onComplete: function(){
				meerkat.modules.loadingAnimation.hide( $submitButton );
			}
		});
		
	}

	function hasCallbackBeenRequested(){
		return isRequested;
	}

	function hideForms(){
		$forms.each(function(){
			$(this).hide();
		});
	}

	function showThanks(){
		$forms.each(function(){
			$(this).after( getThankYouMessage() );
		});
	}

	function showErrors(){
		// form tag is required to be there for stupid Bootstrap dropdown which will close themselves on click if the container is not a form
		$forms.each(function(){
			$(this).after('<form class="callmeback-feedback"><h5>Call back service offline</h5><p>Sadly our call back service is offline - Please try again later.</p></form>');
		});
	}

	function getThankYouMessage(){
		// form tag is required to be there for stupid Bootstrap dropdown which will close themselves on click if the container is not a form
		return '<form class="callmeback-feedback"><h5>Someone will call you</h5><p>Thank you, a member of our staff will call you in the ' + getTimeInLetters( $currentForm.find($time).val() ) + '</p></form>';
	}

	function getTimeInLetters( letterCode ){

		switch(letterCode){
			case 'M':
				time = "morning";
				break;
			case 'A':
				time = 'afternoon';
				break;
			default:
				time = 'evening (excludes WA)';
				break;
		}
		return time;

	}

	function setCurrentForm( $form ){
		$currentForm = $form;
	}

	function setValidation(){

		$forms.each(function(){
			meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($(this));
		});

		if( $name.length > 0 ){
			$name.setRequired(true, "Please enter your name");
		}


		if( $time.length > 0 ){
			$time.setRequired(true);
		}

	}

	function enableSubmitButton(){
		if( $currentForm !== null ){
			$currentForm.find($submitButton).removeClass('disabled');
		}
	}

	function disableSubmitButton(){
		if( $currentForm !== null ){
			$currentForm.find($submitButton).addClass('disabled');
		}
	}

	meerkat.modules.register("callMeBack", {
		init: init,
		events: events,
		hasCallbackBeenRequested: hasCallbackBeenRequested,
		prefillForm: prefillForm,
		updateSelectedElements: updateSelectedElements,
		submitCallMeBack: submitCallMeBack
	});

})(jQuery);