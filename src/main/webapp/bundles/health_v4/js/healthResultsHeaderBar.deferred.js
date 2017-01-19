;(function ($, undefined) {

    var meerkat = window.meerkat;

    function init() {
        $(document).ready(function () {
            var settings = {
                disableOnXs: false,
                navbarSelector: '.results-control-container',
                getStartOffset: function () {
                    var topOffset;
                    switch (meerkat.modules.deviceMediaState.get()) {
                        case 'xs':
                            topOffset = 40;
                            break;
                        default:
                            topOffset = $('.resultsOverflow').offset().top;
                            break;
                    }
                    return topOffset;
                }
            };
            meerkat.modules.resultsHeaderBar.initResultsHeaderBar(settings);
        });

    }

    meerkat.modules.register('healthResultsHeaderBar', {
        init: init
    });

})(jQuery);