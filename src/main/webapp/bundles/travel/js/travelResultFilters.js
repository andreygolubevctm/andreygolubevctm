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
        $('input[name="luggageRangeSlider"]').change(function (value) {
            _displaySliderValue ("LUGGAGE", $(this).val());
            _updateTravelResults("LUGGAGE", parseInt($(this).val()));
        });

        // update the results as per the cancellation filter
        $('input[name="cancellationRangeSlider"]').change(function () {
            _displaySliderValue ("CXDFEE", $(this).val());
            _updateTravelResults("CXDFEE", parseInt($(this).val()));
        });

        // update the results as per the overseas medical filter
        $('input[name="overseasMedicalRangeSlider"]').change(function () {
            _displaySliderValue ("MEDICAL", $(this).val());
            _updateTravelResults("MEDICAL", parseInt($(this).val()));
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
                var coverType = $(this).data('ranking-filter');
                if (coverType == 'B') {
                    Results.model.isBasicTravelCover = true;
                } else {
                    Results.model.isBasicTravelCover = false;
                }
                _updateTravelResultsByCoverType(coverType);
            });
        });

        // show down arrow when the dropdown is hidden
        $('.dropdown').on('hide.bs.dropdown', function () {
            $(this).find(".icon").removeClass("icon-angle-up").addClass("icon-angle-down");
        });

        // toggle brands select all/none
        $('.brands-select-toggle').click(function () {
            var _providers = [];

            if ($(this).data('brands-toggle') == 'none') {
                $('[data-provider-code]').each(function (key, provider) {
                   _providers.push($(provider).data('provider-code'));
                   $(provider).prop('checked', false);
                });
                Results.model.travelFilters.PROVIDERS = _providers;
                $(this).data('brands-toggle', 'all');
                $(this).empty().text('Select all');
            } else {
                Results.model.travelFilters.PROVIDERS = [];
                $('[data-provider-code]').prop('checked', true);
                $(this).data('brands-toggle', 'none');
                $(this).empty().text('Select none');
            }

            _displayCustomResults(true);
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
        _displayCustomResults(true);
    }

    /**
     * update travel results by cover type
     * @param cover - cover type input
     * @private
     */
    function _updateTravelResultsByCoverType(cover) {
        var _coverTypeValues = {
            C: {
                LUGGAGE: 5000,
                CXDFEE: 20000,
                MEDICAL: 20000000
            },
            M: {
                LUGGAGE: 2500,
                CXDFEE: 5000,
                MEDICAL: 10000000
            },
            B: {
                LUGGAGE: 2500,
                CXDFEE: 5000,
                MEDICAL: 10000000
            }
        };

        var _filters = Results.model.travelFilters;
        _filters.LUGGAGE = _coverTypeValues[cover].LUGGAGE;
        _filters.CXDFEE = _coverTypeValues[cover].CXDFEE;
        _filters.MEDICAL = _coverTypeValues[cover].MEDICAL;

        // update luggage filter
        $('input[name="luggageRangeSlider"]').val(_filters.LUGGAGE);
        _displaySliderValue ("LUGGAGE", _filters.LUGGAGE);

        // update cancellation filter
        $('input[name="cancellationRangeSlider"]').val(_filters.CXDFEE);
        _displaySliderValue ("CXDFEE", _filters.CXDFEE);

        // update overseas medical filter
        $('input[name="overseasMedicalRangeSlider"]').val(_filters.MEDICAL);
        _displaySliderValue ("MEDICAL", _filters.MEDICAL);

        meerkat.modules.customRangeSlider.init();
        Results.model.travelFilters = _filters;
        _displayCustomResults(false);
    }

    /**
     * Display the slider value at the top of the slider
     * @param slider - which slider
     * @param value - value of that slider
     * @private
     */
    function _displaySliderValue (slider, value) {
        switch (slider) {
            case 'LUGGAGE':
                $('.luggage-range-value').empty().text('$' + Number(value).toLocaleString('en'));
                break;

            case 'CXDFEE':
                if (Number(value) == 30000) {
                    $('.cancellation-range-value').empty().text('Unlimited');
                } else {
                    $('.cancellation-range-value').empty().text('$' + Number(value).toLocaleString('en'));
                }
                break;

            case 'MEDICAL':
                if (Number(value) == 50000000) {
                    $('.overseas-medical-range-value').empty().text('Unlimited');
                } else {
                    $('.overseas-medical-range-value').empty().text('$' + Number(value / 1000000) + ' million');
                }
                break;
        }
    }

    /**
     * Update the results as per the excess value
     * @param value - accept the excess value
     */
    function _updateResultsByExcess(value) {
        Results.model.travelFilters.EXCESS = value;
        meerkat.modules.coverLevelTabs.resetTabResultsCount();
        meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_MODEL_UPDATE_BEFORE_FILTERSHOW);
        Results.model.filter(true, true);
        meerkat.modules.coverLevelTabs.updateTabCounts();

        if ($('[data-travel-filter="custom"]').hasClass('active')) {
            _displayCustomResults(true);
        }
    }

    /**
     * Display the custom filter results
     * @param customFilter - boolean value for custom filter
     * @private
     */
    function _displayCustomResults (customFilter) {
        Results.model.travelResultFilter(true, true);
        if (customFilter) {
            $('input[name="reset-filters-radio-group"]').prop('checked', false);
        }
        meerkat.modules.coverLevelTabs.buildCustomTab();
    }

    meerkat.modules.register("travelResultFilters", {
        init: init
    });
})(jQuery);