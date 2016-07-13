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
     * The custom Marker object that we use to generate the icon
     */
    var Marker;
    /**
     * The custom markerLabel object that extends google.maps.overlayView
     */
    var MarkerLabel;
    var markers = {};
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
            '&signed_in=false&callback=meerkat.modules.fuelMap.initCallback';
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
                zoom: 16, // higher the number, closer to the ground.
                minZoom: 13, // e.g. 0 is whole world
                mapTypeId: google.maps.MapTypeId.ROAD,
                streetViewControl: false,
                zoomControl: true,
                center: {
                    lat: -33.8684511,
                    lng: 151.1984322
                },
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

            // Initialise the info window
            infoWindow = new google.maps.InfoWindow({map: map});

            // Try HTML5 geolocation.
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    var pos = {
                        lat: position.coords.latitude,
                        lng: position.coords.longitude
                    };

                    map.setCenter(pos);
                    meerkat.modules.fuelResults.get();
                }, function () {
                    _handleLocationError(true, infoWindow, map.getCenter());
                });
            } else {
                // Browser doesn't support Geolocation
                _handleLocationError(false, infoWindow, map.getCenter());
            }

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

        var bandId = info.hasOwnProperty('bandId') ? info.bandId : 0;

        var marker = new google.maps.Marker({
            position: latLng,
            title: info.name,
            map: map,
            animation: google.maps.Animation.DROP,
            icon: {
                url: 'assets/brand/ctm/graphics/fuel/' + bandId + '@2x.png',
                // base image is 52x52 px
                size: new google.maps.Size(52, 52),
                // we want to render @ 26x26 logical px (@2x dppx or 'Retina')
                scaledSize: new google.maps.Size(26, 26)
            }
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
                    productID: info.id || null,
                    productBrandCode: info.brandId || null,
                    productName: info.name || ""
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

    function plotMarkers(sites) {
        if (!sites) {
            log("plotMarkers: No Results Available to plot markers");
            return;
        }
        var bounds = new google.maps.LatLngBounds();

        for (var i = 0; i < sites.length; i++) {
            var latLng = createLatLng(sites[i].lat, sites[i].lng);
            var marker = createMarker(latLng, sites[i]);
            markers[sites[i].id] = marker;
            bounds.extend(latLng);
        }

        map.fitBounds(bounds);
    }

    function getMap() {
        return map;
    }

    function initFuelMap() {
        $(document).ready(function ($) {
            setMapHeight();
            markerTemplate = _.template($('#map-marker-template').html());
        });

    }

    meerkat.modules.register("fuelMap", {
        init: initFuelMap,
        events: moduleEvents,
        initGoogleAPI: initGoogleAPI,
        initCallback: initCallback,
        getMap: getMap,
        plotMarkers: plotMarkers
    });

})(jQuery);