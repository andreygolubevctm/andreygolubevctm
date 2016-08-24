(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var moduleEvents = {
        fuel: {}
    }, steps = null;

    function initFuel() {
        $(document).ready(function () {
            // Only init if fuel
            if (meerkat.site.vertical !== "fuel")
                return false;

            //meerkat.modules.fuelPrefill.setHashArray();

            // Init common stuff
            initJourneyEngine();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
            applyEventListeners();
        });
    }

    function applyEventListeners() {
        $(document).on('change', '#fuel_type_id', function () {
            toggleCanSave(true);
            meerkat.modules.fuelMap.addToHistory();
            meerkat.modules.fuelResults.get();
        });

        $('.change-location-fuel-text').on('click', function() {
            // toggle form on mobile
            $('#google-map-container .sidebar-widget:first-child').toggleClass('show-fieldrows', true);
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
                meerkat.modules.jqueryValidate.initJourneyValidator();
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