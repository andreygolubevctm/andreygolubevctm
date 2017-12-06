;(function ($, undefined) {
    var meerkat = window.meerkat;

    var events = {

    };

    function initRedemptionComponent() {
        $(document).ready(function () {
            console.log('test!!!');
        });
    }

    meerkat.modules.register('redemptionComponent', {
        init: initRedemptionComponent,
        events: events
    });

})(jQuery);