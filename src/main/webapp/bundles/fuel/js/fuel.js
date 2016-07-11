(function($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var moduleEvents = {
        fuel: {}
    }, steps = null;

    /**
     * Google API key from the Developers Console.
     * @source https://console.developers.google.com/project/ctm-fuel-map/apiui/apiview/maps_backend/usage
     * @type {string}
     */
    var googleAPIKey = 'AIzaSyC8ygWPujOpSI1O-7jsiyG3_YIDlPoIP6U';
    /**
     * The google Map object
     * @type {Map}
     */
    var map;
    /**
     * The infoWindow object for the current info window.
     * @type {InfoWindow}
     */
    var infoWindow;
    var markers = {};
    /**
     * The current latitude or longitude from the clicked map.
     * @type {String|Number}
     */
    var currentLat,
        currentLng; //String/Number
    var markerTemplate,
        modalId,
        siteId,
        modalTemplate,
        windowResizeListener;

    /**
     * Asynchronously load in the Google Maps API and then calls initCallback
     * Uses Google Developer Console API Key
     */
    function initGoogleAPI() {
        if (typeof map !== 'undefined') {
            return;
        }
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = 'https://maps.googleapis.com/maps/api/js?key=' + googleAPIKey + '&v=3.exp' +
            '&signed_in=false&callback=meerkat.modules.fuel.initCallback';
        script.onerror = function (msg, url, linenumber) {
            _handleError(msg + ':' + linenumber, "fuel.js:initGoogleAPI");
        };
        document.body.appendChild(script);
    }

    /**
     * This is executed as a callback to loading the script asynchronously.
     */
    function initCallback() {
        try {
            var mapOptions = {
                zoom: 15, // higher the number, closer to the ground.
                minZoom: 11, // e.g. 0 is whole world
                mapTypeId: google.maps.MapTypeId.ROAD,
                mapTypeControlOptions: {
                    style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
                }
            };

            // Create the modal so that map-canvas exists in the DOM.
           // createModal();
            // Initialise the Google Map
            map = new google.maps.Map(document.getElementById('map-canvas'),
                mapOptions);
            // Initialise the info window
            infoWindow = new google.maps.InfoWindow({map: map});

            // Try HTML5 geolocation.
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var pos = {
                        lat: position.coords.latitude,
                        lng: position.coords.longitude
                    };

                    infoWindow.setPosition(pos);
                    infoWindow.setContent('Location found.'); // TODO: hook this up with backend
                    map.setCenter(pos);
                }, function() {
                    _handleLocationError(true, infoWindow, map.getCenter());
                });
            } else {
                // Browser doesn't support Geolocation
                _handleLocationError(false, infoWindow, map.getCenter());
            }

            // Plot all the markers for the current result set.
            //plotMarkers();
            //
        } catch (e) {
            _handleError(e, "fuel.js:initCallback");
        }
    }

    function centerMap(LatLng) {
        map.panTo(LatLng);
    }

    /**
     * Utility function to create a LatLng object from two values.
     * @param lat
     * @param lng
     * @returns {google.maps.LatLng}
     */
    function createLatLng(lat, lng) {
        return new google.maps.LatLng(
            parseFloat(lat),
            parseFloat(lng)
        );
    }

    /**
     * Create the marker objects and bind click events.
     * @param latLng
     * @param info
     * @param markerOpts
     * @returns {google.maps.Marker}
     */
    function createMarker(latLng, info, markerOpts) {

        var marker = new google.maps.Marker({
            map: map,
            position: latLng,
            icon: "assets/brand/ctm/graphics/fuel/map-pin.png",
            animation: google.maps.Animation.DROP
        });

        google.maps.event.addListener(marker, 'click', function () {
            openInfoWindow(marker, info);
        });
        return marker;
    }

    /**
     * open the infoWindow inside a google map on marker click and by default.
     * @param marker
     * @param info
     */
    function openInfoWindow(marker, info) {
        var htmlString = "";
        if (markerTemplate) {
            htmlString = markerTemplate(info);
            infoWindow.setContent(htmlString);
            infoWindow.open(map, marker);

            meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                method: 'trackProductView',
                object: {
                    productID: info.productId || null,
                    productBrandCode: info.provider || null,
                    productName: (info.name || "") + " " + (info.fuelText || "")
                }
            });

        } else {
            _handleError("", 'An error occurred displaying information for this fuel provider.');
        }
    }

    function _handleError(e, page) {
        meerkat.modules.errorHandling.error({
            errorLevel: "warning",
            message: "An error occurred with loading the Google Map. Please reload the page and try again.",
            page: page,
            description: "[Google Maps] Error Initialising Map",
            data: {
                error: e.toString()
            },
            id: meerkat.modules.transactionId.get()
        });
    }

    function _handleLocationError(browserHasGeolocation, infoWindow, pos) {
        infoWindow.setPosition(pos);
        infoWindow.setContent(browserHasGeolocation ?
            'Error: The Geolocation service failed.' :
            'Error: Your browser doesn\'t support geolocation.');
    }

    function setMapHeight() {
        _.defer(function () {
            var isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false,
                $header = $('header');
            var heightToSet = isXS ? window.innerHeight - $header.height() /* TODO: minus price band and infoBox */  : window.innerHeight - $header.height(); /* TODO: minus footer signup box */
            $('#google-map-container').css('height', heightToSet);
        });
    }

    function initFuel() {
        $(document).ready(function() {
            // Only init if fuel
            if (meerkat.site.vertical !== "fuel")
                return false;

            //meerkat.modules.fuelPrefill.setHashArray();

            // Init common stuff
            initJourneyEngine();
            setMapHeight();
            initGoogleAPI();

            if (meerkat.site.pageAction === 'amend' || meerkat.site.pageAction === 'latest' || meerkat.site.pageAction === 'load' || meerkat.site.pageAction === 'start-again') {
                meerkat.modules.form.markInitialFieldsWithValue($("#mainform"));
            }
        });
    }

    function initJourneyEngine() {
        setJourneyEngineSteps();

        // Initialise the journey engine
        var startStepId = null;
        if (meerkat.site.isFromBrochureSite === true && meerkat.modules.address.getWindowHashAsArray().length === 1) {
            startStepId = steps.startStep.navigationId;
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

    function setJourneyEngineSteps() {
        var startStep = {
            title : 'Fuel Details',
            navigationId : 'start',
            slideIndex : 0,
            validation: {
                validate: true
            },
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.fuel.getTrackingFieldsObject
            },
            onInitialise: function(){
                meerkat.modules.jqueryValidate.initJourneyValidator();
                //meerkat.modules.fuelPrefill.initFuelPrefill();
            },
            onAfterEnter: function() {
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
        //        meerkat.modules.showMoreQuotesPrompt.initPromptBar();
        //        meerkat.modules.fuelSorting.initSorting();
        //        meerkat.modules.fuelResultsMap.initFuelResultsMap();
        //        meerkat.modules.fuelCharts.initFuelCharts();
        //    },
        //    onAfterEnter: function afterEnterResults(event) {
        //        meerkat.modules.fuelResults.get();
        //        meerkat.modules.fuelResultsMap.resetMap();
        //    },
        //    onAfterLeave: function(event) {
        //        if(event.isBackward) {
        //            meerkat.modules.showMoreQuotesPrompt.disablePromptBar();
        //        }
        //    }
        //};

        /**
         * Add more steps as separate variables here
         */
        steps = {
            startStep: startStep
            //,resultsStep: resultsStep
        };
    }

    // Build an object to be sent by tracking.
    function getTrackingFieldsObject(special_case) {
        try {

            var current_step = meerkat.modules.journeyEngine.getCurrentStepIndex();
            var furthest_step = meerkat.modules.journeyEngine.getFurtherestStepIndex();

            var location = $("#fuel_location").val().split(' '),
                actionStep = '';

            switch (current_step) {
                case 0:
                    actionStep = "fuel details";
                    break;
                case 1:
                    if (special_case === true) {
                        actionStep = 'fuel more info';
                    } else {
                        actionStep = 'fuel results';
                    }
                    break;
            }

            var response = {
                actionStep: actionStep,
                quoteReferenceNumber: meerkat.modules.transactionId.get()
            };

            // Push in values from 2nd slide only when have been beyond it
            if (furthest_step > meerkat.modules.journeyEngine.getStepIndex('start')) {
                _.extend(response, {
                    state: location[location.length-1],
                    postcode: location[location.length-2]
                });
            }

            return response;

        } catch (e) {
            return {};
        }
    }

    meerkat.modules.register("fuel", {
        init: initFuel,
        events: moduleEvents,
        initCallback: initCallback,
        getTrackingFieldsObject: getTrackingFieldsObject
    });
})(jQuery);