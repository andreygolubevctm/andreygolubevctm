;(function ($, undefined) {

    /**
     * carRegoLookup - provides the car journey front-end implementation of the rego lookup feature
     **/

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var events = {
            regoLookup: {
                REGO_LOOKUP_STARTED: 'REGO_LOOKUP_STARTED',
                REGO_LOOKUP_COMPLETE: 'REGO_LOOKUP_COMPLETE'
            }
        },
        moduleEvents = events.regoLookup;

    var $elements = {
        container: null,
        feedback: null
    };


    function init() {
        $(document).ready(function () {
            $elements.container = $('#unableToFindRego');
            $elements.feedback = $('#regoErrorMessage');
        });
    }

    function validate() {

        var optionsObj = meerkat.site.vehicleSelectionDefaults;
        var state = optionsObj.searchState || false;
        var rego = optionsObj.searchRego || false;

        if (state !== false && rego !== false) {
            return _.extend({}, {plateNumber: rego}, {state: state});
        } else {
            return false;
        }
    }

    function lookup() {
        var data = validate();
        if (data !== false) {
            meerkat.messaging.publish(moduleEvents.REGO_LOOKUP_STARTED);
            meerkat.modules.regoLookup.get(data, {
                useDefaultErrorHandling: false,
                onSuccess: _.bind(onLookup, this, data),
                onError: _.bind(onLookupError, this, data)
            });
        } else {
            renderError("Please ensure you enter the state and registration number of your vehicle");
        }
    }

    function onLookup(data, response) {
        if (_.has(response, "vehicle_data") && _.isObject(response.vehicle_data)) {
            var json = response.vehicle_data;
            if (_.has(json, "exception")) {
                switch (json.exception) {
                    case "invalid_state":
                        renderError("An invalid state has been selected. Please try again.");
                        break;
                    case "rego_not_found":
                        renderError("Sorry, no registration details found for state '" + data.state + "' and registration no. '" + data.plateNumber + "'");
                        break;
                    default:
                        /*case "service_error":
                         case "dao_error":
                         case "request_limit_exceeded":
                         case "daily_limit_exceeded":
                         case "daily_limit_undefined":
                         case "daily_usage_error":
                         case "service_turned_off":
                         case "service_toggle_undefined":
                         case "transaction_unverified":*/
                        renderError("Sorry, this service is presently unavailable. Please locate your vehicle using the options below.");
                        break;
                }
            } else {
                meerkat.messaging.publish(
                    moduleEvents.REGO_LOOKUP_COMPLETE,
                    json,
                    _.bind(meerkat.modules.journeyEngine.gotoPath, this, "options")
                );
            }
        }
    }

    function onLookupError(data, jqXHR) {
        renderError("Sorry, this service is experiencing some difficulties. Please try again or perhaps locate your vehicle using the options below.");
        meerkat.modules.errorHandling.error({
            errorLevel: 'silent',
            page: "Rego Lookup (" + meerkat.site.vertical + ")",
            title: "Rego Lookup Ajax Error",
            message: "Fatal ajax call for rego lookup",
            description: "Status: " + jqXHR.status + ", statusText: " + jqXHR.statusText,
            data: data,
            id: meerkat.modules.transactionId.get()
        });
    }

    function renderError(copy) {
        $elements.container.removeClass('hidden');
        $elements.feedback.empty().html(copy);
    }

    meerkat.modules.register("carRegoLookup", {
        init: init,
        lookup: lookup,
        events: events
    });

})(jQuery);