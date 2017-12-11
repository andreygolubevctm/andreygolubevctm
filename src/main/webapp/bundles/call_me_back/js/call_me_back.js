;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
    };

    function initCallMeBack() {
    }

    meerkat.modules.register("callMeBack", {
        init: initCallMeBack,
        events: moduleEvents
    });

})(jQuery);