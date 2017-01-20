;(function ($, undefined) {

    var meerkat = window.meerkat;

    function init() {
        $(document).ready(function () {
            var settings = {
                disableOnXs: true,
                navbarSelector: '.results-control-container',
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