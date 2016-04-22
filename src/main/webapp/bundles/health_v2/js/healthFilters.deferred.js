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
                events: {
                    change: function (filterObject) {

                    },
                    init: function (filterObject) {

                    }
                },
                defaultValueSourceSelector: '#health_filter_frequency',
                defaultValue: 'M'
            },
            "coverLevel": {
                name: 'health_filterBar_coverLevel',
                defaultValueSourceSelector: '#health_filter_coverLevel',
                defaultValue: '',
                events: {
                    init: function (filterObject) {
                        meerkat.modules.sliders.initSlider($('.filter-cover-type .slider-control'));
                        // todo: make sure this sets the default value to whats in the default value.
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
                        meerkat.modules.sliders.initSlider($('.health-filter-excess .slider-control'));
                        // todo: make sure this sets the default value to whats in the default value.
                    }
                }
            },
            "rebate": {
                name: 'health_filterBar_rebate',
                defaultValueSourceSelector: '#health_healthCover_income',
                defaultValue: '',
                events: {
                    init: function (filterObject) {
                        var rebateElement = $(filterObject.defaultValueSourceSelector).parent('.select').clone()
                            .attr('id', model.rebate.name).attr('name', model.rebate.name);
                        $('.filter-rebate-holder').html(rebateElement);
                    }
                }
            },
            "brands": {
                name: 'health_filterBar_brands',
                values: meerkat.site.providerList,
                defaultValueSourceSelector: '#health_filter_providerExclude',
                defaultValue: '',
                defaultValueType: 'array',
                events: {
                    /**
                     * We have to remap the array to match the model format as its straight from a Dao
                     * @param filterObject
                     */
                    beforeInit: function (filterObject) {
                        var arr = [];
                        _.each(filterObject.values, function (object) {
                            arr.push({value: object.code, label: object.name});
                        });
                        filterObject.values = arr;
                    },
                    init: function (filterObject) {

                    }
                }
            }

        };

    function init() {
        meerkat.modules.filters.initFilterModel(model);
        applyEventListeners();
    }


    function applyEventListeners() {

        $(document).on('click', '.filter-brands-toggle', function selectAllNoneFilterBrands(e) {
            e.preventDefault();
            $('input[name=health_filterBar_brands]').prop('checked', $(this).attr('data-toggle') == "true");
        });
        
    }

    meerkat.modules.register("healthFilters", {
        init: init,
        events: {}
    });

})(jQuery);