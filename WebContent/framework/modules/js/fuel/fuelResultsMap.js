/**
 * Description: Google Developer Console set up under user ben.thompson@comparethemarket.com.au and software@comparethemarket.com.au.
 * External documentation: https://developers.google.com/maps/documentation/javascript/3.exp/reference
 */

;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            fuelResultsMap: {}
        },
        moduleEvents = events.fuelResultsMap;

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
        '&signed_in=false&callback=meerkat.modules.fuelResultsMap.initCallback';
        script.onerror = function (msg, url, linenumber) {
            _handleError(msg + ':' + linenumber, "fuelResultsMap.js:initGoogleAPI");
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
                center: createLatLng(currentLat, currentLng),
                mapTypeId: google.maps.MapTypeId.ROAD,
                mapTypeControlOptions: {
                    style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
                }
            };

            // Create the modal so that map-canvas exists in the DOM.
            createModal();
            // Initialise the Google Map
            map = new google.maps.Map(document.getElementById('map-canvas'),
                mapOptions);
            // Initialise the info window
            infoWindow = new google.maps.InfoWindow();

            // Plot all the markers for the current result set.
            plotMarkers();
        } catch (e) {
            _handleError(e, "fuelResultsMap.js:initCallback");
        }

    }

    function initFuelResultsMap() {

        $(document).ready(function ($) {
            applyEventListeners();
            markerTemplate = _.template($('#map-marker-template').html());
            modalTemplate = _.template($('#google-map-canvas-template').html());
        });

    }

    function applyEventListeners() {
        $(document).on('click', '.map-open', function () {
            openMap($(this));
        });
    }

    /**
     * Determines whether to initialise a new map or open an existing one
     * When opens existing one, it resets to the
     * @param $el
     */
    function openMap($el) {
        currentLat = $el.data('lat');
        currentLng = $el.data('lng');
        Results.setSelectedProduct($el.attr('data-productid'));

        if (typeof map === 'undefined') {
            initGoogleAPI();
        } else {
            // If no markers (resets in fuel:onAfterEnter for results step.
            if (!_.keys(markers).length) {
                plotMarkers();
            }
            $('#' + modalId).modal('show');
            infoWindow.close();
            var product = Results.getSelectedProduct();

            siteId = product.siteid;
            meerkat.modules.address.appendToHash('map-' + siteId);

            if (product) {
                openInfoWindow(markers[product.siteid], product);
                centerMap(createLatLng(currentLat, currentLng));
            }
        }
        //open map counted as bridging click
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
            method:	'trackQuoteForms',
            object:	_.bind(meerkat.modules.fuel.getTrackingFieldsObject, this, true)
        });

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
     * We only need to plot the markers once per results view.
     * The markers are reset
     */
    function plotMarkers() {
        var results = filterDuplicatesOut(Results.getFilteredResults());
        var bounds = new google.maps.LatLngBounds();

        var focusMarker, focusCoords, focusInfo;

        for (var selectedProduct = Results.getSelectedProduct(),
                 i = 0; i < results.length; i++) {
            var latLng = createLatLng(results[i].lat, results[i].long);
            var marker = createMarker(latLng, results[i]);
            markers[results[i].siteid] = marker;
            if (results[i].siteid == selectedProduct.siteid) {
                openInfoWindow(marker, results[i]);
                focusMarker = marker;
                focusCoords = latLng;
                focusInfo = results[i];
            }
            bounds.extend(latLng);
        }

        map.fitBounds(bounds);

        if (focusMarker && focusCoords && focusInfo) {
            centerMap(focusCoords);
            openInfoWindow(focusMarker, focusInfo);
        }
    }

    /**
     * When you are loading two different types of fuel, you get duplicate records
     * Hence we cannot use getFilteredResults as-is.
     * This loop smushes the other fuel prices for that station into one result.
     * @param results
     * @returns {*}
     */
    function filterDuplicatesOut(results) {
        return results.filter(function (element, index, array) {
            for (var i = 0; i < array.length; i++) {
                if (i == index) {
                    return true;
                }
                if (array[i].siteid == element.siteid) {
                    if (!array[i].price2Text) {
                        array[i].price2Text = element.priceText;
                        array[i].price2 = element.price;
                        array[i].fuel2Text = element.fuelText;
                    } else {
                        array[i].price3Text = element.priceText;
                        array[i].price3 = element.price;
                        array[i].fuel3Text = element.fuelText;
                    }

                    return false;
                }
            }
            return true;
        });
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
            icon: 'brand/ctm/graphics/fuel/map-pin.png',
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

    /**
     * The modal in this case is never destroyed. It is always kept and just shown using bootstraps own functions.
     * This is to avoid extra API calls to Google Maps.
     * This should only be run once per page load.
     */
    function createModal() {
        var options = {
            htmlContent: modalTemplate(Results.getSelectedProduct()),
            hashId: 'map-' + Results.getSelectedProduct().siteid,
            className: 'googleMap',
            closeOnHashChange: false,
            destroyOnClose: false,
            onClose: onClose,
            onOpen: setMapHeight,
            fullHeight: true
        };
        modalId = meerkat.modules.dialogs.show(options);

        if(windowResizeListener) {
            google.maps.event.removeListener(windowResizeListener);
        }
        windowResizeListener = google.maps.event.addDomListener(window, "resize", function () {
            if(typeof google !== 'undefined' && $('#'+modalId).length) {
                meerkat.modules.dialogs.resizeDialog(modalId);
                setMapHeight();
                google.maps.event.trigger(map, "resize");
                map.setCenter(createLatLng(currentLat, currentLng));
            }
        });
    }

    function onClose() {
        if(siteId)
            meerkat.modules.address.removeFromHash('map-' + siteId);
    }

    function setMapHeight() {
        _.defer(function () {
            var isXS = meerkat.modules.deviceMediaState.get() === "xs" ? true : false,
                $modalContent = $('.googleMap .modal-body');
            var heightToSet = isXS ? $modalContent.css('height') : $modalContent.css('max-height');
            $('#google-map-container').css('height', heightToSet);
        });
    }

    function resetMap() {
        if (infoWindow) {
            infoWindow.close();
        }
        _clearMarkers();
    }

    function _clearMarkers() {
        var keys = _.keys(markers);
        if (!keys.length) {
            return;
        }
        for (var i = 0; i < keys.length; i++) {
            markers[keys[i]].setMap(null);
        }
        markers = {};
    }

    function getMap() {
        return map;
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

    meerkat.modules.register("fuelResultsMap", {
        initFuelResultsMap: initFuelResultsMap,
        events: events,
        initCallback: initCallback,
        resetMap: resetMap,
        getMap: getMap,
        openMap: openMap
    });

})(jQuery);