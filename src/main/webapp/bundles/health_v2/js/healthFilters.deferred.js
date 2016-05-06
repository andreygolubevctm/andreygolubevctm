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
                        var $slider = $('#results-sidebar .health-filter-excess .slider-control');
                        meerkat.modules.sliders.initSlider($slider);
                        $slider.find('.slider')
                            .val($(filterObject.defaultValueSourceSelector).val())
                            // todo: move this to core module with type = 'slider'?
                            .on('change', function(event){
                                meerkat.messaging.publish(meerkatEvents.filters.FILTER_CHANGED, event);
                            });
                    },
                    update: function (filterObject) {
                        var $slider = $('#results-sidebar .health-filter-excess .slider-control .slider');
                        $(filterObject.defaultValueSourceSelector).val($slider.val());
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
                    update: function () {
                        populateSelectedBenefits();
                    }
                }
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

    function populateSelectedBenefits() {
        var selectedBenefits = $('#results-sidebar').find('.results-filters-benefits input[type="checkbox"]:checked').map(function() {
            return this.value;
        });
        meerkat.modules.healthBenefitsStep.populateBenefitsSelection(selectedBenefits);
    }

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

        meerkat.messaging.subscribe(meerkatEvents.filters.FILTER_CHANGED, function (event) {
            // coverLevel change event subscription
            if (event.target.id === 'health_filterBar_coverLevel') {
                var $sidebar = $('#results-sidebar'),
                    currentCover = $(event.target).val(),
                    $allHospitalButtons = $sidebar.find('.benefitsHospital').find('input[type="checkbox"]');

                switch (currentCover) {
                    case 'top':
                        $allHospitalButtons.prop('checked', true);
                        break;
                    case 'limited':
                        $allHospitalButtons.prop('checked', false);
                        break;
                    default:
                        // if is customise, leave as it is, but make sure prHospital is ticked
                        if (currentCover !== 'customise') {
                            $allHospitalButtons.prop('checked', false);
                        }
                        $sidebar.find('.benefitsHospital').find('.' + currentCover + ' input[type="checkbox"]').prop('checked', true);
                        break;
                }
            }
        });

    }

    meerkat.modules.register("healthFilters", {
        init: init,
        events: {}
    });

})(jQuery);