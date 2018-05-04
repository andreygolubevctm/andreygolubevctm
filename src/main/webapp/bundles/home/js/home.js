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

			configureContactDetails();
		});

	}

	function eventDelegates() {

	}

	function toggleLandlords() {
		var landlord = meerkat.site.isLandlord;
		$('.isLandlord input').prop('disabled', !landlord);
		$('.notLandlord input').prop('disabled', landlord);
		if (landlord) {
			$('.isLandlord').show();
			$('.notLandlord').hide();
		} else {
			$('.notLandlord').show();
			$('.isLandlord').hide();
		}
		changeCoverQuestions();
	}

	function changeCoverQuestions() {
		var items = {
		  landlord: [
		    { value: 'Home Cover Only', text: 'Building Cover Only' },
		    { value: 'Contents Cover Only', text: 'Contents Cover Only' },
		    { value: 'Home & Contents Cover', text: 'Building & Contents Cover' }
		  ],
		  home: [
		    { value: 'Home Cover Only', text: 'Home Cover Only' },
		    { value: 'Contents Cover Only', text: 'Contents Cover Only' },
		    { value: 'Home & Contents Cover', text: 'Home & Contents Cover' }
		  ]
		};

		function template(value, text) {
			return '<option class="temp-items" value="' + value + '">' + text + '</option>';
		}

		function changeDropdownVals() {
			var $target = $('#home_coverType');
			var $targetVal = $target.val();
		  var type = meerkat.site.isLandlord ? 'landlord' : 'home';
		  $target.find('.temp-items').remove();
		  for (var i = 0; items[type].length > i; i++) {
		  	$target.append(template(items[type][i].value, items[type][i].text));
		  }
			$target.val($targetVal);
		}

		changeDropdownVals();
	}

	function initJourneyEngine() {

		if (meerkat.site.pageAction === "confirmation") {

			meerkat.modules.journeyEngine.configure(null);

		} else {

			// Initialise the journey engine steps and bar

			initProgressBar(true);
			toggleLandlords();
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
			} else {
				startStepId = meerkat.modules.emailLoadQuote.getStartStepOverride(startStepId);
			}

			meerkat.modules.journeyEngine.configure({
				startStepId: startStepId,
				steps: _.toArray(steps)
			});

			// Call initial supertag call
			var transaction_id = meerkat.modules.transactionId.get();

			if (meerkat.site.isNewQuote === false) {
				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method: 'trackQuoteEvent',
					object: {
						action: 'Retrieve',
						transactionID: parseInt(transaction_id, 10)
					}
				});
			} else {
				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method: 'trackQuoteEvent',
					object: {
						action: 'Start',
						transactionID: parseInt(transaction_id, 10)
					}
				});
			}

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
	
	function initAddressSearch() {
		var xpath = 'home/property/address';
		meerkat.modules.addressLookupV2.getStreetSearch().init(xpath);
		meerkat.modules.addressLookupV2.getHiddenPostcodeSearch().init('street', xpath);
	}

	function setJourneyEngineSteps() {

		var externalTrackingSettings = {
			method:'trackQuoteForms',
			object:meerkat.modules.home.getTrackingFieldsObject
		};

		var startStep = {
			title: 'Cover Type',
			navigationId: 'start',
			slideIndex: 0,
			externalTracking: externalTrackingSettings,
			validation: {
				validate: true,
				customValidation: function (callback) {
					// prevent from jumping to the next step if the selections are incorrect
					var doContinue = meerkat.modules.homeCoverTypeWarning.validateSelections();
					callback(doContinue);
				}
			},
			onInitialise: function onStartInit(event) {
				initAddressSearch();
				meerkat.modules.jqueryValidate.initJourneyValidator();
				// Hook up privacy optin to Email Quote button
				var $emailQuoteBtn = $(".slide-feature-emailquote, .save-quote");

				// Initial value from preload/load quote
				if ($("#home_termsAccepted").is(':checked')) {
					$emailQuoteBtn.addClass("privacyOptinChecked");
				}

				$("#home_termsAccepted").on('change', function(event){
					if ($(this).is(':checked')) {
						$emailQuoteBtn.addClass("privacyOptinChecked");
					} else {
						$emailQuoteBtn.removeClass("privacyOptinChecked");
					}
				});
				initialiseOwner();
				meerkat.modules.homeCoverTypeWarning.initHomeCoverTypeWarning();
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
			validation: {
				validate: true,
				customValidation: function (callback) {
					// prevent from jumping to the next step if the selections are incorrect
					var doContinue = meerkat.modules.homeCoverTypeWarning.validateSelections();
					callback(doContinue);
				}
			},
			externalTracking: externalTrackingSettings,
			onInitialise: function() {
				meerkat.modules.octoberComp.closeMobileBanner();
				meerkat.modules.homeOccupancy.initHomeOccupancy();
				meerkat.modules.homeBusiness.initHomeBusiness();
			},
            onBeforeEnter: function onBeforeEnterOccupancy() {
                if (meerkat.modules.splitTest.isActive(3) === true) {
                    meerkat.modules.homeOccupancy.setupButtonTileDropdownSelectors();
                }
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
				meerkat.modules.homePropertyFeatures.toggleSecurityFeatures(0);
				meerkat.modules.homeCoverAmounts.toggleCoverAmountsFields(0);
				meerkat.modules.homePropertyDetails.validateYearBuilt();

				if (meerkat.modules.splitTest.isActive(3) === true) {
					meerkat.modules.homePropertyDetails.setupButtonTileDropdownSelectors();
				}
			}
		};

		var policyHoldersStep = {
			title: 'Policy Holder',
			navigationId: 'policyHolder',
			slideIndex: 3,
			tracking: {
				touchType: 'H',
				touchComment: 'PolicyHolder',
				includeFormData: true
			},
			externalTracking: externalTrackingSettings,
			onInitialise: function onInitialisePolicyHolder() {
				// Init the results objects required for next step
				meerkat.modules.homePolicyHolder.initHomePolicyHolder();
			},
			onBeforeEnter: function onBeforeEnterPolicyHolder(event) {
				meerkat.modules.homePolicyHolder.togglePolicyHolderFields();
			}
		};

		var historyTracking = {
			touchType: 'H',
			touchComment: 'History',
			includeFormData: true
		};

		var historyStep = {
			title: 'Cover',
			navigationId: 'history',
			slideIndex: 4,
			tracking: historyTracking,
			externalTracking: externalTrackingSettings,
			onInitialise: function onInitialiseHistory(event){
				// Init the results objects required for next step
				meerkat.modules.homeResults.initPage();

				meerkat.modules.homeHistory.initHomeHistory();
				meerkat.modules.resultsFeatures.fetchStructure('hncamsws_');
			},
			onAfterEnter: function onAfterEnterHistory(event) {
			}
		};

		var resultsStep = {
			title: 'Results',
			navigationId: 'results',
			slideIndex: 5,
			externalTracking: externalTrackingSettings,
			onInitialise: function onResultsInit(event) {
				meerkat.modules.octoberComp.hideMobileBanner();
				meerkat.modules.octoberComp.showNav();
				meerkat.modules.homeMoreInfo.initMoreInfo();
				meerkat.modules.homeEditDetails.initEditDetails();
				meerkat.modules.homeFilters.initHomeFilters();
				meerkat.modules.resultsMobileDisplayModeToggle.initToggle();
			},
			onBeforeEnter: function onBeforeEnterResults(event) {
				meerkat.modules.journeyProgressBar.hide();
				$('#resultsPage').addClass('hidden');

				// Sync the filters to the results engine
				meerkat.modules.homeFilters.updateFilters();
			},
			onAfterEnter: function onAfterEnterResults(event) {
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
				meerkat.modules.octoberComp.hideNav();
				meerkat.modules.octoberComp.showMobileBanner();
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

	function setJourneyEngineStepsVariation() {

		var externalTrackingSettings = {
			method:'trackQuoteForms',
			object:meerkat.modules.home.getTrackingFieldsObject
		};

		var startStep = {
			title: 'Cover Type',
			navigationId: 'start',
			slideIndex: 0,
			externalTracking: externalTrackingSettings,
			onInitialise: function onStartInit(event) {
				initialiseOwner();
				meerkat.modules.jqueryValidate.initJourneyValidator();
				meerkat.modules.homeCoverTypeWarning.initHomeCoverTypeWarning();
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
			validation: {
				validate: true,
				customValidation: function (callback) {
					// prevent from jumping to the next step if the selections are incorrect
					var doContinue = meerkat.modules.homeCoverTypeWarning.validateSelections();
					callback(doContinue);
				}
			},
			externalTracking: externalTrackingSettings,
			onInitialise: function() {
				// Hook up privacy optin to Email Quote button
				var $emailQuoteBtn = $(".slide-feature-emailquote, .save-quote");

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
				meerkat.modules.homeOccupancy.initHomeOccupancy();
				meerkat.modules.homeBusiness.initHomeBusiness();
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
				meerkat.modules.homePropertyFeatures.toggleSecurityFeatures(0);
				meerkat.modules.homeCoverAmounts.toggleCoverAmountsFields(0);
				meerkat.modules.homePropertyDetails.validateYearBuilt();
			}
		};

		var policyHoldersStep = {
			title: 'Policy Holder',
			navigationId: 'policyHolder',
			slideIndex: 3,
			tracking: {
				touchType: 'H',
				touchComment: 'PolicyHolder',
				includeFormData: true
			},
			externalTracking: externalTrackingSettings,
			onInitialise: function onInitialisePolicyHolder() {
				// Init the results objects required for next step
				meerkat.modules.homePolicyHolder.initHomePolicyHolder();
			},
			onBeforeEnter: function onBeforeEnterPolicyHolder(event) {
				meerkat.modules.homePolicyHolder.togglePolicyHolderFields();
			}
		};

		var historyStep = {
			title: 'Cover',
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
				meerkat.modules.resultsFeatures.fetchStructure('hncamsws_');
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
				meerkat.modules.resultsMobileDisplayModeToggle.initToggle();
			},
			onBeforeEnter: function onBeforeEnterResults(event) {
				meerkat.modules.journeyProgressBar.hide();
				$('#resultsPage').addClass('hidden');

				// Sync the filters to the results engine
				meerkat.modules.homeFilters.updateFilters();
			},
			onAfterEnter: function onAfterEnterResults(event) {
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
		var keys = _.keys(steps);
		var progressBarSteps = new Array(keys.length - 1);
		var stepOmitList = [];

		for(var i=0; i<keys.length - 1; i++) {
			var step = keys[i];
			if(_.indexOf(stepOmitList,step) === -1) {
				progressBarSteps[steps[step].slideIndex] = {
					label: steps[step].title,
					navigationId: steps[step].navigationId
				};
			}
		}
		meerkat.modules.journeyProgressBar.configure(progressBarSteps);
	}

	function getVerticalFilter() {
		var homeCoverType = $('#home_coverType').val() || null;
		if (homeCoverType && meerkat.site.isLandlord) {
			homeCoverType = 'Landlord ' + homeCoverType;
		}
		return homeCoverType;
	}
	// Build an object to be sent by SuperTag tracking.
	function getTrackingFieldsObject(special_case){
		try{

		special_case = special_case || false;

		// Step 1
		var postCode = $('#home_property_address_postCode').val();
		var stateCode = $('#home_property_address_state').val();
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
		var gender = $('#home_policyHolder_title').val() == 'MR' ? 'Male' : 'Female';
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
				actionStep = 'PolicyHolder';
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
				okToCall:				null,
				verticalFilter:			null,
				ownProperty:			null,
				principalResidence:		null,
				replaceContentsCost:	null,
				rebuildCost:			null
		};

		// Push in values from 1st slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
			_.extend(response, {
				commencementDate:	commencementDate,
				postCode:			postCode,
				state:				stateCode,
				verticalFilter:		meerkat.modules.home.getVerticalFilter()
			});
		}

		// Push in values from 2nd slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('occupancy')) {
			_.extend(response, {
				ownProperty:		ownProperty,
				principalResidence:	principalResidence
			});
		}

		// Push in values from 3rd slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('property')) {
			_.extend(response, {
				replaceContentsCost:	replaceContentsCost,
				rebuildCost:			rebuildCost
			});
		}

		// Push in values from 4th slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('policyHolder')) {
			_.extend(response, {
				yearOfBirth:	yob,
				email:			email,
				marketOptIn:	marketOptIn,
				okToCall:		okToCall,
				gender:			gender
			});
		}

        var crossVerticalOptin = meerkat.modules.leadCapture.getTrackingData();

        if (crossVerticalOptin !== null && current_step === meerkat.modules.journeyEngine.getStepIndex('results')) {
            _.extend(response, {
                crossVerticalOptin: crossVerticalOptin
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

	function initialiseOwner() {
		$owner = $('.ownProperty');

        $owner.find('label:nth-child(1)').addClass('icon-vert-home');
        $owner.find('label:nth-child(2)').addClass('icon-vert-hnc');
	}

	function configureContactDetails(){
		var contactDetailsFields = {
			email: [
				{
					$field: $("#home_policyHolder_email"),
					$optInField: $("#home_policyHolder_marketing")
				}
			]
		};
		meerkat.modules.contactDetails.configure(contactDetailsFields);
	}

	function getPropertyType() {
		return $('#home_property_address_unitSel').val() !== '0' || $('#home_property_address_unitShop').val() !== '' ? 'unit' : 'home';
	}

	function getHomeUnitsItems($el, dontSort) {
		var arr = [],
			homeUnitItems = {
				home: null,
				unit: null
			};

		$el.find('option').each(function() {
			var obj = {
				name: $(this).text(),
				value: $(this).attr('value')
			};

			if ($(this).attr('value')) {
				if (!dontSort) {
					obj.homeOrder = $(this).attr('data-home-order');
					obj.unitOrder = $(this).attr('data-unit-order');
				}

				arr.push(obj);
			}
		});

		if (dontSort) {
			return arr;
		}

		homeUnitItems.home = arr.sort(function(a, b) {
			return a.homeOrder - b.homeOrder;
		});

		homeUnitItems.unit = arr.slice().sort(function(a, b) {
			return a.unitOrder - b.unitOrder;
		});

		return homeUnitItems;
	}

	meerkat.modules.register("home", {
		init: initHome,
		events: moduleEvents,
		initProgressBar: initProgressBar,
		getCoverType: getCoverType,
		getTrackingFieldsObject: getTrackingFieldsObject,
		getVerticalFilter: getVerticalFilter,
		getPropertyType: getPropertyType,
		getHomeUnitsItems: getHomeUnitsItems,
		toggleLandlords: toggleLandlords
	});

})(jQuery);
