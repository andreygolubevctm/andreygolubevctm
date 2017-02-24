;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            benefitsSwitch: {
                SWITCH_CHANGED: 'SWITCH_CHANGED'
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

    function setHospitalFilters() {
        $('#health_benefits_filters_HospitalSwitch')
            .prop('checked', _isSwitchedOn.hospital)
            .bootstrapSwitch();
    }

    function setExtrasFilters() {
        $('#health_benefits_filters_ExtrasSwitch')
            .prop('checked', _isSwitchedOn.extras)
            .bootstrapSwitch();
    }

    meerkat.modules.register('benefitsSwitch', {
        initBenefitsSwitch: initBenefitsSwitch,
        events: moduleEvents,
        isHospitalOn: isHospitalOn,
        isExtrasOn: isExtrasOn,
        setHospitalFilters: setHospitalFilters,
        setExtrasFilters: setExtrasFilters
    });

})(jQuery);