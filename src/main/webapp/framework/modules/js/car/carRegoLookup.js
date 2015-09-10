;(function($, undefined){

    /**
     * carRegoLookup - provides the car journey fron-end implementation of the rego lookup feature
     **/

    var meerkat = window.meerkat,
        meerkatEvents =  meerkat.modules.events;

    var events = {
            regoLookup: {
                REGO_LOOKUP_FORM_IN_USE: 'REGO_LOOKUP_FORM_IN_USE',
                REGO_LOOKUP_STARTED: 'REGO_LOOKUP_STARTED',
                REGO_LOOKUP_COMPLETE: 'REGO_LOOKUP_COMPLETE'
            }
        },
        moduleEvents = events.regoLookup;

    var input_states = {
        NEUTRAL :   0,
        PASS :      true,
        FAIL :      false
    };

    var $elements = {
        container : null,
        button :    null,
        state :     null,
        stateRow :  null,
        rego :      null,
        regoRow :   null,
        feedback :  null
    }


    function init(){
        meerkat.messaging.subscribe(meerkatEvents.car.DROPDOWN_CHANGED, reset);
        $(document).ready(function(){
            $elements.container = $('#rego-lookup-form');
            if(!_.isUndefined(meerkat.modules.regoLookup) && $elements.container) {
                $elements.button = $elements.container.find('.rego-lookup-button').first();
                $elements.state = $elements.container.find('.rego-lookup-state').first();
                $elements.stateRow = $elements.state.closest('.row-content');
                $elements.rego = $elements.container.find('.rego-lookup-number').first();
                $elements.regoRow = $elements.rego.closest('.row-content');
                $elements.feedback = $elements.container.find('.rego-lookup-feedback').first();

                // Listeners
                $elements.state.off().on("change", validateState);
                $elements.rego.off().on("keyup", validateRego);
                $elements.button.off().on("click", lookup);
            }
        });
    }

    function reset() {
        renderError(false);
        $elements.state.prop("selectedIndex",0);
        $elements.rego.val("");
        toggleStyle($elements.state,$elements.stateRow,input_states.NEUTRAL);
        toggleStyle($elements.rego,$elements.regoRow,input_states.NEUTRAL);
    }

    function validateState(hard) {
        hard = hard || false;

        meerkat.messaging.publish(moduleEvents.REGO_LOOKUP_FORM_IN_USE);

        var state = $elements.state.val();
        var valid = true;
        if(_.isEmpty(state)) {
            toggleStyle($elements.state,$elements.stateRow,hard === true ? input_states.FAIL : input_states.NEUTRAL);
            valid = false;
        } else {
            toggleStyle($elements.state,$elements.stateRow,input_states.PASS);
        }

        if(valid === true) {
            return {state:state};
        } else {
            return valid;
        }
    }



    function validateRego(hard) {
        hard = hard || false;

        meerkat.messaging.publish(moduleEvents.REGO_LOOKUP_FORM_IN_USE);

        var rego = $.trim($elements.rego.val());
        var valid = true;
        if(_.isEmpty(rego)) {
            toggleStyle($elements.rego,$elements.regoRow,hard === true ? input_states.FAIL : input_states.NEUTRAL);
            valid = false;
        } else {
            toggleStyle($elements.rego,$elements.regoRow,input_states.PASS);
        }

        if(valid === true) {
            return {plateNumber:rego};
        } else {
            return valid;
        }
    }

    function validate() {
        var state = validateState(true);
        var rego = validateRego(true);

        if(state !== false && rego !== false) {
            renderError(false);
            return _.extend({},state,rego);
        } else {
            return false;
        }
    }

    function lookup(e) {
        e = e || false;
        if(_.isObject(e)) {
            e.preventDefault();
        }
        var data = validate();
        if(data !== false) {
            if(meerkat.modules.deviceMediaState.get() == 'xs') {
                meerkat.modules.loadingAnimation.showInside($elements.button);
            } else {
                meerkat.modules.loadingAnimation.showAfter($elements.button);
            }
            meerkat.messaging.publish(moduleEvents.REGO_LOOKUP_STARTED);
            $elements.feedback.empty();
            meerkat.modules.regoLookup.get(data, {
                useDefaultErrorHandling : false,
                onSuccess : _.bind(onLookup, this, data),
                onError : _.bind(onLookupError, this, data)
            });
        } else {
            renderError("Please ensure you enter the state and registration number of your vehicle");
        }
    }

    function onLookup(data, response) {
        meerkat.modules.loadingAnimation.hide($elements.button);
        if(_.has(response, "vehicle_data") && _.isObject(response.vehicle_data)) {
            var json = response.vehicle_data;
            if(_.has(json, "exception")) {
                switch(json.exception) {
                    case "invalid_state":
                        renderError("An invalid state has been selected. Please try again.");
                        break;
                    case "rego_not_found":
                        renderError("Sorry, no registration details found for state '" + data.state + "' and registration no. '" + data.plateNumber + "'");
                        break;
                    default:
                    case "service_error":
                    case "dao_error":
                    case "request_limit_exceeded":
                    case "daily_limit_exceeded":
                    case "daily_limit_undefined":
                    case "daily_usage_error":
                    case "service_turned_off":
                    case "service_toggle_undefined":
                    case "transaction_unverified":
                        renderError("Sorry, this service is presently unavailable. Please locate your vehicle using the options below.")
                        break
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
        meerkat.modules.loadingAnimation.hide($elements.button);
        renderError("Sorry, this service is experiencing some difficulties. Please try again or perhaps locate your vehicle using the options below.");
        meerkat.modules.errorHandling.error({
            errorLevel: 'silent',
            page: "Rego Lookup (" + meerkat.site.vertical + ")",
            title: "Rego Lookup Ajax Error",
            message: "Fatal ajax call for rego lookup",
            description: "Status: " + jqXHR.status + ", statusText: " + jqXHR.statusText,
            data:data,
            id: meerkat.modules.transactionId.get()
        });
    }

    function toggleStyle($input, $row, state) {
        if(state === input_states.NEUTRAL || state === input_states.PASS) {
            $input.removeClass("has-error");
            $row.removeClass("has-error");
        }
        if(state === input_states.NEUTRAL || state === input_states.FAIL) {
            $input.removeClass("has-success");
            $row.removeClass("has-success");
        }
        if(state === input_states.FAIL) {
            $input.addClass("has-error");
            $row.addClass("has-error");
        }
        if(state === input_states.PASS) {
            $input.addClass("has-success");
            $row.addClass("has-success");
        }
    }

    function renderError(copy) {
        $elements.feedback.empty().append(copy);
    }

    meerkat.modules.register("carRegoLookup", {
        init: init,
        events: events
    });

})(jQuery);