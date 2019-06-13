;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        exception = meerkat.logging.exception,
        moduleEvents = {
            health: {
                CHANGE_MAY_AFFECT_PREMIUM: 'CHANGE_MAY_AFFECT_PREMIUM',
                SNAPSHOT_FIELDS_CHANGE: 'SNAPSHOT_FIELDS_CHANGE'
            },
            WEBAPP_LOCK: 'WEBAPP_LOCK',
            WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
        },
        hasSeenResultsScreen = false,
        rates = null,
        steps = null,
        stateSubmitInProgress = false;

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
            else if (meerkat.site.journeyStage.length > 0 && _.indexOf(['amend', 'latest'], meerkat.site.pageAction) >= 0) {
                // Do not allow the user to go past the results page on amend.
                if (meerkat.site.journeyStage === 'apply' || meerkat.site.journeyStage === 'payment') {
                    startStepId = 'results';
                } else {
                    startStepId = meerkat.site.journeyStage;
                }
            }

            var journeyEngineConfigure = _.bind(meerkat.modules.journeyEngine.configure, this, {
                startStepId: startStepId,
                steps: _.toArray(steps)
            });

            if (meerkat.site.isNewQuote === false) {
                _.delay(journeyEngineConfigure, 500);
            } else {
                journeyEngineConfigure();
            }

            // Call initial supertag call
            var transaction_id = meerkat.modules.transactionId.get();

            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackQuoteEvent',
                object: {
                    action: 'Start',
                    transactionID: parseInt(transaction_id, 10),
                    simplesUser: meerkat.site.isCallCentreUser
                }
            });

            if (meerkat.site.isNewQuote === false) {
                meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                    method: 'trackQuoteEvent',
                    object: {
                        action: 'Retrieve',
                        transactionID: transaction_id,
                        simplesUser: meerkat.site.isCallCentreUser
                    }
                });
            }

        }
    }

    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockHealth(obj) {
            var isSameSource = (typeof obj !== 'undefined' && obj.source && obj.source === 'submitApplication');
            disableSubmitApplication(isSameSource);
        });

        meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockHealth(obj) {
            enableSubmitApplication();
        });

        $('#health_application-selection').delegate('.changeStateAndQuote', 'click', changeStateAndQuote);

    }

    function initProgressBar(render) {

        setJourneyEngineSteps();
        configureProgressBar();
        if (render) {
            meerkat.modules.journeyProgressBar.render(true);
        }
    }

    /* This is a temporary function for the split test by altering the layout. */
    function adjustLayout() {
        var $mainform = $('#mainform');
        $mainform.find('.col-sm-8')
            .not('.short-list-item')
            .not('.nestedGroup .col-sm-8')
            .not('.results-column-container')
            .not('.no-column-medling')
            .removeClass('col-sm-8').addClass('col-sm-9');
        $mainform.find('.col-sm-offset-4')
            .not('#applicationForm_1 .col-sm-offset-4')
            .not('#applicationForm_2 .col-sm-offset-4')
            .removeClass('col-sm-offset-4').addClass('col-sm-offset-3');
    }

    /**
     * incrementTranIdBeforeEnteringSlide() increment tranId when previous step
     * was in the application phase of the journey. To be called onBeforeEnter
     * method of questionset steps (current step is the previous step index).
     */
    function incrementTranIdBeforeEnteringSlide() {
        if (meerkat.modules.journeyEngine.getCurrentStepIndex() > 3) {
            meerkat.modules.transactionId.getNew(3);
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

                if (meerkat.site.choices) {
                    meerkat.modules.healthChoices.initialise(meerkat.site.choices.cover, meerkat.site.choices.situation, meerkat.site.choices.benefits);
                    meerkat.modules.healthChoices.setState(meerkat.site.choices.state);
                    meerkat.modules.healthChoices.shouldPerformUpdate(meerkat.site.choices.performHealthChoicesUpdate);
                }

                var $healthSitLocation = $('#health_situation_location'),
                    $healthSitHealthCvr = $('#health_situation_healthCvr'),
                    $healthSitHealthSitu = $("input[name=health_situation_healthSitu]"),
                    $healthSitCoverType = $('#health_situation_coverType'),
                    $healthSitRebate = $('#health_healthCover_health_cover_rebate');

                // Add event listeners.
                $healthSitHealthCvr.on('change', function () {
                    meerkat.modules.healthChoices.setCover($(this).val());
                    meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
                });

                // we need to wait till the field gets proparly populated from the address search ajax
                $healthSitLocation.on('change', function () {
                    setTimeout(function () {
                        meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
                    }, 250);

                });

                $healthSitHealthSitu.on('change', function () {
                    meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
                });

                $healthSitLocation.on('blur', function () {
                    meerkat.modules.healthChoices.setLocation($(this).val());
                });

                // For loading in.
                if ($healthSitLocation.val() !== '') {
                    meerkat.modules.healthChoices.setLocation($healthSitLocation.val());
                }

                // change benefits page layout when change the coverType
                $healthSitCoverType.on('change', function () {
                    var coverTypeVal = $(this).find('input:checked').val();
                    meerkat.modules.healthBenefitsStep.updateHiddenFields(coverTypeVal);
                });

                if ($("#health_privacyoptin").val() === 'Y') {
                    $(".slide-feature-emailquote").addClass("privacyOptinChecked");
                }

                // Don't fire the change event by default if amend mode and the user has selected items.
                if (_.indexOf(['amend', 'latest'], meerkat.site.pageAction) === -1 && meerkat.site.pageAction !== 'start-again' && meerkat.modules.healthBenefitsStep.getSelectedBenefits().length === 0) {
                    if ($healthSitHealthSitu.filter(":checked").val() !== '') {
                        $healthSitHealthSitu.change();
                    }
                }

                // This on Start step instead of Details because Simples interacts with it
                var emailQuoteBtn = $(".slide-feature-emailquote");
                $(".health-contact-details-optin-group .checkbox").on("click", function (event) {
                    var $this = $("#health_privacyoptin");
                    if ($this.val() === 'Y') {
                        emailQuoteBtn.addClass("privacyOptinChecked");
                    } else {
                        emailQuoteBtn.removeClass("privacyOptinChecked");
                    }
                });

                if (meerkat.site.isCallCentreUser === true) {
                    // Handle pre-filled
                    toggleInboundOutbound();
                    toggleDialogueInChatCallback();
                    meerkat.modules.provider_testing.setApplicationDateCalendar();

                    // Handle toggle inbound/outbound
                    $('input[name=health_simples_contactType]').on('change', function () {
                        toggleInboundOutbound();
                    });

                    $('.follow-up-call input:checkbox, .simples-privacycheck-statement input:checkbox').on('change', function () {
                        toggleDialogueInChatCallback();
                    });
                }

                $healthSitRebate.on('change', function () {
                    toggleRebate();
                });
                toggleRebate();


            },
            onBeforeEnter: incrementTranIdBeforeEnteringSlide,
            onAfterEnter: function healthV2AfterEnter() {
                // if coming from brochure site and all prefilled data are valid, let's hide the fields
                toggleAboutYou();

                if (meerkat.modules.healthTaxTime.isFastTrack()) {
                    meerkat.modules.healthTaxTime.disableNewQuestion(false);
                }
            },
            onBeforeLeave: function (event) {
                meerkat.modules.healthTaxTime.disableNewQuestion(true);
                meerkat.modules.healthTiersLabel.setIncomeLabel();
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
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.health.getTrackingFieldsObject
            },
            validation: {
                validate: true
            },
            onInitialise: function onResultsInit(event) {
                meerkat.modules.healthResults.initPage();

                var $healthSitCoverType = $('#health_situation_coverType');
                var $hospitalBenefits = $('.Hospital_container  input:checkbox');
                var $extraBenefits = $('.GeneralHealth_container input:checkbox');

                $healthSitCoverType.on('change', function (event) {
                    meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
                });

                $hospitalBenefits.click(function () {
                    meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
                });
                $extraBenefits.click(function () {
                    meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
                });

            },
            onBeforeEnter: function enterBenefitsStep(event) {
                meerkat.modules.healthBenefitsStep.disableFields();
                meerkat.modules.healthBenefitsStep.applySituationBasedCopy();
                meerkat.modules.healthBenefitsStep.activateBenefitPreSelections(event.isForward);
                incrementTranIdBeforeEnteringSlide();
            },
            onAfterEnter: function (event) {
                // Delay 1 sec to make sure we have the data bucket saved in to DB, then filter segment
                //_.delay(function() {
                //	meerkat.modules.healthSegment.filterSegments();
                //}, 1000);

                if (event.isForward) {
                    if (!meerkat.site.isCallCentreUser) {
                        $('input[name="health_situation_accidentOnlyCover"]').prop('checked', ($("input[name=health_situation_healthSitu]").filter(":checked").val() === 'ATP'));
                        // For CC we simply ignore and accept the current value as true and correct
                    }
                }
            },
            onAfterLeave: function (event) {
                var selectedBenefits = meerkat.modules.healthBenefitsStep.getSelectedBenefits();
                meerkat.modules.healthResultsChange.onBenefitsSelectionChange(selectedBenefits);
            },
            onBeforeLeave: function (event) {
                meerkat.modules.healthBenefitsStep.enableFields();
                meerkat.modules.healthBenefitsStep.flushHiddenBenefits();
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
                meerkat.modules.resultsFeatures.fetchStructure('health2016');
            },
            onBeforeEnter: function enterBenefitsStep(event) {
                if (event.isForward) {
                    // Delay 1 sec to make sure we have the data bucket saved in to DB, then filter coupon
                    _.delay(function () {
                        // coupon logic, filter for user, then render banner
                        meerkat.modules.coupon.loadCoupon('filter', null, function successCallBack() {
                            meerkat.modules.coupon.renderCouponBanner();
                        });
                    }, 1000);
                }
                meerkat.modules.healthAboutYou.setRabdQuestion();
                incrementTranIdBeforeEnteringSlide();
            },
            onAfterEnter: function enteredContactStep(event) {
            },
            onAfterLeave: function leaveContactStep(event) {
                /*
                 This is here because for some strange reason the benefits slide dropdown disables the tracking touch on the contact
                 slide. Manually forcing it to run so that the contact details are saved into the session and subsequently to
                 the transaction_details table.
                 */
                meerkat.messaging.publish(meerkat.modules.tracking.events.tracking.TOUCH, this);
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
            onInitialise: function onInitResults(event) {

                meerkat.modules.healthSafariColumnCountFix.initHealthSafariColumnCountFix();
                meerkat.modules.healthPriceRangeFilter.initHealthPriceRangeFilter();
                meerkat.modules.healthAltPricing.initHealthAltPricing();
                meerkat.modules.healthMoreInfo.initMoreInfo();
                meerkat.modules.healthPriceComponent.initHealthPriceComponent();
                meerkat.modules.healthDualPricing.initDualPricing();
            },
            onBeforeEnter: function enterResultsStep(event) {
                meerkat.modules.sessionCamHelper.stop();
                meerkat.modules.healthDependants.resetConfig();
                if (event.isForward && meerkat.site.isCallCentreUser) {
                    $('#journeyEngineSlidesContainer .journeyEngineSlide').eq(meerkat.modules.journeyEngine.getCurrentStepIndex()).find('.simples-dialogue').show();
                }
                if (meerkat.site.isCallCentreUser) {
                    // For Simples we need to only unload healthFund specific changes
                    meerkat.modules.healthFunds.unload();
                } else {
                    // Reset selected product. (should not be inside a forward or backward condition because users can skip steps backwards)
                    meerkat.modules.healthResults.resetSelectedProduct();
                }
            },
            onAfterEnter: function (event) {

                if (event.isForward === true) {
                    meerkat.modules.healthResults.getBeforeResultsPage();
                }

                if (meerkat.modules.healthTaxTime.isFastTrack()) {
                    meerkat.modules.healthTaxTime.disableFastTrack();
                }
                meerkat.modules.healthResults.setCallCentreText();
            },
            onBeforeLeave: function (event) {
                // Increment the transactionId
                if (event.isBackward === true) {
                    meerkat.modules.transactionId.getNew(3);
                }

                meerkat.modules.healthResults.resetCallCentreText();
            },
            onAfterLeave: function (event) {
                meerkat.modules.healthResults.recordPreviousBreakpoint();
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
            onInitialise: function onInitApplyStep(event) {

                meerkat.modules.healthDependants.initHealthDependants();
                meerkat.modules.healthMedicare.initHealthMedicare();

                if (!meerkat.modules.splitTest.isActive(18)) {
                    healthApplicationDetails.init();
                }

                // Listen to any input field which could change the premium. (on step 4 and 5)
                $(".changes-premium :input").on('change', function (event) {
                    meerkat.messaging.publish(moduleEvents.health.CHANGE_MAY_AFFECT_PREMIUM);
                });

                // Show/hide membership number and authorisation checkbox questions for previous funds.
                $('#health_previousfund_primary_fundName, #health_previousfund_partner_fundName').on('change', function () {
                    meerkat.modules.healthCoverDetails.displayHealthFunds();
                });

                // Check state selection
                $('#health_application_address_postCode, #health_application_address_streetSearch, #health_application_address_suburb').on('change', function () {
                    healthApplicationDetails.testStatesParity();
                });

                meerkat.modules.healthApplyStep.onInitialise();

            },
            onBeforeEnter: function enterApplyStep(event) {

                if (event.isForward === true) {
                    var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();

                    // Show warning if applicable
                    meerkat.modules.healthFunds.toggleWarning($('#health_application-warning'));

                    this.tracking.touchComment = selectedProduct.info.provider + ' ' + selectedProduct.info.des;
                    this.tracking.productId = selectedProduct.productId.replace("PHIO-HEALTH-", "");

                    // Load the selected product details.
                    meerkat.modules.healthFunds.load(selectedProduct.info.provider);

                    // Clear any previous validation errors on Apply or Payment
                    var $slide = $('#journeyEngineSlidesContainer .journeyEngineSlide').slice(meerkat.modules.journeyEngine.getCurrentStepIndex() - 1);
                    $slide.find('.error-field').remove();
                    $slide.find('.has-error').removeClass('has-error');

                    // Pre-populate medicare fields from previous step (TODO we need some sort of name sync module)
                    var $firstnameField = $("#health_payment_medicare_firstName");
                    var $surnameField = $("#health_payment_medicare_surname");
                    if ($firstnameField.val() === '') $firstnameField.val($("#health_application_primary_firstname").val());
                    if ($surnameField.val() === '') $surnameField.val($("#health_application_primary_surname").val());

                    // Unset the Health Declaration checkbox (could be refactored to only uncheck if the fund changes)
                    $('#health_declaration input:checked').prop('checked', false).change();

                    // Update the state of the dependants object.
                    meerkat.modules.healthDependants.updateDependantConfiguration();

                    meerkat.modules.healthApplyStep.onBeforeEnter();
                    meerkat.modules.healthMedicare.updateMedicareLabel();

                    var product = meerkat.modules.healthResults.getSelectedProduct();
                    var mustShowList = ["gmhba", "frank", "budget direct", "bupa", "hif", "qchf", "navy health", "tuh", "nib"];

	                if (!meerkat.modules.healthCoverDetails.isRebateApplied() && $.inArray(product.info.providerName.toLowerCase(), mustShowList) == -1) {
                        $("#health_payment_medicare-selection > .nestedGroup").hide().attr("style", "display:none !important");
                    } else {
                        $("#health_payment_medicare-selection > .nestedGroup").removeAttr("style");
                    }
                }
            },
            onAfterEnter: function afterEnterApplyStep(event) {

                // show edit button in policy summary side bar
                $(".policySummaryContainer").find('.footer').removeClass('hidden');

                adjustLayout();
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
            onInitialise: function initPaymentStep(event) {

                meerkat.modules.healthPaymentDate.initPaymentDate();
                meerkat.modules.healthPaymentIPP.initHealthPaymentIPP();

                $("#joinDeclarationDialog_link").on('click', function () {
                    var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();
                    var data = {};
                    data.providerId = selectedProduct.info.providerId;
                    data.providerContentTypeCode = meerkat.site.isCallCentreUser === true ? 'JDC' : 'JDO';
                    data.styleCode = meerkat.site.tracking.brandCode;

                    meerkat.modules.comms.get({
                        url: "health/provider/content/get.json",
                        data: data,
                        cache: true,
                        errorLevel: "silent",
                        onSuccess: function getProviderContentSuccess(result) {
                            if (result.hasOwnProperty('providerContentText')) {
                                meerkat.modules.dialogs.show({
                                    title: 'Declaration',
                                    htmlContent: result.providerContentText
                                });
                            }
                        }
                    });

                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method: 'trackOfferTerms',
                        object: {
                            productID: selectedProduct.productId
                        }
                    });

                });

                // Submit application button
                $("#submit_btn").on('click', function (event) {
                    var valid = meerkat.modules.journeyEngine.isCurrentStepValid();

                    // Because validation is inline we can't see them inside privacy/compliance panels.
                    if (meerkat.site.isCallCentreUser === true) {
                        $('.agg_privacy').each(function () {
                            var $this = $(this);
                            $this.find('.error-count').remove();
                            var $errors = $this.find('.error-field label');
                            $this.children('button').after('<span class="error-count' + (($errors.length > 0) ? ' error-field' : '') + '" style="margin-left:10px">' + $errors.length + ' validation errors in this panel.</span>');
                        });
                    }

                    // Validation passed, submit the application.
                    if (valid) {
                        submitApplication();
                    }
                });

            },
            onBeforeEnter: function enterPaymentStep(event) {

                if (event.isForward === true) {

                    meerkat.modules.healthPaymentStep.rebindCreditCardRules();
                    var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();

                    // Show warning if applicable
                    meerkat.modules.healthFunds.toggleWarning($('#health_payment_details-selection'));

                    // Insert fund into checkbox label
                    $('#mainform').find('.health_declaration span').text(selectedProduct.info.providerName);
                    // Insert fund into Contact Authority
                    $('#mainform').find('.health_contact_authority span').text(selectedProduct.info.providerName);

                    meerkat.modules.healthPaymentStep.updatePremium();
                }
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

    function configureProgressBar() {
        // Changing the location of the progressBar for v2 only as it needs to be moved from its default location
        meerkat.modules.journeyProgressBar.changeTargetElement(".journeyProgressBar_v2");
        var labels = {
            startStep : 'About<span class="hidden-xs"> You</span>',
            benefitStep : '<span class="hidden-xs">Your </span>Cover',
            contactStep : '<span class="hidden-xs">Your </span>Details',
            resultsStep : 'Compare<span class="hidden-xs"> Cover</span>',
            applyStep : 'Purchase<span class="hidden-xs"> Cover</span>'
        };
        var barSteps = [
            {
                label: labels.startStep,
                navigationId: steps.startStep.navigationId
            },
            {
                label: labels.benefitStep,
                navigationId: steps.benefitsStep.navigationId
            },
            {
                label: labels.contactStep,
                navigationId: steps.contactStep.navigationId
            },
            {
                label: labels.resultsStep,
                navigationId: steps.resultsStep.navigationId
            },
            {
                label: labels.applyStep,
                navigationId: steps.applyStep.navigationId
            }
        ];

        meerkat.modules.journeyProgressBar.configure(barSteps);

    }

    function configureContactDetails() {

        var contactDetailsOptinField = $("#health_contactDetails_optin");

        // define fields here that are multiple (i.e. email field on contact details and on application step) so that they get prefilled
        // or fields that need to publish an event when their value gets changed so that another module can pick it up
        // the category names are generally arbitrary but some are used specifically and should use those types (email, name, potentially phone in the future)
        var contactDetailsFields = {
            name: [
                {
                    $field: $("#health_contactDetails_name"),
                    $fieldInput: $("#health_contactDetails_name") // pointing at the same field as a trick to force change event on itself when forward populated
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
            dob_primary: [
                {
                    $field: $("#health_healthCover_primary_dob"), // this is a hidden field
                    $fieldInput: $("#health_healthCover_primary_dob") // pointing at the same field as a trick to force change event on itself when forward populated
                },
                {
                    $field: $("#health_application_primary_dob"), // this is a hidden field
                    $fieldInput: $("#health_application_primary_dob") // pointing at the same field as a trick to force change event on itself when forward populated
                }
            ],
            dob_secondary: [
                {
                    $field: $('#partner-health-cover').find("input[name='health_healthCover_partner_dob']"), // this is a hidden field
                    $fieldInput: $('#partner-health-cover').find("input[name='health_healthCover_partner_dob']") // pointing at the same field as a trick to force change event on itself when forward populated
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
                    $field: $("#health_contactDetails_contactNumber_mobile"),
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
                    $field: $("#health_contactDetails_contactNumber_other"),
                    $optInField: contactDetailsOptinField
                },
                // otherPhone from application step
                {
                    $field: $("#health_application_other"),
                    $fieldInput: $("#health_application_otherinput")
                },
                // call back popup
                {
                    $field: $("#health_callback_otherNumberinput"),
                    $fieldInput: $("#health_callback_otherNumberinput")
                }
            ],
            flexiPhone: [
                // flexiPhone from details step
                {
                    $field: $("#health_contactDetails_flexiContactNumber"),
                    $fieldInput: $("#health_contactDetails_flexiContactNumberinput")
                },
                // otherPhone and mobile from quote step
                {
                    $field: $("#health_application_mobileinput"),
                    $otherField: $("#health_application_otherinput")
                }
            ],
            flexiPhoneV2: [
                // flexiPhone from details step
                {
                    $field: $("#health_contactDetails_flexiContactNumber"),
                    $fieldInput: $("#health_contactDetails_flexiContactNumberinput")
                },
                // otherPhone and mobile from quote step
                {
                    $field: $("#health_contactDetails_contactNumber_mobile"),
                    $otherField: $("#health_contactDetails_contactNumber_other")
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

    // Use the situation value to determine if a partner is visible on the journey.
    function hasPartner() {
        var cover = $(':input[name="health_situation_healthCvr"]').val();
        if (cover == 'F' || cover == 'C') {
            return true;
        } else {
            return false;
        }
    }

    // Make the rates object available outside of this module.
    function getRates() {
        return rates;
    }

    // Make the rebate available publicly, and handle rates property being null.
    function getRebate() {
        if (!_.isNull(rates) && rates.rebate) {
            return rates.rebate;
        }
        else {
            return 0;
        }
    }

    // Set the rates object and hidden fields in the form so it is included in post data.
    function setRates(ratesObject) {
        rates = ratesObject;
        $("#health_rebate").val((rates.rebate || ''));
        $("#health_rebateChangeover").val((rates.rebateChangeover || ''));
        $("#health_previousRebate").val((rates.previousRebate || ''));
        $("#health_loading").val((rates.loading || ''));
        $("#health_primaryCAE").val((rates.primaryCAE || ''));
        $("#health_partnerCAE").val((rates.partnerCAE || ''));

        meerkat.modules.healthResults.setLhcApplicable(rates.loading);
    }

    function loadRatesBeforeResultsPage(forceRebate, callback) {

        var $healthCoverDetails = $('#startForm');

        var postData = {
            dependants: $healthCoverDetails.find(':input[name="health_healthCover_dependants"]').val(),
            income: $healthCoverDetails.find(':input[name="health_healthCover_income"]').val() || 0,
            rebate_choice: forceRebate === true ? 'Y' : $healthCoverDetails.find('input[name="health_healthCover_rebate"]:checked').val(),
            primary_dob: $healthCoverDetails.find('#health_healthCover_primary_dob').val(),
            primary_loading: $healthCoverDetails.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
            primary_current: meerkat.modules.healthAboutYou.getPrimaryCurrentCover(),
            primary_loading_manual: $healthCoverDetails.find('.primary-lhc').val(),
            cover: $healthCoverDetails.find(':input[name="health_situation_healthCvr"]').val()
        };

        // If the customer answers Yes for current health insurance, assume 0% LHC
        if (postData.primary_current === 'Y' && postData.primary_loading !== 'N') {
            postData.primary_loading = 'Y';
        }

        if (hasPartner()) {
            postData.partner_dob = $healthCoverDetails.find('input[name="health_healthCover_partner_dob"]').val();
            postData.partner_current = meerkat.modules.healthAboutYou.getPartnerCurrentCover() || 'N';
            postData.partner_loading = $healthCoverDetails.find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val() || 'N';
            postData.partner_loading_manual = $healthCoverDetails.find('input[name="health_healthCover_partner_lhc"]').val();
        }

        if (!fetchRates(postData, true, callback)) {
            exception("Failed to fetch rates");
        }
    }

    // Load the rates object via ajax. Also validates currently filled in fields to ensure only valid attempts are made.
    function loadRates(callback) {

        var $healthCoverDetails = $('#startForm');

        var postData = {
            dependants: $healthCoverDetails.find(':input[name="health_healthCover_dependants"]').val(),
            income: $healthCoverDetails.find(':input[name="health_healthCover_income"]').val() || 0,
            rebate_choice: $healthCoverDetails.find('input[name="health_healthCover_rebate"]:checked').val() || 'Y',
            primary_dob: $healthCoverDetails.find('#health_healthCover_primary_dob').val(),
            primary_loading: $healthCoverDetails.find('input[name="health_healthCover_primary_healthCoverLoading"]:checked').val(),
            primary_current: meerkat.modules.healthAboutYou.getPrimaryCurrentCover(),
            primary_loading_manual: $healthCoverDetails.find('.primary-lhc').val(),
            partner_dob: $healthCoverDetails.find('#health_healthCover_partner_dob').val(),
            partner_loading: $healthCoverDetails.find('input[name="health_healthCover_partner_healthCoverLoading"]:checked').val(),
            partner_current: meerkat.modules.healthAboutYou.getPartnerCurrentCover(),
            partner_loading_manual: $healthCoverDetails.find('.partner-lhc').val(),
            cover: $healthCoverDetails.find(':input[name="health_situation_healthCvr"]').val()
        };

        if ($('#health_application_provider, #health_application_productId').val() === '') {

            // before application stage
            postData.primary_dob = $('#health_healthCover_primary_dob').val();

        } else {

            // in application stage
            postData.primary_dob = $('#health_application_primary_dob').val();
            postData.partner_dob = $('#health_application_partner_dob').val() || postData.primary_dob;  // must default, otherwise fetchRates fails.
            postData.primary_current = ( meerkat.modules.healthPreviousFund.getPrimaryFund() == 'NONE' ) ? 'N' : 'Y';
            postData.partner_current = ( meerkat.modules.healthPreviousFund.getPartnerFund() == 'NONE' ) ? 'N' : 'Y';

        }

        if (!fetchRates(postData, true, callback)) {
            exception("Failed to Fetch Health Rebate Rates");
        }
    }

    function fetchRates(postData, canSetRates, callback) {
        // Check if there is enough data to ask the server.
        var coverTypeHasPartner = hasPartner();
        if (postData.cover === '') return false;
        if (postData.rebate_choice === '') return false;
        if (postData.primary_dob === '') return false;
        if (coverTypeHasPartner && postData.partner_dob === '')  return false;

        if (meerkat.modules.age.returnAge(postData.primary_dob) < 0) return false;
        if (coverTypeHasPartner && meerkat.modules.age.returnAge(postData.partner_dob) < 0)  return false;
        if (postData.rebate_choice === "Y" && postData.income === "") return false;

        // check in valid date format
        var dateRegex = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;

        if (!postData.primary_dob.match(dateRegex)) return false;
        if (coverTypeHasPartner && !postData.partner_dob.match(dateRegex))  return false;

	    postData.commencementDate = null;
	    var commencementDate = $('#health_payment_details_start');
	    var searchDate = $('#health_searchDate');
	    if(commencementDate.length && !_.isEmpty(commencementDate.val())) {
		    postData.commencementDate = commencementDate.val();
	    } else if (searchDate.length && !_.isEmpty(searchDate.val())) {
		    postData.commencementDate = searchDate.val();
	    }

        return meerkat.modules.comms.post({
            url: "ajax/json/health_rebate.jsp",
            data: postData,
            cache: true,
            errorLevel: "warning",
            onSuccess: function onRatesSuccess(data) {
                if (canSetRates === true) setRates(data);
                if (!_.isNull(callback) && typeof callback !== 'undefined') {
                    callback(data);
                }
            }
        });
    }


    function changeStateAndQuote(event) {
        event.preventDefault();

        var suburb = $('#health_application_address_suburbName').val();
        var postcode = $('#health_application_address_postCode').val();
        var state = $('#health_application_address_state').val();
        $('#health_situation_location').val([suburb, postcode, state].join(' '));
        $('#health_situation_suburb').val(suburb);
        $('#health_situation_postcode').val(postcode);
        $('#health_situation_state').val(state);
        meerkat.modules.healthChoices.setState(state);

        window.location = this.href;

        var handler = meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function changeStateAndQuoteStep(step) {
            meerkat.messaging.unsubscribe(meerkatEvents.journeyEngine.STEP_CHANGED, handler);
            meerkat.modules.healthResults.get();
        });

        //OLD CODE: Results.resubmitForNewResults();
    }

    // Build an object to be sent by SuperTag tracking.
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
                contactTypeTrial: null,
                simplesUser: meerkat.site.isCallCentreUser
            };

            // Push in values from 1st slide only when have been beyond it
            if (furtherest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {

                var contactType = null;
                var contactTypeTrial = '';
                if ($('#health_simples_contactType_inbound').is(':checked')) {
                    contactType = 'inbound';
                } else if ($('#health_simples_contactType_outbound').is(':checked')) {
                    contactType = 'outbound';
                } else if ($('#health_simples_contactType_clioutbound').is(':checked')) {
                    contactType = 'clioutbound';
                } else if ($('#health_simples_contactType_trialcampaign').is(':checked')) {
                    contactType = 'outbound';
                    contactTypeTrial = 'Trial Campaign';
				} else if ($('#health_simples_contactType_chat').is(':checked')) {
					contactType = 'webchat';
                }

                $.extend(response, {
                    postCode: $("#health_application_address_postCode").val(),
                    state: state,
                    healthCoverType: $("#health_situation_healthCvr").val(),
                    healthSituation: $("input[name=health_situation_healthSitu]").filter(":checked").val(),
                    contactType: contactType,
                    contactTypeTrial: contactTypeTrial
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


    function enableSubmitApplication() {
        // Enable button, hide spinner
        var $button = $('#submit_btn');
        $button.removeClass('disabled');
        meerkat.modules.loadingAnimation.hide($button);
    }

    function disableSubmitApplication(isSameSource) {
        // Disable button, show spinner
        var $button = $('#submit_btn');
        $button.addClass('disabled');
        if (isSameSource === true) {
            meerkat.modules.loadingAnimation.showAfter($button);
        }
    }

    function submitApplication() {

        if (stateSubmitInProgress === true) {
            alert('Your application is still being submitted. Please wait.');
            return;
        }
        stateSubmitInProgress = true;

        meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'submitApplication' });

        try {

            Results.updateApplicationEnvironment();

            var postData = meerkat.modules.journeyEngine.getFormData();

            // Disable fields must happen after the post data has been collected.
            meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'submitApplication', disableFields: true });


            var healthApplicationUrl = "ajax/json/health_application.jsp";
            if (meerkat.modules.splitTest.isActive(401) || meerkat.site.isDefaultToHealthApply) {
                healthApplicationUrl = "ajax/json/health_application_ws.jsp";
            }

            meerkat.modules.comms.post({
                url: healthApplicationUrl,
                data: postData,
                cache: false,
                useDefaultErrorHandling: false,
                errorLevel: "silent",
                timeout: 250000, //10secs more than SOAP timeout
                onSuccess: function onSubmitSuccess(resultData) {

                    meerkat.modules.leavePageWarning.disable();

                    var redirectURL = "health_confirmation_v2.jsp?action=confirmation&transactionId=" + meerkat.modules.transactionId.get() + "&token=";
                    var extraParameters = "";

                    if (meerkat.site.utm_source !== '' && meerkat.site.utm_medium !== '' && meerkat.site.utm_campaign !== '') {
                        extraParameters = "&utm_source=" + meerkat.site.utm_source + "&utm_medium=" + meerkat.site.utm_medium + "&utm_campaign=" + meerkat.site.utm_campaign;
                    }

                    // Success
                    if (resultData.result && resultData.result.success) {
                        window.location.replace(redirectURL + resultData.result.confirmationID + extraParameters);

                        // Pending and not a call centre user (we want them to see the errors)
                    } else if (resultData.result && resultData.result.pendingID && resultData.result.pendingID.length > 0 && (!resultData.result.callcentre || resultData.result.callcentre !== true)) {
                        window.location.replace(redirectURL + resultData.result.pendingID + extraParameters);

                        // Handle errors
                    } else {
                        // Normally this shouldn't be reached because it should go via the onError handler thanks to the comms module detecting the error.
                        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'submitApplication' });
                        handleSubmittedApplicationErrors(resultData);
                    }
                },
                onError: onSubmitApplicationError,
                onComplete: function onSubmitComplete() {
                    stateSubmitInProgress = false;
                }
            });

        }
        catch (e) {
            stateSubmitInProgress = false;
            onSubmitApplicationError();
        }

    }

    function onSubmitApplicationError(jqXHR, textStatus, errorThrown, settings, data) {
        meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'submitApplication' });
        stateSubmitInProgress = false;
        if (errorThrown == meerkat.modules.comms.getCheckAuthenticatedLabel()) {
            // Handling of this error is defined in comms module
        } else if (textStatus == 'Server generated error') {
            handleSubmittedApplicationErrors(errorThrown);
        } else {
            handleSubmittedApplicationErrors(data);
        }
    }

    function handleSubmittedApplicationErrors(resultData) {
        var error = resultData;
        if (resultData.hasOwnProperty("error") && typeof resultData.error == "object") {
            error = resultData.error;
        }


        var msg = '';
        var validationFailure = false;
        try {
            // Handle errors return by provider
            if (resultData.result && resultData.result.errors) {
                var target = resultData.result.errors;
                if ($.isArray(target.error)) {
                    target = target.error;
                }
                $.each(target, function (i, error) {
                    msg += "<p>";
                    msg += '[Code: ' + error.code + '] ' + error.text;
                    msg += "</p>";
                });
                if (msg === '') {
                    msg = 'An unhandled error was received.';
                }
                // Handle internal SOAP error
            } else if (error && error.hasOwnProperty("type")) {
                switch (error.type) {
                    case "validation":
                        validationFailure = true;
                        break;
                    case "timeout":
                        msg = "Fund application service timed out.";
                        break;
                    case "parsing":
                        msg = "Error parsing the XML request - report issue to developers.";
                        break;
                    case "confirmed":
                        msg = error.message;
                        break;
                    case "transaction":
                        msg = error.message;
                        break;
                    case "submission":
                        msg = error.message;
                        break;
                    default:
                        msg = '[' + error.code + '] ' + error.message + " (Please report to IT before continuing)";
                        break;
                }
                // Handle unhandled error
            } else {
                msg = 'An unhandled error was received.';
            }
        } catch (e) {
            msg = 'Application unsuccessful. Failed to handle response: ' + e.message;
        }

        if (validationFailure) {
            meerkat.modules.serverSideValidationOutput.outputValidationErrors({
                validationErrors: error.errorDetails.validationErrors,
                startStage: 'payment'
            });
            if (typeof error.transactionId != 'undefined') {
                meerkat.modules.transactionId.set(error.transactionId);
            }
        } else {

            // Only show the real error to the Call Centre operator
            if (meerkat.site.isCallCentreUser === false) {
                msg = "Please contact us on <span class=\"callCentreHelpNumber\">" + meerkat.site.content.callCentreHelpNumber + "</span> for assistance.";
            }
            meerkat.modules.errorHandling.error({
                message: "<strong>Application failed:</strong><br/>" + msg,
                page: "health.js",
                errorLevel: "warning",
                description: "handleSubmittedApplicationErrors(). Submit failed: " + msg,
                data: resultData
            });

            //call the custom fail handler for each fund
            if (meerkat.modules.healthFunds.applicationFailed) {
                meerkat.modules.healthFunds.applicationFailed();
            }
        }

    }

    // Hide/show about you
    function toggleAboutYou() {

        if (meerkat.site.isFromBrochureSite === true) {
            var $healthSitLocation = $('#health_situation_location'),
                $healthSitHealthCvr = $('#health_situation_healthCvr');

            var healthCvrValid = $healthSitHealthCvr.isValid();
            var healthLocoValid = $healthSitLocation.isValid();

            if (healthCvrValid) {
                $healthSitHealthCvr.attr('data-attach', 'true');
                $('.health-cover').addClass('hidden');
            }

            if (healthLocoValid) {
                $healthSitLocation.attr('data-attach', 'true');
                $('.health-location').addClass('hidden');
            }

            if (healthCvrValid && healthLocoValid) {
                $('.health-about-you, .health-about-you-title').addClass('hidden');
            }

            $('.btn-edit').on('click', function () {
                toggleAboutYou();
            });

            meerkat.site.isFromBrochureSite = false;
        } else {
            $('.health-cover').removeClass('hidden');
            $('.health-location').removeClass('hidden');
            $('.health-about-you, .health-about-you-title').removeClass('hidden');
            $('.health-situation .fieldset-column-side .sidebar-box').css('margin-top', '');
        }
    }

    // Hide/show simple dialogues when toggle inbound/outbound in simples journey
    function toggleInboundOutbound() {
        // Inbound
        if ($('#health_simples_contactType_inbound').is(':checked')) {
            $('.follow-up-call').addClass('hidden');
            $('.simples-privacycheck-statement, .new-quote-only').removeClass('hidden');
            $('.simples-privacycheck-statement input:checkbox').prop('disabled', false);
        }
        // Outbound
        else if ($('#health_simples_contactType_outbound').is(':checked')) {
            $('.simples-privacycheck-statement, .new-quote-only, .follow-up-call').addClass('hidden');
        }
        // Follow up call
        else if ($('#health_simples_contactType_followup').is(':checked')) {
            $('.simples-privacycheck-statement, .new-quote-only').addClass('hidden');
            $('.follow-up-call').removeClass('hidden');
            $('.follow-up-call input:checkbox').prop('disabled', false);
        }
        // Chat Callback
        else if ($('#health_simples_contactType_callback').is(':checked')) {
            $('.simples-privacycheck-statement, .new-quote-only, .follow-up-call').removeClass('hidden');
            toggleDialogueInChatCallback();
        }
    }

    // Disable/enable follow up/New quote dialogue when the other checkbox ticked in Chat Callback sesction in simples
    function toggleDialogueInChatCallback() {
        var $followUpCallField = $('.follow-up-call input:checkbox');
        var $privacyCheckField = $('.simples-privacycheck-statement input:checkbox');

        if ($followUpCallField.is(':checked')) {
            $privacyCheckField.attr('checked', false);
            $privacyCheckField.prop('disabled', true);
            $('.simples-privacycheck-statement .error-field').hide();
        } else if ($privacyCheckField.is(':checked')) {
            $followUpCallField.attr('checked', false);
            $followUpCallField.prop('disabled', true);
            $('.follow-up-call .error-field').hide();
        } else {
            $privacyCheckField.prop('disabled', false);
            $followUpCallField.prop('disabled', false);
            $('.simples-privacycheck-statement .error-field').show();
            $('.follow-up-call .error-field').show();
        }
    }

    function toggleRebate() {
        if ($('#health_healthCover_health_cover_rebate').find('input:checked').val() === 'N') {
            $('#health_healthCover_tier').hide();
            $('.health_cover_details_dependants').hide();
        } else {
            $('#health_healthCover_tier').show();
            var cover = $(':input[name="health_situation_healthCvr"]').val();
            if (cover === 'F' || (cover === 'EF' || (cover === 'SPF' || cover === 'ESP'))) {
                $('.health_cover_details_dependants').show();
            }
        }
    }

    function initHealth() {

        var self = this;

        $(document).ready(function () {

            // Only init if health... obviously...
            if (meerkat.site.vertical !== "health") return false;

            // Init common stuff
            initJourneyEngine();

            // Only continue if not confirmation page.
            if (meerkat.site.pageAction === "confirmation") return false;

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

            eventSubscriptions();
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

            $("#health_contactDetails_optin").on("click", function () {
                var optinVal = $(this).is(":checked") ? "Y" : "N";
                $('#health_privacyoptin').val(optinVal);
                $("#health_contactDetails_optInEmail").val(optinVal);
                $("#health_contactDetails_call").val(optinVal);
            });

            if ($('input[name="health_directApplication"]').val() === 'Y') {
                $('#health_application_productId').val(meerkat.site.loadProductId);
                $('#health_application_productTitle').val(meerkat.site.loadProductTitle);
            }

            if (meerkat.site.isCallCentreUser === true) {
                meerkat.modules.simplesSnapshot.initSimplesSnapshot();
            }

            adjustLayout();

            if (meerkat.site.isCallCentreUser === false) {
                meerkat.modules.saveQuote.initSaveQuote();
            }

	        try {
		        if (!!window.LogRocket) {
			        window.LogRocket.identify(meerkat.modules.transactionId.get());
		        }
	        } catch(e) {
		        meerkat.logging.error("Exception thrown launching logrocket: " + e.message);
	        }
        });


    }

    function getCoverType() {
        return $('#health_situation_coverType input').filter(":checked").val();
    }

    function getSituation() {
        return $('#health_situation_healthCvr').val();
    }

    function getHospitalCoverLevel() {
        return $('#health_benefits_covertype').val();
    }

    meerkat.modules.register("health", {
        init: initHealth,
        events: moduleEvents,
        initProgressBar: initProgressBar,
        getTrackingFieldsObject: getTrackingFieldsObject,
        getCoverType: getCoverType,
        getSituation: getSituation,
        getHospitalCoverLevel: getHospitalCoverLevel,
        getRates: getRates,
        setRates: setRates,
        getRebate: getRebate,
        fetchRates: fetchRates,
        loadRates: loadRates,
        loadRatesBeforeResultsPage: loadRatesBeforeResultsPage,
        hasPartner: hasPartner,
        configureContactDetails: configureContactDetails
    });

})(jQuery);
