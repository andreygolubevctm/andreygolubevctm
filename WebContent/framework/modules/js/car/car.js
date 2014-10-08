/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;

	var moduleEvents = {
		car : {

		},
		WEBAPP_LOCK : 'WEBAPP_LOCK',
		WEBAPP_UNLOCK : 'WEBAPP_UNLOCK'
	}, steps = null;

	var templateAccessories;

	function initCar() {

		var self = this;

		$(document).ready(function() {

			// Only init if car
			if (meerkat.site.vertical !== "car")
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

			var $e = $('#quote-accessories-template');
			if ($e.length > 0) {
				templateAccessories = _.template($e.html());
			}
			$e = $('#more-info-template');
			if ($e.length > 0) {
				templateMoreInfo = _.template($e.html());
			}
			$e = $('#calldirect-template');
			if ($e.length > 0) {
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
			else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'latest') {
				startStepId = steps.resultsStep.navigationId;
			} else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'amend') {
				startStepId = steps.startStep.navigationId;
			}

			// Defered to allow time for the slide modules to init e.g. vehicle selection
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
							vertical: meerkat.site.vertical
						}
					});
				} else {
					meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
						method: 'trackQuoteEvent',
						object: {
							action: 'Start',
							transactionID: parseInt(transaction_id, 10),
							vertical: meerkat.site.vertical
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

		var startStep = {
			title : 'Your Car',
			navigationId : 'start',
			slideIndex : 0,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.car.getTrackingFieldsObject
			},
			onInitialise : function onStartInit(event) {

				// Hook up privacy optin to Email Quote button
				var $emailQuoteBtn = $(".slide-feature-emailquote");

				// Initial value from preload/load quote
				if ($("#quote_privacyoptin").is(':checked')) {
					$emailQuoteBtn.addClass("privacyOptinChecked");
				}

				$("#quote_privacyoptin").on('change', function(event){
					if ($(this).is(':checked')) {
						$emailQuoteBtn.addClass("privacyOptinChecked");
					} else {
						$emailQuoteBtn.removeClass("privacyOptinChecked");
					}
				});

				meerkat.modules.carSnapshot.init();

			},
			validation:{
				validate:true,
				customValidation:function(callback){
					$('#quote_vehicle_selection').find('select').each(function(){
						if($(this).is('[disabled]')) {
							callback(false);
							return;
						}
					});
					callback(true);
				}
			}
		};

		var optionsStep = {
			title : 'Car Details',
			navigationId : 'options',
			slideIndex : 1,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.car.getTrackingFieldsObject
			},
			tracking:{
				touchType:'H',
				touchComment: 'OptionsAccs',
				includeFormData:true
			},
			onInitialise: function() {
				meerkat.modules.carYoungDrivers.initCarYoungDrivers();
			},
			onAfterEnter: function onOptionsEnter(event) {
				meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(1) .snapshot');
			}
		};

		var detailsStep = {
			title : 'Driver Details',
			navigationId : 'details',
			slideIndex : 2,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.car.getTrackingFieldsObject
			},
			tracking:{
				touchType:'H',
				touchComment: 'DriverDtls',
				includeFormData:true
			},
			onAfterEnter: function(event) {
				meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(2) .snapshot');
			},
			onBeforeLeave : function(event) {
			}
		};

		var addressStep = {
			title : 'Address & Contact',
			navigationId : 'address',
			slideIndex : 3,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.car.getTrackingFieldsObject
			},
			tracking:{
				touchType:'H',
				touchComment: 'AddressCon',
				includeFormData:true
			},
			onInitialise : function (event) {
				meerkat.modules.carResults.initPage();
				var driversFirstName =  $('#quote_drivers_regular_firstname');
				var driversLastName =  $('#quote_drivers_regular_surname');
				var driversPhoneNumber =  $('#quote_contact_phoneinput');
				var driversContactEmail =  $('#quote_contact_email');

				$('#quote_riskAddress_postCode, #quote_vehicle_parking, #quote_riskAddress_suburb, #quote_riskAddress_nonStdStreet, #quote_riskAddress_streetSearch').on('change', function() {
					sendEarlyRequest();
				});

				// Need to add a blur event on this search field because the address loading does weird stuff.
				$('#quote_riskAddress_streetSearch').on('blur', function() {
					sendEarlyRequest();
				});

					$('#quote_options_commencementDate').on('blur', function() {
						sendEarlyRequest();
					});

				$('#quote_contact_competition_optin').on('change', function() {
					if ($(this).is(':checked')) {
						driversFirstName.rules('add', {required:true, messages:{required:'Please enter your First Name to be eligible for the competition'}});
						driversLastName.rules('add', {required:true, messages:{required:'Please enter your Last Name to be eligible for the competition'}});
						driversPhoneNumber.rules('add', {required:true, messages:{required:'Please enter your Contact Number to be eligible for the competition'}});
						driversContactEmail.rules('add', {required:true, messages:{required:'Please enter your Email Address to be eligible for the competition'}});
					}
					else {
						driversFirstName.rules('remove', 'required');
						driversLastName.rules('remove', 'required');
						driversPhoneNumber.rules('remove', 'required');
						driversContactEmail.rules('remove', 'required');

						driversFirstName.valid();
						driversLastName.valid();
						driversPhoneNumber.valid();
						driversContactEmail.valid();
					}
				});
			},
			onAfterEnter : function (event) {
				meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(3) .snapshot');
				if (event.isForward === true && meerkat.modules.journeyEngine.getCurrentStep().navigationId === "address") {
					// Delay this call to avoid conflicts with the access touch
					_.defer(sendEarlyRequest);
				}
			},
			onBeforeLeave : function(event) {
			}
		};

		var resultsStep = {
			title: 'Results',
			navigationId: 'results',
			slideIndex: 4,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.car.getTrackingFieldsObject
			},
			onInitialise: function onResultsInit(event) {
				meerkat.modules.carMoreInfo.initMoreInfo();
				meerkat.modules.carEditDetails.initEditDetails();
			},
			onBeforeEnter: function enterResultsStep(event) {
				meerkat.modules.journeyProgressBar.hide();
				$('#resultsPage').addClass('hidden');
				// show disclaimer here.
				// Sync the filters to the results engine
				meerkat.modules.carFilters.updateFilters();
				Results.startResultsFetch();
			},
			onAfterEnter: function afterEnterResults(event) {
				var resultsAjaxRequest = Results.getAjaxRequest();
				if (resultsAjaxRequest === false) {
					// If the ajax ever fails it will equal false. So we don't need to check for timeouts or 404's
					meerkat.modules.carResults.get();
				} else {
				// Wait the mandatory five seconds, then show results. Otherwise keep waiting till we have results.
				window.setTimeout(function() {
						resultsAjaxRequest = Results.getAjaxRequest();
						if (resultsAjaxRequest.readyState === 4 &&
								resultsAjaxRequest.status === 200 &&
							$.isArray(Results.getReturnedResults()))
						{
							// We have an appropriate ajax response from the early fetch and we have products.
							Results.finishResultsFetch();
							// Ensure that ranking only written after touch - conflict avoidance
							meerkat.modules.tracking.recordTouch('R', '', true, Results.publishResultsDataReady);
					}

				}, 5000);
				}

				// Show the filters bar
				meerkat.modules.carFilters.show();
			},
			onBeforeLeave: function(event) {
				// Increment the transactionId
				if(event.isBackward === true) {
					meerkat.modules.transactionId.getNew(3);
				}
			},
			onAfterLeave: function(event) {
				meerkat.modules.journeyProgressBar.show();

				// Hide the filters bar
				meerkat.modules.carFilters.hide();
				meerkat.modules.carEditDetails.hide();
			}
		};

		steps = {
			startStep: startStep,
			optionsStep: optionsStep,
			detailsStep: detailsStep,
			addressStep: addressStep,
			resultsStep: resultsStep
		};

	}

	function configureProgressBar() {
		meerkat.modules.journeyProgressBar.configure([
			{
				label: 'Your Car',
				navigationId: steps.startStep.navigationId
			},
			{
				label: 'Car Details',
				navigationId: steps.optionsStep.navigationId
			},
			{
				label: 'Driver Details',
				navigationId: steps.detailsStep.navigationId
			},
			{
				label: 'Address & Contact',
				navigationId: steps.addressStep.navigationId
			},
			{
				label: 'Your Quotes',
				navigationId: steps.resultsStep.navigationId
			}
		]);
	}
	// Build an object to be sent by SuperTag tracking.
	function getTrackingFieldsObject(special_case){
		try{

		special_case = special_case || false;

		var yob=$('#quote_drivers_regular_dob').val();
		if (yob.length > 4){
			yob = yob.substring(yob.length-4);
		}

		var gender = null;
		var gVal = $('input[name=quote_drivers_regular_gender]:checked').val();
		if(!_.isUndefined(gVal)) {
			switch(gVal){
				case 'M': gender='Male'; break;
				case 'F': gender='Female'; break;
			}
		}

		var marketOptIn = null;
		var mVal = $('input[name=quote_contact_marketing]:checked').val();
		if(!_.isUndefined(mVal)) {
			marketOptIn = mVal;
		}

		var okToCall = null;
		var oVal = $('input[name=quote_contact_oktocall]:checked').val();
		if(!_.isUndefined(oVal)) {
			okToCall = oVal;
		}

		var postCode = $('#quote_riskAddress_postCode').val();
		var stateCode = $('#quote_riskAddress_state').val();
		var vehYear = $('#quote_vehicle_year').val();
		var vehMake = $('#quote_vehicle_make option:selected').text();

		var email = $('#quote_contact_email').val();

		var transactionId = meerkat.modules.transactionId.get();

		var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
		var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

		var actionStep='';

		switch(current_step) {
			case 0:
				actionStep = "your car";
				break;
			case 1:
				actionStep = 'car details';
				break;
			case 2:
				actionStep = 'driver details';
				break;
			case 3:
				actionStep = 'address contact';
				break;
			case 4:
				if(special_case === true) {
					actionStep = 'more info';
				} else {
					actionStep = 'car results';
				}
				break;
		}

		var response =  {
				vertical:				meerkat.site.vertical,
				actionStep:				actionStep,
				transactionID:			transactionId,
				quoteReferenceNumber:	transactionId,
				yearOfManufacture:		null,
				makeOfCar:				null,
				gender:					null,
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
				yearOfManufacture:		vehYear,
				makeOfCar:				vehMake
			});
		}

		// Push in values from 2nd slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('details')) {
			_.extend(response, {
				yearOfBirth:	yob,
				gender:			gender
			});
		}

		// Push in values from 2nd slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('address')) {
			_.extend(response, {
				postCode:		postCode,
				state:			stateCode,
				email:			email,
				marketOptIn:	marketOptIn,
				okToCall:		okToCall
			});
		}

		return response;

		}catch(e){
			return false;
		}
	}

	function sendEarlyRequest() {
		// Cancel any current requests.
		if (Results.getAjaxRequest() !== false &&
			Results.getAjaxRequest().readyState !== 4 &&
			Results.getAjaxRequest().status !== 200)
		{
			// Cancel if we have a results request in progress.
			Results.getAjaxRequest().abort();
		}

		var fieldsValidForEarlyRequest = validateRequiredEarlyFetchFields();
		if (fieldsValidForEarlyRequest) {
			meerkat.modules.carResults.earlyGet("ajax/json/car_quote_results.jsp?fetchMode=early", undefined);
		}
	}

	function validateRequiredEarlyFetchFields() {
		if ($('#quote_riskAddress_nonStd:checked').val () === 'Y') {
			if (!$('#quote_riskAddress_postCode').isValid()) return false;
			if (!$('#quote_riskAddress_suburb').isValid()) return false;
			if (!$('#quote_riskAddress_nonStdStreet').isValid()) return false;
		} else {
			if (!$('#quote_riskAddress_postCode').isValid()) return false;
			if (!$('#quote_riskAddress_streetSearch').isValid()) return false;
		}

		if (!$('#quote_vehicle_parking').isValid()) return false;

			if (!$('#quote_options_commencementDate').isValid()) return false;

		return true;
	}

	meerkat.modules.register("car", {
		init: initCar,
		events: moduleEvents,
		initProgressBar: initProgressBar,
		getTrackingFieldsObject: getTrackingFieldsObject
	});

})(jQuery);