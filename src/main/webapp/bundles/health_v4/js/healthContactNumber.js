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
        // Toggle the visible phone input when quote loaded
	    var phone = $.trim($elements.flexiNumber.val()).replace(/\D/g,'');
        if(!_.isEmpty(phone)) {
	        if (getContactBy(phone) === 'other') {
		        $elements.switchNumber.each(function(){
	                var $that = $(this);
		            $that.closest('.contact-number').attr('data-contact-by','mobile');
		            onSwitchClicked($that);
		        });
	        }
        }
    }

    function _setupFields() {
        $elements = {
            inputs: $('.contact-details-contact-number .contact-number-field'),
            flexiNumber: $('#health_contactDetails_flexiContactNumber'),
            switchNumber: $('.contact-number-switch'),
	        phone: {
		        quote: {
			        mobile: $("#health_contactDetails_contactNumber_mobile"),
			        other: $("#health_contactDetails_contactNumber_other")
		        },
		        application: {
			        mobile: $("#health_application_mobile"),
			        other: $("#health_application_other")
		        }
	        }
        };
    }

    function _applyEventListeners() {
        $(document).on('click', '.contact-number-switch', function onSwitchClickedEvent() {
	        onSwitchClicked($(this));
        });

        $elements.inputs.on(dynamicChangeEvent, function onInputsEventTrigger() {
            $elements.flexiNumber.val($(this).valid() ? meerkat.modules.phoneFormat.cleanNumber($(this).val()) : "");
        });
    }

    function onSwitchClicked($switch) {
        var $contactNumber = $switch.closest('.contact-number'),
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
    }

    function insertContactNumber($contactNumberContainer, contactNumber) {
        var contactBy = getContactBy(contactNumber);
        if(contactBy !== false) {
            $contactNumberContainer.attr('data-contact-by', contactBy);
            $contactNumberContainer.find('.contact-number-' + contactBy + ' input.contact-number-field').val(contactNumber).trigger(dynamicChangeEvent);
        }
    }

    function getContactNumberFromField($contactNumberContainer) {
        var contactBy = $contactNumberContainer.attr('data-contact-by');

        return $contactNumberContainer.find('.contact-number-' + contactBy + ' input.contact-number-field').val();
    }

    function getContactBy(contactNumber) {
        var contactBy = false;
	    if (contactNumber.length > 0) {
		    contactBy = contactNumber.match(/^(04|614|6104)/g) ? 'mobile' : 'other';
	    }
	    return contactBy;
    }

	function getPhone(){
		var mobile = $elements.phone.application.mobile.val();
		if(_.isEmpty(mobile)) {
			var other = $elements.phone.appliction.other.val();
			if(_.isEmpty(other)) {
				mobile = $elements.phone.quote.mobile.val();
				if(_.isEmpty(mobile)) {
					other = $elements.phone.quote.other.val();
					if(_.isEmpty(other)) {
						return null;
					}
					return other;
				}
			}
			return other;
		}
		return mobile;
	}

    meerkat.modules.register('healthContactNumber', {
        init: initHealthContactNumber,
        insertContactNumber: insertContactNumber,
        getContactNumberFromField: getContactNumberFromField,
	    getPhone: getPhone
    });

})(jQuery);