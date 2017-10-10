;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    function trigger() {
        $('<div class="sidebar-widget sidebar-widget-padded sidebar-widget-background-contained mobile-logo-container visible-xs"><h3>You&apos;re one step away from comparing cover!</h3><p>Find the right plan that suits you from one of our 15 partners</p><div class="logo-images-container"><div class="logo-panel collapsed">&nbsp;</div></div><div class="logo-panel-collapsed-link"><a href="javascript:;" >View all partners  <span class="icon-angle-down"></span></a></div><div class="logo-panel-link hidden"><a href="javascript:;" >hide <span class="icon-angle-up"></span></a></div></div>').insertBefore('#contactForm');
        $(".logo-panel-collapsed-link").click(function(){
            $('.logo-panel-link').removeClass('hidden');
            $('.logo-panel-collapsed-link').addClass('hidden');
            $('.logo-panel.collapsed').removeClass('collapsed');
        });
        $(".logo-panel-link").click(function(){
            $('.logo-panel-collapsed-link').removeClass('hidden');
            $('.logo-panel').addClass('collapsed');
            $('.logo-panel-link').addClass('hidden');
        });
    }

    meerkat.modules.register('healthMobileLogoBanner', {
        trigger: trigger
    });

})(jQuery);