;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var _cover = '',
        _state = '',
        _performUpdate = false,
        $elements = {};

    function init() {
        $(document).ready(function () {
            _setupFields();
            _eventSubscriptions();
        });
    }

    function initialise(cover) {
        setCover(cover);
    }

    function _setupFields() {
        $elements = {
            body: $('body'),
            healthSit: $('#health_benefits_healthSitu'),
            healthSitGroup: $("input[name=health_situation_healthSitu]"),
            healthSitCSF: $('#health_situation_healthSitu_CSF'),
            state: $('#health_situation_state'),
            postcode: $('#health_situation_postcode'),
            suburb: $('#health_situation_suburb')
        };
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.healthSituation.SITUATION_CHANGED, function toggleHasPartner() {
            $elements.body.attr('data-has-partner', function() {
                return hasPartner() ? true : false;
            });
        });
    }

    function hasPartner() {
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
        _cover = cover || '';
    }

    function setState(state) {
        _state = state;
    }

    function returnCoverCode() {
        return _cover;
    }

    function shouldPerformUpdate(performUpdate) {
        _performUpdate = performUpdate;
    }

    function getCoverType() {
        return $('#health_situation_coverType').val();
    }

    /**
     * Set to C, E, or H
     * @param value
     */
    function setCoverType(value) {
        $('#health_situation_coverType').val(value);
    }

    meerkat.modules.register("healthChoices", {
        events: moduleEvents,
        init: init,
        initialise: initialise,
        hasPartner: hasPartner,
        returnCoverCode: returnCoverCode,
        setCover: setCover,
        setState: setState,
        shouldPerformUpdate: shouldPerformUpdate,
        getCoverType: getCoverType,
        setCoverType: setCoverType
    });

})(jQuery);