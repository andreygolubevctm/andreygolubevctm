;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            mobileFiltersMenu: {
                FOOTER_BUTTON_UPDATE: 'FOOTER_BUTTON_UPDATE'
            }
        },
        $elements = {};

    function initHealthRefineResultsMobileFunds() {
        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();

        return this;
    }

    function _setupElements() {
        $elements.providerExclude = $('#health_filter_providerExclude');
    }

    function _applyEventListeners() {
        $(document).on('click', '.refine-results-brands-toggle', function(e) {
            e.preventDefault();

            $(':input[name=health_refine_results_brands]').prop('checked', $(this).attr('data-toggle') == "true");
            meerkat.messaging.publish(moduleEvents.mobileFiltersMenu.FOOTER_BUTTON_UPDATE);
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.refineResults.REFINE_RESULTS_OPENED, function () {
            // loop through selected funds
            var providerExcludedArr = $elements.providerExclude.val().split(',');
            $(':input[name=health_refine_results_brands]').each(function() {
                $(this).prop('checked', !_.contains(providerExcludedArr, $(this).val()));
            });
        });

        meerkat.messaging.subscribe(meerkatEvents.refineResults.REFINE_RESULTS_FOOTER_BUTTON_UPDATE_CALLBACK, function() {
            var excluded = [];

            $(':input[name=health_refine_results_brands]').each(function () {
                if (!$(this).prop('checked')) {
                    excluded.push($(this).val());
                }
            });

            $elements.providerExclude.val(excluded.join(','));
        });
    }

    function getFundsText() {
        var numBrands = $(':input[name=health_refine_results_brands]').length,
            numBrandsChecked = $(':input[name=health_refine_results_brands]:checked').length;

        return numBrands === numBrandsChecked ? 'All Funds' : numBrandsChecked + ' Brands selected';
    }

    meerkat.modules.register('healthRefineResultsMobileFunds', {
        initHealthRefineResultsMobileFunds: initHealthRefineResultsMobileFunds,
        events: moduleEvents,
        getFundsText: getFundsText
    });

})(jQuery);