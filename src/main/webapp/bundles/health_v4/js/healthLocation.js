;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthLocation: {
                STATE_CHANGED: 'STATE_CHANGED'
            }
        },
        $elements;

    function initHealthLocation() {
        _setupFields();
        _eventSubscriptions();
        setLocation(getLocation());
    }

    function _setupFields() {
        $elements = {
            location: $('#health_situation_location'),
            state: $('input[name=health_situation_state]'),
            postcode: $('#health_situation_postcode'),
            postcodeApp: $('#health_application_address_postCode'),
            suburb: $('#health_situation_suburb')
        };
    }

    function _eventSubscriptions() {
        $elements.state.on('change', function onStateChanged() {
            meerkat.messaging.publish(moduleEvents.healthLocation.STATE_CHANGED, { state: $(this).val() });
        });
    }

    function setLocation(location) {
        if (location === '') {
            return;
        }

        if (_isValidLocation(location)) {
            var value = $.trim(String(location)),
                pieces = value.split(' '),
                state = pieces.pop(),
                postcode = pieces.pop(),
                suburb = pieces.join(' ');

            $elements.location.val(location);
            $elements.state.val(state);
            $elements.postcode.val(postcode);
            $elements.postcodeApp.val(postcode);
            $elements.suburb.val(suburb);
        }
    }

    function setResidentialState(value) {
        $('#health_situation_state').val(value);
    }

    function _isValidLocation(location) {
        var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/),
            value = $.trim(String(location));

        if (value !== '') {
            if (value.match(search_match)) {
                return true;
            }
        }

        return false;
    }

    function getLocation() {
        return $elements.location.val();
    }

    meerkat.modules.register('healthLocation', {
        initHealthLocation: initHealthLocation,
        events: moduleEvents,
        setLocation: setLocation,
        getLocation: getLocation,
        setResidentialState: setResidentialState
    });

})(jQuery);
