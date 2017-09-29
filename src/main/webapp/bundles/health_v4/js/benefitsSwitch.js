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
            hiddenExtraCover: $('input[name="health_benefits_benefitsExtras_GeneralHealth"]')
        };

        var hasHospitalCover = $elements.hiddenHospitalCover.val() === 'Y',
            hasExtrasCover = $elements.hiddenExtraCover.val() === 'Y';

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
            if (options.isHospital && meerkat.modules.benefitsModel.getHospitalCount() === 0) {
                $elements.hospitalSwitch.bootstrapSwitch('setState', false);
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

    function initHospitalFilters() {
        $('#health_benefits_filters_HospitalSwitch')
            .prop('checked', _isSwitchedOn.hospital)
            .bootstrapSwitch();

        toggleFiltersSwitch('hospital', true);

        $('#health_benefits_filters_HospitalSwitch').on('switch-change', function(e, data) {
            var $hospitalBenefits = $('input[name=health_filterBar_benefitsHospital]');

            if (data.value && $hospitalBenefits.filter(':checked').length === 0) {
                _.defer(function() {
                    $hospitalBenefits.filter('[data-benefit-code=PrHospital]').trigger('click');
                });
            }

            meerkat.messaging.publish(moduleEvents.benefitsSwitch.FILTERS_SWITCH_CHANGED, {
                benefit: 'hospital',
                isSwitchedOn: data.value
            });
        });
    }

    function initExtrasFilters() {
        $('#health_benefits_filters_ExtrasSwitch')
            .prop('checked', _isSwitchedOn.extras)
            .bootstrapSwitch();

        toggleFiltersSwitch('extras', true);

        $('#health_benefits_filters_ExtrasSwitch').on('switch-change', function(e, data) {
            meerkat.messaging.publish(moduleEvents.benefitsSwitch.FILTERS_SWITCH_CHANGED, {
                benefit: 'extras',
                isSwitchedOn: data.value
            });
        });
    }

    function isFiltersHospitalOn() {
        return $('#health_benefits_filters_HospitalSwitch').bootstrapSwitch('state');
    }

    function isFiltersExtrasOn() {
        return $('#health_benefits_filters_ExtrasSwitch').bootstrapSwitch('state');
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