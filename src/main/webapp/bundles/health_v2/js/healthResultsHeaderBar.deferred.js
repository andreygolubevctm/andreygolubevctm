;(function ($, undefined) {

    var meerkat = window.meerkat;

    function init() {
        $(document).ready(function () {
            var settings = {
                disableOnXs: false,
                getStartOffset: function () {
                    var topOffset = 0;
                    switch (meerkat.modules.deviceMediaState.get()) {
                        case 'lg':
                            topOffset = 160;
                            break;
                        case 'md':
                            topOffset = 150;
                            break;
                        case 'sm':
                            topOffset = 150;
                            break;
                        case 'xs':
                            topOffset = 120;
                            break;
                    }
                    return $('.resultsOverflow').offset().top + topOffset;
                }
            };
            meerkat.modules.resultsHeaderBar.initResultsHeaderBar(settings);
        });

    }

    meerkat.modules.register('healthResultsHeaderBar', {
        init: init
    });

})(jQuery);