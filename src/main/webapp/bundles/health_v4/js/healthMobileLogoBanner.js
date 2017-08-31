;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    function trigger() {
        $('<div class="sidebar-widget sidebar-widget-padded sidebar-widget-background-contained mobile-logo-container visible-xs" style="border: 1px solid #ddd; background-color: #fff; margin-bottom: 15px;"><h3>You&apos;re one step away from comparing cover!</h3><p>Find the right plan that suits you from one of our 16 partners</p><img class="logo-panel hidden" src="/static/health/images/partner-logos.png" width="231px" height="262px"><img class="logo-panel-collapsed" src="/static/health/images/partner-logos-collapsed.png" width="231px" height="81px"><div class="logo-panel-collapsed-link"><a href="javascript:;" >View all partners  <span class="icon-angle-down"></span></a></div><div class="logo-panel-link hidden"><a href="javascript:;" >hide <span class="icon-angle-up"></span></a></div></div>').insertBefore('#contactForm');
        $(".logo-panel-collapsed-link").click(function(){
            $('.logo-panel, .logo-panel-link').removeClass('hidden');
            $('.logo-panel-collapsed-link, .logo-panel-collapsed').addClass('hidden');
        });
        $(".logo-panel-link").click(function(){
            $('.logo-panel-collapsed-link, .logo-panel-collapsed').removeClass('hidden');
            $('.logo-panel, .logo-panel-link').addClass('hidden');
        });
    }

    meerkat.modules.register('healthMobileLogoBanner', {
        trigger: trigger
    });

})(jQuery);