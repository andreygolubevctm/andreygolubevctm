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
                        $(filterObject.defaultValueSourceSelector).val($('input[name=' + filterObject.name + ']:checked').val());
                    }
                }
            },
            "coverLevel": {
                name: 'health_filterBar_coverLevel',
                defaultValueSourceSelector: '#health_filter_coverLevel', //todo: input doesn't exist yet
                defaultValue: '',
                events: {
                    update: function (filterObject) {
                        // todo Set to defaultValueSourceSelector
                        // it should default update the model if we run setDefaultsToModel again.
                        // additional backports
                        var value = $('select[name=' + filterObject.name + ']').val();
                        $('.hospitalCoverToggles a[data-category="' + value + '"]').click();
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
                        $slider.data('value', '2'); // todo: make sure this sets the default value to whats in the default value.
                        meerkat.modules.sliders.initSlider($slider);
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
                         * Copy the element and place it in the filters with a new id etc.
                         */
                        var rebateElement = $(filterObject.defaultValueSourceSelector).parent('.select').clone().find('select')
                            .attr('id', model.rebate.name).attr('name', model.rebate.name);
                        $('.filter-rebate-holder').html(rebateElement);
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
            "coverType": {
                // Note: how this filter will look has not been designed as yet...
                // its more the add/remove, so it may need to be separate -.-
                name: 'health_filterBar_coverType',
                values: {},
                defaultValueSourceSelector: 'input[name=health_situation_coverType]',
                defaultValue: 'C',
                events: {
                    update: function (filterObject) {
                        var value = $('input[name=' + filterObject.name + ']').val();
                        $(filterObject.defaultValueSourceSelector).val(value);
                        $('input[name=health_situation_coverType]').each(function () {
                            $(this).prop('checked', false);
                            if ($(this).val() == value) {
                                //seem to need both events...
                                $(this).prop('checked', true).change().click();
                            }
                        });
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
                        // populateBenefitsSelection
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
                events: {}
            }

        },
        settings = {
            filters: [
                {
                    template: '#filter-benefits-template',
                    container: '.results-filters-benefits',
                    context: '#results-sidebar'
                }
            ]
        };

    function init() {
        meerkat.modules.filters.initFilters(settings, model, 'filters');
        applyEventListeners();
        eventSubscriptions();
    }


    function applyEventListeners() {

        $(document).on('click', '.filter-brands-toggle', function selectAllNoneFilterBrands(e) {
            e.preventDefault();
            $('input[name=health_filterBar_brands]').prop('checked', $(this).attr('data-toggle') == "true");
        });

    }

    function eventSubscriptions() {

    }

    meerkat.modules.register("healthFilters", {
        init: init,
        events: {}
    });

})(jQuery);