;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		msg = meerkat.messaging;

	var events = {
		sendEmail: {
			REQUEST_SEND : "REQUEST_SEND"
		}
	},
	moduleEvents = events.sendEmail;

	var defaultSettings = {
		form : null,
		instructions : null,
		email : null,
		marketing : null,
		submitButton : null,
		emailResultsSuccess : null,
		emailResultsFields : null,
		lastEmailChecked : null,
		emailTypingTimer : null,
		checkUserAjaxObject : null,
		userExists : null,
		isConfirmed : false,
		isEnabled : false,
		emailResultsFailCallback : defaultEmailResultsFail
	};

	function init(){
		msg.subscribe( moduleEvents.REQUEST_SEND, function emailRequestFunction(request) {
			sendEmail(request.instanceSettings);
		});
	}

	function setup(instanceSettings){
		var settings = $.extend({}, defaultSettings, instanceSettings);

		setValidation(settings);
		hideMarketingCheckbox(settings);

		settings.emailInputOnChangeFunction = function(event){
			emailKeyChange(event , settings);
		};

		settings.emailInputBlurFunction =  function(event) {
			emailKeyChange(event , settings);
			$(this).val( $.trim( $(this).val() ) );
		};

		settings.fieldChangedFunction = function(fieldDetails){
			if(settings.emailInput.val() === ""){
				settings.emailInput.val(fieldDetails.$field.val()).trigger("change");
			}
		};

		settings.emailRequestFunction = function(request){
			if(settings.identifier === request.instanceSettings.identifier){
				sendEmail(instanceSettings);
			}
		};

		msg.subscribe( meerkatEvents.contactDetails.email.FIELD_CHANGED, settings.fieldChangedFunction);

		settings.emailInput.on("keydown change", settings.emailInputOnChangeFunction);
		settings.emailInput.on('blur', settings.emailInputBlurFunction) ;

//		TODO: get population between tabs working
//		if (settings.emailInput.val() === '') {
//			settings.emailInput.val(meerkat.modules.contactDetails.getLatestValue("email"));
//			settings.emailInput.trigger('change');
//		}

		return settings;
	}

	function tearDown(settings){
		settings.emailInput.off('blur', settings.emailInputBlurFunction) ;
		settings.emailInput.off("keydown change", settings.emailInputOnChangeFunction);
		settings.submitButton.off("click", settings.submitClickButtonFunction);
		msg.unsubscribe( meerkatEvents.contactDetails.email.FIELD_CHANGED, settings.fieldChangedFunction);
	}

	function setValidation(settings){
		if (settings.form === null || settings.form.length === 0) {
			// Save form does not exist so validation will fail
			return false;
		}
		meerkat.modules.jqueryValidate.setupDefaultValidationOnForm( settings.form );
		return true;
	}

	function emailKeyChange(event , settings){
		if (event.keyCode == 13) event.preventDefault();
		if (event.keyCode == 13 || event.keyCode == 9) {
			emailChanged(settings);
		} else {
			var emailHasChanged = settings.lastEmailChecked != settings.emailInput.val();
			if (emailHasChanged) {
				clearInterval(settings.emailTypingTimer);
				settings.emailTypingTimer = setTimeout(function(){
					emailChanged(settings);
				}, 800);
			}
		}
	}

	function emailChanged(settings) {
		if(typeof settings.emailInput == 'undefined'){
			meerkat.modules.errorHandling.error({
				errorLevel:		'info',
				page:			'sendEmail.js:emailChanged',
				description:	"settings.emailInput is undefined"
			});
			disableSubmitButton(settings);
			tearDown(settings);
		} else {
			var validEmailAddress = true;
			if (settings.form !== null && settings.form.length > 0) {
				validEmailAddress = settings.emailInput.valid();
				if (validEmailAddress) {
					$('#emailAddress-error').remove();
				}
			}
			var hasChanged = settings.lastEmailChecked != settings.emailInput.val();
			if(validEmailAddress && hasChanged) {
				checkUserExists(settings);
			}
			if(settings.canEnableSubmit(settings)){
				enableSubmitButton(settings);
			} else {
				disableSubmitButton(settings);
			}
		}

	}

	function showInProgess(settings) {
		disableSubmitButton(settings);
		meerkat.modules.loadingAnimation.showAfter( settings.emailInput );
	}

	function stopInProgess(settings) {
		if(settings.canEnableSubmit(settings)){
			enableSubmitButton(settings);
		}
		meerkat.modules.loadingAnimation.hide( settings.emailInput );
	}

	function checkUserExists(instanceSettings) {

		if (instanceSettings.checkUserAjaxObject && instanceSettings.checkUserAjaxObject.state() === "pending") {
			if (typeof settings.checkUserAjaxObject.abort === 'function') {
				instanceSettings.checkUserAjaxObject.abort();
			}
		}

		// disable submit and show a loading animation
		if(instanceSettings.lockoutOnCheckUserExists){
			showInProgess(instanceSettings);
			meerkat.modules.loadingAnimation.showAfter( instanceSettings.emailInput );
		}

		var emailAddress = instanceSettings.emailInput.val();
		// set to last changed
		instanceSettings.lastEmailChecked = emailAddress;


		instanceSettings.checkUserAjaxObject = meerkat.modules.optIn.fetch( {
			returnAjaxObject: true, // This is required so we can store the ajax object and can do an abort() if necessary.
			data: {
				type: "email",
				value: emailAddress
			},
			cache: true,
			onComplete: function(){
				if(instanceSettings.lockoutOnCheckUserExists) {
					meerkat.modules.loadingAnimation.hide( instanceSettings.emailInput );
					if(instanceSettings.canEnableSubmit(instanceSettings)) {
						stopInProgess(instanceSettings);
					}
				}
			},
			onSuccess:  function checkUserExistsSuccess(result) {
				// If the user has already opted in hide the opt in checkbox
				if( result.optInMarketing ) {
					hideMarketingCheckbox(instanceSettings);
				} else {
					showMarketingCheckbox(instanceSettings);
				}
			},
			onError: function checkUserExistsError(){
				userExists = false;
				// If the user has already opted is unknown so show checked
				showMarketingCheckbox(instanceSettings);
			}
		});
	}

	function sendEmail(settings){
		// do not email again if in email is in progress
		if (settings.isPending ) {
			return;
		}
		if ( settings.form.valid() ) {
			settings.isPending = true;
			// prepare data
			var dat = settings.sendEmailDataFunction(settings);

			dat = purgefromData('vertical', dat);
			dat.push({
				name:'vertical',
				value: meerkat.site.vertical
			});

			dat = purgefromData('email', dat);
			dat.push({
				name:'email',
				value: settings.emailInput.val()
			});

			showInProgess(settings);

			// ajax call to email results
			meerkat.modules.comms.post({
				url: settings.submitUrl,
				data: dat,
				dataType: 'json',
				cache: false,
				errorLevel: "warning",
				onSuccess:  function emailResultsSuccess(result){
					appendUsedEmail(settings);
					if(typeof result.transactionId !== 'undefined' && result.transactionId !== "") {
						meerkat.modules.transactionId.set(result.transactionId);
					}
					if(typeof settings.emailResultsSuccessCallback === 'function'){
						settings.emailResultsSuccessCallback(result, settings);
					}
				},
				onError: function emailResultsError(){
					settings.emailResultsFailCallback(settings);
				},
				onComplete: function(){
					settings.isPending = false;
					stopInProgess(settings);
				}
			});
		}

	}
	function purgefromData(item, dat) {
		var i;
		for (i = 0; i < dat.length; i++) {
			if (dat[i].name === item) {
				dat.splice(i, 1);
			}
		}
		return dat;
	}

	function appendUsedEmail(settings) {
		if(_.has(settings,'emailHistoryInput') && $(settings.emailHistoryInput).length) {
			var email = $.trim(settings.emailInput.val());
			var history = $.trim(settings.emailHistoryInput.val());
			history = !_.isEmpty(history) ? history.split(',') : [];
			if(_.indexOf(history,email) === -1) {
				history.push(email);
				settings.emailHistoryInput.val(history.join(','));
				_.defer(_.bind(meerkat.modules.writeQuote.write,this,null,false,null));
			}
		}
	}

	function defaultEmailResultsFail(settings){
		enableSubmitButton(settings);
	}

	function hideMarketingCheckbox(settings){
		settings.marketing.parents(".row").first().slideUp();
	}

	function showMarketingCheckbox(settings){
		settings.marketing.parents(".row").first().slideDown();
	}

	function enableSubmitButton(settings){
		settings.submitButton.removeClass("disabled");
	}

	function disableSubmitButton(settings){
		settings.submitButton.addClass("disabled");
	}

	meerkat.modules.register("sendEmail", {
		init : init,
		events: events,
		setup : setup,
		tearDown : tearDown,
		sendEmail : sendEmail,
		emailChanged : emailChanged,
		enableSubmitButton : enableSubmitButton,
		disableSubmitButton : disableSubmitButton,
		checkUserExists : checkUserExists,
		purgefromData : purgefromData
	});

})(jQuery);