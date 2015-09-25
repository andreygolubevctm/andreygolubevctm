/**
 * Description: On focus of an element, set its width to be auto, only if its auto width is greater than its original width.
 * Then on blur, return it back to what it was before.
 */

;(function ($, undefined) {

    var meerkat = window.meerkat;

    function initIe8SelectMenuAutoExpand() {
        // do nothing
    }

    function bindEvents($parent, selector) {
        // Only for IE8
        if (!meerkat.modules.performanceProfiling.isIE8()) {
            return;
        }

        $parent.on('focus', selector, function () {
            var el = $(this);
            el.data('width', el.width());
            el.width('auto');
            el.data('width-auto', $(this).width());
            // if "auto" width < start width, set to start width, otherwise set to new width
            if (el.data('width-auto') < el.data('width')) {
                el.width(el.data('width'));
            } else {
                el.width(el.data('width-auto') + 15);
            }
        }).on('blur', selector, function () {
            var el = $(this);
            el.width(el.data('width'));
            // make it reset
        });
    }

    meerkat.modules.register("ie8SelectMenuAutoExpand", {
        init: initIe8SelectMenuAutoExpand,
        bindEvents: bindEvents
    });

})(jQuery);