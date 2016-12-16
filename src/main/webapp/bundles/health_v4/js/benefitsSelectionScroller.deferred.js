/**
 * Description: External documentation:
 */

(function($, undefined) {

    var meerkat =window.meerkat,
        $elements = { };

    function init() {
        $elements = {
            scroller: $('.benefitsScroller'),
            benefitsSection: $('fieldset.mainBenefitHeading')
        };

        _eventsSubscription();
    }

    function _eventsSubscription() {
        $elements.scroller.on('click', 'a', function scrollToBenefits(){
            $('html,body').animate({scrollTop: ($elements.benefitsSection.offset().top - $elements.benefitsSection.height())}, 500);
        });
    }

    meerkat.modules.register("benefitsSelectionScroller", {
        init: init
    });

})(jQuery);