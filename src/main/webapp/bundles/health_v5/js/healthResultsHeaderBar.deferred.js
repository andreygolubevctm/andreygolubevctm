;(function ($, undefined) {

    var meerkat = window.meerkat;

    function init() {
        $(document).ready(function () {
            var settings = {
                disableOnXs: false,
                navbarSelector: '.results-control-container',
                whilePaginatingOffset: -1,
                removeAffixXs: true,
                getStartOffset: function () {
                    return $('.resultsOverflow').offset().top;
                }
            };
            meerkat.modules.resultsHeaderBar.initResultsHeaderBar(settings);
        });

    }

    meerkat.modules.register('healthResultsHeaderBar', {
        init: init
    });

})(jQuery);