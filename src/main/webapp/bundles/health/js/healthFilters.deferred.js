/**
 * Description: External documentation:
 */
(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception,
        activeGroups = [],
        benefitGroups = [],
        manuallySelectedHealthBenefits = {},
        manuallySelectedClinicalBenefits = {};

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
            "abd": {
                name: 'health_filterBar_abd',
                defaultValueSourceSelector: 'input[name="health_abdProducts"]',
                defaultValue: '',
                events: {
                    init: function (filterObject) {
                        var isChecked = $(filterObject.defaultValueSourceSelector + ":checked").length > 0 && $(filterObject.defaultValueSourceSelector + ":checked").val() === 'Y';
                        $('input[name=' + filterObject.name + ']').prop('checked', isChecked);
                    },
                    update: function (filterObject) {
                        var isChecked = $('input[name=' + filterObject.name + ']').is(':checked');
                        $(filterObject.defaultValueSourceSelector).val(isChecked ? "Y" : "N");
                        if (isChecked) {
                            $(filterObject.defaultValueSourceSelector+'[value="Y"]').prop('checked', true).trigger('change');
                        } else {
                            $(filterObject.defaultValueSourceSelector+'[value="N"]').prop('checked', true).trigger('change', [false]);
                        }
                    }
                }
            },
            "extendedFamily": {
                name: 'health_filterBar_extendedFamily',
                defaultValueSourceSelector: '#health_situation_healthCvr',
                defaultValue: '',
                values: [
                    {
                        value: 'F',
                        label: 'Family'
                    },
                    {
                        value: 'EF',
                        label: 'Extended Family'
                    },
                    {
                        value: 'SPF',
                        label: 'Single Parent Family'
                    },
                    {
                        value: 'ESP',
                        label: 'Extended Single Parent Family'
                    }

                ],
                events: {
                    update: function (filterObject) {
                        if (_.indexOf(['F', 'EF', 'SPF', 'ESP'], meerkat.modules.health.getSituation()) > -1) {
                            var value = $('select[name=' + filterObject.name + ']').val();
                            $(filterObject.defaultValueSourceSelector).val(value);
                            meerkat.modules.healthChoices.setCover(value);
                            meerkat.modules.simplesBindings.toggleRebateDialogue();
                        }
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
                        label: 'Basic/Basic+'
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
            "extrasCoverLevel": {
                name: 'health_filterBar_extrasCoverLevel',
                defaultValueSourceSelector: '#health_filter_tierExtras',
                defaultValue: '',
                values: [
                    {
                        value: '',
                        label: 'Default'
                    },
                    {
                        value: '1',
                        label: 'Budget'
                    },
                    {
                        value: '2',
                        label: 'Medium'
                    },
                    {
                        value: '3',
                        label: 'Comprehensive'
                    }

                ],
                events: {
                    update: function (filterObject) {
                        var value = $('select[name=' + filterObject.name + ']').val();
                        $(filterObject.defaultValueSourceSelector).val(value);
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
                            /**
                             * Copy the element and place it in the filters with a new id etc. (jQuery Clone doesn't copy the value...)
                             */
                            var $excessElement = $(filterObject.defaultValueSourceSelector).parent('.select').clone().find('select')
                                .attr('id', model.hospitalExcess.name).attr('name', model.hospitalExcess.name).val($(filterObject.defaultValueSourceSelector).val());
    
                            $('.health_cover_details_excess').attr('id', model.hospitalExcess.name)
                            .attr('name', model.hospitalExcess.name)
                            .val($(filterObject.defaultValueSourceSelector).val());
                        },
                        update: function (filterObject) {
                            $(filterObject.defaultValueSourceSelector).val($('select[name=' + filterObject.name + ']').val()).trigger('change');
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
            "benefitsClinical": {
                name: 'health_filterBar_benefitsClinical',
                values: meerkat.modules.healthBenefitsStep.getClinicalBenefitsModel(),
                defaultValueSourceSelector: '#clinicalCategoriesContent',
                defaultValue: {
                    getDefaultValue: function () {
                        return meerkat.modules.healthBenefitsStep.getSelectedBenefits();
                    }
                },
                events: {
                    // update event already run in hospital events
                    initAfterDefaultValue: function () {
                        setupActiveGroups();
                        setupClinicalBenefitGroups();
                        setupManuallySelectedBenefits();
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
            },
	        "ambulanceAccidentCover": {
		        name: 'health_filterBar_ambulanceAccidentCover',
		        values: meerkat.modules.healthBenefitsStep.getAmbulanceAccidentCoverModel(),
		        defaultValueSourceSelector: '.ambulanceAccidentCover_container',
		        defaultValue: {
			        getDefaultValue: function () {
				        return meerkat.modules.healthBenefitsStep.getAmbulanceAccidentCover();
			        }
		        },
		        events: {
			        update: function () {
				        populateAmbulanceAccidentCover();
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
            ],
            events: {
                update: function() {
                    // Update benefits step coverType
                    coverType = coverType || meerkat.modules.health.getCoverType();
                    $('#health_situation_coverType').find('input[value="' + coverType + '"]').prop("checked", true).trigger('change').end().trigger('change');

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
    	var selectedBenefits = _.flatten($('.results-filters-benefits input[type="checkbox"][name^="health_filterBar_benefits"]:checked').map(function() {
            return this.value;
        }));
        meerkat.modules.healthResults.setSelectedBenefitsList(selectedBenefits);
        meerkat.modules.healthClinicalCategories.synManuallySelectedBenefits(manuallySelectedHealthBenefits, manuallySelectedClinicalBenefits);
        meerkat.modules.healthBenefitsStep.populateBenefitsSelection(selectedBenefits);
        meerkat.modules.healthClinicalCategories.toggleDataVisibiltyOfSelectedBenefits(selectedBenefits);


        // when hospital is set to off in [Customise Cover] hide the excess section
        var $excessSection = $("#resultsPage").find('.cell.excessSection');
        _.contains(selectedBenefits, 'Hospital') ? $excessSection.show() : $excessSection.hide();

		_.delay(meerkat.modules.healthClinicalCategories.reverseUpdateLabels, 1500);
    }

	function populateAmbulanceAccidentCover() {
		var selectedAmbulanceAccidentCover = $('.results-filters-benefits input[type="checkbox"][name^="health_filterBar_ambulanceAccidentCover_"]:checked').map(function() {
			return this.value;
		});
		meerkat.modules.healthResults.setAmbulanceAccidentCoverList(selectedAmbulanceAccidentCover);
		meerkat.modules.healthBenefitsStep.populateAmbulanceAccidentCoverSelection(selectedAmbulanceAccidentCover);
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
                    $(this).addClass('hidden').find('input').prop('checked', false);
                    $sidebar.find('.filter-remove.extras').addClass('hidden');
                    $sidebar.find('.need-no-hospital').removeClass('hidden').slideDown('fast');
                });
                clearManuallySelectedBenefits();
                coverType = 'E';
            }
            else if ($this.hasClass('extras')) {
                $sidebar.find('.need-extras').slideUp('fast', function () {
                    $(this).addClass('hidden').find('input').prop('checked', false).trigger('change');
                    $sidebar.find('.filter-remove.hospital').addClass('hidden');
                    $sidebar.find('.need-no-extras').removeClass('hidden').slideDown();
                });
	            resetExtrasCoverLevel();
                coverType = 'H';
            }
            meerkat.messaging.publish(meerkatEvents.filters.FILTER_CHANGED, e);
        });

        $(document).on('click', '.filter-add', function addBenefitsSection(e) {
            var $this = $(this),
                $sidebar = $('.sidebar-widget');

            if ($this.hasClass('hospital')) {
                $sidebar.find('.need-no-hospital').slideUp('fast', function () {
                    $(this).addClass('hidden');
                    $sidebar.find('.filter-remove.extras').removeClass('hidden');
                    $sidebar.find('.need-hospital').removeClass('hidden').slideDown('fast');
                });
            }
            else if ($this.hasClass('extras')) {
                $sidebar.find('.need-no-extras').slideUp('fast', function () {
                    $(this).addClass('hidden');
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
                $this.find('.text').text('Show more');
                $benefitsList.find('.checkbox').filter(function () {
                    return !$(this).find('input').is(':checked');
                }).slideUp('fast', function () {
                    $(this).addClass('hidden');
                });
            } else {
                $this.find('.text').text('Show less');
                $benefitsList.find('.checkbox').removeClass('hidden').slideDown('fast');
            }

            $benefitsList.toggleClass('expanded');
            $this.find('.icon').toggleClass('icon-angle-up icon-angle-down');
            toggleBenefitsLink($benefitsList);
        });

        $(document).on('click', '.filter-toggle-all-clinical', function toggleAllBenefits(e) {
            var $this = $(e.currentTarget),
                $benefitsList = $this.parents('.benefits-list');

            if ($benefitsList.hasClass('expanded')) {
                $this.find('.text').text('View Clinical categories');
                $benefitsList.find('.checkbox').slideUp('fast', function () {
                    $(this).addClass('hidden');
                });
            } else {
                $this.find('.text').text('Hide Clinical categories');
                $benefitsList.find('.checkbox').removeClass('hidden').slideDown('fast');
            }

            $benefitsList.toggleClass('expanded');
            $this.find('.icon').toggleClass('icon-angle-up icon-angle-down');
            toggleBenefitsLink($benefitsList);
        });

	    $(document).on('change', ":input[name^='health_filterBar_ambulanceAccidentCover']", function (e) {
		    populateAmbulanceAccidentCover();
	    });

        $(document).on('change', ".benefitsHospital :input[type='checkbox']", function (e) {
            var $that = $(this);
            _.defer(function(){
                toggleSelector($that);
                var isChecked = $that.is(":checked");
                if(!isChecked) {
                    manuallySelectedHealthBenefits[$that.attr("value")] =  false;
                }
            });
        });

        $(document).on('click.manualHospitalBenefitSelection', ".benefitsHospital :input[type='checkbox']", function (e) {
            var $that = $(this);
            _.defer(function(){
                toggleSelector($that);
                var isChecked = $that.is(":checked");
                manuallySelectedHealthBenefits[$that.attr("value")] = isChecked;
            });
        });

        $(document).on('click.manualClinicalBenefitSelection', ".benefitsClinical :input[type='checkbox']", function (e) {
            var $row = $(this);
            var groupsStr = $row.attr("data-groups");
            if(!_.isUndefined(groupsStr)) {
                var groups = groupsStr.split(",");
                _.defer(function () {
                    var $input = $row;
                    var checked = $input.is(":checked");
                    manuallySelectedClinicalBenefits[$input.attr("value")] = checked;
                    if(!_.isEmpty(groupsStr) && !_.isEmpty(groups)) {
                        reverseToggleSelectors({row: $row, groups: groups, checked: checked});
                    }
                });
            }
        });

        $(document).on('change', ".benefitsClinical :input[type='checkbox']", function (e) {
            var $row = $(this);
            _.defer(function () {
                var $input = $row;
                var checked = $input.is(":checked");
                if (!checked) {
                    manuallySelectedClinicalBenefits[$input.attr("value")] = checked;
                }
            });
        });
    }

    function toggleBenefitsLink($benefitsList) {
        $benefitsList.find('.filter-toggle-all').toggle($benefitsList.find('input[type="checkbox"]:checked').length !== $benefitsList.find('input[type="checkbox"]').length);
    }

    function toggleSelector($selector) {
        var group = $selector.attr("data-group");
        if(!_.isUndefined(group) && !_.isEmpty(group)) {
            var position = _.indexOf(activeGroups, group);
            if ($selector.is(":checked")) {
                if (position === -1) {
                    activeGroups.push(group);
                }
            } else if (position !== -1) {
                activeGroups[position] = null;
                activeGroups = _.compact(activeGroups);
            }
            toggleBenefits(group);
        }
    }

    /**
     * toggleBenefits updates the selected benefits when a quick select option group is toggled.
     *
     * @param group
     */
    function toggleBenefits(group) {
        $('.sidebar-widget').find('.benefitsClinical').find('.checkbox').each(function(index){
            var $row = $(this);
            if(benefitGroups[index].length > 0) {
                // Toggled group must exist current benefit row
                if(_.indexOf(benefitGroups[index], group) !== -1) {
                    // Check benefit related to ANY selected groups
                    var isInASelectedGroup = _.intersection(benefitGroups[index], activeGroups).length > 0;
                    var $input = $row.find(":input");
                    var benefit = $input.attr('value');
                    var manuallySelected = !_.isUndefined(manuallySelectedClinicalBenefits[benefit]) && manuallySelectedClinicalBenefits[benefit];
                    var isActive = manuallySelected || isInASelectedGroup;
                    $input.prop("checked", isActive).change();
                } else {
                    // Ignore as benefit not related to toggled group
                }
            } else {
                // Ignore as benefit is not related to any groups
            }
        });

    }
  
    //might be useful in the future.
    function showClinicalFilter() {
        var $this = $('.filter-toggle-all-clinical'),
            $benefitsList = $this.parents('.benefits-list');

        if (!$benefitsList.hasClass('expanded')) {
            $this.find('.text').text('Hide Clinical categories');
            $benefitsList.find('.checkbox').removeClass('hidden').slideDown('fast');
            $benefitsList.toggleClass('expanded');
            $this.find('.icon').toggleClass('icon-angle-up icon-angle-down');
            toggleBenefitsLink($benefitsList);
        }

    }

    /**
     * reverseToggleSelectors updates the selectors when a user manually toggles benefits.
     *
     * @param obj
     */
    function reverseToggleSelectors(payload) {
        // Only proceed if benefit is in a group
        if(!_.isEmpty(payload.groups)) {
            if (!payload.checked) {
                // Need to unselect any selected groups applicable to the benefit
                var selectedBenefitGroups = _.intersection(payload.groups, activeGroups);
                if (selectedBenefitGroups.length > 0) {
                    _.each(selectedBenefitGroups, function (group) {
                        var position = _.indexOf(activeGroups, group);
                        if (position !== -1) {
                            activeGroups[position] = null;
                            activeGroups = _.compact(activeGroups);
                            var $option = $('.sidebar-widget').find('.benefitsHospital').find('input[type="checkbox"]').filter("[data-group=" + group + "]");
                            if ($option.length) {
                                $option.prop("checked", false).trigger("change.randomChangeEvent");
                            }
                        }
                    });
                }
            } else {
                // Need to select any groups that have all applicable benefits selected
                var nonSelectedBenefitGroups = _.difference(payload.groups, activeGroups);
                if (nonSelectedBenefitGroups.length > 0) {
                    _.each(nonSelectedBenefitGroups, function (group) {
                        var allBenefitsSelected = true;
                        var selectedBenefitCount = 0;
                        $('.sidebar-widget').find('.benefitsClinical').find('input[type="checkbox"]').each(function(index){
                            var $row = $(this);
                            // Benefit has to have group or it can be ignored
                            if(benefitGroups[index].length > 0) {
                                // Benefit must be related to the compared group or it can be ignored
                                if(_.indexOf(benefitGroups[index], group) !== -1) {
                                    // Benefit must be checked or it fails the all-selected test
                                    if($row.is(":checked")) {
                                        selectedBenefitCount++;
                                    } else {
                                        allBenefitsSelected = false;
                                    }
                                } else {
                                    // Ignore as benefit is not related to comparitor group
                                }
                            }
                        });

                        if (allBenefitsSelected && selectedBenefitCount > 0) {
                            activeGroups.push(group);
                            var $option = $('.sidebar-widget').find('.benefitsHospital').find('input[type="checkbox"]').filter("[data-group=" + group + "]");
                            if ($option.length) {
                                $option.prop("checked", true).trigger("change.randomChangeEvent");
                                //once a hospital benefit gets automatically selected, it should not be deselected again.
                                return false;
                            }
                        }
                    });
                }
            }
        }
    }

	function resetExtrasCoverLevel(){
	    $('#' + model.extrasCoverLevel.name).find('option').prop('selected',null).end().find('option:first').prop('selected',true).end().trigger('change');
    }

    function eventSubscriptions() {
        // health specific logic attached to filter change
        meerkat.messaging.subscribe(meerkatEvents.filters.FILTER_CHANGED, function (event) {
            var $sidebar = $('.sidebar-widget');
			// coverLevel change event subscription
            switch (event.target.name) {
                case 'health_filterBar_coverLevel':
                    var currentCover = $(event.target).val(),
                        $allHospitalButtons = $sidebar.find('.benefitsHospital').find('input[type="checkbox"]'),
                        $allClinicalButtons = $sidebar.find('.benefitsClinical').find('input[type="checkbox"]');

                    switch (currentCover) {
                        case 'top':
                            $allHospitalButtons.prop('checked', true).parents('.benefits-list').find('.filter-toggle-all').trigger('click');
                            break;
                        case 'limited':
                            $allHospitalButtons.prop('checked', false);
                            $allClinicalButtons.prop('checked', false);
                            break;
                        default:
                            // if is customise, leave as it is, but make sure prHospital is ticked
                            if (currentCover !== 'customise') {
                                $allHospitalButtons.prop('checked', false);
                                $allClinicalButtons.prop('checked', false);
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

    function setupActiveGroups() {
        activeGroups = meerkat.modules.healthClinicalCategories.getActiveGroups();
    }

    function setupClinicalBenefitGroups() {
        benefitGroups = meerkat.modules.healthClinicalCategories.getBenefitGroups();
    }

    function setupManuallySelectedBenefits() {
        manuallySelectedHealthBenefits = {};
        var hospitalArray = meerkat.modules.healthClinicalCategories.getManuallySelectedHospitalBenefit();
        $(hospitalArray).each(function (index, item) {
            manuallySelectedHealthBenefits[item] = true;
        });
        manuallySelectedClinicalBenefits = {};
        var clinicalArray = meerkat.modules.healthClinicalCategories.getManuallySelectedClinicalCategories();
        $(clinicalArray).each(function (index, item) {
            manuallySelectedClinicalBenefits[item] = true;
        });
    }
    
    function clearManuallySelectedBenefits() {
        manuallySelectedHealthBenefits = {};
        manuallySelectedClinicalBenefits = {};
    }

    meerkat.modules.register("healthFilters", {
        init: init,
        events: {}
    });

})(jQuery);