/*
 *
 * Handling of the enquiry page
 *
*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		stateSubmitInProgress = false,
		$foundProperty,
		$foundPanel,
		$bestContact,
		$bestContactPanel,
		$submitButton;

	var moduleEvents = {
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
	};

	function applyEventListeners(){

		$submitButton.on("click", function(event) {
			var valid = meerkat.modules.journeyEngine.isCurrentStepValid();
			if (valid) {
				submitEnquiry();
			}
		});

		$bestContact.on("change", function() {
			if ($bestContact.val() === 'P') {
				$bestContactPanel.addClass('show_Y').removeClass('show_N').removeClass('show_');
			} else {
				$bestContactPanel.addClass('show_N').removeClass('show_Y').removeClass('show_');
			}
		});

		$('#homeloan_enquiry_contact_firstName, #homeloan_enquiry_contact_lastName').on("change", function() {
			meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(2) .snapshot');
		});


		$foundProperty.on("change", function() {
			if ($('#homeloan_enquiry_newLoan_foundAProperty_Y').is(':checked')) {
				$foundPanel.addClass('show_Y').removeClass('show_N').removeClass('show_');
			} else {
				$foundPanel.addClass('show_N').removeClass('show_Y').removeClass('show_');
				$('#homeloan_enquiry_newLoan_offerTime').val('');
				$('#homeloan_enquiry_newLoan_propertyType').val('');
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, lockSlide);

		meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, unlockSlide);
	}

	function initHomeloanEnquiry(){

		//Elements need to be in the page
		$(document).ready(function() {
			$submitButton = $("#submit_btn");
			$bestContact = $("#homeloan_enquiry_contact_bestContact");
			$bestContactPanel = $("#homeloan_enquiry_contact_bestcontactToggleArea");
			$foundProperty = $("#homeloan_enquiry_newLoan_foundAProperty");
			$foundPanel = $('#homeloan_enquiry_newLoan_foundToggleArea');

			applyEventListeners();

			// Re-flow the questionset in case there are pre-filled values e.g. load quote
			$bestContact.trigger('change');
			$foundProperty.trigger('change');
		});
	}

	function lockSlide(obj) {
		var isSameSource = (typeof obj !== 'undefined' && obj.source && obj.source === 'homeloanEnquiry');
		var disableFields = (typeof obj !== 'undefined' && obj.disableFields && obj.disableFields === true);

		// Disable button, show spinner
		$submitButton.addClass('disabled');

		if(disableFields === true) {
			var $slide = $('#enquiryForm');
			$slide.find(':input').prop('disabled', true);
			$slide.find('.select').addClass('disabled');
			$slide.find('.btn-group label').addClass('disabled');
		}

		if (isSameSource === true) {
			meerkat.modules.loadingAnimation.showAfter($submitButton);
		}
	}

	function unlockSlide(obj) {
		$submitButton.removeClass('disabled');
		meerkat.modules.loadingAnimation.hide($submitButton);

		var $slide = $('#enquiryForm');
		$slide.find(':input').prop('disabled', false);
		$slide.find('.select').removeClass('disabled');
		$slide.find('.btn-group label').removeClass('disabled');
	}

	function submitEnquiry() {

		if (stateSubmitInProgress === true) {
			alert('This page is still being processed. Please wait.');
			return;
		}

		stateSubmitInProgress = true;

		// Must collect the form data BEFORE the application lockdown which disables the fields on the slide
		var postData = meerkat.modules.journeyEngine.getFormData();

		meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source:'homeloanEnquiry', disableFields:true });

		meerkat.modules.comms.post({
			url: "ajax/json/homeloan_submit.jsp",
			data: postData,
			cache: false,
			useDefaultErrorHandling: false,
			errorLevel: "fatal",
			timeout: 75000, //10secs more than service timeout
			onSuccess: function onSubmitSuccess(resultData) {
				stateSubmitInProgress = false;

				if (resultData.hasOwnProperty('confirmationkey') === false) {
					onSubmitError(false, '', 'Missing confirmationkey', false, resultData);
					return;
				}

				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method:'trackQuoteForms',
					object: meerkat.modules.homeloan.getTrackingFieldsObject
				});

				//var obj = resultData.responseData;
				//window.location.href = "homeloan_confirmation.jsp?transactionid=" + meerkat.modules.transactionId.get() + "&data=" + obj;

				var confirmationId = resultData.confirmationkey;
				window.location.href = 'viewConfirmation?key=' + encodeURI(confirmationId);
			},
			onError: onSubmitError,
			onComplete: function onSubmitComplete() {
				stateSubmitInProgress = false;
			}
		});
	}

	function onSubmitError(jqXHR, textStatus, errorThrown, settings, resultData) {
		stateSubmitInProgress = false;
		meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source:'homeloanEnquiry'});
		meerkat.modules.errorHandling.error({
			message:		"An error occurred when attempting to submit your enquiry.",
			page:			"homeloanEnquiry.js:submitEnquiry()",
			errorLevel:		"warning",
			description:	"Ajax request to homeloan/opportunity/apply.json failed to return a valid response: " + errorThrown,
			data: resultData
		});
	}

	meerkat.modules.register("homeloanEnquiry", {
		initHomeloanEnquiry: initHomeloanEnquiry
	});

})(jQuery);