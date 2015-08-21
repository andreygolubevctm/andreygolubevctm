;(function ($, undefined) {
    var meerkat = window.meerkat;

    var events = {
        };

    function init() {
        $(document).ready(function () {
            applyEventListeners();
        });
    }

    function applyEventListeners() {

    }

    meerkat.modules.register('jqueryValidate', {
        init: init,
        events: events
    });

})(jQuery);