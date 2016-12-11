/**
 * Description: External documentation:
 */

(function($, undefined) {

    var meerkat =window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        $elements = {},
        $defaultSelections = {
            all: 'all',
            family: ''
        };

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
        _registerXSBenefitsSlider();
        _registerBenefitsCounter();
    }

    function _registerXSBenefitsSlider() {
        $elements.hospitalOverlay.hide();

        $elements.extrasOverlay.off().on('click', function displayExtrasBenefits() {
            $elements.benefitsOverlow.animate({'left': ($elements.extrasOverlay.width() * -1)}, 500, function onExtrasAnimateComplete(){
                _setOverlayLabelCount($elements.hospitalOverlay, meerkat.modules.benefitsModel.getHospitalCount());
                $elements.extrasOverlay.hide();
                $elements.hospitalOverlay.show();
            });
        });

        $elements.hospitalOverlay.off().on('click', function displayHospitalBenefits() {
            $elements.benefitsOverlow.animate({'left': 0}, 500, function onHospitalAnimateComplete() {
                _setOverlayLabelCount($elements.extrasOverlay, meerkat.modules.benefitsModel.getExtrasCount());
                $elements.hospitalOverlay.hide();
                $elements.extrasOverlay.show();
            });
        });

    }

    function _registerBenefitsCounter() {
        $('.GeneralHealth_container, .Hospital_container').on('click', 'label:not(.help_icon)', function(){
            var benefitType = ($(this).closest('.Hospital_container').length === 1 ? 'hospital' : 'extras');
            if ($(this).prev('input').is(':checked') === false) {
                meerkat.modules.benefitsModel.increaseBenefitCount(benefitType);
            } else {
                meerkat.modules.benefitsModel.decreaseBenefitCount(benefitType);
            }
        });
    }

    function _setOverlayLabelCount($overlay, count) {
        $overlay.find('span').text(count);
    }

    function setDefaults(list) {

    }

    meerkat.modules.register("benefitsTab", {
        init : initBenefits
    });

})(jQuery);