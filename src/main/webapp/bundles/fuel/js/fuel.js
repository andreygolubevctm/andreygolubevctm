(function ($, undefined) {

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
    /**
     * The custom Marker object that we use to generate the icon
     */
    var Marker;
    /**
     * The custom markerLabel object that extends google.maps.overlayView
     */
    var MarkerLabel;
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

            initCustomMarkerLabel();
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
                navigator.geolocation.getCurrentPosition(function (position) {
                    var pos = {
                        lat: position.coords.latitude,
                        lng: position.coords.longitude
                    };

                    infoWindow.setPosition(pos);
                    infoWindow.setContent('Location found.'); // TODO: hook this up with backend
                    map.setCenter(pos);
                    meerkat.modules.fuelResults.initPage();
                    meerkat.modules.fuelResults.get();
                }, function () {
                    _handleLocationError(true, infoWindow, map.getCenter());
                });
            } else {
                // Browser doesn't support Geolocation
                _handleLocationError(false, infoWindow, map.getCenter());
            }

            // Plot all the markers for the current result set.
            $(document).on("resultsLoaded", function() {
                plotMarkers();
            });
            //
        } catch (e) {
            _handleError(e, "fuel.js:initCallback");
        }
    }

    /**
     * Map Icons created by Scott de Jonge
     * @version 3.0.0
     * @url http://map-icons.com
     *
     */
    function initCustomMarkerLabel() {
        // Function to do the inheritance properly
        // Inspired by: http://stackoverflow.com/questions/9812783/cannot-inherit-google-maps-map-v3-in-my-custom-class-javascript
        var inherits = function (childCtor, parentCtor) {
            /** @constructor */
            function tempCtor() {
            }

            tempCtor.prototype = parentCtor.prototype;
            childCtor.superClass_ = parentCtor.prototype;
            childCtor.prototype = new tempCtor();
            childCtor.prototype.constructor = childCtor;
        };

        Marker = function (options) {
            google.maps.Marker.apply(this, arguments);

            if (options.map_icon_label) {
                this.MarkerLabel = new MarkerLabel({
                    map: this.map,
                    marker: this,
                    text: options.map_icon_label
                });
                this.MarkerLabel.bindTo('position', this, 'position');
            }
        };

        // Apply the inheritance
        inherits(Marker, google.maps.Marker);

        // Custom Marker SetMap
        Marker.prototype.setMap = function () {
            google.maps.Marker.prototype.setMap.apply(this, arguments);
            (this.MarkerLabel) && this.MarkerLabel.setMap.apply(this.MarkerLabel, arguments);
        };

        // Marker Label Overlay
        MarkerLabel = function (options) {
            var self = this;
            this.setValues(options);

            // Create the label container
            this.div = document.createElement('div');
            this.div.className = 'map-icon-label';

            // Trigger the marker click handler if clicking on the label
            google.maps.event.addDomListener(this.div, 'click', function (e) {
                (e.stopPropagation) && e.stopPropagation();
                google.maps.event.trigger(self.marker, 'click');
            });
        };

        // Create MarkerLabel Object
        MarkerLabel.prototype = new google.maps.OverlayView();

        // Marker Label onAdd
        MarkerLabel.prototype.onAdd = function () {
            var pane = this.getPanes().overlayImage.appendChild(this.div);
            var self = this;

            this.listeners = [
                google.maps.event.addListener(this, 'position_changed', function () {
                    self.draw();
                }),
                google.maps.event.addListener(this, 'text_changed', function () {
                    self.draw();
                }),
                google.maps.event.addListener(this, 'zindex_changed', function () {
                    self.draw();
                })
            ];
        };

        // Marker Label onRemove
        MarkerLabel.prototype.onRemove = function () {
            this.div.parentNode.removeChild(this.div);

            for (var i = 0, I = this.listeners.length; i < I; ++i) {
                google.maps.event.removeListener(this.listeners[i]);
            }
        };

        // Implement draw
        MarkerLabel.prototype.draw = function () {
            var projection = this.getProjection();
            var position = projection.fromLatLngToDivPixel(this.get('position'));
            var div = this.div;

            this.div.innerHTML = this.get('text').toString();

            div.style.zIndex = this.get('zIndex'); // Allow label to overlay marker
            div.style.position = 'absolute';
            div.style.display = 'block';
            div.style.left = (position.x - 10) + 'px';
            div.style.top = (position.y - 20) + 'px';

        };
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

        var marker = new Marker({
            map: map,
            position: latLng,
            icon: {
                path: google.maps.SymbolPath.CIRCLE,
                // todo: just need something to set the color based on its range.
                fillColor: '#00CCBB',
                fillOpacity: 1,
                scale: 8,
                strokeColor: '#ffffff',
                strokeWeight: 2
            },
            map_icon_label: '<span class="icon icon-vert-fuel"></span>',
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
                error: e.toString(),
                exception: e
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
            var heightToSet = isXS ? window.innerHeight - $header.height() /* TODO: minus price band and infoBox */ : window.innerHeight - $header.height();
            /* TODO: minus footer signup box */
            $('#google-map-container').css('height', heightToSet);
        });
    }

    function plotMarkers() {
        var results = Results.getFilteredResults();
        console.log("we has results");
        if (!results) {
            log("plotMarkers: No Results Available to plot markers");
            return;
        }
        var bounds = new google.maps.LatLngBounds();

        for (var i = 0; i < results.length; i++) {
            var latLng = createLatLng(results[i].lat, results[i].lng);
            var marker = createMarker(latLng, results[i]);
            markers[results[i].id] = marker;
            bounds.extend(latLng);
        }

        map.fitBounds(bounds);
    }

    function initFuel() {
        $(document).ready(function () {
            // Only init if fuel
            if (meerkat.site.vertical !== "fuel")
                return false;

            //meerkat.modules.fuelPrefill.setHashArray();

            // Init common stuff
            initJourneyEngine();
            setMapHeight();

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

        $(document).ready(function () {
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
            title: 'Fuel Details',
            navigationId: 'start',
            slideIndex: 0,
            validation: {
                validate: true
            },
            externalTracking: {
                method: 'trackQuoteForms',
                object: meerkat.modules.fuel.getTrackingFieldsObject
            },
            onInitialise: function () {
                meerkat.modules.jqueryValidate.initJourneyValidator();
                initGoogleAPI();
                //meerkat.modules.fuelPrefill.initFuelPrefill();
            },
            onAfterEnter: function () {
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
                    state: location[location.length - 1],
                    postcode: location[location.length - 2]
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