;(function($, undefined) {
    var meerkat = window.meerkat,
        meerkatModules = meerkat.modules,
        meerkatEvents = meerkatModules.events,
        log = meerkat.logging.info;

    var hashArray,
        mapLoaded = false;

    function initFuelPrefill() {
        _registerSubscriptions();
        _eventDelegates();
    }

    function setHashArray(){
        hashArray = meerkat.modules.address.getWindowHashAsArray();
    }

    /**
     * Registers meerkat messaging subscriptions
     * @private
     */
    function _registerSubscriptions() {
        _populateInputs();
    }

    function _eventDelegates() {
        $(document).on("resultsAnimated", _findMap);
    }

    function _findMap() {
        if(mapLoaded === false && hashArray.length >= 4 && hashArray[3].match(/^(map-)/g)) {
            var siteId = hashArray[3].replace("map-", "");
            meerkat.modules.fuelResultsMap.openMap($(document).find("a[data-siteid='" + siteId + "']").first());
            mapLoaded = true;
        }
    }

    /**
     * Gets the available query params and attempts to populate inputs
     * @private
     */
    function _populateInputs() {
        if (typeof meerkat.site.formData !== "undefined" || hashArray.length >= 3) {
            _setFuelType();
            _setLocation();
        }
    }

    /**
     * Selects (up to) two fuels of a specified type
     * @private
     */
    function _setFuelType() {
        var fuelType;
        if(typeof hashArray[2] !== "undefined")
            fuelType = hashArray[2];
        else if(typeof meerkat.site.formData !== "undefined" && typeof meerkat.site.formData.fuelType !== "undefined")
            fuelType = meerkat.site.formData.fuelType;

        if(typeof fuelType !== "undefined") {
            var isCustomSelection = fuelType.match(/\d,?\d?/g);

            if(isCustomSelection) {
                var selected = fuelType.split(",").slice(0,2);

                $("#checkboxes-all .checkbox-custom").each(function() {
                        for(var i = 0; i < selected.length; i++) {
                            var $this = $(this);

                            if ($this.val() === selected[i])
                                $this.trigger("click");
                        }
                    });
            } else {
                var fuelTypeId;

                switch (fuelType) {
                    case "P":
                        fuelTypeId = "petrol";
                        break;
                    case "D":
                        fuelTypeId = "diesel";
                        break;
                    case "L":
                        fuelTypeId = "lpg";
                        break;
                    default:
                        return;
                }

                $("#checkboxes-" + fuelTypeId).find(".checkbox-custom").slice(0,2).trigger("click");
            }
        }
    }

    /**
     * Sets the value of the #fuel_location input.
     * @private
     */
    function _setLocation() {
        var location;
        if(typeof hashArray[1] !== "undefined" && hashArray[1].substr(0,7) !== "?stage=")
            location = hashArray[1].replace(/\+/g, " ");
        else if(typeof meerkat.site.formData !== "undefined" && typeof meerkat.site.formData.location !== "undefined")
            location = meerkat.site.formData.location;

        if(location !== "undefined")
            $("#fuel_location").val(location);
    }

    meerkat.modules.register("fuelPrefill", {
        initFuelPrefill: initFuelPrefill,
        setHashArray: setHashArray
    });
})(jQuery);