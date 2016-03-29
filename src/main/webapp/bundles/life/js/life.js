;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		moduleEvents = {
			life: {

			},
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
		},
		steps = null;

    function initLife() {
        $(document).ready(function() {
            // Only init if life
            if (meerkat.site.vertical !== "life")
                return false;

            // Init common stuff
            initJourneyEngine();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
        });
    }

    function initJourneyEngine() {
        // Initialise the journey engine steps and bar
        initProgressBar(true);

        // Initialise the journey engine
        var startStepId = null;
        if (meerkat.site.isFromBrochureSite === true && meerkat.modules.address.getWindowHashAsArray().length === 1) {
            startStepId = steps.startStep.navigationId;
            skipToResults = true;
        }
        // Use the stage user was on when saving their quote
        else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'latest') {
            startStepId = steps.resultsStep.navigationId;
        } else if (meerkat.site.journeyStage.length > 0 && meerkat.site.pageAction === 'amend') {
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

	function initProgressBar(render){

		setJourneyEngineSteps();

		if(render){
			meerkat.modules.journeyProgressBar.render(true);
		}
	}

	function setJourneyEngineSteps(){
		var startStep = {
			title: 'Life Insurance Details',
			navigationId: 'start',
			slideIndex:0,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.life.getTrackingFieldsObject
			},
			onInitialise: function onStartInit(event){
				meerkat.modules.jqueryValidate.initJourneyValidator();
			}, onBeforeLeave: function onInsuranceDetailsLeave() {
				var $coverForRadioVal = $('input[name="life_primary_insurance_partner"]:checked');
				meerkat.modules.lifePartner.togglePartnerFields($coverForRadioVal.val() === 'Y');
			}
		};

		var aboutYouStep = {
			title: 'About You',
			navigationId: 'about',
			slideIndex:1,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.life.getTrackingFieldsObject
			},
			onInitialise:function onDetailsInit(event){
				meerkat.modules.occupationSelector.initOccupationSelector();
			},
			onBeforeEnter: function onDetailsBeforeEnter(e) {
				meerkat.modules.lifePrefill.occupations();
			}
		};

		var aboutPartnerStep = {
			title: 'About your partner',
			navigationId: 'partner',
			slideIndex: 2,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.life.getTrackingFieldsObject
			},
			onInitialise: function aboutPartnerInit(event){
			},
			onBeforeEnter: function onDetailsBeforeEnter(e) {
				meerkat.modules.lifePrefill.occupations();
			},
			onAfterEnter: function aboutPartnerBeforeEnter(event){
				meerkat.modules.lifePartner.toggleSkipToResults();
			}
		};
		var contactStep = {
			title: 'Contact Details',
			navigationId: 'contact',
			slideIndex: 3,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.life.getTrackingFieldsObject
			},
			onInitialise: function onContactInit(event){

			}
		};

		var resultsStep = {
			title: 'Your Results',
			navigationId: 'results',
			slideIndex: 4,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.life.getTrackingFieldsObject
			},
			onInitialise: function onInitResults(event){
				meerkat.modules.lifeResults.initLifeResults();
			},
			onBeforeEnter: function enterResultsStep(event) {
				Results.removeSelectedProduct();
				// Always force it to be a "Load" in Life, as currently, we always get a new tranid.
				meerkat.modules.resultsTracking.setResultsEventMode('Load');
				$('#resultsPage').addClass('hidden');
			},
			onAfterEnter: function afterEnterResults(event) {
				if (event.isForward === true) {
					meerkat.modules.lifeResults.get();
				}
			}
		};

		var confirmationStep = {
			title: 'Confirmation',
			navigationId: 'apply',
			slideIndex: 5,
			onInitialise: function onInitApplyStep(event) {

			}
		};

		steps = {
			startStep: startStep,
			aboutYouStep: aboutYouStep,
			aboutPartnerStep: aboutPartnerStep,
			contactStep: contactStep,
			resultsStep: resultsStep,
			confirmationStep: confirmationStep
		};
	}

	function configureProgressBar() {
		meerkat.modules.journeyProgressBar.configure([
			{
				label: 'Life Insurance Details',
				navigationId: steps.startStep.navigationId
			},
			{
				label: 'About You',
				navigationId: steps.aboutYouStep.navigationId
			},
			{
				label: 'About Your Partner',
				navigationId: steps.aboutPartnerStep.navigationId
			},
			{
				label: 'Contact Details',
				navigationId: steps.contactStep.navigationId
			},
			{
				label: 'Your Quotes',
				navigationId: steps.resultsStep.navigationId
			}
		]);
	}

	// Build an object to be sent by SuperTag tracking.
	function getTrackingFieldsObject(){
		try{

			var transactionId = meerkat.modules.transactionId.get();

			var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
			var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

			var actionStep='';
			switch(current_step) {
				case 0:
					actionStep = "life insurance details";
					break;
				case 1:
					actionStep = "life about you";
					break;
				case 2:
					actionStep = "life about your partner";
					break;
				case 3:
					actionStep = "life contact details";
					break;
				case 4:
					actionStep = "life results";
					break;
			}

			var gender = $('input[name=life_primary_gender]:checked', '#mainform') && $('input[name=life_primary_gender]:checked', '#mainform').val() === "M" ? 'Male' : 'Female',
			yob = $("#life_primary_dob").val().length ? $("#life_primary_dob").val().split("/")[2] : "",
			postcode =      $("#life_primary_postCode").val(),
			state =         $("#life_primary_state").val(),
			email =         $("#life_contactDetails_email").val();

			var response =  {
				vertical:				meerkat.site.vertical,
				actionStep:				actionStep,
				transactionID:			transactionId,
				quoteReferenceNumber:	transactionId
			};

			// Push in values from 1st slide only when have been beyond it
			if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
				_.extend(response, {
					yearOfBirth: yob
				});
			}

			// Push in values from 2nd slide only when have been beyond it
			if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('about')) {
				_.extend(response, {
					gender: gender
				});
			}

			// Push in values from 2nd slide only when have been beyond it
			if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('contact')) {
				_.extend(response, {
					email: email,
					postCode: postcode,
					state: state
				});
			}

			return response;

		}catch(e){
			return false;
		}
	}

	meerkat.modules.register("life", {
		init: initLife,
		events: moduleEvents,
		initProgressBar: initProgressBar,
		getTrackingFieldsObject: getTrackingFieldsObject
	});

})(jQuery);