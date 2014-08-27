;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var modalId = false,
		templateBlackList = false,
		action = false, // add or delete
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

	function performSubmit() {

		//Setup target form based on the action
		$targetForm = $('#simples-' + action + '-blacklist');
		
		if (validateForm()) {
			var formData = {
				action: action,
				value: $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, ''),
				channel: $targetForm.find('select[name="channel"]').val().trim(),
				comment: $targetForm.find('textarea[name="comment"]').val().trim()
			}

			meerkat.modules.comms.post({
				url: 'simples/ajax/blacklist_action.jsp',
				dataType: 'json',
				cache: false,
				errorLevel: 'silent',
				timeout: 5000,
				data: formData,
				onSuccess: function onSuccess(json) {
					updateModal(json);
				},
				onError: function onError(obj, txt, errorThrown) {
					updateModal({errorMessage: txt + ': ' + errorThrown});
				}
			});	
		}

	}

	function validateForm() {

		if ($targetForm === false) return false;

		var phoneNumber = $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, '');
		console.log(phoneNumber);
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


	meerkat.modules.register('simplesBlackList', {
		init: init
	});

})(jQuery);
