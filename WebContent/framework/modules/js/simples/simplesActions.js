/*
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var modalId = false,
		currentTransactionId = false,
		currentMessage = false,
		templateComments = false,
		templatePostpone = false,
		$actionsDropdown = false,
		$homeButton = false;



	function init() {
		$(document).ready(function() {

			$homeButton = $('nav .simples-homebutton');

			//
			// Only do the following if found on the page
			//
			var $checkHasActionsDropdown = $("[data-provide='simples-quote-actions']");
			if ($checkHasActionsDropdown.length > 0) {

				// Actions dropdown menu
				$checkHasActionsDropdown.each(function(){
					$actionsDropdown = $(this);

					$actionsDropdown.on('click', '.action-complete', function() {
						if ($(this).parent('li').hasClass('disabled')) return false;
						actionFinish('complete');
					});

					$actionsDropdown.on('click', '.action-unsuccessful', function() {
						if ($(this).parent('li').hasClass('disabled')) return false;
						actionFinish('unsuccessful');
					});

					$actionsDropdown.on('click', '.action-postpone', function(event) {
						if ($(this).parent('li').hasClass('disabled')) return false;
						actionPostpone();
					});

					$actionsDropdown.on('click', '.action-comment', function(event) {
						if ($(this).parent('li').hasClass('disabled')) return false;
						actionComments();
					});
				});

				// Subscribe to the transactionId changing
				meerkat.messaging.subscribe(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, function tranIdChange(obj) {
					// Store the ID
					currentTransactionId = obj || false;

					updateMenu();
				});

				// Subscribe to the messageId changing
				meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function idChange(obj) {
					// Store the ID
					currentMessage = obj || false;

					updateMenu();
				});

				// Set up templates
				$e = $('#simples-template-comments');
				if ($e.length > 0) {
					templateComments = _.template($e.html());
				}

				$e = $('#simples-template-postpone');
				if ($e.length > 0) {
					templatePostpone = _.template($e.html());
				}

			}

			//
			// Simples home page
			//
			var $checkSimplesHome = $('.simples-home');
			if ($checkSimplesHome.length > 0) {
				$('.message-getnext').on('click', function clickNext(event) {
					event.preventDefault();

					// Try to call the function from the parent so the modal overlays whole viewport (plus has access to different scope)
					if (window.top.meerkat && window.top.meerkat.modules.simplesMessage) {
						window.top.meerkat.modules.simplesMessage.getNextMessage();
					}
					else {
						meerkat.modules.simplesMessage.getNextMessage();
					}
				});
			}

		});
	}

	/**
	 * Hide or show the menu as appropriate.
	 * Enable or disable the various options in the menu.
	 */
	function updateMenu() {
		var showMenu = false;

		var $tranId = $actionsDropdown.find('.simples-show-transactionid');
		var $msgId = $actionsDropdown.find('.simples-show-messageid');
		var $actionCompleteParent = $actionsDropdown.find('.action-complete').parent('li');
		var $actionUnsuccessfulParent = $actionsDropdown.find('.action-unsuccessful').parent('li');
		var $actionPostponeParent = $actionsDropdown.find('.action-postpone').parent('li');
		var $actionCommentParent = $actionsDropdown.find('.action-comment').parent('li');

		// Comments menu option
		if (currentTransactionId !== false) {
			showMenu = true;
			$tranId.text(currentTransactionId);
			$actionCommentParent.removeClass('disabled');
		}
		else {
			showMenu = false;
			$tranId.text('None');
			$actionCommentParent.addClass('disabled');
		}

		// Actions menu options
		if (currentMessage === false || isNaN(currentMessage.messageId)) {
			if (showMenu === false) showMenu = false;

			$msgId.text('None');
			$actionCompleteParent.addClass('disabled');
			$actionUnsuccessfulParent.addClass('disabled');
			$actionPostponeParent.addClass('disabled');
		}
		else {
			showMenu = true;

			$msgId.text(currentMessage.messageId);
			$actionCompleteParent.removeClass('disabled');
			$actionUnsuccessfulParent.removeClass('disabled');

			// Can the message be postponed?
			if (currentMessage.hasOwnProperty('canPostpone') && currentMessage.canPostpone === true) {
				$actionPostponeParent.removeClass('disabled');
			}
			else {
				$actionPostponeParent.addClass('disabled');
			}
		}

		// Hide/show the actions navbar menu
		if (showMenu) {
			$actionsDropdown.removeClass('hidden');
		}
		else {
			$actionsDropdown.addClass('hidden');
		}
	}

	/**
	 * This covers Complete and Unsuccessful due to code overlap.
	 */
	function actionFinish(type) {
		if (!type) return;

		var parentStatusId = 0;
		if (type === 'complete') {
			parentStatusId = 2;
		}
		else if (type === 'unsuccessful') {
			parentStatusId = 6;
		}

		modalId = meerkat.modules.dialogs.show({
			title: ' ',
			url: 'simples/ajax/message_statuses.html.jsp?parentStatusId=' + parentStatusId,
			buttons: [{
				label: 'Cancel',
				className: 'btn-cancel',
				closeWindow: true
			},
			{
				label: 'OK',
				className: 'btn-cta message-savebutton',
				closeWindow: false
			}],
			onOpen: function(id) {
				modalId = id;

				var $button = $('#'+modalId).find('.message-savebutton');
				$button.prop('disabled', true);
			},
			onLoad: function() {
				var $modal = $('#'+modalId);
				var $button = $modal.find('.message-savebutton');

				$modal.find('input[type=radio]').on('change', function() {
					$button.prop('disabled', false);
				});

				$button.on('click', function loadClick() {
					$button.prop('disabled', true);
					meerkat.modules.loadingAnimation.showInside($button, true);

					var statusId = $modal.find('input[type=radio]:checked').val();

					meerkat.modules.simplesMessage.performFinish(type, {reasonStatusId:statusId}, function performCallback() {
						// Click the nav bar home button
						if ($homeButton.length > 0) $homeButton[0].click();

						// Clean up
						meerkat.modules.dialogs.close(modalId);
					});
				});
			}
		});

	}

	function actionPostpone() {
		meerkat.modules.dialogs.show({
			title: 'Postpone message',
			buttons: [{
				label: 'Cancel',
				className: 'btn-cancel',
				closeWindow: true
			},
			{
				label: 'OK',
				className: 'btn-save message-savebutton',
				closeWindow: false
			}],
			onOpen: function(id) {
				modalId = id;

				var $modal = $('#'+modalId);
				var $button = $modal.find('.message-savebutton');
				$button.prop('disabled', true);

				// Loading animation
				meerkat.modules.dialogs.changeContent(modalId, meerkat.modules.loadingAnimation.getTemplate());

				// Get some content
				meerkat.modules.comms.get({
					url: 'simples/ajax/message_statuses.json.jsp?parentStatusId=4',
					dataType: 'json',
					cache: true,
					errorLevel: 'silent',
					onSuccess: function onSuccess(json) {
						updateModal(json, templatePostpone);
					},
					onError: function onError(obj, txt, errorThrown) {
						updateModal(null, templatePostpone);
					},
					onComplete: function onComplete() {
						// Enable button
						$button.prop('disabled', false);

						// Set up datepicker
						var $picker = $modal.find('#postponedate');
						$picker.datepicker({
							clearBtn: false,
							format: 'dd/mm/yyyy'
						});
						$picker.siblings('.input-group-addon').on('click', function(){
							$picker.datepicker('show');
						});

						// Hook up save button
						$button.on('click', function loadClick() {
							$button.prop('disabled', true);
							meerkat.modules.loadingAnimation.showInside($button, true);

							var data = {
								postponeDate: $modal.find('#postponedate').val(),
								postponeTime: $modal.find('#postponetime').val(),
								reasonStatusId: $modal.find('select').val(),
								comment: $modal.find('textarea').val(),
								assignToUser: $modal.find('#assigntome').is(':checked')
							};

							meerkat.modules.simplesMessage.performFinish('postpone', data, function performCallback() {
								// Click the nav bar home button
								if ($homeButton.length > 0) $homeButton[0].click();

								// Clean up
								meerkat.modules.dialogs.close(modalId);
							},
							function callbackError() {
								$button.prop('disabled', false);
								meerkat.modules.loadingAnimation.hide($button);
							});
						});
					}
				});
			}
		});
	}

	function actionComments() {

		// Open modal and show loading animation
		openModal(function() {
			meerkat.modules.dialogs.changeContent(modalId, meerkat.modules.loadingAnimation.getTemplate());
		});

		meerkat.modules.comms.get({
			url: 'simples/comments/list.json',
			cache: false,
			errorLevel: 'silent',
			data: {
				transactionId: currentTransactionId
			},
			onSuccess: function onSuccess(json) {
				updateModal(json, templateComments);
			},
			onError: function onError(obj, txt, errorThrown) {
				var json = {"errors":[{"message": txt + ' ' + errorThrown}]};
				updateModal(json, templateComments);
			}
		});
	}

	function openModal(callbackOpen) {
		modalId = meerkat.modules.dialogs.show({
			title: ' ',
			fullHeight: true,
			onOpen: function(id) {
				modalId = id;

				if (typeof callbackOpen === 'function') {
					callbackOpen();
				}
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



	meerkat.modules.register('simplesActions', {
		init: init
	});

})(jQuery);
