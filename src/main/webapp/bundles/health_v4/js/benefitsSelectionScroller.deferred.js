/**
 * Description: External documentation:
 */

(function($, undefined) {

    var meerkat =window.meerkat,
        $elements = { };

    function init() {
        $elements = {
            scroller: $('.benefitsScroller'),
            benefitsSection: $('fieldset.mainBenefitHeading'),
            extrasBenefitsContainer: $('.ExtrasBenefitsContainer'),
            headerTopFixed: $('.header-top.navMenu-row-fixed'),
            progressBarAffix: $('.progress-bar-row.navbar-affix')
        };

        _eventsSubscription();
    }

    function _eventsSubscription() {
        $elements.scroller.on('click', 'a', function scrollToBenefits() {
            _scroll();
        });
    }

    function _scroll(benefit) {
        var isXS = (meerkat.modules.deviceMediaState.get() === 'xs'),
            extraHeight = (meerkat.modules.deviceMediaState.get() === 'lg') ? $elements.progressBarAffix.find('li').outerHeight() : 0,
            offsetHeight = $elements[isXS ? 'headerTopFixed' : 'progressBarAffix'].outerHeight() + extraHeight,
            scrollTop = $elements[isXS && benefit === 'extras' ? 'extrasBenefitsContainer' : 'benefitsSection'].offset().top - offsetHeight;

        $('html,body').animate({
            scrollTop: scrollTop
        }, 500);
    }

    function triggerScroll(benefit) {
        _scroll(benefit);
    }

    meerkat.modules.register("benefitsSelectionScroller", {
        init: init,
        triggerScroll: triggerScroll
    });

})(jQuery);