;(function($, undefined) {
    var meerkat = window.meerkat;
    var events = {};

    var $aboutPartnerContainer,
        $nextStep;

    function initLifePartner() {
        _initFields();
    }

    function _initFields() {
        $aboutPartnerContainer = $('#aboutYourPartner'),
        $nextStep = $aboutPartnerContainer.next().find('a.btn-next');
    }

    function togglePartnerFields(showFields) {
        $aboutPartnerContainer.toggle(showFields);
        $nextStep.toggle(showFields);
    }

    function toggleSkipToResults(){
        if (!$aboutPartnerContainer.is(":visible")) {
            meerkat.modules.journeyEngine.gotoPath("next");
            meerkat.modules.journeyEngine.gotoPath("next"); // jump to contact page
        }
    }

    meerkat.modules.register("lifePartner", {
        init: initLifePartner,
        toggleSkipToResults: toggleSkipToResults,
        togglePartnerFields: togglePartnerFields,
        events: events
    });
})(jQuery);