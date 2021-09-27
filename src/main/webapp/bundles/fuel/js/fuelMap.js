/**
 * Description: Google Developer Console set up under user ben.thompson@comparethemarket.com.au and software@comparethemarket.com.au.
 * External documentation: https://developers.google.com/maps/documentation/javascript/3.exp/reference
 */
;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            fuelMap: {}
        },
        moduleEvents = events.fuelMap;

    /**
     * Google API key from the Developers Console.
     * @source https://console.developers.google.com/project/ctm-fuel-map/apiui/apiview/maps_backend/usage
     * @type {string}
     */
    var googleAPIKey = 'AIzaSyBZVPuL7f9bsBm9EwV5Dqvcu0EFiQiRGcA';
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
     * Markers array to iterate through and remove
     * @type {Array}
     */
    var markers = [];
    var clickedMarker; // The marker when you click on a location or map point.
    var mapStyles = [
        {
            "featureType": "road.arterial",
            "elementType": "geometry",
            "stylers": [
                {"visibility": "simplified"},
                {"color": "#ffffff"}
            ]
        }, {
            "featureType": "road",
            "stylers": [
                {"visibility": "simplified"}
            ]
        }, {
            "featureType": "road.local",
            "elementType": "geometry",
            "stylers": [
                {"visibility": "simplified"},
                {"color": "#fbfaf8"}
            ]
        }, {
            "featureType": "road.highway",
            "elementType": "geometry",
            "stylers": [
                {"visibility": "simplified"},
                {"color": "#ffe15f"}
            ]
        }, {
            "featureType": "road",
            "elementType": "labels.text.fill",
            "stylers": [
                {"color": "#808080"},
                {"visibility": "on"}
            ]
        }, {
            "featureType": "transit",
            "stylers": [
                {"visibility": "off"}
            ]
        }, {
            "featureType": "administrative",
            "elementType": "labels.text.fill",
            "stylers": [
                {"color": "#808080"}
            ]
        }, {
            "featureType": "water",
            "stylers": [
                {"visibility": "simplified"},
                {"color": "#a2daf2"}
            ]
        }, {
            "featureType": "poi",
            "stylers": [
                {"visibility": "simplified"}
            ]
        }, {
            "featureType": "poi.business",
            "elementType": "geometry",
            "stylers": [
                {"color": "#bde6ab"}
            ]
        }, {
            "featureType": "landscape",
            "stylers": [
                {"lightness": 75},
                {"color": "#f7f1df"}
            ]
        }, {
            "featureType": "poi.park",
            "stylers": [
                {"color": "#bde6ab"}
            ]
        }, {
            "featureType": "poi.sports_complex",
            "stylers": [
                {"color": "#bde6ab"}
            ]
        }, {
            "featureType": "poi",
            "elementType": "labels",
            "stylers": [
                {"visibility": "off"}
            ]
        }, {
            "featureType": "poi.business",
            "stylers": [
                {"visibility": "off"}
            ]
        }, {
            "featureType": "poi.government",
            "stylers": [
                {"visibility": "off"}
            ]
        }, {
            "featureType": "poi.medical",
            "elementType": "geometry",
            "stylers": [
                {"color": "#fbd3da"}
            ]
        }
    ];

    var markerTemplate,
        isXsInfoWindowShown = false,
        $xsInfoWindow,
        $mapCanvas,
        autoComplete;

    /**
     * Constants - Configuration for limiting zoom.
     * @type {number}
     */
    var DEFAULT_ZOOM = 13,
        MIN_ZOOM = 12,
        MIN_MAP_HEIGHT = 735;
    /**
     * Hard coding Sydney based off Google Analytics usage data as at 12/07/2016
     * @type {{lat: number, lng: number}}
     */
    var DEFAULT_LOCATION = {
        lat: -33.8684511,
        lng: 151.1984322
    };

    var currentZoom = DEFAULT_ZOOM,
        fetchResultsTimeout,
        keyDownTimeout,
        fuelLocation,
        $fuelLocation,
        $fuelFieldsWidget,
        preventLookup = true,
        markerZIndexOrder = [0, 5, 4, 3, 2, 1];

    var resizeMessage,
        $signupEmail = $('#fuel_signup_email');

    function initFuelMap() {
        $(document).ready(function ($) {
            $mapCanvas = $('#map-canvas');
            $xsInfoWindow = $('#info-window-container-xs');
            $fuelLocation = $('#fuel_location');
            fuelLocation = document.getElementById('fuel_location');
            $fuelFieldsWidget = $('.fuel-fields-widget');
            setMapHeight();
            markerTemplate = _.template($('#map-marker-template').html());
            resizeMessage = meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, setMapHeight);

            // fix for Android, stopping it from resizing the map when virtual keyboard is shown
            if (meerkat.modules.performanceProfiling.isAndroid) {
                $signupEmail.on('focus', function () {
                    meerkat.messaging.unsubscribe(meerkatEvents.device.RESIZE_DEBOUNCED, resizeMessage);
                }).on('blur', function () {
                    resizeMessage = meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, setMapHeight);
                });
            }
        });
    }

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
        script.src = 'https://maps.googleapis.com/maps/api/js?key=' + googleAPIKey + '&v=3.43' +
            '&libraries=places&callback=meerkat.modules.fuelMap.initCallback';
        script.onerror = function (msg, url, linenumber) {
            _handleError(msg + ':' + linenumber, "fuelMap.js:initGoogleAPI");
        };
        document.body.appendChild(script);
    }

    /**
     * This is executed as a callback to loading the script asynchronously.
     */
    function initCallback() {
        try {
            initMap();
            initAutoComplete();
            initInfoWindowProperties();
            initPreload();
            $('#fuel-signup').removeClass('invisible');
        } catch (e) {
            _handleError(e, "fuel.js:initCallback");
        }
    }

    /**
     * Using a timeout to prevent so many requests even for when people are
     * constantly moving the map around.
     */
    function getResults() {
        getBoundsAndSetFields();
        if (fetchResultsTimeout) {
            clearTimeout(fetchResultsTimeout);
        }
        fetchResultsTimeout = setTimeout(function () {
            meerkat.modules.fuelResults.get();
        }, 400);

    }

    /**
     * Initialise map options and event listeners.
     */
    function initMap() {
        var styledMap = new google.maps.StyledMapType(mapStyles,
            {name: "Fuel Map"});
        var mapOptions = {
            mapTypeControl: false, // disable Map/Satellite dropdown
            zoom: DEFAULT_ZOOM, // higher the number, closer to the ground.
            minZoom: MIN_ZOOM, // e.g. 0 is whole world
            mapTypeId: google.maps.MapTypeId.ROAD,
            streetViewControl: false,
            zoomControl: true,
            scrollwheel: false,
            zoomControlOptions: {
                position: google.maps.ControlPosition.RIGHT_TOP
            },
            mapTypeControlOptions: {
                mapTypeIds: [google.maps.MapTypeId.ROADMAP, 'map_style']
            }
        };

        // Initialise the Google Map
        map = new google.maps.Map(document.getElementById('map-canvas'),
            mapOptions);

        //Associate the styled map with the MapTypeId and set it to display.
        map.mapTypes.set('map_style', styledMap);
        map.setMapTypeId('map_style');

        google.maps.event.addListener(map, 'zoom_changed', function (event) {
            var newZoom = map.getZoom();
            if (currentZoom > newZoom) {
                getResults();
            }
            currentZoom = newZoom;
            addToHistory();
            toggleFieldRows(false);
        });
        google.maps.event.addListener(map, 'dragend', function (event) {
            getResults();
            addToHistory();
            toggleFieldRows(false);
        });
    }

    function initPreload() {
        // Preload From Widget
        if (!bookmarkedPreload()) {
            initGeoLocation();
        }
    }

    function bookmarkedPreload() {
        if (!meerkat.site.hasOwnProperty('formData')) {
            return false;
        }
        var formData = meerkat.site.formData;
        // it can be "select type of fuel" so we check if its a number.
        if (formData.fuelType !== "" && !isNaN(parseInt(formData.fuelType))) {
            $('#fuel_type_id').val(_legacyMapFuelTypes(formData.fuelType));
        }
        var hasCoordinates = !_.isUndefined(formData.coords) && formData.coords !== "";
        if (formData.location !== "") {
            $fuelLocation.val(formData.location);
            if (!hasCoordinates) {
                google.maps.event.addListenerOnce(map, 'idle', function () {
                    google.maps.event.trigger(fuelLocation, 'focus');
                    google.maps.event.trigger(fuelLocation, 'keydown', {
                        keyCode: 13
                    });
                });
                return true;
            } else {
                $('#fuel_location').val(formData.location);
            }
        }
        if (hasCoordinates) {
            google.maps.event.addListenerOnce(map, 'idle', function () {
                var mapMeta = formData.coords.split(','),
                    zoom = parseInt(mapMeta[2]) || DEFAULT_ZOOM;
                var coords = {
                    lat: parseFloat(mapMeta[0]),
                    lng: parseFloat(mapMeta[1])
                };
                map.setCenter(coords);
                map.setZoom(zoom);
                getResults();
            });
        } else {
            //geolocate instead
            return false;
        }
        return true;
    }

    /**
     * Initialise geolocation
     */
    function initGeoLocation() {
        // set a timeout to prevent getting locations forever for slow connections
        var geoOptions = {
            enableHighAccuracy: false,
            timeout: 10000, // Wait 10 seconds
            maximumAge: 0
        };

        // Try HTML5 geolocation.
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                var pos = {
                    lat: position.coords.latitude,
                    lng: position.coords.longitude
                };
                // do this here in case they take a while to click 'allow' as no idle triggers in that case.
                map.setCenter(pos);
                google.maps.event.addListenerOnce(map, 'idle', function () {
                    getResults();
                });
            }, function () {
                // User refuses to provide location
                _handleLocationError();
            }, geoOptions);
        } else {
            // Browser doesn't support Geolocation
            _handleLocationError();
        }

    }

    function initAutoComplete() {

        $fuelLocation.on('keydown', function (e) {

            // Step 1: Stop it if its < 2 characters
            if ($(this).val().length < 2) {
                e.stopImmediatePropagation();
                preventLookup = true;
                return;
            }

            // Step 2: Stop Propagation to Google Places API by default, unless its outside the 250ms
            if (preventLookup) {
                // prevent the event from bubbling up to google. This will also stop tracking.
                e.stopImmediatePropagation();
            }

            var keypress = e.which;
            if (keyDownTimeout) {
                clearTimeout(keyDownTimeout);
            }
            // When this fires, preventLookup must be false, so that it bubbles.
            keyDownTimeout = setTimeout(function () {
                preventLookup = false;
                google.maps.event.trigger(fuelLocation, 'focus');
                google.maps.event.trigger(fuelLocation, 'keydown', {
                    keyCode: keypress
                });
            }, 250);

            preventLookup = true;

        });
        var options = {
            types: ['(regions)'],
            componentRestrictions: {
                country: "au"
            }
        };
        var autoCompleteService = new google.maps.places.AutocompleteService(),
            placesService = new google.maps.places.PlacesService(map);

        autoComplete = new google.maps.places.Autocomplete(fuelLocation, options);

        autoComplete.bindTo('bounds', map);
        autoComplete.addListener('place_changed', function () {
            var place = autoComplete.getPlace();
            // if user didn't type anything to start the search then there is not much we can do...
            if (!place || !place.name || place.length === 0) {
                log("place_changed: No place returned");
                return;
            }

            if (!place.geometry) {
                autoCompleteService.getPlacePredictions({
                    input: place.name,
                    types: ['(regions)'],
                    componentRestrictions: {
                        country: "au"
                    },
                    bounds: map.getBounds()
                }, function (predictions, status) {
                    if (status !== google.maps.places.PlacesServiceStatus.OK) {
                        return;
                    }
                    // choose the first prediction assuming there are any returned...
                    if (!predictions[0]) {
                        return;
                    }
                    $fuelLocation.val(predictions[0].description);
                    // ...but we first need to get the details of the
                    // place so we get the actual place object that contains geometry
                    placesService.getDetails({
                            'placeId': predictions[0].place_id
                        }, function (placeDetails, placesServiceStatus) {
                            if (placesServiceStatus === google.maps.places.PlacesServiceStatus.OK) {
                                handleAutoCompleteLocationChange(placeDetails);
                            }
                        }
                    );
                });
                return;
            }

            handleAutoCompleteLocationChange(place);
        });
    }

    function handleAutoCompleteLocationChange(place) {
        meerkat.modules.fuel.toggleCanSave(true);
        map.setCenter(place.geometry.location);
        map.setZoom(DEFAULT_ZOOM);
        drawClickedMarker(place.geometry.location);
        getResults();
    }

    /**
     * Helper to initialise infoWindow properties.
     */
    function initInfoWindowProperties() {
        // Initialise the info window
        infoWindow = new google.maps.InfoWindow({
            pixelOffset: new google.maps.Size(-13, 8)
        });

        // Remove it from the map
        google.maps.event.addListener(infoWindow, 'closeclick', removeClickedMarker);

        // Removes the pointer arrow on the infoWindow as per design.
        google.maps.event.addListener(infoWindow, 'domready', function () {
            var el = document.getElementById('iw_content').parentNode.parentNode.parentNode;
            el = el.previousElementSibling || el.previousSibling;
            el.setAttribute('class', 'infoWindowBackground');
            var arrow = el.children[2];
            el.removeChild(arrow);
        });

    }

    /**
     * open the infoWindow inside a google map on marker click and by default.
     * @param marker
     * @param info
     */
    function openInfoWindow(marker, info) {
        if (!markerTemplate) {
            _handleError("", 'An error occurred displaying information for this fuel provider.');
            return;
        }
        var htmlString = markerTemplate(info);

        if (meerkat.modules.deviceMediaState.get() === "xs") {
            var height = $xsInfoWindow.html(htmlString).height();
            if (!isXsInfoWindowShown) {
                $mapCanvas.animate({height: '-=' + height}, 'fast');
                isXsInfoWindowShown = true;
            }
            $xsInfoWindow.find('.closeInfoWindow').on('click', function () {
                hideXsInfoWindow();
            });
        } else {
            infoWindow.setContent(htmlString);
            infoWindow.open(map, marker);
        }

        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method: 'trackProductView',
            object: {
                productID: info.id || null,
                productBrandCode: info.brandId || null,
                productName: info.name || ""
            }
        });
    }

    function addToHistory(event) {
        var center = map.getCenter(),
            baseUrl = meerkat.site.urls.base + 'fuel_quote.jsp';
        // Fail silently. This is only an issue where baseurl doesn't match real url.
        try {
            window.history.pushState({}, "", baseUrl + '?map=' + center.lat() + ',' + center.lng() + ',' + map.getZoom() + '&fueltype=' + meerkat.modules.fuel.getFuelType());
        } catch (e) {
        }
    }

    function hideXsInfoWindow() {
        if (isXsInfoWindowShown !== true) {
            return;
        }
        removeClickedMarker();
        var height = $xsInfoWindow.height();
        $xsInfoWindow.empty();
        $mapCanvas.animate({height: '+=' + height}, 'fast');
        isXsInfoWindowShown = false;
    }

    function removeClickedMarker() {
        if (clickedMarker != null)
            clickedMarker.setMap(null);
    }

    function plotMarkers(sites) {
        if (!sites) {
            log("plotMarkers: No Results Available to plot markers");
            return;
        }
        removeClickedMarker();
        cleanupMarkers();
        // clear XsInfoWindow
        hideXsInfoWindow();
        for (var i = 0; i < sites.length; i++) {
            if (sites[i].hasOwnProperty('id')) {
                markers.push(createMarker(sites[i]));
            }
        }
    }

    function cleanupMarkers() {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
        }
        markers = [];
    }

    /**
     * Create the marker objects and bind click events.
     * @param info
     * @returns {google.maps.Marker}
     */
    function createMarker(info) {

        var bandId = info.hasOwnProperty('bandId') ? info.bandId : 0;

        // de-emphasize unavailable
        var scaledSize = bandId === 0 ? 16 : 26;

        var marker = new google.maps.Marker({
            position: new google.maps.LatLng(
                parseFloat(info.lat),
                parseFloat(info.lng)
            ),
            title: info.name,
            map: map,
            icon: {
                url: 'assets/brand/ctm/graphics/fuel/' + bandId + '@2x.png',
                // base image is 52x52 px
                size: new google.maps.Size(52, 52),
                anchor: new google.maps.Point(13, 13),
                // we want to render @ 26x26 logical px (@2x dppx or 'Retina')
                scaledSize: new google.maps.Size(scaledSize, scaledSize)
            },
            zIndex: markerZIndexOrder[bandId]
        });

        google.maps.event.addListener(marker, 'click', function (event) {
            toggleFieldRows(false);
            _.defer(function () {
                openInfoWindow(marker, info);
                drawClickedMarker(event.latLng, bandId);
            });
        });

        return marker;
    }

    /**
     * When we click on the map, draw this marker at location
     * @param location LatLng
     * @param bandId Integer
     */
    function drawClickedMarker(location, bandId) {
        // clear previous markers
        removeClickedMarker();

        var anchorPoint = bandId === 0 ? new google.maps.Point(18, 30) : new google.maps.Point(13, 26);
        clickedMarker = new google.maps.Marker({
            position: location,
            icon: {
                url: 'assets/brand/ctm/graphics/fuel/pin.png',
                anchor: anchorPoint,
                size: new google.maps.Size(26, 26),
                scaledSize: new google.maps.Size(26, 26)
            },
            map: map,
            draggable: false,
            optimized: false,
            zIndex: 999
        });
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

    function _handleLocationError() {
        map.setCenter(DEFAULT_LOCATION);
        map.setZoom(DEFAULT_ZOOM);
        drawClickedMarker(DEFAULT_LOCATION);
    }

    function setMapHeight() {
        _.defer(function () {
            var isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false,
                $header = $('header'),
                $resultsSidebar = $('#results-sidebar'),
                $fuelSignupLink = $('.fuel-signup-link'),
                $fuelSignup = $('#fuel-signup'),
                heightToSet;
            if (isXS) {
                heightToSet = window.innerHeight - $header.height() - $resultsSidebar.height() - 36 - $xsInfoWindow.height() - $fuelSignupLink.outerHeight();
            } else {
                heightToSet = window.innerHeight - $header.height() - $fuelSignup.outerHeight();
                heightToSet = heightToSet < MIN_MAP_HEIGHT ? MIN_MAP_HEIGHT : heightToSet;
            }
            /* TODO: minus footer signup box */
            $mapCanvas.css('height', heightToSet);
            if (google.maps) {
                google.maps.event.trigger(map, 'resize');
            }
        });
    }

    /**
     * Set the top-left(northWest), bottom-right(southEast) coordinates for fuel_quote service to use.
     * Google map bounds only has coordinates for northEast and SourthWest, so we have to form the ones we want
     */
    function getBoundsAndSetFields() {
        if (!map) {
            return;
        }
        var bounds = map.getBounds();
        if (bounds && _.isFunction(bounds.getNorthEast)) {
            var ne = bounds.getNorthEast(),
                sw = bounds.getSouthWest(),
                nw = new google.maps.LatLng(ne.lat(), sw.lng()),
                se = new google.maps.LatLng(sw.lat(), ne.lng());

            $('#fuel_map_northWest').val(nw.lat() + ',' + nw.lng());
            $('#fuel_map_southEast').val(se.lat() + ',' + se.lng());
        }
    }

    function getMap() {
        return map;
    }

    function getMarkers() {
        return markers;
    }

    /**
     * Preload the saved hashes into formData so we can prefill the data in the same format.
     * @param hashArray
     */
    function setInitialHash(hashArray) {
        if (hashArray && hashArray.length && hashArray[0] === 'results' && _.isString(hashArray[1])) {
            meerkat.site.formData = {
                location: decodeURIComponent(hashArray[1].replace(/\+/g, '%20')),
                fuelType: decodeURIComponent(hashArray[2])
            };
        }
    }

    /**
     * Mapping legacy fuel types to the new versions
     * @param fuelType
     * @returns {number}
     * @private
     */
    function _legacyMapFuelTypes(fuelType) {

        switch (fuelType) {
            case '6,2':
            case '2,6':
                return 999;
            case '3,9':
            case '9,3':
                return 1000;
            case '6':
                return 12;
            case '8':
            case '9':
                return 14;
            case 'P':
                return 2;
            case 'L':
                return 4;
            case 'D':
                return 3;
            default:
                return fuelType;
        }

    }

    function toggleFieldRows(state) {
        if (meerkat.modules.deviceMediaState.get() === 'xs') {
            $fuelFieldsWidget.toggleClass('show-fieldrows', state);
            setMapHeight();
        }
    }

    meerkat.modules.register("fuelMap", {
        init: initFuelMap,
        events: moduleEvents,
        initGoogleAPI: initGoogleAPI,
        initCallback: initCallback,
        getMap: getMap,
        getMarkers: getMarkers,
        plotMarkers: plotMarkers,
        addToHistory: addToHistory,
        setInitialHash: setInitialHash,
        toggleFieldRows: toggleFieldRows
    });

})(jQuery);