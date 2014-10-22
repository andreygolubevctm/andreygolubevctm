/**
 * HOME AND CONTENTS
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;

	var moduleEvents = {
		home: {

		},
		WEBAPP_LOCK : 'WEBAPP_LOCK',
		WEBAPP_UNLOCK : 'WEBAPP_UNLOCK'
	}, steps = null;

	var templateAccessories;

	function initHome() {

		var self = this;

		$(document).ready(function() {

			// Only init if home
			if (meerkat.site.vertical !== "home")
				return false;

			// Init common stuff
			initJourneyEngine();

			// Only continue if not confirmation page.
			if (meerkat.site.pageAction === "confirmation") {
				return false;
			}

			eventDelegates();

			if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
				meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
			}

			$e = $('#calldirect-template');
			if ($e.length) {
				templateCallDirect = _.template($e.html());
			}

		});

	}

	function eventDelegates() {

	}

	function initJourneyEngine() {

		if (meerkat.site.pageAction === "confirmation") {

			meerkat.modules.journeyEngine.configure(null);

		} else {

			// Initialise the journey engine steps and bar
			initProgressBar(false);

			// Initialise the journey engine
			var startStepId = null;
			if (meerkat.site.isFromBrochureSite === true) {
				startStepId = steps.startStep.navigationId;
			}
			// Use the stage user was on when saving their quote
			else if (meerkat.site.journeyStage.length && meerkat.site.pageAction === 'latest') {
				startStepId = steps.resultsStep.navigationId;
			} else if (meerkat.site.journeyStage.length && meerkat.site.pageAction === 'amend') {
				startStepId = steps.startStep.navigationId;
			}

			$(document).ready(function(){

				meerkat.modules.journeyEngine.configure({
					startStepId : startStepId,
					steps : _.toArray(steps)
				});

				// Call initial supertag call
				var transaction_id = meerkat.modules.transactionId.get();

				if(meerkat.site.isNewQuote === false){
					meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
						method:'trackQuoteEvent',
						object: {
							action: 'Retrieve',
							transactionID: parseInt(transaction_id, 10),
							vertical: 'Home_Contents' // has to be this. meerkat.site.vertical
						}
					});
				} else {
					meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
						method: 'trackQuoteEvent',
						object: {
							action: 'Start',
							transactionID: parseInt(transaction_id, 10),
							vertical: 'Home_Contents' // has to be this. meerkat.site.vertical
						}
					});
				}
			});

		}
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

		var externalTrackingSettings = {
			method:'trackQuoteForms',
			object:meerkat.modules.home.getTrackingFieldsObject
		};

		var startStep = {
			title: 'Cover',
			navigationId: 'start',
			slideIndex: 0,
			externalTracking: externalTrackingSettings,
			onInitialise: function onStartInit(event) {

				// Hook up privacy optin to Email Quote button
				var $emailQuoteBtn = $(".slide-feature-emailquote");

				// Initial value from preload/load quote
				if ($("#home_privacyoptin").is(':checked')) {
					$emailQuoteBtn.addClass("privacyOptinChecked");
				}

				$("#home_privacyoptin").on('change', function(event){
					if ($(this).is(':checked')) {
						$emailQuoteBtn.addClass("privacyOptinChecked");
					} else {
						$emailQuoteBtn.removeClass("privacyOptinChecked");
					}
				});
				meerkat.modules.currencyField.initCurrency();
			}
		};

		var occupancyStep = {
			title: 'Occupancy',
			navigationId: 'occupancy',
			slideIndex: 1,
			tracking: {
				touchType: 'H',
				touchComment: 'Occupancy',
				includeFormData: true
			},
			externalTracking: externalTrackingSettings,
			onInitialise: function() {
				meerkat.modules.homeOccupancy.initHomeOccupancy();
				meerkat.modules.homeBusiness.initHomeBusiness();
			},
			onAfterEnter: function onOccupancyEnter(event) {
				meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(1) .snapshot');
			}
		};


		var propertyStep = {
			title: 'Property Details',
			navigationId: 'property',
			slideIndex: 2,
			tracking: {
				touchType: 'H',
				touchComment: 'Property',
				includeFormData: true
			},
			externalTracking: externalTrackingSettings,
			onInitialise: function onInitialiseProperty() {
				meerkat.modules.homePropertyDetails.initHomePropertyDetails();
				meerkat.modules.homePropertyFeatures.initHomePropertyFeatures();
				meerkat.modules.homeCoverAmounts.initHomeCoverAmounts();
			},
			onBeforeEnter: function onBeforeEnterProperty(event) {
				meerkat.modules.homePropertyFeatures.toggleSecurityFeatures();
				meerkat.modules.homeCoverAmounts.toggleCoverAmountsFields();
			},
			onAfterEnter: function onPropertyEnter(event) {
				meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(2) .snapshot');
			}
		};

		var policyHoldersStep = {
			title: 'You',
			navigationId: 'you',
			slideIndex: 3,
			tracking: {
				touchType: 'H',
				touchComment: 'You',
				includeFormData: true
			},
			externalTracking: externalTrackingSettings,
			onInitialise: function onInitialisePolicyHolder() {
				meerkat.modules.homePolicyHolder.initHomePolicyHolder();
			},
			onBeforeEnter: function onBeforeEnterPolicyHolder(event) {
				meerkat.modules.homePolicyHolder.togglePolicyHolderFields();
			},
			onAfterEnter: function onPolicyHolderEnter(event) {
				meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(3) .snapshot');
			}
		};

		var historyStep = {
			title: 'Cover History',
			navigationId: 'history',
			slideIndex: 4,
			tracking: {
				touchType: 'H',
				touchComment: 'History',
				includeFormData: true
			},
			externalTracking: externalTrackingSettings,
			onInitialise: function onInitialiseHistory(event){
				// Init the results objects required for next step
				meerkat.modules.homeResults.initPage();
				meerkat.modules.homeHistory.initHomeHistory();
			},
			onAfterEnter: function onHistoryEnter(event) {
				meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(4) .snapshot');
			}
		};

		var resultsStep = {
			title: 'Results',
			navigationId: 'results',
			slideIndex: 5,
			externalTracking: externalTrackingSettings,
			onInitialise: function onResultsInit(event) {
				meerkat.modules.homeMoreInfo.initMoreInfo();
				meerkat.modules.homeEditDetails.initEditDetails();
				meerkat.modules.homeFilters.initHomeFilters();
			},
			onBeforeEnter: function onBeforeEnterResults(event) {
				meerkat.modules.journeyProgressBar.hide();
				$('#resultsPage').addClass('hidden');

				// Sync the filters to the results engine
				meerkat.modules.homeFilters.updateFilters();
			},
			onAfterEnter: function onAfterEnterResults(event){
				if(event.isForward === true){
					meerkat.modules.homeResults.get();
				}
				meerkat.modules.homeFilters.show();
			},
			onBeforeLeave: function onBeforeLeaveResults(event) {
				// Increment the transactionId
				if(event.isBackward === true) {
					meerkat.modules.transactionId.getNew(3);
				}
			},
			onAfterLeave: function onAfterLeaveResults(event) {
				meerkat.modules.journeyProgressBar.show();

				// Hide the filters bar
				meerkat.modules.homeFilters.hide();
				meerkat.modules.homeEditDetails.hide();
			}
		};

		steps = {
			startStep: startStep,
			occupancyStep: occupancyStep,
			propertyStep: propertyStep,
			policyHoldersStep: policyHoldersStep,
			historyStep: historyStep,
			resultsStep: resultsStep
		};
	}

	function configureProgressBar() {
		meerkat.modules.journeyProgressBar.configure([
			{
				label: 'Cover Type',
				navigationId: steps.startStep.navigationId
			},
			{
				label: 'Occupancy',
				navigationId: steps.occupancyStep.navigationId
			},
			{
				label: 'Property Details',
				navigationId: steps.propertyStep.navigationId
			},
			{
				label: 'You',
				navigationId: steps.policyHoldersStep.navigationId
			},
			{
				label: 'Cover History',
				navigationId: steps.historyStep.navigationId
			}
		]);
	}

	// Build an object to be sent by SuperTag tracking.
	function getTrackingFieldsObject(special_case){
		try{

		special_case = special_case || false;

		// Step 1
		var postCode = $('#home_property_address_postCode').val();
		var stateCode = $('#home_property_address_state').val();
		var verticalOption = $('#home_coverType').val();
		var commencementDate = $('#home_startDate').val();

		var yob=$('#home_policyHolder_dob').val();
		if (yob.length > 4){
			yob = yob.substring(yob.length-4);
		}

		// Step 2
		var ownProperty = $('input[name=home_occupancy_ownProperty]:checked').val();
		var principalResidence = $('input[name=home_occupancy_principalResidence]:checked').val();

		// Step 3
		var rebuildCost = $('#home_coverAmounts_rebuildCost').val(),
		replaceContentsCost = $('#home_coverAmounts_replaceContentsCost').val();
		switch(getCoverType()) {
		case 'H':
			replaceContentsCost = null;
			break;
		case 'C':
			rebuildCost = null;
			break;
		}

		var email = $('#home_policyHolder_email').val();
		var marketOptIn = null;
		var mVal = $('input[name=home_policyHolder_marketing]:checked').val();
		var gender = $('#home_policyHolder_title').val() == 'MR' ? 'M' : 'F';
		if($('#home_policyHolder_title').val() === '') {
			gender = null;
		}

		if(!_.isUndefined(mVal)) {
			marketOptIn = mVal;
		}

		var okToCall = null;
		var oVal = $('input[name=home_policyHolder_oktocall]:checked').val();
		if(!_.isUndefined(oVal)) {
			okToCall = oVal;
		}



		var transactionId = meerkat.modules.transactionId.get();
		var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
		var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

		var actionStep='';

		switch(current_step) {
			case 0:
				actionStep = "Cover";
				break;
			case 1:
				actionStep = 'Occupancy';
				break;
			case 2:
				actionStep = 'Property';
				break;
			case 3:
				actionStep = 'You';
				break;
			case 4:
				actionStep = 'History';
				break;
			case 5:
				if(special_case === true) {
					actionStep = 'MoreInfo';
				} else {
					actionStep = 'Results';
				}
				break;
		}

		var response =  {
				vertical:				'Home_Contents', // has to be this as old journey had it as this.
				actionStep:				actionStep,
				transactionID:			transactionId,
				quoteReferenceNumber:	transactionId,
				yearOfBirth:			null,
				postCode:				null,
				state:					null,
				email:					null,
				emailID:				null,
				marketOptIn:			null,
				okToCall:				null
		};

		// Push in values from 1st slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
			_.extend(response, {
				commencementDate: commencementDate,
				postCode: postCode,
				state: stateCode,
				verticalFilter: verticalOption
			});
		}

		// Push in values from 2nd slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('occupancy')) {
			_.extend(response, {
				ownProperty:	ownProperty,
				principalResidence: principalResidence
			});
		}

		// Push in values from 3rd slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('property')) {
			_.extend(response, {
				replaceContentsCost: replaceContentsCost,
				rebuildCost: rebuildCost
			});
		}

		// Push in values from 4th slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('you')) {
			_.extend(response, {
				yearOfBirth:	yob,
				email:			email,
				marketOptIn:	marketOptIn,
				okToCall:		okToCall,
				gender: gender
			});
		}

		return response;

		}catch(e){
			return false;
		}
	}

	function getCoverType() {
		var value = $('#home_coverType').val();
		switch(value) {
			case 'Home Cover Only':
				return 'H';
			case 'Contents Cover Only':
				return 'C';
			case 'Home & Contents Cover':
				return 'HC';
		}
		return '';
	}



	meerkat.modules.register("home", {
		init: initHome,
		events: moduleEvents,
		initProgressBar: initProgressBar,
		getCoverType: getCoverType,
		getTrackingFieldsObject: getTrackingFieldsObject
	});

})(jQuery);