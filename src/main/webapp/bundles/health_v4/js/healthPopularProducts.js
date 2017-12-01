;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements,
        _templates = {
            banner: '#results-popular-products-banner-template',
            tag: '#results-popular-products-tag-template'
        },
        _tagHTML = '',
        _isEnabled = false,
        _tagShown = false,
        _count = 0,
        _classNames = {
            popularProducts: 'result-popular-products',
            hasPopularProducts: 'result-has-popular-products',
            showPopularProductsTag: 'results-show-popular-products-tag'
        };

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
            popularProducts: $(':input[name=health_popularProducts]'),
            resultsContainer: $('.resultsContainer'),
            purchased: $(':input[name=health_popularProducts_purchased]')
        };
    }

    function _eventSubscriptions() {
        $elements.button.on('click', function() {
            var popularProducts = $(this).attr('data-popular-products');

            if (popularProducts === 'Y' && !_tagShown) _showTag();

            setPopularProducts(popularProducts);
            meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
            meerkat.modules.healthResults.get();
        });
    }

    function _showTag() {
        _tagShown = true;
        $elements.resultsContainer.addClass(_classNames.showPopularProductsTag);
    }

    function show() {
        if (isEnabled()) {
            $elements.banner.removeClass('invisible');
            $elements.options.toggleClass('hidden', $elements.popularProducts.val() === 'Y');
            $elements.deciding.toggleClass('hidden', $elements.popularProducts.val() === 'N');

            if (_count > 0) {
                $('.result-row').addClass(_classNames.hasPopularProducts);
            }
        }
    }

    function hide() {
        if (isEnabled()) {
            $elements.banner.addClass('invisible');
            _count = 0;
        }
    }

    function setPopularProducts(value) {
        if (isEnabled()) {
            $elements.popularProducts.val(value);
        }
    }

    function injectTag($resultRow, rankPos) {
        if (isEnabled()) {
            $resultRow.addClass(_classNames.popularProducts).prepend(_tagHTML({'rankPos': rankPos}));
            _count++;
        }
    }

    function updatePurchased() {
        if (isEnabled()) {
            // Update if popular products tag has been shown
            if (_tagShown) {
                var selectedProduct = Results.getSelectedProduct();

                // Set value to be popular products rank otherwise 0 for non popular product
                $elements.purchased.val(selectedProduct.info.popularProduct ? selectedProduct.info.popularProductsRank : 0);
            }
        }
    }

    meerkat.modules.register('healthPopularProducts', {
        initHealthPopularProducts: initHealthPopularProducts,
        isEnabled: isEnabled,
        show: show,
        hide: hide,
        setPopularProducts: setPopularProducts,
        injectTag: injectTag,
        updatePurchased: updatePurchased
    });

})(jQuery);
