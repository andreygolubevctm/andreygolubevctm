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
        _eventSubscriptions();
    }

    function _applyEventListeners() {
        $elements.showPromos.on('click', function() {
            $elements.bannerTop.find('.marketing-content-container, .coupon-banner-container').show();
            $elements.showPromos.hide();
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function (event) {
            if (meerkat.modules.deviceMediaState.get() === 'xs' && event.hash.indexOf('contact') !== -1) {
                $elements.bannerTop.find('.marketing-content-container, .coupon-banner-container').hide();
                $elements.showPromos.show();
            }
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
                content = '<iframe class="marketing-content-container" src="' + banner.url + '"></iframe>';
                break;
        }

        $banner.append(content);

        if (banner.type === 'coupon' && meerkat.modules.deviceMediaState.get() === 'xs' && _hasPromo && $('.coupon-banner-container').length === 0) {
            render(banner, 'top');
        }
    }

    meerkat.modules.register('bannerPlacement', {
        init: init,
        render: render,
        events: moduleEvents
    });
})(jQuery);