;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var $elements = {},
        _hasPromo,
        _placementClassName = {
            top: '.banner-top-container',
            tile: '.banner-tile-container'
        };

    function init() {
        $elements = {
            bannerTop: $('.banner-top-container'),
            showPromos: $('.banner-show-promotions')
        };

        _applyEventListeners();
    }

    function _applyEventListeners() {
        $elements.showPromos.on('click', function() {
            $elements.bannerTop.find('.marketing-content-container, .coupon-banner-container').show();
            $elements.showPromos.hide();
        });
    }

    function render(banner, placementOverride) {
        var placement = placementOverride,
            $banner = null,
            className = '',
            content = '';

        switch(banner.type) {
            case 'coupon':
                _hasPromo = _hasPromo || meerkat.modules.marketingContent.hasContent();
                placement = !_.isUndefined(placement) ? placement :
                    (_hasPromo ? 'tile' : (banner.placement ? banner.placement : 'top'));
                $banner = $(_placementClassName[placement]);
                className = 'coupon-' + (placement === 'top' ? 'banner' : 'tile') + '-container';
                $banner.find('.'+className).remove();
                content = '<div class="'+className+'">'+banner.content[placement]+'</div>';
                break;

            case 'marketing-content':
                placement = !_.isUndefined(placement) ? placement : 'top';
                $banner = $(_placementClassName[placement]);
                content = '<div class="marketing-content-container"><iframe src="' + banner.url + '" scrolling="no"></iframe></div>';
                break;
        }

        $banner.append(content);

        if (banner.type === 'coupon' && meerkat.modules.deviceMediaState.get() === 'xs' && _hasPromo && $('.coupon-banner-container').length === 0) {
            render(banner, 'top');
        }
    }

    function xsLayout() {
        if (meerkat.modules.deviceMediaState.get() === 'xs') {
            $elements.bannerTop.find('.marketing-content-container, .coupon-banner-container').hide();
            $elements.showPromos.show();
        }
    }

    meerkat.modules.register('bannerPlacement', {
        init: init,
        render: render,
        xsLayout: xsLayout,
        events: moduleEvents
    });
})(jQuery);