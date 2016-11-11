;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var modalId = false,
		templateCLIFilter = false,
		action = false,// add, delete
		$targetForm = false;

	function init() {
		$(document).ready(function() {

			$('[data-provide="simples-clifilter-action"]').on('click', 'a', function(event) {
				event.preventDefault();

				action = $(this).data('action');

				// Set up templates
				var $e = $('#simples-template-clifilter-' + action);
				if ($e.length > 0) {
					templateCLIFilter = _.template($e.html());
				}

				openModal();
			});

			// Event: CLI Filter form submit (uses #dynamic_dom because that is static on the page so retains the event binds)
			$('#dynamic_dom').on('click', '[data-provide="simples-clifilter-submit"]', function(event) {
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

		if (typeof templateCLIFilter === 'function') {

			if (data.errorMessage && data.errorMessage.length > 0) {
				// Error message has been specified elsewhere
			}

			// Run the template
			htmlContent = templateCLIFilter(data);
		}

		// Replace modal with updated contents
		meerkat.modules.dialogs.changeContent(modalId, htmlContent);

	}

	function performSubmit() {

		//Setup target form based on the action
		$targetForm = $('#simples-' + action + '-clifilter');
		
		if (validateForm()) {
			var formData = {
				value: $targetForm.find('input[name="phone"]').val().trim().replace(/\s+/g, ''),
				comment: $targetForm.find('textarea[name="comment"]').val().trim()
			};

			var url = 'spring/rest/simples/clifilter/' + action + '.json',
				actionText = action === 'add' ? 'added to' : 'deleted from',
				successMessage = 'Success : ' + formData.value + ' is ' + actionText  + ' CLI Filter';
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
		var comment = $targetForm.find('textarea[name="comment"]').val().trim();
		var $error = $targetForm.find('.form-error');

		if (phoneNumber === '' || !isValidPhoneNumber(phoneNumber)) {
			$error.text('Please enter a valid phone number.');
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

	meerkat.modules.register('simplesCLIFilter', {
		init: init
	});

})(jQuery);
