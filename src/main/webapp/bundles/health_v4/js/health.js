/**
 * Description: Health setup
 */
;(function ($, undefined) {


    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var moduleEvents = {
        health: {
            SNAPSHOT_FIELDS_CHANGE:'SNAPSHOT_FIELDS_CHANGE'
        },
        WEBAPP_LOCK: 'WEBAPP_LOCK',
        WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
    }, steps = null;

    function initHealth() {

        $(document).ready(function () {

            if (meerkat.site.vertical !== "health") return false;

            // Only continue if not confirmation page.
            if (meerkat.site.pageAction === "confirmation") {
                meerkat.modules.journeyEngine.configure(null);
                return false;
            } else {
                initJourneyEngine();
            }

            _enableLiveChat();

            eventSubscriptions();
            applyEventListeners();

            configureContactDetails();

            if (_.indexOf(['amend', 'latest', 'load', 'start-again'], meerkat.site.pageAction) >= 0) {

                // If retrieving a quote and a product had been selected, inject the fund's application set.
                if (meerkat.modules.healthFunds.checkIfNeedToInjectOnAmend) {
                    meerkat.modules.healthFunds.checkIfNeedToInjectOnAmend(function onLoadedAmeded() {
                        // Need to mark any populated field with a data attribute so it is picked up with by the journeyEngine.getFormData()
                        // This is because values from forward steps will not be selected and will be lost when the quote is re-saved.
                        meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
                    });
                } else {
                    meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
                }
            }

            _postInitialisation();

        });
    }

    function _postInitialisation() {

        if ($('input[name="health_directApplication"]').val() === 'Y') {
            $('#health_application_productId').val(meerkat.site.loadProductId);
            $('#health_application_productTitle').val(meerkat.site.loadProductTitle);
        }

        if (meerkat.site.isCallCentreUser === true) {
            meerkat.modules.simplesSnapshot.initSimplesSnapshot();
        }

        if(meerkat.site.isCallCentreUser === false) {
            meerkat.modules.saveQuote.initSaveQuote();
        }
    }

    function eventSubscriptions() {

        // @todo this belongs in health Apply Step logic.
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockHealth(obj) {
            var isSameSource = (typeof obj !== 'undefined' && obj.source && obj.source === 'submitApplication');
            meerkat.modules.healthSubmitApplication.disableSubmitApplication(isSameSource);
        });
        // @todo this belongs in health Apply Step logic.
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockHealth(obj) {
            meerkat.modules.healthSubmitApplication.enableSubmitApplication();
        });

    }

    function applyEventListeners() {
        // @todo review this once new content is in.
        $("#health_contactDetails_optin").on("click", function () {
            var optinVal = $(this).is(":checked") ? "Y" : "N";
            $('#health_privacyoptin').val(optinVal);
            $("#health_contactDetails_optInEmail").val(optinVal);
            $("#health_contactDetails_call").val(optinVal);
        });
    }


    function _enableLiveChat() {
        // Online user, check if livechat is active and needs to show a button
        if (meerkat.site.isCallCentreUser === false) {
            setInterval(function () {
                var content = $('#chat-health-insurance-sales').html();
                if (content === "" || content === "<span></span>") {
                    $('#contact-panel').removeClass("hasButton");
                } else {
                    $('#contact-panel').addClass("hasButton");
                }
            }, 5000);
        }
    }

    function initJourneyEngine() {

        // Initialise the journey engine steps and bar
        initProgressBar(false);

        // Initialise the journey engine
        var startStepId = null;
        if (meerkat.site.isFromBrochureSite === true) {
            startStepId = steps.startStep.navigationId;
        // Use the stage user was on when saving their quote
        } else if (meerkat.site.journeyStage.length > 0 && _.indexOf(['amend', 'latest'], meerkat.site.pageAction) >= 0) {
            // Do not allow the user to go past the results page on amend.
            if (meerkat.site.journeyStage === 'apply' || meerkat.site.journeyStage === 'payment') {
                startStepId = 'results';
            } else {
                startStepId = meerkat.site.journeyStage;
            }
        }

        var configureJourneyEngine = _.bind(meerkat.modules.journeyEngine.configure, this, {
            startStepId: startStepId,
            steps: _.toArray(steps)
        });
        // Allow time for journey to be fully populated/rendered when loading an existing quote
        _.delay(configureJourneyEngine, meerkat.site.isNewQuote === false ? 750 : 0);

        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackQuoteEvent',
            object: {
                action: 'Start',
                simplesUser: meerkat.site.isCallCentreUser
            }
        });

        if (meerkat.site.isNewQuote === false) {
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackQuoteEvent',
                object: {
                    action: 'Retrieve',
                    simplesUser: meerkat.site.isCallCentreUser
                }
            });
        }
    }


    /**
     * Initialise and configure the progress bar.
     * @param {bool} render
     */
    function initProgressBar(render) {
        setJourneyEngineSteps();
        configureProgressBar(true);
        if (render) {
            meerkat.modules.journeyProgressBar.render(true);
        }
    }

    function setJourneyEngineSteps() {

        var startStep = {
            title: 'Your Details',
            navigationId: 'start',
            slideIndex: 0,
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            onInitialise: function onStartInit(event) {
                meerkat.modules.jqueryValidate.initJourneyValidator();

                meerkat.modules.healthLocation.initHealthLocation();
                meerkat.modules.healthPostcode.initPostcode();

                meerkat.modules.fieldUtilities.initFields();

                if (meerkat.site.choices) {
                    meerkat.modules.healthChoices.initialise($('input[name=health_situation_healthCvr]:checked').val());
                    meerkat.modules.healthChoices.setState(meerkat.site.choices.state);
                    meerkat.modules.healthChoices.shouldPerformUpdate(meerkat.site.choices.performHealthChoicesUpdate);
                }
                meerkat.modules.healthRebate.toggleRebateQuestions();
            },
            onBeforeEnter: function enterStartStep(event) {
                if (event.isForward) {
                    // Delay 1 sec to make sure we have the data bucket saved in to DB, then filter coupon
                    _.delay(function () {
                        // coupon logic, filter for user, then render banner
                        meerkat.modules.coupon.loadCoupon('filter', null, function successCallBack() {
                            meerkat.modules.coupon.renderCouponBanner();
                        });
                    }, 1000);
                }
                _incrementTranIdBeforeEnteringSlide();

                // configure progress bar
                configureProgressBar(true);
            },
            onAfterEnter: function healthAfterEnter() {

            },
            onBeforeLeave: function (event) {
                meerkat.modules.healthTiers.setIncomeLabel();
            }

        };

        var benefitsStep = {
            title: 'Your Cover',
            navigationId: 'benefits',
            slideIndex: 1,
            tracking: {
                touchType: 'H',
                touchComment: 'HLT benefi',
                includeFormData: true
            },
            validation: {
                validate: true
            },
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            onBeforeEnter: function enterBenefitsStep(event) {
                // configure progress bar
                configureProgressBar(true);
                if (event.isForward) {
                    // Delay 1 sec to make sure we have the data bucket saved in to DB, then filter coupon
                    _.delay(function () {
                        // coupon logic, filter for user, then render banner
                        meerkat.modules.coupon.loadCoupon('filter', null, function successCallBack() {
                            meerkat.modules.coupon.renderCouponBanner();
                        });
                    }, 1000);
                }
                _incrementTranIdBeforeEnteringSlide();
            },
            onAfterEnter: function enterBenefitsStep(event) {
                // Note: Not sure if this will be introduced back in a later date
                // var toggleBarInitSettings = {
                //     container: 'body[data-step="benefits"]',
                //     currentStep: steps.benefitsStep.navigationId
                // };
                //
                // meerkat.modules.benefitsToggleBar.initToggleBar(toggleBarInitSettings);
            },
            onAfterLeave: function leaveBenefitsStep(event) {
                var selectedBenefits = meerkat.modules.benefitsModel.getSelectedBenefits();
                meerkat.modules.healthResultsChange.onBenefitsSelectionChange(selectedBenefits);
                // Note: Not sure if this will be introduced back in a later date
                // meerkat.modules.benefitsToggleBar.deRegisterScroll();
                if(meerkat.modules.benefits.getHospitalType() == 'limited') {
                    meerkat.modules.benefitsModel.setIsHospital(true);
                    meerkat.modules.benefitsModel.setBenefits([]);
                }
            }
        };

        var contactStep = {
            title: 'Your Contact Details',
            navigationId: 'contact',
            slideIndex: 2,
            tracking: {
                touchType: 'H',
                touchComment: 'HLT contac',
                includeFormData: true
            },
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            validation: {
                validate: true
            },
            onInitialise: function onContactInit(event) {
                meerkat.modules.resultsFeatures.fetchStructure('health_v4');
            },
            onBeforeEnter: function enterContactStep(event) {
                // configure progress bar
                configureProgressBar(true);

                if (event.isForward) {
                    // Delay 1 sec to make sure we have the data bucket saved in to DB, then filter coupon
                    _.delay(function () {
                        // coupon logic, filter for user, then render banner
                        meerkat.modules.coupon.loadCoupon('filter', null, function successCallBack() {
                            meerkat.modules.coupon.renderCouponBanner();
                        });
                    }, 1000);
                }
                _incrementTranIdBeforeEnteringSlide();

            },
            onAfterEnter: function afterEnterContactStep(event) {
                meerkat.modules.coupon.dealWithAddedCouponHeight();
            },
            onAfterEnter: function afterEnterContactStep(event) {
                meerkat.modules.coupon.dealWithAddedCouponHeight();
            },
            onAfterLeave: function leaveContactStep(event) {

            }
        };

        var resultsStep = {
            title: 'Your Results',
            navigationId: 'results',
            slideIndex: 3,
            validation: {
                validate: false,
                customValidation: function validateSelection(callback) {

                    if (meerkat.site.isCallCentreUser === true) {
                        // Check mandatory dialog have been ticked
                        var $_exacts = $('.resultsSlide').find('.simples-dialogue.mandatory:visible');
                        if ($_exacts.length != $_exacts.find('input:checked').length) {
                            meerkat.modules.dialogs.show({
                                htmlContent: 'Please complete the mandatory dialogue prompts before applying.'
                            });
                            callback(false);
                        }
                    }

                    if (meerkat.modules.healthResults.getSelectedProduct() === null) {
                        callback(false);
                    }

                    callback(true);
                }
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.healthResults.initPage();
                meerkat.modules.healthMoreInfo.initMoreInfo();
                meerkat.modules.healthPriceComponent.initHealthPriceComponent();
                meerkat.modules.healthDualPricing.initDualPricing();
                meerkat.modules.healthPyrrCampaign.initPyrrCampaign();
                meerkat.modules.healthResultsRefineMobile.initHealthResultsRefineMobile();
            },
            onBeforeEnter: function enterResultsStep(event) {
                meerkat.modules.healthDependants.resetConfig();
                if (event.isForward && meerkat.site.isCallCentreUser) {
                    $('#journeyEngineSlidesContainer .journeyEngineSlide')
                        .eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).find('.simples-dialogue').show();
                } else {
                    // Reset selected product. (should not be inside a forward or backward condition because users can skip steps backwards)
                    meerkat.modules.healthResults.resetSelectedProduct();
                }
                meerkat.messaging.publish(meerkatEvents.filters.FILTERS_CANCELLED);
            },
            onAfterEnter: function onAfterEnterResultsStep(event) {
                if (event.isForward === true) {
                    meerkat.modules.healthResults.getBeforeResultsPage();
                }

                if (meerkat.modules.healthTaxTime.isFastTrack()) {
                    meerkat.modules.healthTaxTime.disableFastTrack();
                }
                meerkat.modules.healthResults.setCallCentreText();

            },
            onBeforeLeave: function beforeLeaveResultsStep(event) {
                // Increment the transactionId
                if (event.isBackward === true) {
                    meerkat.modules.transactionId.getNew(3);
                }

                meerkat.modules.healthResults.resetCallCentreText();
            }
        };

        var applyStep = {
            title: 'Your Application',
            navigationId: 'apply',
            slideIndex: 4,
            tracking: {
                touchType: 'A'
            },
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            onInitialise: function onApplyInit(event) {
                meerkat.modules.healthDependants.initHealthDependants();
                meerkat.modules.healthMedicare.initHealthMedicare();
                meerkat.modules.healthApplyStep.onInitialise();
            },
            onBeforeEnter: function beforeEnterApplyStep(event) {
                meerkat.modules.benefitsToggleBar.deRegisterScroll();
                if (event.isForward === true) {
                    var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();

                    // configure progress bar
                    configureProgressBar(false);

                    // Show warning if applicable
                    meerkat.modules.healthFunds.toggleWarning($('#health_application-warning'));

                    this.tracking.touchComment =  selectedProduct.info.provider + ' ' + selectedProduct.info.des;
                    this.tracking.productId = selectedProduct.productId.replace("PHIO-HEALTH-", "");

                    // Load the selected product details.
                    meerkat.modules.healthFunds.load(selectedProduct.info.provider);

                    // Clear any previous validation errors on Apply or Payment
                    var $slide = $('#journeyEngineSlidesContainer .journeyEngineSlide').slice(meerkat.modules.journeyEngine.getCurrentStepIndex() - 1);
                    $slide.find('.error-field').remove();
                    $slide.find('.has-error').removeClass('has-error');

                    // Unset the Health Declaration checkbox (could be refactored to only uncheck if the fund changes)
                    $('#health_declaration input:checked').prop('checked', false).change();

                    meerkat.modules.healthApplyStep.onBeforeEnter();
                    meerkat.modules.healthDependants.updateDependantConfiguration();
                    meerkat.modules.healthMedicare.onBeforeEnterApply();
                }
            },
            onAfterEnter: function afterEnterApplyStep(event) {
                meerkat.modules.coupon.dealWithAddedCouponHeight();
            }
        };

        var paymentStep = {
            title: 'Your Payment',
            navigationId: 'payment',
            slideIndex: 5,
            tracking: {
                touchType: 'H',
                touchComment: 'HLT paymnt',
                includeFormData: true
            },
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            onInitialise: function onPaymentInit(event) {
                meerkat.modules.healthPaymentDate.initPaymentDate();
                meerkat.modules.healthPaymentIPP.initHealthPaymentIPP();
                meerkat.modules.healthSubmitApplication.initHealthSubmitApplication();
            },
            onBeforeEnter: function beforeEnterPaymentStep(event) {

                if (event.isForward === true) {
                    var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();

                    meerkat.modules.healthPaymentStep.rebindCreditCardRules();

                    // Show warning if applicable
                    meerkat.modules.healthFunds.toggleWarning($('#health_payment_details-selection'));

                    // Insert fund into checkbox label
                    $('#mainform').find('.health_declaration span').text( selectedProduct.info.providerName  );
                    // Insert fund into Contact Authority
                    $('#mainform').find('.health_contact_authority span').text( selectedProduct.info.providerName  );

                    meerkat.modules.healthPaymentStep.updatePremium();
                }
            },
            onAfterEnter: function afterEnterPaymentStep() {
                meerkat.modules.coupon.dealWithAddedCouponHeight();
            }
        };

        steps = {
            startStep: startStep,
            benefitsStep: benefitsStep,
            contactStep: contactStep,
            resultsStep: resultsStep,
            applyStep: applyStep,
            paymentStep: paymentStep
        };

    }

    // @todo review this during progress bar refactor
    function configureProgressBar(isJourney) {
        var phase = isJourney ? 'journey' : 'application',
            progressBarSteps = {
                journey: [
                    {
                        label: 'About you',
                        navigationId: steps.startStep.navigationId
                    },
                    {
                        label: '<span class="hidden-sm hidden-md hidden-lg">Preferences</span><span class="hidden-xs">Insurance preferences</span>',
                        navigationId: steps.benefitsStep.navigationId
                    },
                    {
                        label: 'Contact details',
                        navigationId: steps.contactStep.navigationId
                    }
                ],
                application: [
                    {
                        label: 'Application',
                        navigationId: steps.applyStep.navigationId
                    },
                    {
                        label: 'Payment',
                        navigationId: steps.paymentStep.navigationId
                    },
                    {
                        label: 'Thank You'
                    }
                ]
            };

        // Better progressBar just works...
        meerkat.modules.journeyProgressBar.changeTargetElement('.journeyProgressBar[data-phase='+phase+']');
        meerkat.modules.journeyProgressBar.configure(progressBarSteps[phase]);
    }


    function configureContactDetails() {
        var contactDetailsOptinField = $("#health_contactDetails_optin");

        // define fields here that are multiple (i.e. email field on contact details and on application step) so that they get prefilled
        // or fields that need to publish an event when their value gets changed so that another module can pick it up
        // the category names are generally arbitrary but some are used specifically and should use those types (email, name, potentially phone in the future)
        var contactDetailsFields = {
            name:[
                {
                    $field: $("#health_contactDetails_name")
                },
                {
                    $field: $("#health_callback_name"),
                    $fieldInput: $("#health_callback_name")
                },
                {
                    $field: $("#health_application_primary_firstname"),
                    $otherField: $("#health_application_primary_surname")
                }
            ],
            dob_primary:[
                {
                    $field: $("#health_healthCover_primary_dob"), // this is a hidden field
                    $fieldInput: $("#health_healthCover_primary_dob") // pointing at the same field as a trick to force change event on itself when forward populated
                },
                {
                    $field: $("#health_application_primary_dob"), // this is a hidden field
                    $fieldInput: $("#health_application_primary_dob") // pointing at the same field as a trick to force change event on itself when forward populated
                }
            ],
            dob_secondary:[
                {
                    $field: $("#health_healthCover_partner_dob"), // this is a hidden field
                    $fieldInput: $("#health_healthCover_partner_dob") // pointing at the same field as a trick to force change event on itself when forward populated
                },
                {
                    $field: $("#health_application_partner_dob"), // this is a hidden field
                    $fieldInput: $("#health_application_partner_dob") // pointing at the same field as a trick to force change event on itself when forward populated
                }
            ],
            email: [
                // email from details step
                {
                    $field: $("#health_contactDetails_email"),
                    $optInField: contactDetailsOptinField
                },
                // email from application step
                {
                    $field: $("#health_application_email"),
                    $optInField: $("#health_application_optInEmail")
                }
            ],
            mobile: [
                // mobile from details step
                {
                    $field: $("#health_contactDetails_contactNumber_mobileinput"),
                    $optInField: contactDetailsOptinField
                },
                // mobile from application step
                {
                    $field: $("#health_application_mobile"),
                    $fieldInput: $("#health_application_mobileinput")
                },
                // callback popup
                {
                    $field: $("#health_callback_mobileinput"),
                    $fieldInput: $("#health_callback_mobileinput")
                }
            ],
            otherPhone: [
                // otherPhone from details step
                {
                    $field: $("#health_contactDetails_contactNumber_otherinput"),
                    $optInField: contactDetailsOptinField
                },
                // otherPhone from application step
                {
                    $field: $("#health_application_other"),
                    $fieldInput: $("#health_application_otherinput")
                }
            ],
            postcode: [
                // postcode from details step
                { $field: $("#health_situation_postcode") },
                //postcode from application step
                {
                    $field: $("#health_application_address_postCode"),
                    $fieldInput: $("#health_application_address_postCode")
                }
            ]
        };

        meerkat.modules.contactDetails.configure(contactDetailsFields);
    }

    // @todo: review this during form revamp.
    function getTrackingFieldsObject() {
        try {
            var state = $("#health_situation_state").val();
            var state2 = $("#health_application_address_state").val();
            // Set state to application state if provided and is different
            if (state2.length && state2 != state) {
                state = state2;
            }

            var gender = null;
            var $gender = $('input[name=health_application_primary_gender]:checked');
            if ($gender) {
                if ($gender.val() == "M") {
                    gender = "Male";
                } else if ($gender.val() == "F") {
                    gender = "Female";
                }
            }

            var yob = "";
            var yob_str = $("#health_healthCover_primary_dob").val();
            if (yob_str.length) {
                yob = yob_str.split("/")[2];
            }

            var ok_to_call = $('input[name=health_contactDetails_call]', '#mainform').val() === "Y" ? "Y" : "N";
            var mkt_opt_in = $('input[name=health_application_optInEmail]:checked', '#mainform').val() === "Y" ? "Y" : "N";

            var email = $("#health_contactDetails_email").val();
            var email2 = $("#health_application_email").val();
            // Set email to application email if provided and is different
            if (email2.length > 0) {
                email = email2;
            }

            var transactionId = meerkat.modules.transactionId.get();

            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furtherest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

            //@TODO @FIXME - In the review with Rebecca, Tim, Kevin, on 24th of Feb 2014, it's likely that this lookup table wont be required anymore, and we can pass through the name of the journey engine step directly.
            //Update 1: Looks like nobody really knows or considered which calls are required. Also, the current code is basically magical (not understood), so without further review of what they want, the original stages will be logged. Hence this mapping here is still required. The livechat stats will still report the exact journey step names instead. Eg. the below mappings could be replaced by 'start', 'details', 'benefits', 'results', 'apply', 'payment', 'confirmation'.
            var actionStep = '';

            switch (current_step) {
                case 0:
                    actionStep = "health situation";
                    break;
                case 1:
                    actionStep = 'health benefits';
                    break;
                case 2:
                    actionStep = 'health contact';
                    break;
                case 4:
                    actionStep = 'health application';
                    break;
                case 5:
                    actionStep = 'health payment';
                    break;
                case 6:
                    actionStep = 'health confirmation';
                    break;
            }

            var response = {
                vertical: 'Health',
                actionStep: actionStep,
                transactionID: transactionId,
                quoteReferenceNumber: transactionId,
                postCode: null,
                state: null,
                healthCoverType: null,
                healthSituation: null,
                gender: null,
                yearOfBirth: null,
                email: null,
                emailID: null,
                marketOptIn: null,
                okToCall: null,
                contactType: null,
                simplesUser: meerkat.site.isCallCentreUser
            };

            // Push in values from 1st slide only when have been beyond it
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
                var contactType = null;
                if ($('#health_simples_contactType_inbound').is(':checked')) {
                    contactType = 'inbound';
                } else if ($('#health_simples_contactType_outbound').is(':checked')) {
                    contactType = 'outbound';
                }

                $.extend(response, {
                    postCode: $("#health_application_address_postCode").val(),
                    state: state,
                    healthCoverType: meerkat.modules.healthSituation.getSituation(),
                    contactType: contactType
                });
            }

            // Push in values from 2nd slide only when have been beyond it
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('details')) {
                $.extend(response, {
                    yearOfBirth: yob,
                    email: email,
                    marketOptIn: mkt_opt_in,
                    okToCall: ok_to_call
                });
            }

            // Push in values from 2nd slide only when have been beyond it
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('apply')) {
                $.extend(response, { gender: gender });
            }

            return response;

        } catch (e) {
            return false;
        }
    }


    /**
     * incrementTranIdBeforeEnteringSlide() increment tranId when previous step
     * was in the application phase of the journey. To be called onBeforeEnter
     * method of questionset steps (current step is the previous step index).
     */
    function _incrementTranIdBeforeEnteringSlide() {
        if (meerkat.modules.journeyEngine.getCurrentStepIndex() > 3) {
            meerkat.modules.transactionId.getNew(3);
        }
    }

    meerkat.modules.register("health", {
        init: initHealth,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject
    });


})(jQuery);