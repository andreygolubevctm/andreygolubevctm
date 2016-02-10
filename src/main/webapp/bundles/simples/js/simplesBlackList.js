;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var modalId = false,
		templateBlackList = false,
		action = false,// add, delete, or unsubscribe
		$targetForm = false;

	function init() {
		$(document).ready(function() {

			$('[data-provide="simples-blacklist-action"]').on('click', 'a', function(event) {
				event.preventDefault();

				action = $(this).data('action');

				// Set up templates
				var $e = $('#simples-template-blacklist-' + action);
				if ($e.length > 0) {
					templateBlackList = _.template($e.html());
				}

				openModal();
			});

			// Event: Blacklist form submit (uses #dynamic_dom because that is static on the page so retains the event binds)
			$('#dynamic_dom').on('click', '[data-provide="simples-blacklist-submit"]', function(event) {
				event.preventDefault();
				performSubmit();
			});

			$('#dynamic_dom').on('click', '[data-provide="simples-unsubscribe-submit"]', function(event) {
				event.preventDefault();
				performUnsubscribe();
			});

		});
	}

	function openModal() {
		modalId = meerkat.modules.dialogs.show({
			title: ' ',
			fullHeight: true,
			onOpen: function(id) {
				modalId = id;
				updateModal();
			},
			onClose: function() {
			}
		});
	}

	function updateModal(data) {
		var htmlContent = 'No template found.';
		data = data || {};

		if (typeof templateBlackList === 'function') {

			if (data.errorMessage && data.errorMessage.length > 0) {
				// Error message has been specified elsewhere
			}

			// Run the template
			htmlContent = templateBlackList(data);
		}

		// Replace modal with updated contents
		meerkat.modules.dialogs.changeContent(modalId, htmlContent);

	}

	function performUnsubscribe() {
		$targetForm = $('#simples-unsubscribe-email');

		if(validateUnsubscribeForm()) {
			var formData = {
				email: $targetForm.find('input[name="email"]').val().replace(/ /g,''),
				comment: $targetForm.find('textarea[name="comment"]').val().trim()
			};

			var url = 'spring/rest/simples/blacklist/unsubscribe.json',
				successMessage = 'Success : ' + formData.email + ' is unsubscribed from all verticals';
			makeAjaxCall(url, formData, successMessage);
		}
	}

	function performSubmit() {

		//Setup target form based on the action
		$targetForm = $('#simples-' + action + '-blacklist');
		
		if (validateForm()) {
			var formData = {
				value: $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, ''),
				channel: $targetForm.find('select[name="channel"]').val().trim(),
				comment: $targetForm.find('textarea[name="comment"]').val().trim()
			};

			var url = 'spring/rest/simples/blacklist/' + action + '.json',
				actionText = action === 'add' ? 'added to' : 'deleted from',
				successMessage = 'Success : ' + formData.value + ' [' + formData.channel + '] is ' + actionText  + ' Blacklist';
			makeAjaxCall(url, formData, successMessage);
		}

	}

	function makeAjaxCall(url, formData, successMessage) {
		meerkat.modules.comms.post({
			url: url,
			dataType: 'json',
			cache: false,
			errorLevel: 'silent',
			timeout: 10000,
			data: formData,
			onSuccess: function onSuccess(json) {
				if(json.outcome === 'success') {
					updateModal({'successMessage': successMessage});
				} else {
					updateModal({'errorMessage': 'Failed : ' + json.outcome});
				}
			},
			onError: function onError(obj, txt, errorThrown) {
				updateModal({errorMessage: txt + ': ' + errorThrown});
			}
		});
	}

	function validateForm() {

		if ($targetForm === false) return false;

		var phoneNumber = $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, '');
		var channel = $targetForm.find('select[name="channel"]').val().trim();
		var comment = $targetForm.find('textarea[name="comment"]').val().trim();
		var $error = $targetForm.find('.form-error');

		if (phoneNumber === '' || !isValidPhoneNumber(phoneNumber)) {
			$error.text('Please enter a valid phone number.');
			return false;
		}
		if (channel === '' || (channel !== 'phone' && channel !== 'sms')) {
			$error.text('Channel has to be either [Phone] or [SMS].');
			return false;
		}
		if (comment === '') {
			$error.text('Comment length can not be zero.');
			return false;
		}

		$error.text('');
		return true;
	}

	// Validate phone number
	function isValidPhoneNumber(phone) {
		if (phone.length === 0) return true;

		var valid = true;
		var strippedValue = phone.replace(/[^0-9]/g, '');
		if (strippedValue.length === 0 && phone.length > 0) {
			return false;
		}

		var phoneRegex = new RegExp('^(0[234785]{1}[0-9]{8})$');
		valid = phoneRegex.test(strippedValue);
		return valid;
	}

	function validateUnsubscribeForm() {
		if ($targetForm === false) return false;

		var email = $targetForm.find('input[name="email"]').val().replace(/ /g,''),
			comment = $targetForm.find('textarea[name="comment"]').val().trim(),
			$error = $targetForm.find('.form-error'),
			//regex from jquery.validate.js
			emailRegex = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i;

		if (email === '' || !emailRegex.test(email)) {
			$error.text('Please enter a valid email address.');
			return false;
		}

		if (comment === '') {
			$error.text('Comment length can not be zero.');
			return false;
		}

		$error.text('');
		return true;
	}


	meerkat.modules.register('simplesBlackList', {
		init: init
	});

})(jQuery);
