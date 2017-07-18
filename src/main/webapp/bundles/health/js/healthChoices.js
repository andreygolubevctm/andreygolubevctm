;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        moduleEvents = {
            health: {
                SNAPSHOT_FIELDS_CHANGE: 'SNAPSHOT_FIELDS_CHANGE'
            }
        };

    var _cover = '',
        _state = '',
        _situation = '',
        _performUpdate = false,
        $elements = {};

    function init() {
        $(document).ready(function () {
            _setupFields();
            _eventListeners();
        });
    }

    function initialise(cover, situation, benefits) {
        setCover(cover, true, true);
        var performUpdate = _performUpdate;
        setSituation(situation, performUpdate);
    }

    function _setupFields() {
        $elements = {
            healthSit: $('#health_benefits_healthSitu'),
            healthSitGroup: $("input[name=health_situation_healthSitu]"),
            healthSitCSF: $('#health_situation_healthSitu_CSF'),
            healthCover: $('input[name=health_situation_healthCvr]'),
            state: $('#health_situation_state'),
            postcode: $('#health_situation_postcode'),
            suburb: $('#health_situation_suburb')
        };
    }

    function _eventListeners() {
        $elements.healthCover.on('change', function () {
            meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
        });

        $elements.healthSitGroup.on('change', function () {
            meerkat.messaging.publish(moduleEvents.health.SNAPSHOT_FIELDS_CHANGE);
        });
    }

    function hasSpouse() {
        switch (_cover) {
            case 'C':
            case 'F':
            case 'EF':
                return true;
            default:
                return false;
        }
    }

    function setCover(cover) {
        _cover = cover; // default to a single

        updateSituation();
    }

    function setState(state) {
        _state = state;
    }

    function returnCoverCode() {
        return _cover;
    }

    function isValidLocation(location) {

        var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

        value = $.trim(String(location));

        if (value !== '') {
            if (value.match(search_match)) {
                return true;
            }
        }

        return false;
    }

    function setLocation(location) {

        if (isValidLocation(location)) {
            var value = $.trim(String(location));
            var pieces = value.split(' ');
            var state = pieces.pop();
            var postcode = pieces.pop();
            var suburb = pieces.join(' ');
            $('#health_situation_state').val(state);
            $('#health_situation_postcode').val(postcode).trigger("change");
            $('#health_situation_suburb').val(suburb);

            setState(state);
        } else if (meerkat.site.isFromBrochureSite) {
            //Crappy input which doesn't get validated on brochureware quicklaunch should be cleared as they didn't get the opportunity to see results via typeahead on our side.
            $('#health_situation_location').val("");
        }
    }

    function shouldPerformUpdate(performUpdate) {
        _performUpdate = performUpdate;
    }

    function updateSituation() {
        var $familyTile = $('#health_situation_healthSitu_CSF').siblings("span").first();
        var copy = $familyTile.text();
        switch (_cover) {
            case 'F':
            case 'SPF':
            case 'EF':
            case 'ESP':
                copy = copy.replace('Start a family', 'Grow my family');
                break;
            default:
                copy = copy.replace('Grow my family', 'Start a family');
        }
        $familyTile.text(copy);
    }

    function setSituation(situation, performUpdate) {
        if (performUpdate !== false)
            performUpdate = true;

        //// Change the message
        if (situation != _situation) {
            _situation = situation;
        }

        $('#health_benefits_healthSitu').val(situation);

        if (!_.isEmpty(situation)) {
            $("input[name=health_situation_healthSitu]").filter('[value=' + situation + ']').prop('checked', true).trigger('change');
        }

    }

    meerkat.modules.register("healthChoices", {
        events: moduleEvents,
        init: init,
        initialise: initialise,
        isValidLocation: isValidLocation,
        hasSpouse: hasSpouse,
        returnCoverCode: returnCoverCode,
        setCover: setCover,
        setLocation: setLocation,
        setState: setState,
        shouldPerformUpdate: shouldPerformUpdate
    });

})(jQuery);