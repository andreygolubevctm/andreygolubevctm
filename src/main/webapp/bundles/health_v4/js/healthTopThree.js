;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements;

    function initHealthTopThree() {
        var template = _.template($('#results-top-three-banner-template').html());
        if ($('.results-top-three-banner').length === 0) {
            $('#pageContent').prepend(template);
        }

        _setupFields();
        _eventSubscriptions();
    }

    function _setupFields() {
        $elements = {
            banner: $('.results-top-three-banner'),
            options: $('.results-top-three-banner .top-three-options'),
            deciding: $('.results-top-three-banner .top-three-deciding'),
            button: $('.results-top-three-banner button'),
            popularProducts: $(':input[name=health_popularProducts]')
        };
    }

    function _eventSubscriptions() {
        $elements.button.on('click', function() {
            $elements.popularProducts.val($(this).attr('data-popular-products'));
            meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
            meerkat.modules.healthResults.get();
        });
    }

    function show() {
        $elements.banner.removeClass('invisible');
        $elements.options.toggleClass('hidden', $elements.popularProducts.val() === 'Y');
        $elements.deciding.toggleClass('hidden', $elements.popularProducts.val() === 'N');
    }

    function hide() {
        $elements.banner.addClass('invisible');
    }

    function setPopularProducts() {
        $elements.popularProducts.val('N');
    }

    meerkat.modules.register('healthTopThree', {
        initHealthTopThree: initHealthTopThree,
        show: show,
        hide: hide,
        setPopularProducts: setPopularProducts
    });

})(jQuery);
