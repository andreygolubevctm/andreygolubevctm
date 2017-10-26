(function ($) {
    function init () {

        // close dropdown only if outside is clicked
        $('.dropdown-menu').click(function(e) {
            e.stopPropagation();
        });

        // set the excess default
        $('#travel_filter_excess_200').trigger('click');

        // update the results as per the excess filter
        $('input[name="radio-group"]').change(function () {
           $('.selected-excess-value .filter-excess-value').text($(this).val());
            _updateResultsByExcess(parseInt($(this).data('excess')));
            $('#excessFilterDropdownBtn').dropdown('toggle');
        });

        // update the results as per the luggage filter
        $('input[name="luggageRangeSlider"]').change(function () {
           $('.luggage-range-value').empty().text('$' + Number($(this).val()).toLocaleString('en'));
            _updateTravelResults('LUGGAGE', parseInt($(this).val()));
        });

        // update the results as per the cancellation filter
        $('input[name="cancellationRangeSlider"]').change(function () {
            if (Number($(this).val()) == 30000) {
                $('.cancellation-range-value').empty().text('Unlimited');
            } else {
                $('.cancellation-range-value').empty().text('$' + Number($(this).val()).toLocaleString('en'));
            }
            _updateTravelResults('CXDFEE', parseInt($(this).val()));
        });

        // update the results as per the overseas medical filter
        $('input[name="overseasMedicalRangeSlider"]').change(function () {
            if (Number($(this).val()) == 50000000) {
                $('.overseas-medical-range-value').empty().text('Unlimited');
            } else {
                $('.overseas-medical-range-value').empty().text('$' + Number($(this).val() / 1000000) + ' million');
            }
            _updateTravelResults('MEDICAL', parseInt($(this).val()));
        });

        // display the filtered results
        $('.more-filters-results-btn').click(function () {
            $('#moreFiltersDropdownBtn').dropdown('toggle');
        });

        // update the results as per the providers
        $('.col-brand input[type="checkbox"]').change(function () {
            _updateTravelResults('PROVIDERS', $(this).data('provider-code'));
        });

        // show up arrow when the dropdown is shown
        $('.dropdown').on('show.bs.dropdown', function () {
            $(this).find(".icon").removeClass("icon-angle-down").addClass("icon-angle-up");
            $('input[name="reset-filters-radio-group"]').change(function () {
                var id = $(this).data('reset-filter-index');
                $('[data-clt-index="' + id + '"]').click();
                $('[data-clt-index="' + id + '"]').siblings().removeClass('active').end().addClass('active');
            });
        });

        // show down arrow when the dropdown is hidden
        $('.dropdown').on('hide.bs.dropdown', function () {
            $(this).find(".icon").removeClass("icon-angle-up").addClass("icon-angle-down");
        });
    }

    /**
     * Set the Result model with the travel filter values & call the travel filter function
     * @param filter - name of the filter
     * @param value - value of the filter
     */
    function _updateTravelResults (filter, value) {
        var _filters = Results.model.travelFilters;

        switch (filter) {
            case 'LUGGAGE':
                _filters.LUGGAGE = value;
                break;
            case 'CXDFEE':
                _filters.CXDFEE = value;
                break;
            case 'MEDICAL':
                _filters.MEDICAL = value;
                break;
            case 'PROVIDERS':
                if (_filters.PROVIDERS.indexOf(value) == -1) {
                    _filters.PROVIDERS.push(value);
                } else {
                    _filters.PROVIDERS.splice(_filters.PROVIDERS.indexOf(value), 1);
                }
                break;
        }
        Results.model.travelFilters = _filters;
        Results.model.travelResultFilter(true, true);
        meerkat.modules.coverLevelTabs.buildCustomTab();
        $('input[name="reset-filters-radio-group"]').prop('checked', false);
    }

    /**
     * Update the results as per the excess value
     * @param value - accept the excess value
     */
    function _updateResultsByExcess(value) {
        Results.model.travelFilters.EXCESS = value;
        Results.model.filter(true, true);

        if ($('[data-travel-filter="custom"]').hasClass('active')) {
            Results.model.travelResultFilter(true, true);
            meerkat.modules.coverLevelTabs.buildCustomTab();
        }
    }

    meerkat.modules.register("travelResultFilters", {
        init: init
    });
})(jQuery);