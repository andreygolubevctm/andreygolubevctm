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
     * The google map autocomplete object
     * @type {{autocomplete}}
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
        $mapCanvas;

    /**
     * Constants - Configuration for limiting zoom.
     * @type {number}
     */
    var DEFAULT_ZOOM = 13,
        MIN_ZOOM = 12,
        MIN_MAP_HEIGHT = 735,
        // hard coding Sydney based off Google Analytics usage data as at 12/07/2016
        DEFAULT_LOCATION = {
            lat: -33.8684511,
            lng: 151.1984322
        };

    var currentZoom = DEFAULT_ZOOM,
        fetchResultsTimeout;

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
        script.src = 'https://maps.googleapis.com/maps/api/js?key=' + googleAPIKey + '&v=3.24' +
            '&libraries=places&signed_in=false&callback=meerkat.modules.fuelMap.initCallback';
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

            var styledMap = new google.maps.StyledMapType(mapStyles,
                {name: "Fuel Map"});
            var mapOptions = {
                mapTypeControl: false, // disable Map/Satellite dropdown
                zoom: DEFAULT_ZOOM, // higher the number, closer to the ground.
                minZoom: MIN_ZOOM, // e.g. 0 is whole world
                mapTypeId: google.maps.MapTypeId.ROAD,
                streetViewControl: false,
                zoomControl: true,
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

            initAutoComplete();
            initInfoWindowProperties();

            // set a timeout to prevent getting locations forever for slow connections
            var geoOptions = {
                enableHighAccuracy: false,
                timeout: 5000, // Wait 5 seconds
                maximumAge: 0
            };
            // Try HTML5 geolocation.
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    var pos = {
                        lat: position.coords.latitude,
                        lng: position.coords.longitude
                    };

                    map.setCenter(pos);
                    drawClickedMarker(pos);
                    getResults();
                }, function () {
                    // User refuses to provide location
                    _handleLocationError();
                }, geoOptions);
            } else {
                // Browser doesn't support Geolocation
                _handleLocationError();
            }


            google.maps.event.addListener(map, 'zoom_changed', function (event) {
                var newZoom = map.getZoom();
                if (currentZoom > newZoom) {
                    getResults();
                }
                currentZoom = newZoom;
            });
            google.maps.event.addListener(map, 'dragend', function (event) {
                getResults();
            });

        } catch (e) {
            _handleError(e, "fuel.js:initCallback");
        }
    }

    function getResults() {
        getBoundsAndSetFields();
        if (fetchResultsTimeout) {
            clearTimeout(fetchResultsTimeout);
        }
        fetchResultsTimeout = setTimeout(function () {
            meerkat.modules.fuelResults.get();
        }, 400);

    }

    function initAutoComplete() {
        var options = {
            types: ['(regions)'],
            componentRestrictions: {
                country: "au"
            }
        };
        var autocompleteService = new google.maps.places.AutocompleteService(),
            placesService = new google.maps.places.PlacesService(map),
            autocomplete = new google.maps.places.Autocomplete(document.getElementById('fuel_location'), options);

        autocomplete.bindTo('bounds', map);
        autocomplete.addListener('place_changed', function () {
            var place = autocomplete.getPlace();
            // if user didn't type anything to start the search then there is not much we can do...
            if (!place || !place.name || place.length === 0) {
                return;
            }

            if (!place.geometry) {
                autocompleteService.getPlacePredictions({
                    input: place.name,
                    types: ['(regions)'],
                    componentRestrictions: {
                        country: "au"
                    },
                    bounds: map.getBounds()
                }, function (predictions, status) {
                    if (status === google.maps.places.PlacesServiceStatus.OK) {
                        // choose the first prediction assuming there are any returned...
                        if (predictions[0]) {
                            $('#fuel_location').val(predictions[0].description);
                            // ...but we first need to get the details of the place so we get the actual place object that contains geometry
                            placesService.getDetails(
                                {
                                    'placeId': predictions[0].place_id
                                },
                                function (placeDetails, placesServiceStatus) {
                                    if (placesServiceStatus === google.maps.places.PlacesServiceStatus.OK) {
                                        handleAutoCompleteLocationChange(placeDetails);
                                    }
                                }
                            );
                        }
                    }
                });
                return;
            }

            handleAutoCompleteLocationChange(place);
        });
    }

    function handleAutoCompleteLocationChange(place) {
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
        google.maps.event.addListener(infoWindow, 'closeclick', function () {
            if (clickedMarker != null)
                clickedMarker.setMap(null);
        });

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
        if (markerTemplate) {
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

        } else {
            _handleError("", 'An error occurred displaying information for this fuel provider.');
        }
    }

    function hideXsInfoWindow() {
        if (isXsInfoWindowShown === true) {
            var height = $xsInfoWindow.height();
            $xsInfoWindow.empty();
            $mapCanvas.animate({height: '+=' + height}, 'fast');
            isXsInfoWindowShown = false;
        }
    }

    function plotMarkers(sites) {
        if (!sites) {
            log("plotMarkers: No Results Available to plot markers");
            return;
        }
        //var bounds = new google.maps.LatLngBounds();
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
            }
        });

        google.maps.event.addListener(marker, 'click', function (event) {
            openInfoWindow(marker, info);
            drawClickedMarker(event.latLng, bandId);
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
        if (clickedMarker != null)
            clickedMarker.setMap(null);

        var anchorPoint = bandId === 0 ? new google.maps.Point(18, 30) : new google.maps.Point(13, 26);
        clickedMarker = new google.maps.Marker({
            position: location,
            icon: {
                url: 'assets/brand/ctm/graphics/fuel/pin.png',
                anchor: anchorPoint,
                size: new google.maps.Size(52, 52),
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
                heightToSet;
            if (isXS) {
                heightToSet = window.innerHeight - $header.height() - $('#results-sidebar').height() - 36 - $xsInfoWindow.height();
            } else {
                heightToSet = window.innerHeight - $header.height();
                heightToSet = heightToSet < MIN_MAP_HEIGHT ? MIN_MAP_HEIGHT : heightToSet;
            }
            /* TODO: minus footer signup box */
            $mapCanvas.css('height', heightToSet);
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

    function initFuelMap() {
        $(document).ready(function ($) {
            $mapCanvas = $('#map-canvas');
            $xsInfoWindow = $('#info-window-container-xs');

            setMapHeight();
            markerTemplate = _.template($('#map-marker-template').html());
            meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, function () {
                setMapHeight();
            });
        });

    }

    meerkat.modules.register("fuelMap", {
        init: initFuelMap,
        events: moduleEvents,
        initGoogleAPI: initGoogleAPI,
        initCallback: initCallback,
        getMap: getMap,
        getMarkers: getMarkers,
        plotMarkers: plotMarkers
    });

})(jQuery);