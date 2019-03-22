(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var moduleEvents = {
        fuel: {}
    }, steps = null;

    var $signup = $('#fuel-signup'),
        $signupLink = $('.fuel-signup-link'),
        $signupForm = $('#fuel-signup-form'),
        $signupEmail = $('#fuel_signup_email'),
        $signupBtn = $signupForm.find('button');

    function initFuel() {
        $(document).ready(function () {
            // Only init if fuel
            if (meerkat.site.vertical !== "fuel")
                return false;

            initStickyHeader();

            //meerkat.modules.fuelPrefill.setHashArray();

            // Init common stuff
            initJourneyEngine();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
            applyEventListeners();
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

    function applyEventListeners() {
        $(document).on('change', '#fuel_type_id', function () {
            toggleCanSave(true);
            meerkat.modules.fuelMap.addToHistory();
            meerkat.modules.fuelResults.get();
        });

        $signupLink.on('click', function(e) {
            e.preventDefault();

            $('html,body').animate({
                scrollTop: $signup.outerHeight() - $signupLink.outerHeight()
            }, 300);
        });

        $signupEmail.on('keydown', function(e) {
            if (e.keyCode === 13) {
                $signupBtn.trigger('click');
                return false;
            }
        });

        $signupBtn.on('click', function(e) {
            e.preventDefault();

            if(!$signupEmail.valid()) {
                return false;
            }

            $signupForm.removeClass('fuel-signup-success');
            $signupBtn
                .attr('disabled', true)
                .find('span').hide();
            meerkat.modules.loadingAnimation.showInside($signupBtn);

            return meerkat.modules.comms.post({
                url: "ajax/write/fuel_signup.jsp",
                data: $signupEmail.serialize() + '&transactionId=' + meerkat.modules.transactionId.get(),
                dataType: 'json',
                cache: false,
                errorLevel: "warning",
                onSuccess: function onSubmitSuccess(resultData) {
                    $signupForm.addClass('fuel-signup-success');
                },
                onComplete: function onSubmitComplete() {
                    $signupBtn
                        .removeAttr('disabled')
                        .find('span').show();
                    meerkat.modules.loadingAnimation.hide($signupBtn);
                }
            });
        });

        $('.change-location-fuel-text').on('click', function() {
            // toggle form on mobile
            meerkat.modules.fuelMap.toggleFieldRows(true);
        });
    }

    function initJourneyEngine() {
        setJourneyEngineSteps();

        // Initialise the journey engine
        var startStepId = null;
        if (meerkat.site.isFromBrochureSite === true && meerkat.modules.address.getWindowHashAsArray().length === 1) {
            startStepId = steps.startStep.navigationId;
        }

        $(document).ready(function () {

            meerkat.modules.fuelMap.setInitialHash(meerkat.modules.address.getWindowHashAsArray());
            meerkat.modules.journeyEngine.configure({
                startStepId: startStepId,
                steps: _.toArray(steps)
            });

            // Call initial supertag call
            var transaction_id = meerkat.modules.transactionId.get();
            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackQuoteEvent',
                object: {
                    action: 'Start',
                    transactionID: parseInt(transaction_id, 10),
                    vertical: meerkat.site.vertical
                }
            });
        });
    }

    function setJourneyEngineSteps() {
        var startStep = {
            title: 'Fuel Prices',
            navigationId: 'start',
            slideIndex: 0,
            validation: {
                validate: false
            },
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.fuel.getTrackingFieldsObject
            },
            onInitialise: function () {
                // meerkat.modules.jqueryValidate.initJourneyValidator();
                initJourneyValidator();
                meerkat.modules.fuelMap.initGoogleAPI();
                meerkat.modules.fuelResults.initPage();
                if(meerkat.site.isFromBrochureSite && meerkat.site.formData.location) {
                    $('#fuel_location').val(meerkat.site.formData.location);
                }
                //meerkat.modules.fuelPrefill.initFuelPrefill();
            }
        };

        //var resultsStep = {
        //    title : 'Fuel Prices',
        //    navigationId : 'results',
        //    slideIndex : 1,
        //    externalTracking: {
        //        method: 'trackQuoteForms',
        //        object: meerkat.modules.fuel.getTrackingFieldsObject
        //    },
        //    additionalHashInfo: function() {
        //        var fuelTypes = $("#fuel_hidden").val(),
        //            location = $("#fuel_location").val().replace(/\s/g, "+");
        //
        //        return location + "/" + fuelTypes;
        //    },
        //    onInitialise: function onResultsInit(event) {
        //        meerkat.modules.fuelResults.initPage();
        //    },
        //    onAfterEnter: function afterEnterResults(event) {
        //        meerkat.modules.fuelResults.get();
        //        meerkat.modules.fuelResultsMap.resetMap();
        //    }
        //};

        /**
         * Add more steps as separate variables here
         */
        steps = {
            startStep: startStep
        };
    }

    function initJourneyValidator() {
        meerkat.modules.jqueryValidate.setupDefaultValidationOnForm($('#fuel-signup-form'));
    }

    // Build an object to be sent by tracking.
    function getTrackingFieldsObject(special_case) {
        try {

            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();

            var actionStep = '';

            switch (current_step) {
                case 0:
                    actionStep = "fuel details";
                    break;
            }

            var response = {
                actionStep: actionStep,
                quoteReferenceNumber: meerkat.modules.transactionId.get()
            };

            return response;

        } catch (e) {
            return {};
        }
    }

    function getFuelType() {
        return $('#fuel_type_id').val();
    }

    function toggleCanSave(canSave) {
        var value = canSave === true ? 1 : 0;
        $('#fuel_canSave').val(value);
    }

    meerkat.modules.register("fuel", {
        init: initFuel,
        events: moduleEvents,
        getTrackingFieldsObject: getTrackingFieldsObject,
        getFuelType: getFuelType,
        toggleCanSave: toggleCanSave
    });
})(jQuery);
