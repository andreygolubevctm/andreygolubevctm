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

	var templateMessageDetail = false,
		currentMessage = false,
		$messageDetailsContainer,
		baseUrl = '';



	function init() {
		$(document).ready(function() {

			baseUrl = meerkat.modules.simples.getBaseUrl();
			$messageDetailsContainer = $('.simples-message-details-container');

			//
			// Set up templates
			//
			$e = $('#simples-template-messagedetail');
			if ($e.length > 0) {
				templateMessageDetail = _.template($e.html());
			}

			//
			// Navbar button (when this module is run by the main page)
			//
			$('.simples-menubar .simples-homebutton').on('click.simplesMessage', function clickHome(event) {
				// Clear message
				setCurrentMessage(false);

				// Clear tranId
				meerkat.messaging.publish(meerkat.modules.events.simplesInterface.TRANSACTION_ID_CHANGE, false);
			});

			//
			// Simples home page
			//
			var $checkSimplesHome = $('.simples-home');
			if ($checkSimplesHome.length > 0) {
				$('.message-getnext').on('click.simplesMessage', function clickNext(event) {
					event.preventDefault();

					var $button = $(event.target);
					if ($button.prop('disabled') === true) {
						return;
					}

					$button.prop('disabled', true).addClass('disabled');
					$messageDetailsContainer.empty();
					meerkat.modules.loadingAnimation.showInside($messageDetailsContainer);

					getNextMessage(function nextComplete() {
						$button.prop('disabled', false).removeClass('disabled');
					});
				});

				// Check if Simples is being launched from the InIn dialler
				var urlVars = getUrlVars();
				if (urlVars.hasOwnProperty('launchTranId')) {
					performLauncherSearch(urlVars['launchTranId']);
				}
			}

			//
			// Message details
			//
			var messageId = 0;
			if ($messageDetailsContainer.length > 0) {
				// Render
				renderMessageDetails(false, $messageDetailsContainer);

				// Subscribe to changes (be mindful this is only within the scope of the owner frame)
				meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function messageChange(obj) {
					renderMessageDetails(obj, $messageDetailsContainer);
					messageId = obj.message.messageId;
				});

				// Amend quote button
				$messageDetailsContainer.on('click', '.messagedetail-loadbutton', loadMessage);

				// Call buttons
				$messageDetailsContainer.on('click', 'button[data-phone]', makeCall);
			}

			$('#simples-transaction-search-navbar').on('submit', function navbarSearchSubmit(event) {
				event.preventDefault();
				performLauncherSearch($(this).find(':input[name=keywords]').val());
			});
		});
	}

	// Read a page's GET URL variables and return them as an associative array.
	function getUrlVars() {
		var vars = [], hash;
		var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
		for(var i = 0; i < hashes.length; i++)
		{
			hash = hashes[i].split('=');
			vars[hash[0]] = hash[1];
		}
		return vars;
	}

	function makeCall(event) {
		event.preventDefault();

		var button = $(this);
		var phone = button.attr('data-phone');

		meerkat.modules.loadingAnimation.showAfter(button);
		meerkat.modules.comms.get({
			url:  baseUrl + 'simples/phones/call.json?phone=' + phone,
			dataType: 'text',
			cache: false,
			errorLevel: 'warning',
			onComplete: function () {
				meerkat.modules.loadingAnimation.hide(button);
			}
		});
	}

	function loadMessage(event) {
		event.preventDefault();

		if (currentMessage === false || !currentMessage.hasOwnProperty('message')) {
			alert('Message details have not been stored correctly - can not load.');
			return;
		}

		var $button = $(event.target);
		$button.prop('disabled', true).addClass('disabled');
		meerkat.modules.loadingAnimation.showAfter($button);

		// Set message status to in progress
		meerkat.modules.comms.post({
			url: baseUrl + 'simples/ajax/message_set_inprogress.jsp',
			dataType: 'json',
			cache: false,
			errorLevel: 'silent',
			data: {
				messageId: currentMessage.message.messageId
			},
			onSuccess: function onSuccess(json) {
				if (json.hasOwnProperty('errors') && json.errors.length > 0) {
					alert('Could not set message to In Progress...\n' + json.errors[0].message);
					$button.prop('disabled', false).removeClass('disabled');
					meerkat.modules.loadingAnimation.hide($button);
					return;
				}

				// Load the quote
				var url = 'simples/loadQuote.jsp?brandId=' + currentMessage.transaction.styleCodeId + '&verticalCode=' + currentMessage.transaction.verticalCode + '&transactionId=' + encodeURI(currentMessage.transaction.newestTransactionId) + '&action=amend';
				log(url);
				meerkat.modules.simplesLoadsafe.loadsafe(url, true);
			},
			onError: function onError(obj, txt, errorThrown) {
				alert('Could not set message to In Progress...\n' + txt + ': ' + errorThrown);
				$button.prop('disabled', false).removeClass('disabled');
				meerkat.modules.loadingAnimation.hide($button);
			}
		});
	}

	function performLauncherSearch(searchTransactionId) {
		if (searchTransactionId === false || searchTransactionId === '') return;

		$messageDetailsContainer.html( meerkat.modules.loadingAnimation.getTemplate() );

		return meerkat.modules.comms.get({
			url: baseUrl + 'simples/transaction/get.json',
			cache: false,
			errorLevel: 'silent',
			useDefaultErrorHandling: false,
			data: {
				transactionId: searchTransactionId
			}
		})
		.then(function onSuccess(json) {
			if (!json.hasOwnProperty('message')) {
				$messageDetailsContainer.html( templateMessageDetail(json) );
			}
			else {
				// Store the data and publish
				setCurrentMessage(json);
			}
		})
		.catch(function onError(obj) {
			var json = {"errors":[]};
			obj.responseJSON.errors.forEach(function(errorMessage){
				json.errors.push({"message": errorMessage});
			});
			$messageDetailsContainer.html( templateMessageDetail(json) );
		});
	}

	function isMobile(value) {
		var phoneRegex = new RegExp('^(0[45]{1}[0-9]{8})$');
		return phoneRegex.test(value);
	}

	function getNextMessage(callbackComplete) {
		meerkat.modules.comms.get({
			url: baseUrl + 'simples/messages/next.json',
			cache: false,
			errorLevel: 'silent'
		})
		.then(function onSuccess(json) {
			if (!json.hasOwnProperty('message') || !json.message.hasOwnProperty('messageId') || json.message.messageId === 0) {
				$messageDetailsContainer.html( templateMessageDetail(json) );
			}
			else {
				// Store the data and publish
				setCurrentMessage(json);
			}
		})
		.catch(function onError(obj, txt, errorThrown) {
			var json = {"errors":[{"message": txt + ': ' + errorThrown}]};
			$messageDetailsContainer.html( templateMessageDetail(json) );
		})
		.always(function onComplete() {
			if (typeof callbackComplete === 'function') {
				callbackComplete();
			}
		});
	}

	function performFinish(type, data, callbackSuccess, callbackError) {
		//alert('Message ID: ' + currentMessageId + ', statusId: ' + statusId);

		if (!type) return;

		if (currentMessage === false || !currentMessage.hasOwnProperty('message')) {
			alert('Message details have not been stored correctly - can not load.');
			return;
		}

		if (currentMessage.message.messageId === false || isNaN(currentMessage.message.messageId)) {
			alert('No Message ID is currently known, so can not set as complete.');
			return;
		}

		data = data || {};
		data.messageId = currentMessage.message.messageId;

		var url = baseUrl + 'simples/ajax/message_set_' + type + '.jsp';
		if (type === 'postpone') {
			url = baseUrl + 'spring/rest/simples/messages/setPostpone.json';
		}

		meerkat.modules.comms.post({
			url: url,
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
				setCurrentMessage(false);

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

	function getCurrentMessage() {
		return currentMessage;
	}

	function setCurrentMessage(message) {
		// Publish to the top frame if necessary
		if (window.self !== window.top) {
			window.top.meerkat.modules.simplesMessage.setCurrentMessage(message);
		}

		currentMessage = message;
		meerkat.messaging.publish(moduleEvents.MESSAGE_CHANGE, currentMessage);
	}

	function renderMessageDetails(message, $destination) {
		$destination = $destination || false;
		if ($destination === false || $destination.length === 0) return;

		if (message === false) {
			$('.simples-notice-board, .simples-splashpage-item').removeClass('hidden');

			var remainingSalesTableTbody = $('.simples-remaining-sales-container #remaining-sales-table').find('tbody');
			remainingSalesTableTbody.empty();

			// update remaining sales
			renderRemainingSales(function (data) {
				var htmlOutput = "";
				var remainingSales = "";
				var remainingDays = "";
				for (var i = 0; i < data.length; i++) {
					remainingSales = data[i].remainingSales > 15 ? '15+' : (data[i].remainingSales);
					remainingDays = data[i].remainingDays == 1 ? data[i].remainingDays + ' day' : data[i].remainingDays + ' days';
					htmlOutput += '<tr><td>' + data[i].fundName + '</td><td>' + remainingSales + ' left</td><td>in ' + remainingDays + '</td></tr>';
				}
				remainingSalesTableTbody.append(htmlOutput);
			});

		}
		else {
			$('.simples-notice-board, .simples-splashpage-item').addClass('hidden');

			// swap numbers if there is only one mobile and this is the 2nd number as we want mobiles displayed first
			if (isMobile(message.message.phoneNumber2) && !isMobile(message.message.phoneNumber1)) {
				var x = message.message.phoneNumber1;
				message.message.phoneNumber1 = message.message.phoneNumber2;
				message.message.phoneNumber2 = x;
			}
		}

		$destination.html( templateMessageDetail(message) );
	}

	function renderRemainingSales(callbackSuccess, callbackError) {
		meerkat.modules.comms.get({
			url: baseUrl + 'spring/rest/simples/remainingSales.json',
			dataType: 'json',
			cache: false,
			errorLevel: 'silent',
			onSuccess: function onSuccess(json) {
				callbackSuccess(json);
			},
			onError: function onError(obj, txt, errorThrown) {
				alert('Could not set to ' + type + '...\n' + txt + ': ' + errorThrown);
			}
		});
	}

	meerkat.modules.register('simplesMessage', {
		init: init,
		events: events,
		getNextMessage: getNextMessage,
		getCurrentMessage: getCurrentMessage,
		setCurrentMessage: setCurrentMessage,
		performFinish: performFinish,
		renderMessageDetails: renderMessageDetails,
		performLauncherSearch: performLauncherSearch
	});

})(jQuery);
