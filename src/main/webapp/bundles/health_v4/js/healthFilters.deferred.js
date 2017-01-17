/**
 * Description: External documentation:
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

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
         * @type POJO
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
                defaultValue: 'M',
                events: {
                    update: function (filterObject) {
                        var valueNew = $('input[name=' + filterObject.name + ']:checked').val();
                        $(filterObject.defaultValueSourceSelector).val(valueNew);
                        Results.setFrequency(meerkat.modules.healthResults.getFrequencyInWords(valueNew), false);
                    }
                }
            },
            /* @todo may need some of this logic for comprehensive/limited
             "coverLevel": {
             name: 'health_filterBar_coverLevel',
             defaultValueSourceSelector: '#health_benefits_covertype',
             defaultValue: '',
             values: [
             {
             value: 'top',
             label: 'Top'
             },
             {
             value: 'medium',
             label: 'Medium'
             },
             {
             value: 'basic',
             label: 'Basic'
             },
             {
             value: 'customise',
             label: 'Customise'
             },
             {
             value: 'limited',
             label: 'Limited'
             }

             ],
             events: {
             update: function (filterObject) {
             var value = $('select[name=' + filterObject.name + ']').val();
             $(filterObject.defaultValueSourceSelector).val(value);
             $('.hospitalCoverToggles a[data-category="' + value + '"]').trigger('click');
             }
             }
             },*/
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
            "rebate": {
                name: 'health_filterBar_rebate',
                defaultValueSourceSelector: '#health_healthCover_rebate_checkbox',
                defaultValue: '',
                events: {
                    init: function (filterObject) {
                        var isChecked = $(filterObject.defaultValueSourceSelector).is(':checked');
                        $('input[name=' + filterObject.name + ']').prop('checked', isChecked);
                        toggleIncome(!isChecked);
                        updateRebateLabels();
                    },
                    update: function (filterObject) {
                        $(filterObject.defaultValueSourceSelector).prop('checked', $('input[name=' + filterObject.name + ']').is(':checked')).trigger('change');

                        toggleRebateEdit(true);
                        updateRebateLabels();
                    }
                }
            },
            "income": {
                name: 'health_filterBar_income',
                defaultValueSourceSelector: '#health_healthCover_income',
                defaultValue: '',
                events: {
                    init: function (filterObject) {
                        /**
                         * Copy the element and place it in the filters with a new id etc. (jQuery Clone doesn't copy the value...)
                         */
                        var $defaultValueSourceSelector = $(filterObject.defaultValueSourceSelector),
                            $incomeElement = $defaultValueSourceSelector.parent().clone();

                        $incomeElement
                            .addClass('hidden')
                            .find('select').attr({
                            'id': filterObject.name,
                            'name': filterObject.name,
                            'data-analytics': 'filter rebate'
                        }).val($defaultValueSourceSelector.val())
                            .find('option[value=""]').remove();

                        $('.filter-income-holder').html($incomeElement);
                    },
                    update: function (filterObject) {
                        $(filterObject.defaultValueSourceSelector).val($('select[name=' + filterObject.name + ']').val()).trigger('change');
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
                        populateSelectedBenefits();
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
            }

        },
        settings = {
            xsContext: '.header-top',
            filters: [
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
                        Results.unfilterBy('productId', "value", false);
                        Results.settings.incrementTransactionId = true;
                        meerkat.modules.healthResults.get();
                    }, 100);
                }
            }
        },
        quoteRefTemplate;

    function _getCheckedBenefitsFromFilters($container) {
        var array = [];
        $container.find('input[type="checkbox"]:checked').map(function () {
            array.push(this.value);
        });
        return array;
    }

    /**
     * This is called just by hospital, as it does both hospital and extras due to the results functionality
     * needing both to set the extras on Features.pageStructure
     */
    function populateSelectedBenefits() {
        // this needs to convert the shortlistkey names e.g. PrHospital to its id for it to work...
        // go back up to init filters and try and make it just run off ids.
        var selectedBenefits = {
            'hospital': _getCheckedBenefitsFromFilters($('.filter-hospital-benefits')),
            'extras': _getCheckedBenefitsFromFilters($('.filter-extras-benefits'))
        };

        meerkat.modules.healthResults.setSelectedBenefitsList(selectedBenefits.hospital.concat(selectedBenefits.extras));

        meerkat.modules.benefitsModel.setIsHospital(false);
        meerkat.modules.benefitsModel.setBenefits(selectedBenefits.extras);

        meerkat.modules.benefitsModel.setIsHospital(true);
        meerkat.modules.benefitsModel.setBenefits(selectedBenefits.hospital);

    }

    function init() {
        if (meerkat.site.pageAction === "confirmation") {
            return false;
        }
        quoteRefTemplate = $('.quote-reference-number');
        meerkat.modules.filters.initFilters(settings, model);
        applyEventListeners();
        eventSubscriptions();
    }


    function applyEventListeners() {
        $(document).on('click', '.filter-brands-toggle', function selectAllNoneFilterBrands(e) {
            e.preventDefault();
            $('input[name=health_filterBar_brands]').prop('checked', $(this).attr('data-toggle') == "true");
            meerkat.messaging.publish(meerkatEvents.filters.FILTER_CHANGED, e);
        });


        $(document).on('change', '#health_filterBar_rebate', function toggleRebateDropdown() {
            toggleIncome(!$(this).is(':checked'));
        });

        $(document).on('click', '.filtersEditTier', function () {
            toggleRebateEdit(false);
        });

        $(document).on('click', '.filter-toggle', function () {
            var filter = $(this).attr('data-filter');

            toggleFilterByContainer($('.filter-' + filter));
            toggleFilter($('.health-filter-' + filter), true);
        });
    }

    function toggleIncome(toggle) {
        $('.results-filters-rebate .income_container').toggleClass('hidden', toggle);
    }

    function toggleRebateEdit(toggle) {
        $('#filtersRebateLabel, #filtersSelectedRebateText').toggle(toggle);
        $('.filter-income-holder .select').toggleClass('hidden', toggle);
    }

    function updateRebateLabels() {
        $('#filtersRebateLabel span').text(meerkat.modules.healthRebate.getRebateLabelText());
        $('#filtersSelectedRebateText').text(meerkat.modules.healthRebate.getSelectedRebateLabelText());
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
            benefitString = '';
        if (coverType === 'H' || extrasCount === 0) {
            benefitString = 'No Extras';
        } else {
            var plural = extrasCount > 1 ? 's' : '';
            benefitString = extrasCount + ' Extra' + plural + ' selected';
        }
        $('.filter-by-extras-benefits').html(benefitString);
    }

    function setFilterByHospitalBenefits() {
        var coverType = meerkat.modules.healthChoices.getCoverType(),
            hospitalType = meerkat.modules.benefits.getHospitalType(),
            hospitalCount = meerkat.modules.benefitsModel.getHospitalCount(),
            benefitString = '';
        if (coverType === 'E' || hospitalCount === 0) {
            benefitString = 'No Hospital';
        } else {
            benefitString = hospitalCount + ' Extras selected';
        }
        var coverTypeLabel = '<div>' + hospitalType.charAt(0).toUpperCase() + hospitalType.slice(1) + " Cover</div>";
        var benefitCount = '<div>' + benefitString + '</div>';
        $('.filter-by-hospital-benefits').html(coverTypeLabel + benefitCount);
    }

    function setFilterByExcess() {
        $('.filter-by-excess').text($('.health-filter-excess .selection').text());
    }

    function setFilterByBrands() {
        var numBrands = $(':input[name=health_filterBar_brands]').length,
            numBrandsChecked = $(':input[name=health_filterBar_brands]:checked').length,
            filterByText = numBrands === numBrandsChecked ? 'All Brands' : numBrandsChecked + ' Brands selected';

        $('.filter-by-brands').text(filterByText);
    }

    function toggleQuoteRefTemplate(toggle) {
        quoteRefTemplate[toggle]();
    }

    function eventSubscriptions() {
        // health specific logic attached to filter change
        meerkat.messaging.subscribe(meerkatEvents.filters.FILTER_CHANGED, function (event) {
            toggleQuoteRefTemplate('slideUp');
        });

        meerkat.messaging.subscribe(meerkatEvents.filters.FILTERS_CANCELLED, function (event) {
            toggleQuoteRefTemplate('slideDown');
        });

        meerkat.messaging.subscribe(meerkatEvents.transactionId.CHANGED, function updateCoupon() {
            _.defer(function () {
                meerkat.modules.coupon.loadCoupon('filter', null, function successCallBack() {
                    meerkat.modules.coupon.renderCouponBanner();
                });
            });
        });

    }

    meerkat.modules.register("healthFilters", {
        init: init,
        events: {}
    });

})(jQuery);