;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {};

    function initHealthRemoveAffixXS() {
        _setupFields();
        _eventSubscriptions();
        _addRequiredCssClasses();
    }

    function _setupFields() {
        $elements = {
            bodyElement: $('body'),
            headerElement: $('header.header-wrap div.header-top')
        };
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkat.modules.coupon.events.coupon.PADDING_TOP_CHANGED, function couponPaddingTopChanged(){
            $elements.bodyElement.css({'padding-top': 0 + 'px'});
        });
    }

    function _addRequiredCssClasses() {
        $elements.bodyElement.addClass("dontAffixXsBanners");
        $elements.headerElement.addClass("dontAffixXsBanners");
    }


    meerkat.modules.register('healthRemoveAffixXS', {
        init: initHealthRemoveAffixXS
    });

})(jQuery);