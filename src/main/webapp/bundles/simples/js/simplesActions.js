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

					$actionsDropdown.on('click', '.action-comment', function(event) {
						if ($(this).parent('li').hasClass('disabled')) return false;
						actionComments();
					});

                    $actionsDropdown.on('click', '.action-unlock', function(event) {
                        if ($(this).parent('li').hasClass('disabled')) return false;
                        meerkat.modules.simplesTransactionLocker.unlock();
                    });
				});


				// Subscribe to the transactionId changing
				meerkat.messaging.subscribe(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, function tranIdChange(obj) {
					// Store the ID
					currentTransactionId = obj || false;

					updateMenu();
				});

				// Subscribe to the messageId changing
				meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function messageChange(obj) {
					// Store the ID
					currentMessage = obj || false;

					if (currentMessage.hasOwnProperty('transaction')) {
						currentTransactionId = currentMessage.transaction.transactionId;
					}

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
		var $actionCompletePmParent = $actionsDropdown.find('.action-complete-pm').parent('li');
		var $actionChangeTimeParent = $actionsDropdown.find('.action-change-time').parent('li');
		var $actionRemovePmParent = $actionsDropdown.find('.action-remove-pm').parent('li');

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
		if (currentMessage === false || isNaN(currentMessage.message.messageId)) {
			if (showMenu === false) showMenu = false;

			$msgId.text('None');
			$actionCompleteParent.addClass('disabled');
			$actionUnsuccessfulParent.addClass('disabled');
			$actionPostponeParent.addClass('disabled');
			$actionCompletePmParent.addClass('disabled');
			$actionChangeTimeParent.addClass('disabled');
			$actionRemovePmParent.addClass('disabled');

		}
		else {
			showMenu = true;

			$msgId.text(currentMessage.message.messageId);
			$actionCompleteParent.removeClass('disabled');
			$actionUnsuccessfulParent.removeClass('disabled');
			$actionRemovePmParent.removeClass('disabled');

			// Can the message be postponed?
			if (currentMessage.message.hasOwnProperty('canPostpone') && currentMessage.message.canPostpone === true) {
				$actionPostponeParent.removeClass('disabled');
				$actionCompletePmParent.removeClass('disabled');
				$actionChangeTimeParent.removeClass('disabled');
			}
			else {
				$actionPostponeParent.addClass('disabled');
				$actionCompletePmParent.addClass('disabled');
				$actionChangeTimeParent.addClass('disabled');
			}

			// If set to completed as pm, user will need to see a different Active dropdown
			if (isCompletedAsPM()) {
				
				$actionRemovePmParent.show();
				$actionChangeTimeParent.show();

				$actionCompleteParent.hide();
				$actionCompletePmParent.hide();
				$actionPostponeParent.hide();
				$actionUnsuccessfulParent.hide();
			}else{
				$actionRemovePmParent.hide();
				$actionChangeTimeParent.hide();

				$actionCompleteParent.show();
				$actionCompletePmParent.show();
				$actionPostponeParent.show();
				$actionUnsuccessfulParent.show();
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

	function actionRemovePM() {
		modalId = meerkat.modules.dialogs.show({
			title: ' ',
			htmlContent: '<p>Are you sure to delete this scheduled call back from your personal messages?</p>',
			buttons: [
				{
				label: 'No',
				className: 'btn-cancel',
				closeWindow: true
				},
				{
					label: 'Yes',
					className: 'btn-cta message-savebutton',
					closeWindow: false
				}
			],
			onOpen: function(id) {
				modalId = id;
				var $modal = $('#'+modalId);
				var $button = $modal.find('.message-savebutton');

				$button.on('click', function loadClick() {
					$button.prop('disabled', true);
					meerkat.modules.loadingAnimation.showInside($button, true);

					var data = {
						rootId: currentMessage.message.transactionId
					};

					meerkat.modules.comms.post({
						url: meerkat.modules.simples.getBaseUrl() + 'spring/rest/simples/messages/removePersonalMessage.json',
						dataType: 'json',
						cache: false,
						errorLevel: 'silent',
						data: data,
						onSuccess: function onSuccess(json) {
							if (json.hasOwnProperty('errors') && json.errors.length > 0) {
								alert('Could not remove the personal message...\n' + json.errors[0].message);
								return;
							}

							// Clear message
							meerkat.modules.simplesMessage.setCurrentMessage(false);

							// Click the nav bar home button
							if ($homeButton.length > 0) $homeButton[0].click();

							// Clean up
							meerkat.modules.dialogs.close(modalId);
						},
						onError: function onError(obj, txt, errorThrown) {
							alert('Could not remove the personal message...\n' + txt + ': ' + errorThrown);
						}
					});
				});
			}
		});
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
		else if (type === 'remove_pm') {
			parentStatusId = 33;
			type = 'complete';
		}

		var isFailJoin = false;
		if (currentMessage.message.sourceId === 5 || currentMessage.message.sourceId === 8) {
			isFailJoin = true;
		}

		modalId = meerkat.modules.dialogs.show({
			title: ' ',
			url: 'simples/ajax/message_statuses.html.jsp?parentStatusId=' + parentStatusId + '&isFailJoin=' + isFailJoin,
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

					meerkat.modules.simplesMessage.performFinish(type, {statusId:parentStatusId, reasonStatusId:statusId}, function performCallback() {
						// Click the nav bar home button
						if ($homeButton.length > 0) $homeButton[0].click();

						// Clean up
						meerkat.modules.dialogs.close(modalId);
					});
				});
			}
		});

	}

	function actionPostpone(assignToUser, type) {
		if (!type) return;

		var parentStatusId = 0;
		var heading = '';
		if (type === 'postpone') {
			parentStatusId = 4;
			heading = 'Postpone this message';
		}
		else if (type === 'complete_pm') {
			parentStatusId = 31;
			heading = 'Complete as PM';
		}
		else if (type === 'change_time') {
			parentStatusId = 32;
			heading = 'Change Time';
		}

		heading = encodeURIComponent(heading);

		meerkat.modules.dialogs.show({
			title: ' ',
			className: (_.indexOf([31,32], parentStatusId) >= 0 ? 'simples-messagescolumn-dialog' : 'simples-postpone-dialog'),
			buttons: [{
				label: 'Cancel',
				className: 'btn-cancel',
				closeWindow: true
			},
			{
				label: 'Postpone',
				className: 'btn-save btn-cta message-savebutton',
				closeWindow: false
			}],
			onOpen: function postponeModalOpen(id) {

				modalId = id;

				var $modal = $('#'+modalId);
				var $button = $modal.find('.message-savebutton');
				$button.prop('disabled', true);

				// Loading animation
				meerkat.modules.dialogs.changeContent(modalId, meerkat.modules.loadingAnimation.getTemplate());

				// Get some content
				meerkat.modules.comms.get({
					url: 'simples/ajax/message_statuses.json.jsp?parentStatusId=' + parentStatusId + '&heading=' + heading,
					dataType: 'json',
					cache: true,
					errorLevel: 'silent'
				})
				.then(function onSuccess(json) {
					json.parentStatusId = parentStatusId;
					updateModal(json, templatePostpone);
				})
				.catch(function onError(obj, txt, errorThrown) {
					updateModal(null, templatePostpone);
				})
				.always(function onComplete() {
					// Enable button
					$button.prop('disabled', false);

					// Default values
					$('#postponehour').val('04');

					// Prepare the start and finish dates for datepicker
					var getDateFormat = function(dateObj) {
							return dateObj.getFullYear() + "-"
							+ ("0" + (dateObj.getMonth() + 1)).slice(-2) + "-"
							+ ("0" + dateObj.getDate()).slice(-2);
					};
					var currentDate = new Date();
					var today = getDateFormat(currentDate);
					currentDate.setMonth(currentDate.getMonth() + 6);
					var future = getDateFormat(currentDate);

					// Set up datepicker
					var $picker = $modal.find('#postponedate_calendar');
					$picker.datepicker({
						startDate: today, // today
						endDate: future,   // 6 months
						clearBtn: false,
						format: 'yyyy-mm-dd'
					})
					.find('table').addClass('table');

					// Put datepicker value into field
					$modal.on('changeDate', $picker, function picker(e) {
						$modal.find('#postponedate').val( e.format('yyyy-mm-dd') );
					});

					// Hook up save button
					$button.on('click', function saveClick() {
						$button.prop('disabled', true);
						meerkat.modules.loadingAnimation.showInside($button, true);

						var data = {
							postponeDate: $modal.find('#postponedate').val(),
							postponeTime: $modal.find('#postponehour').val() + ':' + $modal.find('#postponeminute').val(),
							postponeAMPM: $modal.find('input[name="postponeampm"]:checked').val(),
							statusId: parentStatusId,
							reasonStatusId: $modal.find('select[name="reason"]').val(),
							comment: $modal.find('textarea').val(),
							assignToUser: assignToUser,
							rootId: currentMessage.message.transactionId,
							contactName: currentMessage.message.contactName
						};

						// Validation checks
						if ((!_.isString(data.postponeDate) || data.postponeDate.length === 0) || (!_.isString(data.postponeAMPM) || data.postponeAMPM.length === 0)) {
							meerkat.modules.dialogs.show({
								title: ' ',
								htmlContent: 'Please check fields: date, time and AM/PM.',
								buttons: [{ label: 'OK', className: 'btn-cta', closeWindow: true }]
							});

							$button.prop('disabled', false);
							meerkat.modules.loadingAnimation.hide($button);
							return;
						}

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

					// Add existing messages to view
					var $messages = $modal.find(".personal-messages-container");
					$messages.empty();
					meerkat.modules.simplesPostponedQueue.initDateStuff();
					var messages = document.getElementById('simplesiframe').contentWindow.meerkat.modules.simplesPostponedQueue.getMessageQueue();
					if(!_.isEmpty(messages)) {
						for(var i = 0; i < messages.length; i++) {
							$messages.append(
								$("<span/>").addClass("well")
								.append($("<strong/>").append(messages[i].contactName))
								.append(":&nbsp;" + formatWhenToAction(messages[i].whenToAction))
							);
						}
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
				var json = {"errors":[{"message": txt + ': ' + errorThrown}]};
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

	function isCompletedAsPM() {
		if (meerkat.site.inInEnabled === true && currentMessage.message.isPM === true) {
			return true;
		}

		if (currentMessage.hasOwnProperty("messageaudits")) {
			for (var i = 0; i < currentMessage.messageaudits.length; i++) {
				var auditObj = currentMessage.messageaudits[i];
				if (auditObj.hasOwnProperty("statusId") && auditObj.statusId === 31) {
					return true;
				}
			}
		}
		return false;
	}

	function formatWhenToAction(dateStr) {

		var whenToAction = Date.parse(dateStr) || false;
		if (whenToAction !== false) {
			whenToAction = new Date(whenToAction);
			var ampm = 'am';
			var hours = whenToAction.getHours();
			if (hours < 10) {
				hours = '0' + hours;
			} else if (hours == 12) {
				ampm = 'pm';
			} else if (hours > 12) {
				ampm = 'pm'; hours -= 12;
			}
			var minutes = (whenToAction.getMinutes() < 10) ? '0' + whenToAction.getMinutes() : whenToAction.getMinutes();
			return whenToAction.getDayNameShort() + ' ' + whenToAction.getDate() + ' ' + whenToAction.getMonthNameShort() + ' ' + hours + ':' + minutes + ampm;
		} else {
			return dateStr;
		}
	}

	meerkat.modules.register('simplesActions', {
		init: init
	});

})(jQuery);
