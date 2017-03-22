;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        $elements = {};

    // Used to change the validation trigger on mobile to change.
    // blur is used in all other instances.
    var dynamicChangeEvent = meerkat.modules.performanceProfiling.isMobile() ? 'change' : 'blur';

    function initHealthContactNumber() {
        _setupFields();
        _applyEventListeners();
    }

    function _setupFields() {
        $elements = {
            inputs: $('.contact-details-contact-number .contact-number-field'),
            flexiNumber: $('#health_contactDetails_flexiContactNumber')
        };
    }

    function _applyEventListeners() {
        $(document).on('click', '.contact-number-switch', function onSwitchClicked() {
            var $contactNumber = $(this).closest('.contact-number'),
                deselectedField = $contactNumber.attr('data-contact-by'),
                contactBy = $contactNumber.attr('data-contact-by') === 'mobile' ? 'other' : 'mobile';

            $contactNumber.attr('data-contact-by', contactBy);

            // update flexiNumber only on journey questionset
            if ($contactNumber.hasClass('contact-details-contact-number')) {
                var $input = $contactNumber.find('#health_contactDetails_contactNumber_' + contactBy + 'input');

                $elements.flexiNumber.val('');
                if (!_.isEmpty($input.val())) {
                    $input.trigger(dynamicChangeEvent);
                }
            }

            var $redundantInput = $contactNumber.find('#health_contactDetails_contactNumber_' + deselectedField);
            $redundantInput.val('');

        });

        $elements.inputs.on(dynamicChangeEvent, function onInputsEventTrigger() {
            $elements.flexiNumber.val($(this).valid() ? $(this).val().replace(/ /g,'') : '');
        });
    }

    function insertContactNumber($contactNumberContainer, contactNumber) {
        if (contactNumber.length > 0) {
            var contactBy = contactNumber.match(/^(04|614|6104)/g) ? 'mobile' : 'other';

            $contactNumberContainer.attr('data-contact-by', contactBy);
            $contactNumberContainer.find('.contact-number-' + contactBy + ' input.contact-number-field').val(contactNumber).trigger(dynamicChangeEvent);
        }
    }

    function getContactNumberFromField($contactNumberContainer) {
        var contactBy = $contactNumberContainer.attr('data-contact-by');

        return $contactNumberContainer.find('.contact-number-' + contactBy + ' input.contact-number-field').val();
    }

    meerkat.modules.register('healthContactNumber', {
        init: initHealthContactNumber,
        insertContactNumber: insertContactNumber,
        getContactNumberFromField: getContactNumberFromField
    });

})(jQuery);