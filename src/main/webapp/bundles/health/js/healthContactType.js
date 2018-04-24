;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,

        $input = null,
        $fields = {},
        _contactType = '';

    function init() {
        $(document).ready(function() {
            _setupElements();
            _applyEventListeners();
            _contactType = $input.val();
        });
    }

    function _setupElements() {
        $input = $(':input[name="health_simples_contactTypeRadio"]');

        $fields = {
            phone: $('#health_contactDetails_flexiContactNumberinput'),
            email: $('#health_contactDetails_email')
        };
    }

    function _applyEventListeners() {
        $input.on('change', function() {
            _contactType = $input.val();
        });
    }

    function is(contactType) {
        return !_.isEmpty(_contactType) ? (_contactType === contactType) : false;
    }

    function togglePhoneEmailRequired() {
        var isWebChat = is('webchat');

        $fields.phone.add($fields.email).prop('required', isWebChat);
        $fields.phone.closest('.fieldrow')
            .add($fields.email.closest('.fieldrow')).toggleClass('required_input', isWebChat);
    }

    meerkat.modules.register('healthContactType', {
        init: init,
        is: is,
        togglePhoneEmailRequired: togglePhoneEmailRequired
    });

})(jQuery);