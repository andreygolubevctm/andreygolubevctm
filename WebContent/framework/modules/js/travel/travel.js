;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		templateMoreInfo;

	var moduleEvents = {
			traveldetails: {
				COVER_TYPE_CHANGE: "COVER_TYPE_CHANGE"
			},
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
		};

	var steps = null,
		$policyTypeBtn;

	function initJourneyEngine(){
		$(document).ready(function(){
			$policyTypeBtn = $("input[name=travel_policyType]");
			meerkat.modules.travelYourCover.initTravelCover();
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

				if (meerkat.site.pageAction === 'latest') {
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
					transactionID: transaction_id,
					verticalFilter: meerkat.modules.travel.getVerticalFilter()
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

				var currentJourney = meerkat.modules.tracking.getCurrentJourney();

				if (typeof currentJourney !== 'undefined' && (currentJourney === 5 || currentJourney === 6))
				{
					$('#travel_location').on('blur',function() {
						meerkat.modules.travelContactDetails.setLocation($(this).val());
					});
				}

				// if preloaded or load from EDM
				if ($policyTypeBtn.is(':checked')) {
					meerkat.messaging.publish(moduleEvents.traveldetails.COVER_TYPE_CHANGE);
				}

				meerkat.modules.travelCountrySelection.initCountrySelection();
				$policyTypeBtn.on('change', function(event){
					meerkat.messaging.publish(moduleEvents.traveldetails.COVER_TYPE_CHANGE);
				});
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
				meerkat.modules.travelCoverLevelTabs.initTravelCoverLevelTabs();
			},
			onBeforeEnter: function enterResultsStep(event) {
				// Always force it to be a "Load" in travel, as currently, we always get a nwe tranid.
				meerkat.modules.resultsTracking.setResultsEventMode('Load');
				$('#resultsPage').addClass('hidden');
				meerkat.modules.travelSummaryText.updateText();

				meerkat.modules.travelCoverLevelTabs.updateSettings();
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

	// returns the value considered the vertical filter for travel
	function getVerticalFilter()
	{
		var vf = null;
		if ($policyTypeBtn.is(':checked'))
		{
			vf = $("input[name=travel_policyType]:checked").val() == 'S' ? 'Single Trip' : 'Multi Trip';
		}

		return vf;
	}

	// Build an object to be sent by SuperTag tracking.
	function getTrackingFieldsObject(){
		try{

		var ok_to_call = $('input[name=travel_marketing]', '#mainform').val() === "Y" ? "Y" : "N";
		var mkt_opt_in = $('input[name=travel_marketing]:checked', '#mainform').val() === "Y" ? "Y" : "N";

		var transactionId = meerkat.modules.transactionId.get();

		var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
		var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

		var policyType = $("input[name=travel_policyType]:checked").val(),
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
			vertical:				meerkat.site.vertical,
			actionStep:				actionStep,
			transactionID:			transactionId,
			quoteReferenceNumber:	transactionId,
			//yearOfBirth:			null,
			email:					email,
			emailID:				null,
			marketOptIn:			mkt_opt_in,
			verticalFilter:			meerkat.modules.travel.getVerticalFilter()
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
		getTrackingFieldsObject: getTrackingFieldsObject,
		getVerticalFilter: getVerticalFilter
	});

})(jQuery);