;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            benefitsSwitch: {
                SWITCH_CHANGED: 'SWITCH_CHANGED',
                FILTERS_SWITCH_CHANGED: 'FILTERS_SWITCH_CHANGED'
            }
        },
        $elements,
        _isSwitchedOn = {
            hospital: true,
            extras: true
        };

    function initBenefitsSwitch() {
        _setupFields();
        _eventSubscriptions();
    }

    function _setupFields() {
        $elements = {
            hospitalSwitch: $('#health_benefits_HospitalSwitch'),
            extrasSwitch: $('#health_benefits_ExtrasSwitch'),
            hiddenHospitalCover: $('input[name="health_benefits_benefitsExtras_Hospital"]'),
            hiddenExtraCover: $('input[name="health_benefits_benefitsExtras_GeneralHealth"]'),
            hospitalColContent: $('#benefits_tab_hospital_col_content'),
            extrasColContent: $('#benefits_tab_extras_col_content')
        };

        var hasProductCode = window.meerkat.site.loadProductCode;
        var hospitalVal = $elements.hiddenHospitalCover.val();
        var extrasVal = $elements.hiddenExtraCover.val();

        var hasHospitalCover = hospitalVal === 'Y' || (!hasProductCode && !hospitalVal),
            hasExtrasCover = extrasVal  === 'Y' || (!hasProductCode && !extrasVal);

        $elements.hospitalSwitch.bootstrapSwitch('setState', hasHospitalCover);
        $elements.extrasSwitch.bootstrapSwitch('setState', hasExtrasCover);

        _onBenefitsSwitch('hospital', hasHospitalCover, false);
        _onBenefitsSwitch('extras', hasExtrasCover);
    }

    function _eventSubscriptions() {
        $elements.hospitalSwitch.add($elements.extrasSwitch).on('switch-change', function onBenefitsSwitch(e, data) {
            _onBenefitsSwitch($(data.el).attr('data-benefit'), data.value);
        });

        // benefit selected
        meerkat.messaging.subscribe(meerkatEvents.benefits.BENEFIT_SELECTED, function onBenefitSelected(options) {
            // if (options.isHospital && meerkat.modules.benefitsModel.getHospitalCount() === 0) {
            //     $elements.hospitalSwitch.bootstrapSwitch('setState', false);
            // }
        });

        meerkat.messaging.subscribe(moduleEvents.benefitsSwitch.SWITCH_CHANGED, function onBenefitSwitchChanged(options) {
            if (options.benefit === 'hospital') {
                if (options.isSwitchedOn) {
                    $elements.hospitalColContent.show();
                } else {
                    $elements.hospitalColContent.hide();
                }
            } else {
                if (options.isSwitchedOn) {
                    $elements.extrasColContent.show();
                } else {
                    $elements.extrasColContent.hide();
                }
            }
        });
    }

    function _onBenefitsSwitch(benefit, isSwitched, updateCoverType) {
        updateCoverType = _.isUndefined(updateCoverType) ? true : false;
        _isSwitchedOn[benefit] = isSwitched;
        meerkat.messaging.publish(moduleEvents.benefitsSwitch.SWITCH_CHANGED, {
            benefit: benefit,
            isSwitchedOn: isSwitched,
            updateCoverType: updateCoverType
        });
    }

    function isHospitalOn() {
        return _isSwitchedOn.hospital;
    }

    function isExtrasOn() {
        return _isSwitchedOn.extras;
    }

    function initHospitalFilters(isMobile, initialised) {
        var $switch = isMobile ? $('#health_benefits_refineResults_HospitalSwitch') : $('#health_benefits_filters_HospitalSwitch');

        $switch
            .prop('checked', isMobile && initialised ? isFiltersHospitalOn(true) : _isSwitchedOn.hospital)
            .bootstrapSwitch();

        $switch.on('switch-change', function(e, data) {
            var $hospitalBenefits = isMobile ? $('input[name=health_refineResults_benefitsHospital]') : $('input[name=health_filterBar_benefitsHospital]');

            if (data.value && $hospitalBenefits.filter(':checked').length === 0) {
                _.defer(function() {
                    $hospitalBenefits.filter('[data-benefit-code=PrHospital]').trigger('click');
                });
            }

            meerkat.messaging.publish(moduleEvents.benefitsSwitch.FILTERS_SWITCH_CHANGED, {
                benefit: 'hospital',
                isSwitchedOn: data.value,
                isMobile: isMobile
            });
        });

        if (isMobile) return;

        toggleFiltersSwitch('hospital', true);
    }

    function initExtrasFilters(isMobile, initialised) {
        var $switch = isMobile ? $('#health_benefits_refineResults_ExtrasSwitch') : $('#health_benefits_filters_ExtrasSwitch');

        $switch
            .prop('checked', isMobile && initialised ? isFiltersExtrasOn(true) : _isSwitchedOn.extras)
            .bootstrapSwitch();

        $switch.on('switch-change', function(e, data) {
            meerkat.messaging.publish(moduleEvents.benefitsSwitch.FILTERS_SWITCH_CHANGED, {
                benefit: 'extras',
                isSwitchedOn: data.value,
                isMobile: isMobile
            });
        });

        if (isMobile) return;

        toggleFiltersSwitch('extras', true);
    }

    function isFiltersHospitalOn(isMobile) {
        if (isMobile) {
            var isSwitchedOn = meerkat.modules.healthRefineResultsMobileBenefits.isSwitchedOn('hospital');
            if (!_.isNull(isSwitchedOn)) {
                return isSwitchedOn;
            }
        }

        return isMobile ? isHospitalOn() : $('#health_benefits_filters_HospitalSwitch').bootstrapSwitch('state');
    }

    function isFiltersExtrasOn(isMobile) {
        if (isMobile) {
            var isSwitchedOn = meerkat.modules.healthRefineResultsMobileBenefits.isSwitchedOn('extras');
            if (!_.isNull(isSwitchedOn)) {
                return isSwitchedOn;
            }
        }

        return isMobile ? isExtrasOn() : $('#health_benefits_filters_ExtrasSwitch').bootstrapSwitch('state');
    }

    function toggleFiltersSwitch(benefit, toggle) {
        var benefitUpperCased = benefit[0].toUpperCase() + benefit.slice(1);
        $('#health_benefits_filters_' + benefitUpperCased + 'Switch').closest('.has-switch').toggleClass('hidden', toggle);
    }

    function switchOffHospitalFilters() {
        $('#health_benefits_filters_HospitalSwitch').bootstrapSwitch('setState', false);
    }

    meerkat.modules.register('benefitsSwitch', {
        initBenefitsSwitch: initBenefitsSwitch,
        events: moduleEvents,
        isHospitalOn: isHospitalOn,
        isExtrasOn: isExtrasOn,
        initHospitalFilters: initHospitalFilters,
        initExtrasFilters: initExtrasFilters,
        isFiltersHospitalOn: isFiltersHospitalOn,
        isFiltersExtrasOn: isFiltersExtrasOn,
        toggleFiltersSwitch: toggleFiltersSwitch,
        switchOffHospitalFilters: switchOffHospitalFilters
    });

})(jQuery);
