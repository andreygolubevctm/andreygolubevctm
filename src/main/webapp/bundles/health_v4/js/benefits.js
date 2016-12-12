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
        _registerXSBenefitsSlider();
        _registerBenefitsCounter();
    }

    function _registerXSBenefitsSlider() {
        $elements.hospitalOverlay.hide();

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function extrasOverlayEnterXsState() {
            $elements.extrasOverlay.show();
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function extrasOverlayLeaveXsState() {
            $elements.extrasOverlay.hide();
        });

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
            var $this = $(this);
            meerkat.modules.benefitsModel.setIsHospital($this.closest('.Hospital_container').length === 1);

            if ($this.prev('input').is(':checked') === false) {
                meerkat.modules.benefitsModel.addBenefit($this.prev('input').attr('id'));
            } else {
                meerkat.modules.benefitsModel.removeBenefit($this.prev('input').attr('id'));
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