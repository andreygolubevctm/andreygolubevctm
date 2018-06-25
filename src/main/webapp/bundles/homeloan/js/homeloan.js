;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var moduleEvents = {
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
	};

	var steps = null;

	function initJourneyEngine(){

		if(meerkat.site.pageAction === "confirmation"){
			meerkat.modules.journeyEngine.configure(null);
		} else {
			initProgressBar(true);

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
					transactionID: parseInt(transaction_id, 10),
					vertical: meerkat.site.vertical,
					verticalFilter: meerkat.modules.homeloan.getVerticalFilter()
				}
			});
		}

	}

	function initProgressBar(render){

		setJourneyEngineSteps();
		configureProgressBar();
		if (render) {
				meerkat.modules.journeyProgressBar.render(true);
		}
	}

	function setJourneyEngineSteps(){

		var startStep = {
			title: 'Your Situation',
			navigationId: 'situation',
			slideIndex: 0,
			externalTracking: {
				method: 'trackQuoteForms',
				object: meerkat.modules.homeloan.getTrackingFieldsObject
			},
			onInitialise: function initStartStep(event) {

				// Init the results objects required for next step
				meerkat.modules.homeloanResults.initPage();
				meerkat.modules.currencyField.initCurrency();
				meerkat.modules.jqueryValidate.initJourneyValidator();

				// Hook up privacy optin to Email Quote button
				var $emailQuoteBtn = $(".slide-feature-emailquote");
				var $privacyOptin = $("#homeloan_privacyoptin");
				// Initial value from preload/load quote
				if ($privacyOptin.is(':checked')) {
					$emailQuoteBtn.addClass("privacyOptinChecked");
				}

				$privacyOptin.on('change', function(event){
					if ($(this).is(':checked')) {
						$emailQuoteBtn.addClass("privacyOptinChecked");
					} else {
						$emailQuoteBtn.removeClass("privacyOptinChecked");
					}
				});

				meerkat.modules.resultsFeatures.fetchStructure('hmlams');
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
				object:meerkat.modules.homeloan.getTrackingFieldsObject
			},
			validation: {
				validate: false,
				customValidation: function validateSelection(callback) {

					callback(true);
				}
			},
			onInitialise: function() {
				meerkat.modules.homeloanMoreInfo.initMoreInfo();
				meerkat.modules.homeloanFilters.initFilters();
			},
			onBeforeEnter: function enterResultsStep(event) {
				Results.removeSelectedProduct();

				if(event.isForward === true) {
					$('#resultsPage').addClass('hidden');
					$('.morePromptContainer, .comparison-rate-disclaimer').addClass('hidden');
				}
			},
			onAfterEnter: function(event) {
				// Only fetch results when coming from Step 1. If coming back from Enquire, just re-show the results.
				if(event.isForward === true) {
					meerkat.modules.homeloanResults.get();
				}
				// For some unknown reason, it will not re-affix itself, so this is necessary in HML
				$('#navbar-main').addClass('affix-top').removeClass('affix');
			},
			onBeforeLeave: function(event) {
				// Increment the transactionId when going back to Step 1
				if(event.isBackward === true) {
					meerkat.modules.transactionId.getNew(3);
				}
			}
		};

		var enquiryStep = {
				title: 'Enquiry',
				navigationId: 'enquiry',
				slideIndex: 2,
				tracking:{
					touchType:'A'
				},
				externalTracking:{
					method:'trackQuoteForms',
					object:meerkat.modules.homeloan.getTrackingFieldsObject
				},
				onInitialise: function() {
					meerkat.modules.homeloanEnquiry.initHomeloanEnquiry();
					meerkat.modules.homeloanSnapshot.initHomeloanSnapshot();
				},
				onBeforeEnter: function() {
					meerkat.modules.homeloanSnapshot.onEnter();

					// Populate hidden fields to store product info
					if (Results.getSelectedProduct() !== false && Results.getSelectedProduct().hasOwnProperty('id')) {
						$('#homeloan_product_id').val(Results.getSelectedProduct().id);
						$('#homeloan_product_lender').val(Results.getSelectedProduct().lender);
					}

					var $situationStepFirstNameInput = $('#homeloan_contact_firstName'),
					$enquiryStepFirstNameRow = $('#homeloan_enquiry_contact_firstName').closest('.form-group'),
					$situationStepLastNameInput = $('#homeloan_contact_lastName'),
					$enquiryStepLastNameRow = $('#homeloan_enquiry_contact_lastName').closest('.form-group');

					if($situationStepFirstNameInput.val() === "" || $situationStepLastNameInput.val() === "") {
						$enquiryStepFirstNameRow.add($enquiryStepLastNameRow).removeClass('hidden');
					}
				}
			};

		steps = {
			startStep: startStep,
			resultsStep: resultsStep,
			enquiryStep: enquiryStep
		};
	}

	function configureProgressBar() {
		meerkat.modules.journeyProgressBar.configure([
			{
				label: 'Your Situation',
				navigationId: steps.startStep.navigationId
			},
			{
				label: 'Your Quote',
				navigationId: steps.resultsStep.navigationId
			},
			{
				label: 'Make an Enquiry',
				navigationId: steps.enquiryStep.navigationId
			}
		]);
	}


	function getVerticalFilter() {
		return $('#homeloan_details_situation').val() || null;
	}

	// Build an object to be sent by SuperTag tracking.
	function getTrackingFieldsObject(special_case){
		try{

		special_case = special_case || false;

		var transactionId = meerkat.modules.transactionId.get();

		var goal = $('#homeloan_details_goal').val();
		var postCode = $('#homeloan_details_postcode').val();
		var stateCode = $('#homeloan_details_state').val();

		var purchasePrice = $('#homeloan_loanDetails_purchasePrice').val();
		var loanAmount = $('#homeloan_loanDetails_loanAmount').val();
		var interestRateType = $('input[name=homeloan_loanDetails_interestRate]:checked').val();

		var email = $('#homeloan_contact_email').val();
		var marketOptIn = $('#homeloan_contact_optIn').is(':checked') ? 'Y' : 'N';

		var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
		var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

		var actionStep='';
		switch(current_step) {
			case 0:
				actionStep = "your situation";
				break;
			case 1:
				if(special_case === true) {
					actionStep = 'homeloan more info';
				} else {
					actionStep = 'homeloan results';
				}
				break;
			case 2:
				actionStep = 'enquire now';
				break;
		}

		var response =  {
				vertical:				meerkat.site.vertical,
				actionStep:				actionStep,
				transactionID:			transactionId,
				quoteReferenceNumber:	transactionId,
				postCode:				null,
				state:					null,
				email:					null,
				emailID:				null,
				marketOptIn:			null,
				okToCall:				null
		};

		// Push in values from 1st slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('situation')) {
			_.extend(response, {
				verticalFilter:	meerkat.modules.homeloan.getVerticalFilter(),
				goal:			goal,
				postCode:		postCode,
				state:			stateCode,
				purchasePrice:	purchasePrice,
				loanAmount:		loanAmount,
				interestRateType:interestRateType,
				email:			email,
				marketOptIn:	marketOptIn
			});
		}

		// Push in values from 2nd slide only when have been beyond it
		if(furtherest_step > meerkat.modules.journeyEngine.getStepIndex('enquiry')) {
			_.extend(response, {
			});
		}

		return response;

		}catch(e){
			return false;
		}
	}

	function applyValuesFromBrochureSite() {
		if(meerkat.site.isFromBrochureSite === true) {
			_.defer(function(){
				if(meerkat.site.brochureValues.situation) {
					if($('#homeloan_details_situation_' + meerkat.site.brochureValues.situation).length === 1) {
						$('#homeloan_details_situation_' + meerkat.site.brochureValues.situation).prop('checked', true).change();
					}
				}
				if(meerkat.site.brochureValues.hasOwnProperty('location')) {
					$('#homeloan_details_location').val(meerkat.site.brochureValues.location);
				}
			});
		}
	}

	/**
	 * Configure contact details to forward populate
	 */
	function configureContactDetails(){

		if(meerkat.site.pageAction === 'confirmation') {
			return;
		}

		var $situationStepPhoneInput = $("#homeloan_contact_contactNumberinput"),
			$enquiryStepPhoneInput = $("#homeloan_enquiry_contact_contactNumberinput"),
			$situationStepEmailInput = $("#homeloan_contact_email"),
			$enquiryStepEmailInput = $("#homeloan_enquiry_contact_email"),
			$situationStepFirstNameInput = $('#homeloan_contact_firstName'),
			$enquiryStepFirstNameInput = $('#homeloan_enquiry_contact_firstName'),
			$situationStepLastNameInput = $('#homeloan_contact_lastName'),
			$enquiryStepLastNameInput = $('#homeloan_enquiry_contact_lastName');


		// define fields here that are multiple (i.e. email field on contact details and on application step) so that they get prefilled
		// or fields that need to publish an event when their value gets changed so that another module can pick it up
		// the category names are generally arbitrary but some are used specifically and should use those types (email, name, potentially phone in the future)
		var contactDetailsFields = {
				name: [
						// first name from situation step
						{
							$field: $enquiryStepFirstNameInput,
							$fieldInput: $situationStepFirstNameInput
						},
						// first name from enquiry step
						{
							$field: $enquiryStepFirstNameInput,
							$fieldInput: $enquiryStepFirstNameInput
						}
				],
				lastname: [
						// last name from situation step
						{
							$field: $enquiryStepLastNameInput,
							$fieldInput: $situationStepLastNameInput
						},
						// last name from enquiry step
						{
							$field: $enquiryStepLastNameInput,
							$fieldInput: $enquiryStepLastNameInput
						}
				],
				email: [
				// email from situation step
				{
					$field: $enquiryStepEmailInput,
					$fieldInput: $situationStepEmailInput
				},
				// email from enquiry step
				{
					$field: $enquiryStepEmailInput,
					$fieldInput: $enquiryStepEmailInput
				}
			],
			phone: [
				// phone from situation step
				{
					$field: $("#homeloan_contact_contactNumber"),
					$fieldInput: $situationStepPhoneInput
				},
				// phone from enquiry step
				{
					$field: $("#homeloan_enquiry_contact_contactNumber"),
					$fieldInput: $enquiryStepPhoneInput
				}
			]
		};

		meerkat.modules.contactDetails.configure(contactDetailsFields);
	}

	function trackHandover() {
		var product = Results.getSelectedProduct();
		if(_.isEmpty(product)) {
			product = {};
			product.productId = 'General Enquiry';
			product.lenderProductName = 'General Enquiry';
			product.brandCode = 'General Enquiry';
		}
		var transaction_id = meerkat.modules.transactionId.get();
		meerkat.modules.partnerTransfer.trackHandoverEvent({
			product:				product,
			type:					'ONLINE',
			quoteReferenceNumber:	transaction_id,
			transactionID:			transaction_id,
			productID:				product.productId,
			productName:			product.lenderProductName,
			productBrandCode:		product.brandCode
		}, false);
	}


	function initHomeloan() {

		$(document).ready(function(){

			if(meerkat.site.vertical !== "homeloan") return false;

			applyValuesFromBrochureSite();
			initJourneyEngine();
			configureContactDetails();

		});

	}

	meerkat.modules.register("homeloan", {
		init: initHomeloan,
		events: moduleEvents,
		initProgressBar: initProgressBar,
		getTrackingFieldsObject: getTrackingFieldsObject,
		getVerticalFilter: getVerticalFilter,
		trackHandover: trackHandover
	});

})(jQuery);