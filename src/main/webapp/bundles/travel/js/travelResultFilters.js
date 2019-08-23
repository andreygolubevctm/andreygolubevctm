(function ($) {

    var sortSettings = {
            title: '',
            footerButtonCloseText: 'Back to results',
            template: $('.sortbar-container')
        },
        editDetailsSettings = {
            title: '',
            footerButtonCloseText: 'Back to results',
            template: $('.resultsSummary')
        },
        meerkatEvents = meerkat.modules.events,
        mobileHamBurgerContent = null,
        $elements = {},
        $init = {},
        MobileFiltersMenu = null,
        state = null;
    
    var toggleTimeout;
    function init() {
        _setupElements();
        _applyEventListeners();
        MobileFiltersMenu = meerkat.modules.mobileFiltersMenu.initMobileFiltersMenu(sortSettings);
        MobileFiltersMenu.updateMenuBodyHTML(_.template(mobileHamBurgerContent));
        state = meerkat.modules.deviceMediaState.get();
    }

    function _setupElements() {
        $init = {
            cover: null
        };

        $elements = {
            sortBtn: $('.sort-results-travel-mobile'),
            editDetailsBtn: $('.edit-details-travel-mobile')
        };

        mobileHamBurgerContent =
            '<div class="sortbar-mobile">' +
                sortSettings.template.html() +
            '</div>' +
            '<div class="travelQuoteSummary">' +
                '<h5>Your quote is based on</h5>' +
                editDetailsSettings.template.html() +
                '<a href="javascript:;" data-slide-control="previous">' +
                    '<span class="icon icon-pencil"></span> Edit your details' +
                '</a>' +
            '</div>';
    }

    function _applyEventListeners() {
        // click the sort button in mobile navbar
        $elements.sortBtn.on('click', function (e) {
            if ($(this).hasClass('disabled')) return;
            MobileFiltersMenu.open();
            meerkat.modules.travelSorting.initSorting(true);
            $('.mobile-filters-menu__header-title').text('Sort results');
            // hack to change color of back button in mobile menu
            $('.mobile-filters-menu__footer button').addClass('btn-call');
            $('.sortbar-mobile').show();
            $('.travelQuoteSummary').hide();
        });

        // click the edit details button in mobile navbar
        $elements.editDetailsBtn.on('click', function (e) {
            if ($(this).hasClass('disabled')) return;
            MobileFiltersMenu.open();
            $('.mobile-filters-menu__header-title').text('Edit Details');
            // hack to change color of back button in mobile menu
            $('.mobile-filters-menu__footer button').addClass('btn-call');
            $('.sortbar-mobile').hide();
            $('.travelQuoteSummary').show();
        });

        // close dropdown only if outside is clicked
        $('.dropdown-menu').click(function (e) {
            if (e.target.className !== 'help-icon icon-info') {
                e.stopPropagation();
            }
        });

        // set the excess default
        $('#travel_filter_excess_200').trigger('click');

        // update the results as per the excess filter
        $('input[name="radio-group"]').change(function () {
            var $excessFilterDropdownBtn = $('#excessFilterDropdownBtn');
            $excessFilterDropdownBtn.find('.filter-excess-value').text($(this).val());
            _updateResultsByExcess(parseInt($(this).data('excess')));
            $excessFilterDropdownBtn.dropdown('toggle');
        });

        $('input[name="amt-toggle"]').change(function () {
            var $amtFilterDropdownBtn = $('#amtFilterDropdownBtn');
            $amtFilterDropdownBtn.find('.filter-excess-value').text($(this).data('label'));
            $amtFilterDropdownBtn.dropdown('toggle');
            _toggleAmtType($(this).val());
        });

        // update the results as per the medical conditions checkbox filter
        $('input[name="medicalCondsAssessedCheckbox"]').change(function () {
            _updateTravelResults("CONDITIONS", this.checked);
        });
        
        $('input[name="luggageRangeSlider"]').on('input', function() {
            _displaySliderValue("LUGGAGE", $(this).val());
        });

        // update the results as per the luggage filter
        $('input[name="luggageRangeSlider"]').change(function (value) {
            _displaySliderValue("LUGGAGE", $(this).val());
            _updateTravelResults("LUGGAGE", parseInt($(this).val()));
        });

        // update the results as per the cancellation filter
        $('input[name="cancellationRangeSlider"]').change(function () {
            _displaySliderValue("CXDFEE", $(this).val());
            _updateTravelResults("CXDFEE", parseInt($(this).val()));
        });
        
        $('input[name="cancellationRangeSlider"]').on('input', function() {
            _displaySliderValue("CXDFEE", $(this).val());
        });

        // update the results as per the overseas medical filter
        $('input[name="overseasMedicalRangeSlider"]').change(function () {
            _displaySliderValue("MEDICAL", $(this).val());
            _updateTravelResults("MEDICAL", parseInt($(this).val()));
        });
        
        $('input[name="overseasMedicalRangeSlider"]').on('input', function() {
            _displaySliderValue("MEDICAL", $(this).val());
        });

        // update the results as per the rental vehicle filter
        $('input[name="rentalVehicleRangeSlider"]').change(function () {
            _displaySliderValue("RENTALVEHICLE", $(this).val());
            _updateTravelResults("RENTALVEHICLE", parseInt($(this).val()));
        });

        $('input[name="rentalVehicleRangeSlider"]').on('input', function() {
            _displaySliderValue("RENTALVEHICLE", $(this).val());
        });

        // display the filtered results
        $('.more-filters-results-btn').click(function () {
            $('#moreFiltersDropdownBtn').dropdown('toggle');
            if (['xs', 'sm', 'md'].indexOf(state) !== -1) {
                Results.model.travelResultFilter(true, true, ($init.cover === 'B' ? false : true));
                meerkat.modules.coverLevelTabs.buildCustomTab();
            }
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
                $init.cover = coverType;
                $('[data-travel-filter="custom-mobile"]').prop("checked", true);
                _updateTravelResultsByCoverType(coverType);
            });
        });

        // show down arrow when the dropdown is hidden
        $('.dropdown').on('hide.bs.dropdown', function () {
            $(this).find(".icon").removeClass("icon-angle-up").addClass("icon-angle-down");
        });

        // mobile brands show/hide
        $('.filter-brands-toggle').click(function () {
            if (!$('.filter-brands-container').is(':visible')) {
                $('.filter-brands-container').show();
                $(this).find('.icon-brand').removeClass('icon-angle-down').addClass('icon-angle-up');
            } else {
                $('.filter-brands-container').hide();
                $(this).find('.icon-brand').removeClass('icon-angle-up').addClass('icon-angle-down');
            }
        });

        // toggle brands select all/none
        $('.brands-select-toggle').on("click", function () {
            clearTimeout(toggleTimeout);
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

            toggleTimeout = setTimeout(function () {
                _displayCustomResults(true);
            }, 1000);

        });
    }

    /**
     * Set the Result model with the travel filter values & call the travel filter function
     * @param filter - name of the filter
     * @param value - value of the filter
     */
    function _updateTravelResults(filter, value) {
        var _filters = Results.model.travelFilters;

        switch (filter) {
            case 'CONDITIONS':
                _filters.CONDITIONS = value;
                Results.model.travelFilters = _filters;
                _displayCustomResults(true);
                break;
            case 'LUGGAGE':
                _filters.LUGGAGE = value;
                Results.model.travelFilters = _filters;
                _displayCustomResults(true);
                break;
            case 'CXDFEE':
                _filters.CXDFEE = value;
                Results.model.travelFilters = _filters;
                _displayCustomResults(true);
                break;
            case 'MEDICAL':
                _filters.MEDICAL = value;
                Results.model.travelFilters = _filters;
                _displayCustomResults(true);
                break;
            case 'RENTALVEHICLE':
                _filters.RENTALVEHICLE = value;
                Results.model.travelFilters = _filters;
                _displayCustomResults(true);
                break;
            case 'PROVIDERS':
                if (_filters.PROVIDERS.indexOf(value) == -1) {
                    _filters.PROVIDERS.push(value);
                } else {
                    _filters.PROVIDERS.splice(_filters.PROVIDERS.indexOf(value), 1);
                }
                Results.model.travelFilters = _filters;
                _displayCustomResults(true);

                var TOTAL_PROVIDERS = 28;

                if(_filters.PROVIDERS.length > 0 && _filters.PROVIDERS.length < TOTAL_PROVIDERS) {
                    $('.brands-select-toggle').data('brands-toggle', 'none');
                    $('.brands-select-toggle').empty().text('Select none');
                }else{
                    $('.brands-select-toggle').data('brands-toggle', 'all');
                    $('.brands-select-toggle').empty().text('Select all');
                }
                break;
        }
    }

    /**
     * update travel results by cover type
     * @param cover - cover type input
     * @private
     */
    function _updateTravelResultsByCoverType(cover) {
        var destination = $('#travel_destination').val();
        // when we're on AMT (which didn't have filters before) - the cover string passed in has an extra char, removing so the obj matches up
        cover.length > 1 ? cover = cover.slice(0, cover.length-1) : cover;

        var _coverTypeValues = {
            C: {
                LUGGAGE: 5000,
                CXDFEE: destination === 'AUS' ? 10000 : 20000,
                MEDICAL: 20000000,
                RENTALVEHICLE: 0
            },
            M: {
                LUGGAGE: 2500,
                CXDFEE: 5000,
                MEDICAL: 10000000,
                RENTALVEHICLE: 0
            },
            B: {
                LUGGAGE: 0,
                CXDFEE: 0,
                MEDICAL: 5000000,
                RENTALVEHICLE: 0
            }
        };

        var _filters = Results.model.travelFilters;
        _filters.CONDITIONS = _coverTypeValues[cover].CONDITIONS;
        _filters.LUGGAGE = _coverTypeValues[cover].LUGGAGE;
        _filters.CXDFEE = _coverTypeValues[cover].CXDFEE;
        _filters.MEDICAL = _coverTypeValues[cover].MEDICAL;
        _filters.RENTALVEHICLE = _coverTypeValues[cover].RENTALVEHICLE;

        // update medical conditions assessed filter
        $('input[name="medicalCondsAssessedCheckbox"]').prop("checked", _filters.CONDITIONS);

        // update luggage filter
        $('input[name="luggageRangeSlider"]').val(_filters.LUGGAGE);
        _displaySliderValue("LUGGAGE", _filters.LUGGAGE);

        // update cancellation filter
        $('input[name="cancellationRangeSlider"]').val(_filters.CXDFEE);
        _displaySliderValue("CXDFEE", _filters.CXDFEE);

        // update overseas medical filter
        $('input[name="overseasMedicalRangeSlider"]').val(_filters.MEDICAL);
        _displaySliderValue("MEDICAL", _filters.MEDICAL);

        // update overseas medical filter
        $('input[name="rentalVehicleRangeSlider"]').val(_filters.RENTALVEHICLE);
        _displaySliderValue("RENTALVEHICLE", _filters.RENTALVEHICLE);

        meerkat.modules.customRangeSlider.init();
        Results.model.travelFilters = _filters;
        _displayCustomResults(cover === 'B' ? false : true);
    }

    /**
     * Display the slider value at the top of the slider
     * @param slider - which slider
     * @param value - value of that slider
     * @private
     */
    function _displaySliderValue(slider, value) {
        switch (slider) {
            case 'LUGGAGE':
                $('.luggage-range-value').empty().text('$' + Number(value).toLocaleString('en'));
                break;

            case 'CXDFEE':
                $('.cancellation-range-value').empty().text('$' + Number(value).toLocaleString('en'));
                break;

            case 'MEDICAL':
                $('.overseas-medical-range-value').empty().text('$' + Number(value / 1000000) + ' million');
                break;

            case 'RENTALVEHICLE':
                $('.rental-vehicle-range-value').empty().text('$' + Number(value).toLocaleString('en'));
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

        if (meerkat.modules.coverLevelTabs.getActiveTabIndex() === -1) {
            Results.model.travelResultFilter(true, true, ($init.cover === 'B' ? false : true));
        } else {
            Results.model.filterUsingExcess(true, true);
        }

        meerkat.modules.coverLevelTabs.updateTabCounts();
    }

    /**
     * Toggle AMT between Domestic and International
     * @param {String} type - AMT Type, either 'D' (Domestic) or 'I' (International)
     * @private
     */
    function _toggleAmtType(type) {
        var isAmtDomestic = type === 'D';
        meerkat.modules.travelCoverLevelTabs.initTravelCoverLevelTabs(isAmtDomestic, true);
        meerkat.messaging.publish(Results.model.moduleEvents.RESULTS_BEFORE_DATA_READY);
    }

    /**
     * Display the custom filter results\
     * @param matchAllFilter - boolean value to match ALL or ONE filter
     */
    function _displayCustomResults(matchAllFilter) {
        if (state === 'lg') {
            Results.model.travelResultFilter(true, true, matchAllFilter);
            meerkat.modules.coverLevelTabs.buildCustomTab();
        }
    }

    function updateFilterForDestination() {
        var $cancellationSlider = $('input[name="cancellationRangeSlider"]');
        var $cancellationSliderMax = $('[name="cancellationRangeSliderMax"]');
        var $overseasMedicalFilter = $('[name="minimum_overseas_medical_filter"]');
        var $rentalVehicleFilter = $('[name="minimum_rental_vehicle_filter"]');

        var destination = $('#travel_destination').val();

        if(destination === 'AUS') {
            $cancellationSlider.each(function() {
                $(this).prop('min', 0);
                $(this).prop('max', 10000);
                $(this).prop('step', 2500);
            });
            $cancellationSliderMax.each(function() {
                $(this).text("$10,000");
            });

            $overseasMedicalFilter.each(function() {
                $(this).hide();
            });

            $rentalVehicleFilter.each(function() {
                $(this).show();
            });
        }else{
            $cancellationSlider.each(function() {
                $(this).prop('min', 0);
                $(this).prop('max', 30000);
                $(this).prop('step', 5000);
            });
            $cancellationSliderMax.each(function() {
                $(this).text("$30,000");
            });

            $overseasMedicalFilter.each(function() {
                $(this).show();
            });

            $rentalVehicleFilter.each(function() {
                $(this).hide();
            });
        }
    }

    /**
     * Reset all the custom filter functionality
     */
    function resetCustomFilters() {
        var destination = $('#travel_destination').val();

        Results.model.travelFilters = {
            CONDITIONS: false,
            EXCESS: 200,
            LUGGAGE: 5000,
            CXDFEE: destination === 'AUS' ? 10000 : 20000,
            MEDICAL: 20000000,
            RENTALVEHICLE: 0,
            PROVIDERS: []
        };
        Results.model.travelFilteredProductsCount = 0;
        $init.cover = null;
        var _filters = Results.model.travelFilters;

        $('input[name="medicalCondsAssessedCheckbox"]').prop("checked", _filters.CONDITIONS);

        $('input[name="luggageRangeSlider"]').val(_filters.LUGGAGE);
        _displaySliderValue("LUGGAGE", _filters.LUGGAGE);

        $('input[name="cancellationRangeSlider"]').val(_filters.CXDFEE);
        _displaySliderValue("CXDFEE", _filters.CXDFEE);

        $('input[name="overseasMedicalRangeSlider"]').val(_filters.MEDICAL);
        _displaySliderValue("MEDICAL", _filters.MEDICAL);

        $('input[name="rentalVehicleRangeSlider"]').val(_filters.RENTALVEHICLE);
        _displaySliderValue("RENTALVEHICLE", _filters.RENTALVEHICLE);

        meerkat.modules.customRangeSlider.init();
        $('#travel_filter_excess_200').trigger('click');
        $('[data-provider-code]').prop('checked', true);
    }

    meerkat.modules.register("travelResultFilters", {
        init: init,
        resetCustomFilters: resetCustomFilters,
        updateFilterForDestination: updateFilterForDestination
    });
})(jQuery);