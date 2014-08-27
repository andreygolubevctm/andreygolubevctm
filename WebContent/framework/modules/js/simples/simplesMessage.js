/*
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var events = {
			simplesMessage: {
				MESSAGE_CHANGE: 'MESSAGE_CHANGE'
			}
		},
		moduleEvents = events.simplesMessage;

	var modalId = false,
		templateMessageDetail = false,
		currentMessage = false;



	function init() {
		$(document).ready(function() {

			//
			// Set up templates
			//
			$e = $('#simples-template-messagedetail');
			if ($e.length > 0) {
				templateMessageDetail = _.template($e.html());
			}

			//
			// Message detail modal
			//
			$('#dynamic_dom').on('click', '.messagedetail-loadbutton', function(event) {
				event.preventDefault();
				loadMessage();
			});
		});
	}

	function loadMessage() {
		if (currentMessage === false || !currentMessage.hasOwnProperty('messageId')) {
			alert('Message details have not been stored correctly - can not load.');
			return;
		}

		var $button = $('#'+modalId).find('.messagedetail-loadbutton');
		$button.prop('disabled', true);
		meerkat.modules.loadingAnimation.showInside($button, true);

		// 1. Set message status to in progress
		meerkat.modules.comms.post({
			url: 'simples/ajax/message_set_inprogress.jsp',
			dataType: 'json',
			cache: false,
			errorLevel: 'silent',
			data: {
				messageId: currentMessage.messageId
			},
			onSuccess: function onSuccess(json) {
				if (json.hasOwnProperty('errors') && json.errors.length > 0) {
					alert('Could not set message to In Progress...\n' + json.errors[0].message);
					$button.prop('disabled', false);
					meerkat.modules.loadingAnimation.hide($button);
					return;
				}

				// 2. Make call

				// 3. Load the quote
				var url = 'simples/loadQuote.jsp?brandId=' + currentMessage.styleCodeId + '&verticalCode=' + currentMessage.vertical + '&transactionId=' + currentMessage.transactionId + '&action=amend';
				meerkat.modules.simplesLoadsafe.loadsafe(url, true);

				// Publish the new message
				meerkat.messaging.publish(moduleEvents.MESSAGE_CHANGE, currentMessage);

				// Clean up
				meerkat.modules.dialogs.close(modalId);
			},
			onError: function onError(obj, txt, errorThrown) {
				alert('Could not set message to In Progress...\n' + txt + ': ' + errorThrown);
				$button.prop('disabled', false);
				meerkat.modules.loadingAnimation.hide($button);
			}
		});
	}

	function getNextMessage() {
		modalId = meerkat.modules.dialogs.show({
			title: 'Message assigned to you:',
			buttons: [{
				label: 'Cancel',
				className: 'btn-cancel',
				closeWindow: true
			},
			{
				label: 'Load',
				className: 'btn-save messagedetail-loadbutton',
				closeWindow: false
			}],
			onOpen: function(id) {
				modalId = id;

				// Hide the close button
				$('#'+modalId).find('.modal-closebar').addClass('hidden');

				meerkat.modules.dialogs.changeContent(modalId, meerkat.modules.loadingAnimation.getTemplate());
				$('#'+modalId).find('.messagedetail-loadbutton').prop('disabled', true);

				meerkat.modules.comms.get({
					url: 'simples/messages/next.json',
					cache: false,
					errorLevel: 'silent',
					onSuccess: function onSuccess(json) {
						updateModal(json, templateMessageDetail);

						// Store the data
						currentMessage = json;

						// If no errors, enable the Load button
						if (json.hasOwnProperty('errors') === false || json.errors.length === 0) {
							// Is the ID ok?
							if (currentMessage.messageId > 0) {
								$('#'+modalId).find('.messagedetail-loadbutton').prop('disabled', false);
							}
						}
					},
					onError: function onError(obj, txt, errorThrown) {
						var json = {"errors":[{"message": txt + ': ' + errorThrown}]};
						updateModal(json, templateMessageDetail);
					}
				});
			}
		});
	}

	function performFinish(type, data, callbackSuccess, callbackError) {
		//alert('Message ID: ' + currentMessageId + ', statusId: ' + statusId);

		if (!type) return;

		if (currentMessage === false || !currentMessage.hasOwnProperty('messageId')) {
			alert('Message details have not been stored correctly - can not load.');
			return;
		}

		if (currentMessage.messageId === false || isNaN(currentMessage.messageId)) {
			alert('No Message ID is currently known, so can not set as complete.');
			return;
		}

		data = data || {};
		data.messageId = currentMessage.messageId;

		meerkat.modules.comms.post({
			url: 'simples/ajax/message_set_' + type + '.jsp',
			dataType: 'json',
			cache: false,
			errorLevel: 'silent',
			data: data,
			onSuccess: function onSuccess(json) {
				if (json.hasOwnProperty('errors') && json.errors.length > 0) {
					alert('Could not set to ' + type + '...\n' + json.errors[0].message);
					if (typeof callbackError === 'function') callbackError();
					return;
				}

				// Clear message
				meerkat.messaging.publish(moduleEvents.MESSAGE_CHANGE, false);
				currentMessage = false;

				// Callback
				if (typeof callbackSuccess === 'function') callbackSuccess();
			},
			onError: function onError(obj, txt, errorThrown) {
				alert('Could not set to ' + type + '...\n' + txt + ': ' + errorThrown);

				// Callback
				if (typeof callbackError === 'function') callbackError();
			}
		});
	}

	function updateModal(data, template) {
		var htmlContent = 'No template found.';
		data = data || {};

		if (typeof template === 'function') {
			// Run the template
			htmlContent = template(data);
		}

		// Replace modal with updated contents
		meerkat.modules.dialogs.changeContent(modalId, htmlContent);

	}



	meerkat.modules.register('simplesMessage', {
		init: init,
		events: events,
		getNextMessage: getNextMessage,
		performFinish: performFinish
	});

})(jQuery);
