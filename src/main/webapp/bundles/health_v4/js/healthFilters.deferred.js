/**
 * Description: External documentation:
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events;

    var moduleEvents = {
            healthFilters: {},
            WEBAPP_LOCK: 'WEBAPP_LOCK',
            WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
        },
        /**
         * Each object key is a different "filter". Each filter object contains information necessary to render the form field.
         * The idea is that one model can render in many templates, as benefits needs to be in its own separate template
         * for the mobile/sm+ markup to work. Only problem is additional templates need to be defined in settings,
         * and rendered manually from this file
         * @type object
         */
        model = {
            "frequency": {
                name: 'health_filterBar_frequency',
                title: 'Payment frequency',
                values: [
                    {
                        value: 'F',
                        label: 'Fortnightly'
                    },
                    {
                        value: 'M',
                        label: 'Monthly'
                    },
                    {
                        value: 'A',
                        label: 'Annually'
                    }
                ],

                defaultValueSourceSelector: '#health_filter_frequency',
                defaultValue: 'M'
            },
            "hospitalExcess": {
                name: "health_filterBar_excess",
                title: "Hospital excess",
                defaultValueSourceSelector: '#health_excess',
                defaultValue: '4',
                events: {
                    init: function (filterObject) {
                        var $filterExcess = $('.health-filter-excess'),
                            $slider = $filterExcess.find('.slider-control');

                        meerkat.modules.sliders.initSlider($slider);
                        $slider.find('.slider')
                            .val($(filterObject.defaultValueSourceSelector).val())
                            .on('change', function (event) {
                                meerkat.messaging.publish(meerkatEvents.filters.FILTER_CHANGED, event);
                            });

                        toggleFilter($filterExcess);
                        setFilterByExcess();
                    },
                    update: function (filterObject) {
                        var $filterExcess = $('.health-filter-excess'),
                            $slider = $filterExcess.find('.slider-control .slider');

                        $(filterObject.defaultValueSourceSelector).val($slider.val().replace('.00', ''));

                        toggleFilterByContainer($('.filter-excess'), false);
                        toggleFilter($filterExcess, false);
                        setFilterByExcess();
                    }
                }
            },
            "discount": {
                name: 'health_filterBar_discount',
                defaultValueSourceSelector: 'input[name="health_applyDiscounts"]',
                defaultValue: '',
                events: {
                    init: function (filterObject) {
                        var isChecked = $(filterObject.defaultValueSourceSelector).val() === 'Y';
                        $('input[name=' + filterObject.name + ']').prop('checked', isChecked);
                    },
                    update: function (filterObject) {
                        var isChecked = $('input[name=' + filterObject.name + ']').is(':checked');
                        $(filterObject.defaultValueSourceSelector).val(isChecked ? 'Y' : 'N');
                    }
                }
            },
            "rebate": {
                name: 'health_filterBar_rebate',
                defaultValueSourceSelector: 'input[name="health_healthCover_rebate"]',
                defaultValue: '',
                events: {
                    init: function (filterObject) {
                        var isChecked = $(filterObject.defaultValueSourceSelector + ":checked").length > 0 && $(filterObject.defaultValueSourceSelector + ":checked").val() === 'Y';
                        $('input[name=' + filterObject.name + ']').prop('checked', isChecked);
                    },
                    update: function (filterObject) {
                        var isChecked = $('input[name=' + filterObject.name + ']').is(':checked');
                        if (isChecked) {
                            $(filterObject.defaultValueSourceSelector+'[value="Y"]').prop('checked', true).trigger('change');
                        } else {
                            $(filterObject.defaultValueSourceSelector+'[value="N"]').prop('checked', true).trigger('change', [false]);
                        }
                    }
                }
            },
            "brands": {
                name: 'health_filterBar_brands',
                values: meerkat.site.providerList,
                defaultValueSourceSelector: '#health_filter_providerExclude',
                defaultValue: '',
                defaultValueType: 'csv',
                events: {
                    /**
                     * We have to remap the array to match the model format as its straight from a Dao
                     * @param filterObject
                     */
                    beforeInit: function (filterObject) {
                        var arr = [];
                        _.each(filterObject.values, function (object) {
                            arr.push({ value: object.value || object.code, label: object.label || object.name });
                        });
                        filterObject.values = arr;
                    },
                    init: function (filterObject) {
                        toggleFilter($('.health-filter-brands'));
                        setFilterByBrands();
                    },
                    update: function (filterObject) {
                        var excluded = [];
                        $('input[name=' + filterObject.name + ']').each(function () {
                            if (!$(this).prop('checked')) {
                                excluded.push($(this).val());
                            }
                        });
                        $(filterObject.defaultValueSourceSelector).val(excluded.join(',')).trigger('change');

                        toggleFilterByContainer($('.filter-brands'), false);
                        toggleFilter($('.health-filter-brands'), false);
                        setFilterByBrands();
                    }
                }
            },
            "benefitsHospital": {
                name: 'health_filterBar_benefitsHospital',
                // This is all of the benefits
                values: meerkat.modules.benefitsModel.getHospitalBenefitsForFilters(),
                defaultValueSourceSelector: '.Hospital_container',
                defaultValue: {
                    getDefaultValue: function () {
                        // This is what is already selected.
                        return meerkat.modules.benefitsModel.getHospital();
                    }
                },
                events: {
                    init: function (filterObject) {
                        var $filterBenefits = $('.health-filter-hospital-benefits');

                        toggleFilter($filterBenefits);
                        setFilterByHospitalBenefits();
                    },
                    update: function () {
                        // Forced to customise (or limited) as we don't have top/mid/basic in v4
                        var $hospitalType = $('.results-filters-benefits .health-filter-hospital-benefits li.active').find('a'),
                            benefitCoverType = $hospitalType.length && $hospitalType.attr('href').search(/limited/) !== -1 ? 'limited' : 'customise';

                        $('#health_benefits_covertype').val(benefitCoverType);

                        meerkat.modules.benefits.setHospitalType(benefitCoverType);

                        meerkat.modules.benefits.toggleHospitalTypeTabs();

                        populateSelectedBenefits($('.health-filter-hospital-benefits'), $('.health-filter-extras-benefits'));
                        toggleFilterByContainer($('.filter-hospital-benefits'), false);
                        toggleFilter($('.health-filter-hospital-benefits'), false);
                        setFilterByHospitalBenefits();

                    }
                }
            },
            "benefitsExtras": {
                name: 'health_filterBar_benefitsExtras',
                values: meerkat.modules.benefitsModel.getExtrasBenefitsForFilters(),
                defaultValueSourceSelector: '.GeneralHealth_container',
                defaultValue: {
                    getDefaultValue: function () {
                        return meerkat.modules.benefitsModel.getExtras();
                    }
                },
                events: {
                    init: function (filterObject) {
                        var $filterBenefits = $('.health-filter-extras-benefits');

                        toggleFilter($filterBenefits);
                        setFilterByExtrasBenefits();
                    },
                    update: function () {
                        toggleFilterByContainer($('.filter-extras-benefits'), false);
                        toggleFilter($('.health-filter-extras-benefits'), false);
                        setFilterByExtrasBenefits();
                    }
                }
            },
            "benefitsHospitalSwitch": {
                name: 'health_benefits_filters_HospitalSwitch',
                defaultValueSourceSelector: '#health_benefits_HospitalSwitch',
                defaultValue: '',
                events: {
                    init: function (filterObject) {
                        meerkat.modules.benefitsSwitch.initHospitalFilters();
                        toggleFiltersBenefitSelection('hospital', meerkat.modules.benefitsSwitch.isHospitalOn());
                    },
                    update: function (filterObject) {
                        var isSwitchedOn = $('input[name=' + filterObject.name + ']').bootstrapSwitch('state');

                        $(filterObject.defaultValueSourceSelector).bootstrapSwitch('setState', isSwitchedOn);

                        _.defer(function() {
                            setFilterByHospitalBenefits();
                            meerkat.modules.benefitsSwitch.toggleFiltersSwitch('hospital', true);
                        });
                    }
                }
            },
            "benefitsExtrasSwitch": {
                name: 'health_benefits_filters_ExtrasSwitch',
                defaultValueSourceSelector: '#health_benefits_ExtrasSwitch',
                defaultValue: '',
                events: {
                    init: function (filterObject) {
                        meerkat.modules.benefitsSwitch.initExtrasFilters();
                        toggleFiltersBenefitSelection('extras', meerkat.modules.benefitsSwitch.isExtrasOn());
                    },
                    update: function (filterObject) {
                        var isSwitchedOn = $('input[name=' + filterObject.name + ']').bootstrapSwitch('state');

                        $(filterObject.defaultValueSourceSelector).bootstrapSwitch('setState', isSwitchedOn);

                        _.defer(function() {
                            setFilterByExtrasBenefits();
                            meerkat.modules.benefitsSwitch.toggleFiltersSwitch('extras', true);
                        });
                    }
                }
            }
        },
        settings = {
            verticalContextChange: ['xs', 'sm'],
            xsContext: '.header-top',
            filters: [
                {
                    template: '#filter-discount-template',
                    container: '.results-filters-discount',
                    context: '#results-sidebar'
                },
                {
                    template: '#filter-rebate-template',
                    container: '.results-filters-rebate',
                    context: '#results-sidebar'
                },
                {
                    template: '#filter-benefits-template',
                    container: '.results-filters-benefits',
                    context: '#results-sidebar'
                },
                {
                    template: '#filter-results-frequency-template',
                    container: '.results-filters-frequency',
                    context: '.results-control-container'
                }
            ],
            events: {
                update: function () {
                    // Update benefits step coverType
                    meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
                    // Had to use a 100ms delay instead of a defer in order to get the loader to appear on low performance devices.
                    _.delay(function () {
                        // Update Popular Products to be unfiltered results set
                        meerkat.modules.healthPopularProducts.setPopularProducts('N');
                        Results.unfilterBy('productId', "value", false);
                        Results.settings.incrementTransactionId = true;
                        meerkat.modules.healthResults.get();
                    }, 100);
                }
            }
        },
        quoteRefTemplate,
        $navBarFiltersContext,
        $hiddenProductsWrapper,
        $paginationWrapper;

    function getCheckedBenefitsFromFilters($container) {
        var array = [];
        $container.find('input[type="checkbox"]:checked:not([disabled])').map(function () {
            array.push(this.value);
        });
        return array;
    }

    /**
     * This is called just by hospital, as it does both hospital and extras due to the results functionality
     * needing both to set the extras on Features.pageStructure
     */
    function populateSelectedBenefits($hospitalBenefits, $extrasBenefits) {
        // this needs to convert the shortlistkey names e.g. PrHospital to its id for it to work...
        // go back up to init filters and try and make it just run off ids.
        var selectedBenefits = {
            'hospital': getCheckedBenefitsFromFilters($hospitalBenefits),
            'extras': getCheckedBenefitsFromFilters($extrasBenefits)
        };

        meerkat.modules.healthResults.setSelectedBenefitsList(selectedBenefits.hospital.concat(selectedBenefits.extras));

        meerkat.modules.benefitsModel.setIsHospital(false);
        meerkat.modules.benefitsModel.setBenefits(selectedBenefits.extras);

        meerkat.modules.benefitsModel.setIsHospital(true);
        meerkat.modules.benefitsModel.setBenefits(selectedBenefits.hospital);

        meerkat.messaging.publish(meerkatEvents.benefitsModel.BENEFITS_MODEL_UPDATE_COMPLETED);
    }

    function init() {
        if (meerkat.site.pageAction === "confirmation") {
            return false;
        }
        $(document).ready(function () {
            quoteRefTemplate = $('.quote-reference-number');
            $navBarFiltersContext = $('.results-control-container');
            $hiddenProductsWrapper = $('.filter-results-hidden-products', $navBarFiltersContext);
            $paginationWrapper = $('.results-pagination', $navBarFiltersContext);
            _placeFrequencyFilters();
            meerkat.modules.filters.initFilters(
                settings,
                model
            );
            applyEventListeners();
            eventSubscriptions();
        });
    }


    function applyEventListeners() {
        $(document).on('change', 'input[name=health_filterBar_frequency]', function (e) {
            var frequency = $(this).val();
            meerkat.messaging.publish(meerkatEvents.filters.FILTERS_UPDATED);
            _.defer(function () {
                $('#health_filter_frequency').val(frequency);
                Results.setFrequency(meerkat.modules.healthResults.getFrequencyInWords(frequency), false);
                meerkat.modules.resultsTracking.setResultsEventMode('Refresh');
                Results.applyFiltersAndSorts();
            });
        });

        $(document).on('click', '.filter-brands-toggle', function selectAllNoneFilterBrands(e) {
            e.preventDefault();
            $('input[name=health_filterBar_brands]').prop('checked', $(this).attr('data-toggle') == "true");
            meerkat.messaging.publish(meerkatEvents.filters.FILTER_CHANGED, e);
        });

        $(document).on('click', '.filter-toggle', function () {
            var filter = $(this).attr('data-filter');

            toggleFilterByContainer($('.filter-' + filter));
            toggleFilter($('.health-filter-' + filter), true);

            meerkat.modules.benefitsSwitch.toggleFiltersSwitch(filter.replace('-benefits', ''), false);
        });

        $(document).on('shown.bs.tab', '.health-filter-hospital-benefits a[data-toggle="tab"]', function (e) {
            var $hospitalBenefits = $('input[name=health_filterBar_benefitsHospital]'),
                $hospitalBenefitsChecked = $hospitalBenefits.filter(':checked');

            if ($(this).attr('href').search(/hospital/) === 1 && $hospitalBenefitsChecked.length === 0) {
                $hospitalBenefits.filter('[data-benefit-code=PrHospital]').trigger('click');
            } else if ($hospitalBenefitsChecked.length > 0) {
              $hospitalBenefitsChecked.attr('disabled', $(this).attr('href').search(/limited/) === 1);
            }

            meerkat.messaging.publish(meerkatEvents.filters.FILTER_CHANGED, e);
        });

        $(document).on('click', 'input[name=health_filterBar_benefitsHospital]', function () {
            if ($('input[name=health_filterBar_benefitsHospital]:checked').length === 0) {
                meerkat.modules.benefitsSwitch.switchOffHospitalFilters();
            }
        });
    }

    function toggleFilterByContainer($filter, toggle) {
        $filter.find('.filter-by-container').toggleClass('hidden', toggle);
    }

    function toggleFilter($filter, toggle) {
        if (toggle) {
            $filter.slideDown('fast');
        } else {
            $filter.slideUp('fast');
        }
    }

    function setFilterByExtrasBenefits() {
        var coverType = meerkat.modules.healthChoices.getCoverType(),
            extrasCount = meerkat.modules.benefitsModel.getExtrasCount(),
            benefitString = '',
            filterToggleText = 'Change';
        if (coverType === 'H' || extrasCount === 0) {
            benefitString = 'No Extras';
            filterToggleText = 'Add Extras';
        } else {
            var plural = extrasCount > 1 ? 's' : '';
            benefitString = extrasCount + ' Extra' + plural + ' selected';
        }
        $('.filter-by-extras-benefits').html(benefitString)
            .parent().find('.filter-toggle').text(filterToggleText);
    }

    function setFilterByHospitalBenefits() {
        var coverType = meerkat.modules.healthChoices.getCoverType(),
            hospitalType = meerkat.modules.benefits.getHospitalType(),
            hospitalCount = meerkat.modules.benefitsModel.getHospitalCount(),
            benefitString = '',
            filterToggleText = 'Change';
        if (coverType === 'E' || hospitalCount === 0) {
            benefitString = 'No Hospital';
            filterToggleText = 'Add Hospital';
        } else {
            var plural = hospitalCount > 1 ? 's' : '';
            benefitString = hospitalCount + ' Benefit' + plural + ' selected';
        }
        var hospitalLabel = hospitalType == 'customise' ? 'Comprehensive' : 'Limited';
        var coverTypeLabel = '';
        if (coverType !== 'E') { // Only when its H/C
            coverTypeLabel = '<div>' + hospitalLabel + ' Cover</div>';

            // Update the active tab for hospital filter to limited if applicable
            if (hospitalType === 'limited') {
                benefitString = '';
                filterToggleText = 'Change';
                $('.results-filters-benefits .health-filter-hospital-benefits li').find('a').each(function () {
                    var $that = $(this);
                    var isLimited = $that.attr('href').search(/limited/) !== -1;
                    $that.closest('li').toggleClass('active', isLimited);
                    $('#hospitalBenefits').toggleClass('active in', !isLimited);
                    $('#limitedHospital').toggleClass('active in', isLimited);
                });
            }
        }
        var benefitCount = '<div>' + benefitString + '</div>';
        $('.filter-by-hospital-benefits').html(coverTypeLabel + benefitCount)
            .parent().find('.filter-toggle').text(filterToggleText);
    }

    function setFilterByExcess() {
        $('.filter-by-excess').text($('.health-filter-excess .selection').text());
    }

    function setFilterByBrands() {
        var numBrands = $(':input[name=health_filterBar_brands]').length,
            numBrandsChecked = $(':input[name=health_filterBar_brands]:checked').length,
            filterByText = numBrands === numBrandsChecked ? 'All Funds' : numBrandsChecked + ' Brands selected';

        $('.filter-by-brands').text(filterByText);
    }

    function toggleQuoteRefTemplate(toggle) {
        quoteRefTemplate[toggle]();
    }

    function eventSubscriptions() {
        // health specific logic attached to filter change
        meerkat.messaging.subscribe(meerkatEvents.filters.FILTER_CHANGED, function (event) {
            if (!$(event.target).parents('.filter').data('dontToggleUpdate')) {
                toggleQuoteRefTemplate('slideUp');
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.filters.FILTERS_CANCELLED, function (event) {
            toggleQuoteRefTemplate('slideDown');
        });
        meerkat.messaging.subscribe(meerkatEvents.filters.FILTERS_UPDATED, function (event) {
            toggleQuoteRefTemplate('slideDown');
            // note: unpinning products happens in healthResults.js due to the internal JS variable over there.
            meerkat.modules.healthResultsTemplate.unhideFilteredProducts();
            meerkat.modules.healthResults.unpinProductFromFilterUpdate();
        });

        meerkat.messaging.subscribe(meerkatEvents.transactionId.CHANGED, function updateCoupon() {
            _.defer(function () {
                meerkat.modules.coupon.loadCoupon('filter', null, function successCallBack() {
                    meerkat.modules.coupon.renderCouponBanner();
                });
            });
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter() {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results') {
                _placeFrequencyFilters();
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function resultsXsBreakpointLeave() {
            if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results') {
                _placeFrequencyFilters();
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.benefitsSwitch.FILTERS_SWITCH_CHANGED, function (e) {
            toggleFiltersBenefitSelection(e.benefit, e.isSwitchedOn, e.isMobile);

            // defer so switch values get populated within healthRefineResultsMobileBenefits FILTERS_SWITCH_CHANGED
            _.defer(function() {
                _toggleFiltersSwitchValidation(e.isMobile);
            });
        });
    }

    /**
     * To prevent issues with maintaining state of two separate frequency filters (for XS and SM+),
     * need to just move them around in the DOM.
     */
    function _placeFrequencyFilters() {
        var $frequency = $('.results-filters-frequency', $navBarFiltersContext);
         if (meerkat.modules.deviceMediaState.get() === 'xs') {
            $frequency.detach().insertAfter($paginationWrapper);
         } else {
            $frequency.detach().insertBefore($hiddenProductsWrapper);
         }
    }

    function toggleFiltersBenefitSelection(benefit, isSwitchedOn, isMobile) {
        var $benefits = isMobile ? $('.health-refine-results-' + benefit + '-benefits') : $('.filter-' + benefit + '-benefits');

        $benefits
            .toggleClass('benefits-switched-off', !isSwitchedOn)
            .find('.benefits-list input[type=checkbox]').prop('disabled', !isSwitchedOn);
    }

    function _toggleFiltersSwitchValidation(isMobile) {
        var areBenefitsSwitchOn = meerkat.modules.benefitsSwitch.isFiltersHospitalOn(isMobile) || meerkat.modules.benefitsSwitch.isFiltersExtrasOn(isMobile),
            $switchMessage = isMobile ? $('.refine-results-mobile .benefits-switch-off-message') : $('.results-filters-benefits .benefits-switch-off-message');

        $switchMessage.toggleClass('hidden', areBenefitsSwitchOn);

        if (!isMobile) {
            $('.filter-update-changes').attr('disabled', !areBenefitsSwitchOn).prop('disabled', !areBenefitsSwitchOn);
            $('.filter.benefits-switched-off').attr('data-dontToggleUpdate', !areBenefitsSwitchOn);
        }

        // push error tracking object into CtMDatalayer
        if (!areBenefitsSwitchOn) {
            meerkat.modules.benefits.errorTracking('benefits-switch-off');
        }
    }

    function getModel() {
        return model;
    }

    meerkat.modules.register("healthFilters", {
        init: init,
        events: {},
        getModel: getModel,
        populateSelectedBenefits: populateSelectedBenefits,
        toggleFiltersBenefitSelection: toggleFiltersBenefitSelection
    });

})(jQuery);
