;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthLocation: {
                STATE_CHANGED: 'STATE_CHANGED'
            }
        },
        $healthSitLocation,
        $healthSituationState,
        $healthSituationPostcode,
        $healthSituationSuburb;
        // location = '';

    function initHealthLocation() {
        $healthSitLocation = $('#health_situation_location');
        $healthSituationState = $('input[name=health_situation_state]');
        $healthSituationPostcode = $('#health_situation_postcode');
        $healthSituationSuburb = $('#health_situation_suburb');

        eventSubscriptions();

        // location = $healthSitLocation.val();
        setLocation(getLocation());
    }

    function eventSubscriptions() {
        // $healthSitLocation.on('change', function onLocationChanged() {
        //     setLocation($(this).val());
        // });

        $healthSituationState.on('change', function onStateChanged() {
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

            $healthSitLocation.val(location);
            $healthSituationState.filter('[value='+state+']').trigger('click');
            $healthSituationPostcode.val(postcode);
            $healthSituationSuburb.val(suburb);
        }
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
        return $healthSitLocation.val();
    }

    meerkat.modules.register('healthLocation', {
        initHealthLocation: initHealthLocation,
        events: moduleEvents,
        setLocation: setLocation,
        getLocation: getLocation
    });

})(jQuery);