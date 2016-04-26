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
                events: {}
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
                        var rebateElement = $(filterObject.defaultValueSourceSelector).parent('.select').clone()
                            .attr('id', model.rebate.name).attr('name', model.rebate.name);
                        $('.filter-rebate-holder').html(rebateElement);
                    },
                    update: function(filterObject) {
                        $(filterObject.defaultValueSourceSelector).val($(filterObject.name).val()).trigger('change');
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
            },
            "benefitsHospital": {
                name: 'health_filterBar_benefitsHospital',
                values: {},
                defaultValueSourceSelector: '',
                defaultValue: '',
                events: {}
            },
            "benefitsExtras": {
                name: 'health_filterBar_benefitsExtras',
                values: {},
                defaultValueSourceSelector: '',
                defaultValue: '',
                events: {}
            }

        },
        settings = {
            templates: {
                benefits: '#filter-benefits-template'
            },
            containers: {
                benefits: '#results-sidebar .results-filters-benefits'
            }
        };

    function init() {
        meerkat.modules.filters.initFilters(settings, model);
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

        /**
         * I do not like this code...
         * Features.getPageStructure does not contain anything until the async call has come back from results.
         * This means that we cannot trigger the render until this is done...
         */
        meerkat.messaging.subscribe(meerkatEvents.resultsFeatures.STRUCTURE_FETCHED, function () {
            var updatedModel = meerkat.modules.filters.getModel();

            updatedModel.benefitsHospital.values = Features.getPageStructure();
            updatedModel.benefitsHospital.values = preInitBenefits(updatedModel.benefitsHospital, 'Hospital');

            updatedModel.benefitsExtras.values = Features.getPageStructure();
            updatedModel.benefitsExtras.values = preInitBenefits(updatedModel.benefitsExtras, 'GeneralHealth');

            meerkat.modules.filters.setModel(updatedModel);
            meerkat.modules.filters.render('benefits');
        });
    }

    /**
     * Initialise the benefits object internally as it is stored in Features.getPageStructure()
     * @param filterObject
     * @param category
     */
    function preInitBenefits(filterObject, category) {
        var arr = [];
        if (!filterObject) {
            exception('There is nothing in the values for benefits!');
            return;
        }
        _.each(filterObject.values, function (object) {
            if (isShortlistable(object) && hasShortlistableChildren(object) && object.shortlistKey == category) {
                _.each(object.children, function (child) {
                    if (child.shortlistKey)
                        arr.push({value: "Y", label: child.name, helpId: child.helpId, id: child.shortlistKey});
                });
            }
        });
        return arr;
    }

    /**
     * Helper function to determine if a benefit in the array is one
     * that can be selected, or if its just a section/sub-feature.
     * @param object
     * @returns {boolean}
     */
    function isShortlistable(object) {
        if (object.shortlistKey == null || object.shortlistKey === "") return false;
        return true;
    }

    /**
     * Helper function to determine if a benefit in the array is one that can be selected, or if its just a section/sub-feature.
     * @param object
     * @returns {boolean}
     */
    function hasShortlistableChildren(object) {
        for (var i = 0; i < object.children.length; i++) {
            if (isShortlistable(object.children[i])) {
                return true;
            }
        }
        return false;
    }

    meerkat.modules.register("healthFilters", {
        init: init,
        events: {}
    });

})(jQuery);