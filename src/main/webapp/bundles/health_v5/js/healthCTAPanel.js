;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    function trigger() {
        $('body').addClass('ctaPanel-active');

        $('.cta-panel').removeClass('hidden');
        $('#contactForm .campaign-tile-container').addClass('hidden');
    }

    meerkat.modules.register('healthCTAPanel', {
        trigger: trigger
    });

})(jQuery);