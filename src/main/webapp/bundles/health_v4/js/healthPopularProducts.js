;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements,
        _templates = {
            banner: '#results-popular-products-banner-template',
            tag: '#results-popular-products-tag-template'
        },
        _tagHTML = '',
        _isEnabled = false;

    function initHealthPopularProducts() {
        $(document).ready(function() {
            _isEnabled = meerkat.site.showPopularProducts;

            if (!isEnabled()) return;

            _setupTemplates();
            _setupFields();
            _eventSubscriptions();
        });
    }

    function isEnabled() {
        return _isEnabled;
    }

    function _setupTemplates() {
        var template = _.template($(_templates.banner).html());
        if ($('.results-popular-products-banner').length === 0) {
            $('#pageContent').prepend(template);
        }
        _tagHTML = _.template($(_templates.tag).html());
    }

    function _setupFields() {
        $elements = {
            banner: $('.results-popular-products-banner'),
            options: $('.results-popular-products-banner .popular-products-options'),
            deciding: $('.results-popular-products-banner .popular-products-deciding'),
            button: $('.results-popular-products-banner button'),
            popularProducts: $(':input[name=health_popularProducts]')
        };
    }

    function _eventSubscriptions() {
        $elements.button.on('click', function() {
            setPopularProducts($(this).attr('data-popular-products'));
            meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
            meerkat.modules.healthResults.get();
        });
    }

    function show() {
        if (isEnabled()) {
            $elements.banner.removeClass('invisible');
            $elements.options.toggleClass('hidden', $elements.popularProducts.val() === 'Y');
            $elements.deciding.toggleClass('hidden', $elements.popularProducts.val() === 'N');
        }
    }

    function hide() {
        if (isEnabled()) {
            $elements.banner.addClass('invisible');
        }
    }

    function setPopularProducts(value) {
        if (isEnabled()) {
            $elements.popularProducts.val(value);
        }
    }

    function injectTag($resultRow) {
        if (isEnabled()) {
            $resultRow.addClass('result-popular-products').prepend(_tagHTML);
        }
    }

    meerkat.modules.register('healthPopularProducts', {
        initHealthPopularProducts: initHealthPopularProducts,
        isEnabled: isEnabled,
        show: show,
        hide: hide,
        setPopularProducts: setPopularProducts,
        injectTag: injectTag
    });

})(jQuery);
