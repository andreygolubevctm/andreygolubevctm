;(function($, undefined){

    /**
     * carRegoLookup - provides the car journey fron-end implementation of the rego lookup feature
     **/

    var meerkat = window.meerkat,
        meerkatEvents =  meerkat.modules.events;

    var events = {
            regoLookup: {
                REGO_LOOKUP_STARTED: 'REGO_LOOKUP_STARTED',
                REGO_LOOKUP_COMPLETE: 'REGO_LOOKUP_COMPLETE'
            }
        },
        moduleEvents = events.regoLookup;

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
                $elements.state.off().on("change blur", validateState);
                $elements.rego.off().on("change blur", validateRego);
                $elements.button.off().on("click", lookup);
            }
        });
    }

    function validateState() {
        var state = $elements.state.val();
        var valid = true;
        if(_.isEmpty(state)) {
            $elements.state.removeClass('has-success');
            $elements.stateRow.removeClass('has-success');
            $elements.state.addClass('has-error');
            $elements.stateRow.addClass('has-error');
            valid = false;
        } else {
            $elements.state.addClass('has-success');
            $elements.stateRow.addClass('has-success');
            $elements.state.removeClass('has-error');
            $elements.stateRow.removeClass('has-error');
        }

        if(valid === true) {
            return {state:state};
        } else {
            return valid;
        }
    }

    function validateRego() {
        var rego = $.trim($elements.rego.val());
        var valid = true;
        if(_.isEmpty(rego)) {
            $elements.rego.removeClass('has-success');
            $elements.regoRow.removeClass('has-success');
            $elements.rego.addClass('has-error');
            $elements.regoRow.addClass('has-error');
            valid = false;
        } else {
            $elements.rego.addClass('has-success');
            $elements.regoRow.addClass('has-success');
            $elements.rego.removeClass('has-error');
            $elements.regoRow.removeClass('has-error');
        }

        if(valid === true) {
            return {plateNumber:rego};
        } else {
            return valid;
        }
    }

    function validate() {
        var state = validateState();
        var rego = validateRego();

        if(state !== false && rego !== false) {
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
                    case "service_turned_off":
                    case "service_toggle_undefined":
                        renderError("Sorry, this service is presently unavailable. Please locate your vehicle using the options below.")
                        break
                }
            } else {
                meerkat.messaging.publish(moduleEvents.REGO_LOOKUP_COMPLETE, json);
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

    function renderError(copy) {
        $elements.feedback.empty().append(copy);
    }

    meerkat.modules.register("carRegoLookup", {
        init: init,
        events: events
    });

})(jQuery);