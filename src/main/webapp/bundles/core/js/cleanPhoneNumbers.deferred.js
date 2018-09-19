/**
 * Description: Moved from phone_number.tag
 */

;(function ($) {

    function init() {
        $(document).ready(function ($) {
            $(".contact_telno").on("focusout", function () {
                var $el = $(this);
                var $hiddenEl = $("#" + $el.attr('id').substring(0, $el.attr('id').length - 5));
                var phone = meerkat.modules.phoneFormat.cleanNumber($el.val());
                // If number is invalid then don't popoulate the hidden field with it
                var type = meerkat.modules.phoneFormat.getPhoneType(phone);
                if(
                    ($el.hasClass('mobile') && type !== 'mobile') ||
                    ($el.hasClass('landline') && type !== 'landline') ||
                    ($el.hasClass('flexiphone') && type === null)) {
                    phone = "";
                }
                $hiddenEl.val(phone);
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