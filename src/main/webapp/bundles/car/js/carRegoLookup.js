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
        moduleEvents = events.regoLookup,

        $elements = {
            container: null,
            feedback: null,
            carRegoEntry: null,
            carRegoExit: null,
            vehicleSelectionWrapper: null,
            regoLookupWrapper: null,
            stateField: null,
            regoField: null,
            prefillRegoNo: null
        },

        showCustomErrors = false,
        _isRegoLookupMode = false;

    function init() {
        $(document).ready(function () {
            $elements.container = $('#unableToFindRego');
            $elements.feedback = $('#regoErrorMessage');
            $elements.carRegoEntry = $('.carRegoEntry');
            $elements.carRegoExit = $('.carRegoExit');
            $elements.vehicleSelectionWrapper = $('#vehicle_selection_wrapper');
            $elements.regoLookupWrapper = $('#rego_lookup_wrapper');
            $elements.stateField = $('#quote_regoLookup_state');
            $elements.regoField = $('#quote_regoLookup_registrationNumber');
            $elements.prefillRegoNo = $('.prefillRegoNumber');

            applyEventListeners();
        });
    }

    function applyEventListeners() {
        meerkat.messaging.subscribe(meerkatEvents.car.DROPDOWN_CHANGED, function invisibleRego(states) {
            $('.rego-text').addClass('invisible');

            // set rego lookup mode to false
            _isRegoLookupMode = false;
        });

        $elements.carRegoEntry.on('click', function showRegoFields() {
           _toggleRegoFields(true);
            _isRegoLookupMode = true;
        });

        $elements.carRegoExit.on('click', function hideRegoFields() {
            _toggleRegoFields(false);
            _isRegoLookupMode = false;
        });

        _toggleRegoFields(false);
    }

    function validate() {
        var state = getSearchState() || false,
            rego = getSearchRego() || false;

        if (state !== false && rego !== false) {
            return _.extend({}, {plateNumber: rego}, {state: state});
        } else {
            return false;
        }
    }

    function lookup(callback) {
        var data = validate();
        if (data !== false) {
            meerkat.messaging.publish(moduleEvents.REGO_LOOKUP_STARTED);
            meerkat.modules.journeyEngine.loadingShow("Please wait while we retrieve your car's details...");
            meerkat.modules.regoLookup.get(data, {
                useDefaultErrorHandling: false,
                onSuccess: _.bind(onLookup, this, data),
                onError: _.bind(onLookupError, this, data)
            }).then(function(data) {
                meerkat.modules.journeyEngine.loadingHide();
                $elements.prefillRegoNo.addClass('hidden');
                _toggleRegoFields(false);

                if (_.isFunction(callback)) {
                    if (_.isUndefined(data.vehicle_data.exception)) {
                        hideError();
                        // allows journey engine to proceed to the next step
                        callback(true);
                    } else {
                        meerkat.modules.loadingAnimation.hide($('.journeyNavButton'));
                        _isRegoLookupMode = false;
                        // stops journey engine from proceeding
                        callback(false);
                    }
                }
            })
            .catch(meerkat.modules.journeyEngine.loadingHide)
            .then(function () {
                $('.rego-text').removeClass('invisible');
            });

            return true;
        } else {
            return false;
        }
    }

    function onLookup(data, response) {
        if (_.has(response, "vehicle_data") && _.isObject(response.vehicle_data)) {
            var json = response.vehicle_data;
            if (_.has(json, "exception")) {
                switch (json.exception) {
                    case "invalid_state":
                        renderError("An invalid state has been selected.");
                        break;
                    case "rego_not_found":
                        renderError("Sorry, no registration details found for state '" + data.state + "' and registration no. '" + data.plateNumber + "'.");
                        break;
                    case "no_redbook_code":
                        renderError("Sorry, we cannot find a complete match for registration no. '" + data.plateNumber + "'.");
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
                        renderError("Sorry, this service is presently unavailable.");
                        break;
                }
                $elements.prefillRegoNo.addClass('hidden');
                track(false);
            } else {
                meerkat.messaging.publish(
                    moduleEvents.REGO_LOOKUP_COMPLETE,
                    json,
                    _.bind(meerkat.modules.journeyEngine.gotoPath, this, "options")
                );
                track(true);
            }
        } else {
            track(false);
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
        track(false);
    }

    function track(success) {
        var data = {
            method: "trackMotorWeb",
            object: {
                eventCategory: "car motorweb tracking",
                eventAction: _.isBoolean(success) ? (success === true ? "MW Success" : "MW Fail") : "MW Not Used"
            }
        };
        if(_.isBoolean(success)) {
            _.extend(data.object,{eventLabel: $elements.regoField.val()});
        }
        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL,data,true);
    }

    function renderError(copy) {
        $elements.container.removeClass('hidden');
        if(showCustomErrors === true) {
            $elements.feedback.empty().html(copy);
        }
    }

    function hideError() {
        $elements.container.addClass('hidden');
    }

    function _toggleRegoFields(toggle) {
        $elements.vehicleSelectionWrapper.toggleClass('hidden', toggle === true);
        $elements.regoLookupWrapper.toggleClass('hidden', toggle === false);
    }

    function setSearchState() {
        meerkat.site.vehicleSelectionDefaults.searchState = $elements.stateField.val();
    }

    function getSearchState() {
        return meerkat.site.vehicleSelectionDefaults.searchState;
    }

    function setSearchRego() {
        meerkat.site.vehicleSelectionDefaults.searchRego = $elements.regoField.val();
    }

    function getSearchRego() {
        return meerkat.site.vehicleSelectionDefaults.searchRego;
    }

    function isRegoLookupMode() {
        return _isRegoLookupMode;
    }

    function redirectToRegoFields() {
        var state = getSearchState() || false,
            rego = getSearchRego() || false,
            redirect = false;

        if (state) {
            $elements.stateField.val(state);
            redirect = true;
        }

        if (rego) {
            $elements.regoField.val(rego);
            redirect = true;
        }

        if (redirect) {
            triggerEntry();
        }
    }

    function triggerEntry() {
        $elements.carRegoEntry.trigger('click');
    }

    meerkat.modules.register("carRegoLookup", {
        init: init,
        lookup: lookup,
        setSearchState: setSearchState,
        setSearchRego: setSearchRego,
        isRegoLookupMode: isRegoLookupMode,
        redirectToRegoFields: redirectToRegoFields,
        triggerEntry: triggerEntry,
        track: track,
        events: events
    });

})(jQuery);