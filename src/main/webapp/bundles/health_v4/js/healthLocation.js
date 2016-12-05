;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $healthSitLocation,
        $healthSituationState,
        $healthSituationPostcode,
        $healthSituationSuburb,
        location = '';

    function init() {
        $healthSitLocation = $('#health_situation_location');
        $healthSituationState = $('input[name=health_situation_state]');
        $healthSituationPostcode = $('#health_situation_postcode');
        $healthSituationSuburb = $('#health_situation_suburb');

        location = $healthSitLocation.val();

        eventSubscriptions();
    }

    function eventSubscriptions() {
    }

    function setLocation() {
        if (location === '') {
            return;
        }

        if (_isValidLocation()) {
            var value = $.trim(String(location)),
                pieces = value.split(' '),
                state = pieces.pop(),
                postcode = pieces.pop(),
                suburb = pieces.join(' ');

            $healthSituationState.filter('[value='+state+']').trigger('click');
            $healthSituationPostcode.val(postcode);
            $healthSituationSuburb.val(suburb);
        }
    }

    function _isValidLocation() {
        var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/),
            value = $.trim(String(location));

        if (value != '') {
            if (value.match(search_match)) {
                return true;
            }
        }

        return false;
    }

    meerkat.modules.register('healthLocation', {
        init: init,
        setLocation: setLocation
    });

})(jQuery);