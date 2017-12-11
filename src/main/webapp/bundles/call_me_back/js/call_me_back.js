;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
    };

    function initCallMeBack() {
    }

    meerkat.modules.register("call_me_back", {
        init: initCallMeBack,
        events: moduleEvents
    });

})(jQuery);