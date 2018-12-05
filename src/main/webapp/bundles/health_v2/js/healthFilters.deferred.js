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
                        _.defer(function () {
                            meerkat.modules.healthSnapshot.renderPreResultsRowSnapshot();
                        });
                    }
                }
            },
            "coverLevel": {
                name: 'health_filterBar_coverLevel',
                defaultValueSourceSelector: '#health_benefits_covertype',
                defaultValue: '',
                values: [
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
            },
            "hospitalExcess": {
                name: "health_filterBar_excess",
                title: "Hospital excess",
                defaultValueSourceSelector: '#health_excess',
                defaultValue: '4',
                events: {
                    init: function (filterObject) {
                        var $slider = $('.health-filter-excess .slider-control');
                        meerkat.modules.sliders.initSlider($slider);
                        $slider.find('.slider')
                            .val($(filterObject.defaultValueSourceSelector).val())
                            .on('change', function(event){
                                meerkat.messaging.publish(meerkatEvents.filters.FILTER_CHANGED, event);
                            });
                    },
                    update: function (filterObject) {
                        var $slider = $('.health-filter-excess .slider-control .slider');
                        $(filterObject.defaultValueSourceSelector).val($slider.val().replace('.00', ''));
                    }
                }
            },
            "rebate": {
                name: 'health_filterBar_rebate',
                defaultValueSourceSelector: '#health_healthCover_income',
                defaultValue: '',
                events: {
                    init: function (filterObject) {
                        /**
                         * Copy the element and place it in the filters with a new id etc. (jQuery Clone doesn't copy the value...)
                         */
                        var $rebateElement = $(filterObject.defaultValueSourceSelector).parent('.select').clone().find('select')
                            .attr('id', model.rebate.name).attr('name', model.rebate.name).val($(filterObject.defaultValueSourceSelector).val());

                        // remove the empty value option
                        $rebateElement.find('option[value=""]').remove();
                        meerkat.modules.dataAnalyticsHelper.add($rebateElement,'filter rebate');
                        $('.filter-rebate-holder').html($rebateElement);
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
                            arr.push({value: object.value || object.code, label: object.label || object.name});
                        });
                        filterObject.values = arr;
                    },
                    update: function (filterObject) {
                        var excluded = [];
                        $('input[name=' + filterObject.name + ']').each(function () {
                            if (!$(this).prop('checked')) {
                                excluded.push($(this).val());
                            }
                        });
                        $(filterObject.defaultValueSourceSelector).val(excluded.join(',')).trigger('change');
                    }
                }
            },
            "benefitsHospital": {
                name: 'health_filterBar_benefitsHospital',
                values: meerkat.modules.healthBenefitsStep.getHospitalBenefitsModel(),
                defaultValueSourceSelector: '.Hospital_container',
                defaultValue: {
                    getDefaultValue: function () {
                        return meerkat.modules.healthBenefitsStep.getSelectedBenefits();
                    }
                },
                events: {
                    update: function () {
                        populateSelectedBenefits();
                    }
                }
            },
            "benefitsExtras": {
                name: 'health_filterBar_benefitsExtras',
                values: meerkat.modules.healthBenefitsStep.getExtraBenefitsModel(),
                defaultValueSourceSelector: '.GeneralHealth_container',
                defaultValue: {
                    getDefaultValue: function () {
                        return meerkat.modules.healthBenefitsStep.getSelectedBenefits();
                    }
                },
                events: {
                    // already run in hospital events
                }
            }

        },
        settings = {
            filters: [
                {
                    template: '#filter-benefits-template',
                    container: '.results-filters-benefits'
                }
            ],
            events: {
                update: function() {
                    // Update benefits step coverType
                    coverType = coverType || meerkat.modules.health.getCoverType();
                    $('#health_situation_coverType').find('input[value="' + coverType + '"]').prop("checked", true).change().end().change();
                    meerkat.modules.healthBenefitsStep.flushHiddenBenefits();
                    meerkat.modules.journeyEngine.loadingShow('...updating your quotes...', true);
                    // Had to use a 100ms delay instead of a defer in order to get the loader to appear on low performance devices.
                    _.delay(function(){
                        Results.unfilterBy('productId', "value", false);
                        Results.settings.incrementTransactionId = true;
                        meerkat.modules.healthResults.get();
                    },100);
                }
            }
        },
        coverType;

    function populateSelectedBenefits() {
        var selectedBenefits = $('.results-filters-benefits input[type="checkbox"]:checked').map(function() {
            return this.value;
        });
        meerkat.modules.healthResults.setSelectedBenefitsList(selectedBenefits);
        meerkat.modules.healthBenefitsStep.populateBenefitsSelection(selectedBenefits);

        // when hospital is set to off in [Customise Cover] hide the excess section
        var $excessSection = $("#resultsPage").find('.cell.excessSection');
        _.contains(selectedBenefits, 'Hospital') ? $excessSection.show() : $excessSection.hide();
    }

    function init() {
        if(meerkat.site.pageAction === "confirmation") { return false; }
        meerkat.modules.filters.initFilters(settings, model);
        applyEventListeners();
        eventSubscriptions();
    }


    function applyEventListeners() {
        $(document).on('click', '.filter-by-brand-toggle', function filterByBrand() {
            var $this = $(this),
                $brandsContainer = $('.filter-by-brand-container');

            if ($brandsContainer.hasClass('expanded')) {
                $brandsContainer.slideUp('fast', function() {
                    $(this).removeClass('expanded');
                });

                $this.find('.text').text('Filter by brand');
            } else {
                $brandsContainer.slideDown('fast', function() {
                    $(this).addClass('expanded');
                });

                $this.find('.text').text('close filter');
            }

            $this.find('.icon').toggleClass('icon-angle-up icon-angle-down');
        });

        $(document).on('click', '.filter-brands-toggle', function selectAllNoneFilterBrands(e) {
            e.preventDefault();
            $('input[name=health_filterBar_brands]').prop('checked', $(this).attr('data-toggle') == "true");
            meerkat.messaging.publish(meerkatEvents.filters.FILTER_CHANGED, e);
        });

        $(document).on('click', '.filter-remove', function removeBenefitsSection(e) {
            var $this = $(this),
                $sidebar = $('.sidebar-widget');

            if ($this.hasClass('hospital')) {
                $sidebar.find('.need-hospital').slideUp('fast', function () {
                    $this.addClass('hidden');
                    $sidebar.find('.filter-remove.extras').addClass('hidden');
                    $sidebar.find('.need-no-hospital').removeClass('hidden').slideDown('fast');
                });
                coverType = 'E';
            }
            else if ($this.hasClass('extras')) {
                $sidebar.find('.need-extras').slideUp('fast', function () {
                    $this.addClass('hidden');
                    $sidebar.find('.filter-remove.hospital').addClass('hidden');
                    $sidebar.find('.need-no-extras').removeClass('hidden').slideDown();
                });
                coverType = 'H';
            }
            meerkat.messaging.publish(meerkatEvents.filters.FILTER_CHANGED, e);
        });

        $(document).on('click', '.filter-add', function addBenefitsSection(e) {
            var $this = $(this),
                $sidebar = $('.sidebar-widget');

            if ($this.hasClass('hospital')) {
                $sidebar.find('.need-no-hospital').slideUp('fast', function () {
                    $this.addClass('hidden');
                    $sidebar.find('.filter-remove.extras').removeClass('hidden');
                    $sidebar.find('.need-hospital').removeClass('hidden').slideDown('fast');
                });
            }
            else if ($this.hasClass('extras')) {
                $sidebar.find('.need-no-extras').slideUp('fast', function () {
                    $this.addClass('hidden');
                    $sidebar.find('.filter-remove.hospital').removeClass('hidden');
                    $sidebar.find('.need-extras').removeClass('hidden').slideDown('fast');
                });
            }
            coverType = 'C';
            meerkat.messaging.publish(meerkatEvents.filters.FILTER_CHANGED, e);
        });

        $(document).on('click', '.filter-toggle-all', function toggleAllBenefits(e) {
            var $this = $(e.currentTarget),
                $benefitsList = $this.parents('.benefits-list');

            if ($benefitsList.hasClass('expanded')) {
                $this.find('.text').text('add more selections');
                $benefitsList.find('.checkbox').filter(function () {
                    return !$(this).find('input').is(':checked');
                }).slideUp('fast', function () {
                    $(this).addClass('hidden');
                });
            } else {
                $this.find('.text').text('show less');
                $benefitsList.find('.checkbox').removeClass('hidden').slideDown('fast');
            }

            var $wrapper = $this.closest('.benefits-list');
            var groupLabel = '';
            if($wrapper.hasClass('need-hospital')) {
                groupLabel = 'hospital';
            } else if($wrapper.hasClass('need-extras')) {
                groupLabel = 'extras';
            }
            $this.find('.text').attr('data-analytics','filter ' + groupLabel);

            $benefitsList.toggleClass('expanded');
            $this.find('.icon').toggleClass('icon-angle-up icon-angle-down');
            toggleBenefitsLink($benefitsList);
        });

    }

    function toggleBenefitsLink($benefitsList) {
        $benefitsList.find('.filter-toggle-all').toggle($benefitsList.find('input[type="checkbox"]:checked').length !== $benefitsList.find('input[type="checkbox"]').length);
    }

    function eventSubscriptions() {
        // health specific logic attached to filter change
        meerkat.messaging.subscribe(meerkatEvents.filters.FILTER_CHANGED, function (event) {
            var $sidebar = $('.sidebar-widget');

            // coverLevel change event subscription
            switch (event.target.name) {
                case 'health_filterBar_coverLevel':
                    var currentCover = $(event.target).val(),
                        $allHospitalButtons = $sidebar.find('.benefitsHospital').find('input[type="checkbox"]');

                    switch (currentCover) {
                        case 'top':
                            $allHospitalButtons.prop('checked', true).parents('.benefits-list').find('.filter-toggle-all').trigger('click');
                            break;
                        case 'limited':
                            $allHospitalButtons.prop('checked', false);
                            break;
                        default:
                            // if is customise, leave as it is, but make sure prHospital is ticked
                            if (currentCover !== 'customise') {
                                $allHospitalButtons.prop('checked', false);
                            }
                            $sidebar.find('.benefitsHospital').find('.' + currentCover + ' input[type="checkbox"]').prop('checked', true).parent().removeClass('hidden').slideDown('fast');
                            break;
                    }
                    break;
                case 'health_filterBar_benefitsHospital':
                    $('#health_filterBar_coverLevel').val('customise');
                    toggleBenefitsLink($sidebar.find('.benefitsHospital'));
                    break;
                case 'health_filterBar_benefitsExtras':
                    toggleBenefitsLink($sidebar.find('.benefitsExtras'));
                    break;
            }

        });

        meerkat.messaging.subscribe(meerkatEvents.filters.FILTERS_RENDERED, function (){
            // reset coverType to use the journey value
            coverType = meerkat.modules.health.getCoverType();

            // hack for the css3 multi columns, it is buggy when two columns doesn't have the same amount of children
            var $providerListCheckboxes = $('.provider-list .checkbox'),
                nthChild = Math.ceil($providerListCheckboxes.length / 2);
            $providerListCheckboxes.filter(':nth-child(' + nthChild + ')').css('display', 'inline-block');
        });

        meerkat.messaging.subscribe(meerkatEvents.transactionId.CHANGED, function updateCoupon() {
            _.defer(function(){
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