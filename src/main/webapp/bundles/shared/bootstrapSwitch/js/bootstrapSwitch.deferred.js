/**
 * Asynchronously loaded and initialised to reduce initial load on page performance.
 * This module self-initialises.
 */
;(function ($, undefined) {
    var meerkat = window.meerkat;
    var defaults = {
        "on": "&nbsp;YES",
        "off": "NO"
    };

    function bindSwitch() {
        if ($('input.checkbox-switch').length && _.isFunction($.fn.bootstrapSwitch)) {
            $('input.checkbox-switch').bootstrapSwitch();
        }
    }
    function init() {
        $(document).ready(function () {
            bindSwitch();
        });
    }

    function resetState(eventObject) {
        var $el = eventObject.element;
        if(!$el.length) {
            return;
        }
        // In case it hadn't applied properly the first time.
        try {
            $el.bootstrapSwitch('setState');
        } catch(e) {
            bindSwitch();
            $el.bootstrapSwitch('setState');
        }
    }

    meerkat.modules.register("bootstrapSwitch", {
        init: init
    });

})(jQuery);