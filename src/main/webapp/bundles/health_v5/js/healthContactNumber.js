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
	    sanitisedExistingPhoneNumbers();
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

    function getPhoneForType(rawPhone, type) {
    	var phone = meerkat.modules.phoneFormat.cleanNumber(rawPhone);
    	var phoneType = meerkat.modules.phoneFormat.getPhoneType(phone);
	    switch(type) {
		    case "flexi":
		    	return phoneType !== null ? phone : "";
		    case "mobile":
			    return phoneType === 'mobile' ? phone : "";
		    case "landline":
			    return phoneType === 'landline' ? phone : "";
		    default:
		    	return "";
	    }
    }
    
    function sanitisedExistingPhoneNumbers() {
	    var phones = {
			    flexi : $elements.flexiNumber.val(),
			    quote : {
				    mobile : $elements.phone.quote.mobile.val(),
				    other : $elements.phone.quote.other.val()
			    },
			    application : {
				    mobile : $elements.phone.application.mobile.val(),
				    other : $elements.phone.application.other.val()
			    }
	    };
	    // //////////////////////////////////////////////////////////////////
        // This is to resolve cases where invalid numbers remain in a field
        // even though the validation has failed and user has taken a step
        // backwards in the journey. Rather than write that invalid value
        // to the database we'll remove them (but keep the source input
	    // field unchanged so user still aware number is invalid).
	    // //////////////////////////////////////////////////////////////////
	    var phone = "";
	    if(!_.isEmpty(phones.flexi)) {
	    	$elements.flexiNumber.val(getPhoneForType(phones.flexi, "flexi"));
	    }
	    if(!_.isEmpty(phones.quote.mobile)) {
	    	$elements.phone.quote.mobile.val(getPhoneForType(phones.quote.mobile, "mobile"));
	    }
	    if(!_.isEmpty(phones.quote.other)) {
		    $elements.phone.quote.other.val(getPhoneForType(phones.quote.other, "landline"));
	    }
	    if(!_.isEmpty(phones.application.mobile)) {
		    $elements.phone.application.mobile.val(getPhoneForType(phones.quote.mobile, "mobile"));
	    }
	    if(!_.isEmpty(phones.application.other)) {
		    $elements.phone.application.other.val(getPhoneForType(phones.quote.other, "landline"));
	    }
    }

    function insertContactNumber($contactNumberContainer, contactNumber) {
    	contactNumber = meerkat.modules.phoneFormat.cleanNumber(contactNumber);
    	var contactBy = getContactBy(contactNumber);
        if(contactBy !== false) {
            $contactNumberContainer.attr('data-contact-by', contactBy);
            $contactNumberContainer.find('.contact-number-' + contactBy + ' input.contact-number-field').val(contactNumber)
            .trigger("change").trigger("blur").trigger("focusout");
        }
    }

    function getContactNumberFromField($contactNumberContainer) {
        var contactBy = $contactNumberContainer.attr('data-contact-by');

        return $contactNumberContainer.find('.contact-number-' + contactBy + ' input.contact-number-field').val();
    }

    function getContactBy(contactNumber) {
        var type = meerkat.modules.phoneFormat.getPhoneType(contactNumber);
        switch(type) {
	        case 'mobile':
	        	return 'mobile';
	        case 'landline':
	        	return 'other';
	        default:
	        	return false;
        }
    }

	function getPhone(){
		var mobile = $elements.phone.application.mobile.val();
		if(_.isEmpty(mobile)) {
			var other = $elements.phone.application.other.val();
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
	    getPhone: getPhone,
	    sanitisedExistingPhoneNumbers: sanitisedExistingPhoneNumbers
    });

})(jQuery);