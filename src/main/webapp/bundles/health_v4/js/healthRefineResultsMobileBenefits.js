;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            mobileFiltersMenu: {
                FOOTER_BUTTON_UPDATE: 'FOOTER_BUTTON_UPDATE',
                ON_RESET: 'ON_RESET'
            }
        },
        $elements = {},
        _isSwitchedOn = {
            hospital: null,
            extras: null
        },
        _switchTemplates = {
            hospital: '#refineResultsHospitalBenefitsSwitch',
            extras: '#refineResultsExtrasBenefitsSwitch'
        },
        Benefits = null,
        BenefitsModel = null;

    function initHealthRefineResultsMobileBenefits() {
        _setupElements();
        _applyEventListeners();
        _eventSubscriptions();

        Benefits = meerkat.modules.benefits;
        BenefitsModel = meerkat.modules.benefitsModel;

        return this;
    }

    function _setupElements() {
        $elements = {
            hospitalSwitchDefaultSelector: $('#health_benefits_HospitalSwitch'),
            extrasSwitchDefaultSelector: $('#health_benefits_ExtrasSwitch')
        };
    }

    function _applyEventListeners() {
        $(document).on('shown.bs.tab', '.health-refine-results-hospital-benefits a[data-toggle="tab"]', function (e) {
            var $hospitalBenefits = $('input[name=health_refineResults_benefitsHospital]'),
                $hospitalBenefitsChecked = $hospitalBenefits.filter(':checked');

            if ($(this).attr('href').search(/Hospital/) !== -1 && $hospitalBenefitsChecked.length === 0) {
                $hospitalBenefits.filter('[data-benefit-code=PrHospital]').trigger('click');
            } else if ($hospitalBenefitsChecked.length > 0) {
                $hospitalBenefitsChecked.attr('disabled', $(this).attr('href').search(/Limited/) !== -1);
            }

            meerkat.messaging.publish(moduleEvents.mobileFiltersMenu.FOOTER_BUTTON_UPDATE);
        });
    }

    function _eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.refineResults.REFINE_RESULTS_OPENED, function () {
            // loop through selected hospital benefits
            benefitsCheckState('hospital');

            // loop through selected extras benefits
            benefitsCheckState('extras');

            if (Benefits.getHospitalType() === 'limited') {
                $('.health-refine-results-hospital-benefits li a').each(function () {
                    var $that = $(this);
                    var isLimited = $that.attr('href').search(/Limited/) !== -1;
                    $that.closest('li').toggleClass('active', isLimited);
                    $('#refineResultsHospitalBenefits').toggleClass('active in', !isLimited);
                    $('#refineResultsLimitedHospital').toggleClass('active in', isLimited);
                });
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.benefitsSwitch.FILTERS_SWITCH_CHANGED, function (e) {
            if (e.isMobile) {
                _isSwitchedOn[e.benefit] = e.isSwitchedOn;

                meerkat.messaging.publish(meerkatEvents.refineResults.REFINE_RESULTS_UPDATABLE, {
                    updatable: meerkat.modules.benefitsSwitch.isFiltersHospitalOn(true) || meerkat.modules.benefitsSwitch.isFiltersExtrasOn(true)
                });
            }
        });

        meerkat.messaging.subscribe(meerkatEvents.refineResults.REFINE_RESULTS_FOOTER_BUTTON_UPDATE_CALLBACK, function() {
            // update hospital benefits cover type tab
            var $hospitalType = $('.health-refineResults-hospital-benefits li.active').find('a'),
                benefitCoverType = $hospitalType.length && $hospitalType.attr('href').search(/Limited/) !== -1 ? 'limited' : 'customise';

            $('#health_benefits_covertype').val(benefitCoverType);
            Benefits.setHospitalType(benefitCoverType);
            Benefits.toggleHospitalTypeTabs();

            meerkat.modules.healthFilters.populateSelectedBenefits(
                $('.health-refine-results-hospital-benefits'),
                $('.health-refine-results-extras-benefits')
            );

            if (!_.isNull(isSwitchedOn('hospital'))) {
                $elements.hospitalSwitchDefaultSelector.bootstrapSwitch('setState', isSwitchedOn('hospital'));
                _isSwitchedOn.hospital = null;
            }

            if (!_.isNull(isSwitchedOn('extras'))) {
                $elements.extrasSwitchDefaultSelector.bootstrapSwitch('setState', isSwitchedOn('extras'));
                _isSwitchedOn.extras = null;
            }
        });

        meerkat.messaging.subscribe(moduleEvents.mobileFiltersMenu.ON_RESET, function() {
            _resetSwitchState();
        });
    }

    function benefitsCheckState(benefit, uncheckIt) {
        var items = (benefit === 'hospital') ?
            BenefitsModel.getHospitalBenefitsForFilters() : BenefitsModel.getExtrasBenefitsForFilters();

        _.each(items, function (item) {
            $('#health_refineResults_benefits_' + item.id).prop('checked', uncheckIt ? false : BenefitsModel.isSelected(item.id));
        });
    }

    function getSwitchHTML(benefit) {
        return _.template($(_switchTemplates[benefit]).html());
    }

    function switchInit(benefit, initialised, isSwitchedOn) {
        meerkat.modules.benefitsSwitch[benefit === 'hospital' ? 'initHospitalFilters' : 'initExtrasFilters'](true, initialised);
        meerkat.modules.healthFilters.toggleFiltersBenefitSelection(benefit, isSwitchedOn, true);
    }

    function isSwitchedOn(benefit) {
        return _isSwitchedOn[benefit];
    }

    function _resetSwitchState() {
        _isSwitchedOn = {
            hospital: null,
            extras: null
        };
    }

    meerkat.modules.register('healthRefineResultsMobileBenefits', {
        initHealthRefineResultsMobileBenefits: initHealthRefineResultsMobileBenefits,
        events: moduleEvents,
        getSwitchHTML: getSwitchHTML,
        switchInit: switchInit,
        isSwitchedOn: isSwitchedOn
    });

})(jQuery);