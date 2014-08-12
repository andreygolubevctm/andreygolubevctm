;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var moduleEvents = {
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
	};

	var stateSubmitInProgress = false;

	var steps = null;

	function initJourneyEngine(){

		if(meerkat.site.pageAction === "confirmation"){
			meerkat.modules.journeyEngine.configure(null);
		} else {
			initProgressBar(false);

			meerkat.modules.journeyEngine.configure({
				startStepId: null,
				steps: _.toArray(steps)
			});

			// Call initial supertag call
			var transaction_id = meerkat.modules.transactionId.get();

			meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
				method:'trackQuoteEvent',
				object: {
					action: 'Start',
					transactionID: parseInt(transaction_id, 10)
				}
			});
		}
	}

	function initProgressBar(render){

		setJourneyEngineSteps();
	}

	function setJourneyEngineSteps(){

		var startStep = {
			title: 'Your Situation',
			navigationId: 'situation',
			slideIndex:0,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.homeloan.getTrackingFieldsObject
			},
			onInitialise: function initStartStep(event) {

				// Submit application button
				$("#submit_btn").on('click', function(event){
					var valid = meerkat.modules.journeyEngine.isCurrentStepValid();

					// Validation passed, submit the application.
					if (valid) {
						submitToAFG();
					}
				});
			}
		};

		steps = {
			startStep: startStep
		};
	}

	function submitToAFG() {

		if (stateSubmitInProgress === true) {
			alert('This page is still being processed. Please wait.');
			return;
		}

		stateSubmitInProgress = true;

		meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'submitToAFG', disableFields:true });

		var postData = meerkat.modules.journeyEngine.getFormData();

		meerkat.modules.comms.post({
			url: "ajax/json/homeloan_submit.jsp",
			data: postData,
			cache: false,
			useDefaultErrorHandling: false,
			errorLevel: "fatal",
			timeout: 250000, //10secs more than SOAP timeout
			onSuccess: function onSubmitSuccess(resultData) {
				stateSubmitInProgress = false;

				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method:'trackQuoteForms',
					object: meerkat.modules.homeloan.getTrackingFieldsObject
				});

				var obj = resultData.response;
				window.location.href = obj.redirect_url + "?data=" + obj.json;
			},
			onError: onSubmitToAFGError,
			onComplete: function onSubmitComplete() {
				stateSubmitInProgress = false;
			}
		});
	}

	function onSubmitToAFGError(jqXHR, textStatus, errorThrown, settings, resultData) {
		stateSubmitInProgress = false;
		meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'submitToAFG'});
		meerkat.modules.errorHandling.error({
			message:		"An error occurred when attempting to store data before proceeding to step 2.",
			page:			"homeloan.js:submitToAFG()",
			errorLevel:		"warning",
			description:	"Ajax request to homeloan_submit.jsp failed to return a valid response: " + errorThrown,
			data: resultData
		});
	}

	// Build an object to be sent by SuperTag tracking.
	function getTrackingFieldsObject(){

		var actionStep = 'your situation';
		var state = $("#homeloan_details_state").val();
		var postcode = $("#homeloan_details_postcode").val();
		var email = $("#homeloan_contact_email").val();
		var mkt_opt_in = _.isUndefined($('#homeloan_contact_optIn:checked').val()) ? "N" : "Y";
		var transactionId = meerkat.modules.transactionId.get();

		var response =  {
				vertical:				'homeloan',
				actionStep:				actionStep,
				transactionID:			transactionId,
				quoteReferenceNumber:	transactionId,
				postCode:				postcode,
				state:					state,
				gender:					null,
				yearOfBirth:			null,
				email:					email,
				marketOptIn:			mkt_opt_in
		};

		return response;
	}

	function applyValuesFromBrochureSite() {
		if(meerkat.site.isFromBrochureSite === true) {
			_.defer(function(){
				if(meerkat.site.brochureValues.hasOwnProperty('situation')) {
					if($('#homeloan_details_situation_' + meerkat.site.brochureValues.situation).length === 1) {
						$('#homeloan_details_situation').val(meerkat.site.brochureValues.situation);
					}
				}
				if(meerkat.site.brochureValues.hasOwnProperty('location')) {
					$('#homeloan_details_location').val(meerkat.site.brochureValues.location);
				}
			});
		}
	}

	function initHomeloan() {

		$(document).ready(function(){

			if(meerkat.site.vertical !== "homeloan") return false;

			applyValuesFromBrochureSite();

			initJourneyEngine();
		});

	}

	meerkat.modules.register("homeloan", {
		init: initHomeloan,
		events: moduleEvents,
		initProgressBar: initProgressBar,
		getTrackingFieldsObject: getTrackingFieldsObject
	});

})(jQuery);