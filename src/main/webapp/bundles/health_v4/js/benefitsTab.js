/**
 * Description: External documentation:
 */

(function($, undefined) {

    var meerkat =window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        $elements = {};

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


        $elements = {
            benefitsOverlow: $('.benefitsOverflow'),
            extrasOverlay: $('.extrasOverlay'),
            hospitalOverlay: $('.hospitalOverlay')
        };

        _eventSubscription();
    }

    function _eventSubscription() {
        $elements.hospitalOverlay.hide();

        $elements.extrasOverlay.off().on('click', function displayExtrasBenefits() {
            $elements.benefitsOverlow.animate({'left': ($elements.extrasOverlay.width() * -1)}, 500, function onExtrasAnimateComplete(){
                $elements.extrasOverlay.hide();
                $elements.hospitalOverlay.show();
            });
        });

        $elements.hospitalOverlay.off().on('click', function displayHospitalBenefits() {
            $elements.benefitsOverlow.animate({'left': 0}, 500, function onHospitalAnimateComplete() {
                $elements.hospitalOverlay.hide();
                $elements.extrasOverlay.show();
            });
        });
    }

    meerkat.modules.register("benefitsTab", {
        init : initBenefits
    });

})(jQuery);