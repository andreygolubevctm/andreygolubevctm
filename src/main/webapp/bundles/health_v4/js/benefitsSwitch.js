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
            extrasSwitch: $('#health_benefits_ExtrasSwitch')
        };

        $elements.hospitalSwitch.bootstrapSwitch('setState', _isSwitchedOn.hospital);
        $elements.extrasSwitch.bootstrapSwitch('setState', _isSwitchedOn.extras);
    }

    function _eventSubscriptions() {
        $elements.hospitalSwitch.add($elements.extrasSwitch).on('switch-change', function onBenefitsSwitch(e, data) {
            var benefit = $(data.el).attr('data-benefit');

            _isSwitchedOn[benefit] = data.value;
            meerkat.messaging.publish(moduleEvents.benefitsSwitch.SWITCH_CHANGED, {
                benefit: benefit,
                isSwitchedOn: data.value
            });
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

    meerkat.modules.register('benefitsSwitch', {
        initBenefitsSwitch: initBenefitsSwitch,
        events: moduleEvents,
        isHospitalOn: isHospitalOn,
        isExtrasOn: isExtrasOn,
        initHospitalFilters: initHospitalFilters,
        initExtrasFilters: initExtrasFilters,
        isFiltersHospitalOn: isFiltersHospitalOn,
        isFiltersExtrasOn: isFiltersExtrasOn,
        toggleFiltersSwitch: toggleFiltersSwitch
    });

})(jQuery);