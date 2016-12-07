/**
 * Description: External documentation:
 */

(function($, undefined) {

    var meerkat =window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    function initBenefits() {
        $(document).ready(function() {

            // Only init if HEALTH... obviously...
            if (meerkat.site.vertical !== "health")
                return false;

            $('#tabs').on('click', '.nav-tabs a', function(e) {
                e.preventDefault();
                e.stopPropagation();

                $(this).tab('show');
            });
            $('.nav-tabs a:first').click();
        });

    }
    meerkat.modules.register("benefitsTab", {
        init : initBenefits
    });

})(jQuery);