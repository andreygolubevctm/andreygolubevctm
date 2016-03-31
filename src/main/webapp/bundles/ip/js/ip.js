;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		moduleEvents = {
			ip: {

			},
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
		},
		steps = null;

    function initIP() {
        $(document).ready(function() {
            // Only init if ip
            if (meerkat.site.vertical !== "ip")
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
		configureProgressBar();

		if(render){
			meerkat.modules.journeyProgressBar.render(true);
		}
	}

	function setJourneyEngineSteps(){
		var startStep = {
			title: 'IP Insurance Details',
			navigationId: 'start',
			slideIndex:0,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.ip.getTrackingFieldsObject
			},
			onInitialise: function onStartInit(event){
				meerkat.modules.jqueryValidate.initJourneyValidator();
			}, onBeforeLeave: function onInsuranceDetailsLeave() {
				var $coverForRadioVal = $('input[name="ip_primary_insurance_partner"]:checked');
				meerkat.modules.ipPartner.togglePartnerFields($coverForRadioVal.val() === 'Y');
			}
		};

		var aboutYouStep = {
			title: 'About You',
			navigationId: 'about',
			slideIndex:1,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.ip.getTrackingFieldsObject
			},
			onInitialise:function onDetailsInit(event){
				meerkat.modules.occupationSelector.initOccupationSelector();
			}
		};

		var aboutPartnerStep = {
			title: 'About your partner',
			navigationId: 'partner',
			slideIndex: 2,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.ip.getTrackingFieldsObject
			},
			onInitialise: function aboutPartnerInit(event){
				meerkat.modules.occupationSelector.initOccupationSelector();
			},
			onAfterEnter: function aboutPartnerBeforeEnter(event){
				meerkat.modules.ipPartner.toggleSkipToResults();
			}
		};
		var contactStep = {
			title: 'Contact Details',
			navigationId: 'contact',
			slideIndex: 3,
			externalTracking:{
				method:'trackQuoteForms',
				object:meerkat.modules.ip.getTrackingFieldsObject
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
				object:meerkat.modules.ip.getTrackingFieldsObject
			},
			onInitialise: function onInitResults(event){
				meerkat.modules.ipResults.initIPResults();
			},
			onBeforeEnter: function enterResultsStep(event) {
				Results.removeSelectedProduct();
				// Always force it to be a "Load" in IP, as currently, we always get a new tranid.
				meerkat.modules.resultsTracking.setResultsEventMode('Load');
				$('#resultsPage').addClass('hidden');
			},
			onAfterEnter: function afterEnterResults(event) {
				if (event.isForward === true) {
					meerkat.modules.ipResults.get();
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
				label: 'IP Insurance Details',
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
					actionStep = "ip insurance details";
					break;
				case 1:
					actionStep = "ip about you";
					break;
				case 2:
					actionStep = "ip about your partner";
					break;
				case 3:
					actionStep = "ip contact details";
					break;
				case 4:
					actionStep = "ip results";
					break;
			}

			var gender = $('input[name=ip_primary_gender]:checked', '#mainform') && $('input[name=ip_primary_gender]:checked', '#mainform').val() === "M" ? 'Male' : 'Female',
			yob = $("#ip_primary_dob").val().length ? $("#ip_primary_dob").val().split("/")[2] : "",
			postcode =      $("#ip_primary_postCode").val(),
			state =         $("#ip_primary_state").val(),
			email =         $("#ip_contactDetails_email").val();

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

	meerkat.modules.register("ip", {
		init: initIP,
		events: moduleEvents,
		initProgressBar: initProgressBar,
		getTrackingFieldsObject: getTrackingFieldsObject
	});

})(jQuery);