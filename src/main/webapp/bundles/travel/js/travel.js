;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		templateMoreInfo,
		$travel_dates_toDate,
		$travel_dates_fromDate_button,
		$travel_dates_fromDate,
		$travel_dates_toDate_button,
		$travel_adults;

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

			$travel_dates_toDate = $("#travel_dates_toDate"),
			$travel_dates_fromDate_button = $('#travel_dates_fromDate_button'),
			$travel_dates_fromDate = $("#travel_dates_fromDate"),
			$travel_dates_toDate_button = $('#travel_dates_toDate_button').trigger("click"),
			$travel_adults = $('#travel_adults'),
			$travel_dates_toDate = $("#travel_dates_toDate");

			initStickyHeader();


			$policyTypeBtn = $("input[name=travel_policyType]");
			meerkat.modules.travelYourCover.initTravelCover();

			initProgressBar(false);

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

	function initStickyHeader() {
        $(window).scroll(function() {
            var windowYOffset = window.pageYOffset;
            if (windowYOffset >= 16) {
				$('.header-wrap').addClass('stuck');
				$('#logo').addClass('stuck');
            } else {
                $('.header-wrap').removeClass('stuck');
                $('#logo').removeClass('stuck');
			}
        });
	}

	/**
	 * Initialise and configure the progress bar.
	 *
	 * @param {bool}
	 *            render
	 */
	function initProgressBar(render) {
		setJourneyEngineSteps();
		configureProgressBar();
		if (render) {
			meerkat.modules.journeyProgressBar.render(true);
		}
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
				// Call initialisers
				meerkat.modules.jqueryValidate.initJourneyValidator();
				meerkat.modules.travelCountrySelector.initTravelCountrySelector();
				meerkat.modules.travelContactDetails.initContactDetails();
                meerkat.modules.travelPopularDestinations.initTravelPopularDestinations();

				// if preloaded or load from EDM
				if ($policyTypeBtn.is(':checked')) {
					meerkat.messaging.publish(moduleEvents.traveldetails.COVER_TYPE_CHANGE);
				}

				$policyTypeBtn.on('change', function(event){
					meerkat.messaging.publish(moduleEvents.traveldetails.COVER_TYPE_CHANGE);
				});

				$( "#travel_dates_fromDateInputD, #travel_dates_fromDateInputM, #travel_dates_fromDateInputY").focus(function showCalendar() {
					$travel_dates_toDate.datepicker('hide');
					$travel_dates_fromDate_button.trigger("click");
				});

				$( "#travel_dates_toDateInputD, #travel_dates_toDateInputM, #travel_dates_toDateInputY").focus(function showCalendar() {
					$travel_dates_fromDate.datepicker('hide');
					$travel_dates_toDate_button.trigger("click");
				});

				// if in the event the user is a tab key navigator
				$travel_adults.focus(function hideCalendar() {
					$travel_dates_toDate.datepicker('hide');
				});

				meerkat.modules.travelAdultAges.initAdultAges();
				meerkat.modules.travelParameters.noOfTravellersDisplayLogic();


			},
			onBeforeEnter: function(event) {

			},
			onBeforeLeave: function(event) {
				meerkat.modules.travelAdultAges.updateHiddenField();
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
				meerkat.modules.showMoreQuotesPrompt.initPromptBar();
				meerkat.modules.travelSorting.initSorting();
				meerkat.modules.partnerTransfer.initTransfer();
				meerkat.modules.travelCoverLevelTabs.initTravelCoverLevelTabs(isAmtDomesticOnLoadJourney());
			},
			onBeforeEnter: function enterResultsStep(event) {
				meerkat.modules.travellers.mapValues();
				// Always force it to be a "Load" in travel, as currently, we always get a new tranid.
				meerkat.modules.resultsTracking.setResultsEventMode('Load');
				$('#resultsPage').addClass('hidden');
				meerkat.modules.travelSummaryText.updateText();
				meerkat.modules.travelSorting.resetToDefaultSort();
				meerkat.modules.travelCoverLevelTabs.updateSettings();
			},
			onAfterEnter: function afterEnterResults(event) {
				meerkat.modules.travelResults.get();
			},
			onAfterLeave: function(event) {
				if(event.isBackward) {
					meerkat.modules.showMoreQuotesPrompt.disablePromptBar();
				}
			}
		};

		steps = {
			detailsStep: detailsStep,
			resultsStep: resultsStep
		};

	}

	function isAmtDomesticOnLoadJourney() {
        return $('#travel_lastCoverTabLevel').val() === 'D';
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

	function configureProgressBar() {
		meerkat.modules.journeyProgressBar.configure([
			{
				label: 'Travel Details',
				navigationId: steps.detailsStep.navigationId
			},
			{
				label: 'Your Quote',
				navigationId: steps.resultsStep.navigationId
			}
		]);
	}

	// Build an object to be sent by SuperTag tracking.
	function getTrackingFieldsObject(){
		try{

		var mkt_opt_in = $('input[name=travel_marketing]:checked', '#mainform').val() === "Y" ? "Y" : "N";

		var transactionId = meerkat.modules.transactionId.get();

		var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
		var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

		var policyType = $("input[name=travel_policyType]:checked").val(),
			email = $("#travel_email").val(),
			dest='',
			insType='',
			leaveDate = '',
			returnDate = null;

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

			dest = $('#travel_destination').val();
			insType='Single Trip';
			leaveDate = formatDate($("#travel_dates_fromDate").val());
			returnDate = formatDate($("#travel_dates_toDate").val());
		} else {
			insType='Annual Policy';
			dest = "Multi-Trip";
			leaveDate = formatDate(new Date());
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
				marketOptIn:	mkt_opt_in,
				leaveDate:		leaveDate,
				returnDate:		returnDate,
				adults:			$("#travel_adults").val(),
				children:		$("#travel_children").val(),
				oldest:			$("#travel_oldest").val()
			});
		}

		return response;

		}catch(e){
			return false;
		}
	}

	function formatDate(d) {

		if (typeof d === 'string')
		{
			var dateStr = d.split('/');
			d = new Date(dateStr[2], dateStr[1], dateStr[0]);
		}

		var month = d.getMonth()+1;
		var day = d.getDate();

		return (day<10 ? '0' : '') + day
				+ '/' +
			(month<10 ? '0' : '') + month + '/' + d.getFullYear();
	}

	meerkat.modules.register("travel", {
		init: initJourneyEngine,
		events: moduleEvents,
		getTrackingFieldsObject: getTrackingFieldsObject,
		getVerticalFilter: getVerticalFilter,
        isAmtDomesticOnLoadJourney: isAmtDomesticOnLoadJourney
	});

})(jQuery);
