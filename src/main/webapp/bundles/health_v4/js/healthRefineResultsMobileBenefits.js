;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            mobileFiltersMenu: {
                FOOTER_BUTTON_UPDATE: 'FOOTER_BUTTON_UPDATE'
            }
        },
        Benefits = null,
        BenefitsModel = null;

    function initHealthRefineResultsMobileBenefits() {
        _applyEventListeners();
        _eventSubscriptions();

        Benefits = meerkat.modules.benefits;
        BenefitsModel = meerkat.modules.benefitsModel;

        return this;
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
        });
    }

    function benefitsCheckState(benefit, uncheckIt) {
        var items = (benefit === 'hospital') ?
            BenefitsModel.getHospitalBenefitsForFilters() : BenefitsModel.getExtrasBenefitsForFilters();

        _.each(items, function (item) {
            $('#health_refineResults_benefits_' + item.id).prop('checked', uncheckIt ? false : BenefitsModel.isSelected(item.id));
        });
    }

    meerkat.modules.register('healthRefineResultsMobileBenefits', {
        initHealthRefineResultsMobileBenefits: initHealthRefineResultsMobileBenefits,
        events: moduleEvents,
        benefitsCheckState: benefitsCheckState
    });

})(jQuery);