;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            healthContactNumber: {
                CONTACT_NUMBER_CHANGED: 'CONTACT_NUMBER_CHANGED'
            }
        },
        $elements = {},
        _contactBy = 'mobile';

    function initHealthContactNumber() {
        _setupFields();
        _applyEventListeners();
        _eventSubscriptions();
    }

    function _setupFields() {
        $elements = {
            contactRow: $('.contact-number.row'),
            switch: $('.contact-number-switch'),
            inputs: $('input.contact-number-field'),
            flexiNumber: $('#health_contactDetails_flexiContactNumber')
        };
    }

    function _applyEventListeners() {
        $elements.switch.on('click', function() {
            $elements.inputs.val('');
            $elements.flexiNumber.val('');
            $elements.contactRow.toggleClass('hidden');

            _contactBy = $elements.contactRow.filter(':not(.hidden)').find('input').hasClass('mobile') ? 'mobile' : 'other';
        });

        $elements.inputs.on('change', function() {
            if ($(this).valid()) {
                $elements.flexiNumber.val($(this).val());
                // $elements.attr('data')
            }
        });
    }

    function _eventSubscriptions() {

    }

    function getContactBy() {
        return _contactBy;
    }

    function switchField(contactBy) {

    }

    meerkat.modules.register('healthContactNumber', {
        init: initHealthContactNumber,
        events: moduleEvents,
        getContactBy: getContactBy,
        switchField: switchField
    });

})(jQuery);