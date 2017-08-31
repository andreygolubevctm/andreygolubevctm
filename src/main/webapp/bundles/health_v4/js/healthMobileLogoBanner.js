;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    function trigger() {
        $('<div class="sidebar-widget sidebar-widget-padded sidebar-widget-background-contained mobile-logo-container visible-xs" style="border: 1px solid #ddd; background-color: #fff; margin-bottom: 15px;"><h3 style="margin-top: 0; color: #008284;">You&apos;re one step away from comparing cover!</h3><p>Find the right plan that suits you from one of our 16 partners</p><img class="logoPanel hidden" src="/static/health/images/partner-logos.png" width="231px" height="262px"><img class="logoPanelCollapsed" src="/static/health/images/partner-logos-collapsed.png" width="231px" height="81px"><p class="logoPanelCollapsedLink"><a href="javascript:;" >View all partners  <span class="icon-angle-down"></span></a></p><p class="logoPanelLink hidden"><a href="javascript:;" >hide <span class="icon-angle-up"></span></a></p></div>').insertBefore('#contactForm');
        $(".logoPanelCollapsedLink").click(function(){
            $('.logoPanel, .logoPanelLink').removeClass('hidden');
            $('.logoPanelCollapsedLink, .logoPanelCollapsed').addClass('hidden');
        });
        $(".logoPanelLink").click(function(){
            $('.logoPanelCollapsedLink, .logoPanelCollapsed').removeClass('hidden');
            $('.logoPanel, .logoPanelLink').addClass('hidden');
        });
    }

    meerkat.modules.register('healthMobileLogoBanner', {
        trigger: trigger
    });

})(jQuery);