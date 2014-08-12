;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		templateMoreInfo;

	var moduleEvents = {
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
		};

	var steps = null;

	function initJourneyEngine(){
		$(document).ready(function(){
			// Initialise the journey engine steps
			setJourneyEngineSteps();

			// Initialise the journey engine
			var startStepId = null;

			if (meerkat.site.isFromBrochureSite === true) {
				startStepId = steps.detailsStep.navigationId;
			} else {
				//Use the stage user was on when saving their quote
				if (meerkat.site.journeyStage.length > 0 && (meerkat.site.pageAction === 'amend') || meerkat.site.pageAction === 'load') {
					// Publish tracking events.
					meerkat.modules.journeyEngine.loadingShow('retrieving your quote information');
					meerkat.modules.travelReloadQuote.loadQuote(); //kick them into a page refresh once we loaded the data bucket.
				}

				if (meerkat.site.pageAction === 'results') {
					meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
					startStepId = steps.resultsStep.navigationId;
				}
			}

			meerkat.modules.journeyEngine.configure({
				startStepId: startStepId,
				steps: _.toArray(steps)
			});

			// Call initial supertag call
			var transaction_id = meerkat.modules.transactionId.get();

			meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
				method:'trackQuoteEvent',
				object: {
					action: 'Start',
					transactionID: transaction_id
				}
			});

			// From EDM
			if(meerkat.site.isNewQuote === false){
				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method:'trackQuoteEvent',
					object: {
						action: 'Retrieve',
						transactionID: transaction_id
					}
				});
			}

			var $e = $('#more-info-template');
			if ($e.length > 0) {
				templateMoreInfo = _.template($e.html());
			}
		});
	}


	function setJourneyEngineSteps() {

		var detailsStep = {
			title : 'Travel Details',
			navigationId : 'start',
			slideIndex : 0,
			externalTracking : { 
				method:'trackQuoteForms',
				object:meerkat.modules.travel.getTrackingFieldsObject
			},
			onInitialise : function onStartInit(event) {
				meerkat.modules.travelCountrySelection.initCountrySelection();
			},
			onBeforeEnter: function(event) {
			},
			onBeforeLeave: function(event) {
				
			}
		};

		var resultsStep = {
			title: 'Results',
			navigationId: 'results',
			slideIndex: 1,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.travel.getTrackingFieldsObject
			},
			onInitialise: function onResultsInit(event) {
				meerkat.modules.travelResults.initPage();
				meerkat.modules.travelSummaryText.initSummaryText();
				meerkat.modules.travelMoreInfo.initMoreInfo();
				meerkat.modules.travelSorting.initSorting();
				meerkat.modules.partnerTransfer.initTransfer();
			},
			onBeforeEnter: function enterResultsStep(event) {
				$('#resultsPage').addClass('hidden');
				meerkat.modules.travelSummaryText.updateText();
			},
			onAfterEnter: function afterEnterResults(event) {
				meerkat.modules.travelResults.get();
			},
			onAfterLeave: function(event) {
			}
		};

		steps = {
			detailsStep: detailsStep,
			resultsStep: resultsStep
		};

	}

	// Build an object to be sent by SuperTag tracking.
	function getTrackingFieldsObject(){
		try{

		var ok_to_call = $('input[name=travel_marketing]', '#mainform').val() === "Y" ? "Y" : "N";
		var mkt_opt_in = $('input[name=travel_marketing]:checked', '#mainform').val() === "Y" ? "Y" : "N";

		var transactionId = meerkat.modules.transactionId.get();

		var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
		var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

		var policyType=$('#travel_policyType').val(),
			email = $("#travel_email").val(),
			dest='',
			insType='';

		var actionStep='';
		switch(current_step) {
			case 0:
				actionStep = "travel details";
				break;
			case 1:
				actionStep = "travel results";
				break;
		}
		
		if (meerkat.modules.moreInfo.isModalOpen())
		{
			actionStep ="travel more info";
		}

		if (policyType=='S') {
			$('input.destcheckbox:checked').each(function(idx,elem){
				dest+=','+$(this).val();
			});
			dest=dest.substring(1);
			insType='Single Trip';
		} else {
			insType='Annual Policy';
		}

		var response =  {
			vertical:				'travel',
			actionStep:				actionStep,
			transactionID:			transactionId,
			quoteReferenceNumber:	transactionId,
			//yearOfBirth:			null,
			email:					email,
			marketOptIn:			mkt_opt_in
		};

		// Push in values from 2nd slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
			_.extend(response, {
				email:			email,
				destinationCountry: dest,
				travelInsuranceType: insType,
				//okToCall:		ok_to_call
				marketOptIn:	mkt_opt_in
			});
		}

		return response;

		}catch(e){
			return false;
		}
	}

	meerkat.modules.register("travel", {
		init: initJourneyEngine,
		events: moduleEvents,
		getTrackingFieldsObject: getTrackingFieldsObject
	});

})(jQuery);