;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    function trigger() {
        $('body').addClass('ctaPanel-active');
    }

    meerkat.modules.register('healthCTAPanel', {
        trigger: trigger
    });

})(jQuery);