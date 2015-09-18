/**
 * Description: Moved from phone_number.tag
 */

;(function ($) {

    function init() {
        $(document).ready(function ($) {
            $(".contact_telno").on("focusout", function () {
                var $el = $(this);
                var $hiddenEl = $("#" + $el.attr('id').substring(0, $el.attr('id').length - 5));
                $hiddenEl.val($el.val().replace(/[^0-9]+/g, ''));
            }).each(function () {
                // Remove fake placeholders (for IE8/9) if preloaded data
                meerkat.modules.placeholder.invalidatePlaceholder($(this));
            });

        });
    }

    meerkat.modules.register("cleanPhoneNumbers", {
        init: init
    });

})(jQuery);