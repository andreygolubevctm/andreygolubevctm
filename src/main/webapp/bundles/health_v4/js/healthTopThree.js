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
            optionsBtn: $('.results-top-three-banner .top-three-options button'),
            deciding: $('.results-top-three-banner .top-three-deciding'),
            decidingBtn: $('.results-top-three-banner .top-three-deciding button')
        };
    }

    function _eventSubscriptions() {
        $elements.optionsBtn.on('click', function() {
            $elements.options.addClass('hidden');
            $elements.deciding.removeClass('hidden');
        });

        $elements.decidingBtn.on('click', function() {
            $elements.options.removeClass('hidden');
            $elements.deciding.addClass('hidden');
        });
    }

    function show() {
        $elements.banner.removeClass('invisible');
        $elements.options.removeClass('hidden');
        $elements.deciding.addClass('hidden');
    }

    function hide() {
        $elements.banner.addClass('invisible');
    }

    meerkat.modules.register('healthTopThree', {
        initHealthTopThree: initHealthTopThree,
        show: show,
        hide: hide
    });

})(jQuery);
