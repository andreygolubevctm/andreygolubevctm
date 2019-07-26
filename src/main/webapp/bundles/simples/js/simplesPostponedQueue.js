/*
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var templatePQ = false,
		$container = false,
		baseUrl = '',
		viewMessageInProgress = false,
		currentMessageQueue = [];

	function init() {
		$(document).ready(function() {

			$container = $('.simples-postpone-queue-container');
			if ($container.length === 0) return;

			baseUrl = meerkat.modules.simples.getBaseUrl();

			initDateStuff();

			//
			// Set up templates
			//
			var $e = $('#simples-template-postponed-queue');
			if ($e.length > 0) {
				templatePQ = _.template($e.html());
			}

			//
			// Binds
			//
			$container.on('click.viewMessage', '.simples-postponed-message', viewMessage);

			// When message changes, highlight the postponed message in queue
			meerkat.messaging.subscribe(meerkat.modules.events.simplesMessage.MESSAGE_CHANGE, function messageChange(obj) {
				var $messages = $container.find('.simples-postponed-message');

				// Unhighlight all
				$messages.removeClass('active');

				// Highlight correct one
				if (obj !== false) {
					if (meerkat.site.inInEnabled === true) {
						$messages.filter('[data-rootId="' + obj.message.transactionId + '"]').addClass('active');
					} else {
						$messages.filter('[data-messageId="' + obj.message.messageId + '"]').addClass('active');
					}
				}
			});

			// Get the data
			refresh();

		});
	}

	function initDateStuff() {
		Date.locale = {
			month_names: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
			month_names_short: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
			day_of_week: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
			day_of_week_short: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
		};

		Date.prototype.getMonthName = function(asUTC) {
			if (asUTC === true) {
				return Date.locale.month_names[this.getUTCMonth()];
			} else {
				return Date.locale.month_names[this.getMonth()];
			}
		};

		Date.prototype.getMonthNameShort = function(asUTC) {
			if (asUTC === true) {
				return Date.locale.month_names_short[this.getUTCMonth()];
			} else {
				return Date.locale.month_names_short[this.getMonth()];
			}
		};

		Date.prototype.getDayName = function(asUTC) {
			if (asUTC === true) {
				return Date.locale.day_of_week[this.getUTCDay()];
			} else {
				return Date.locale.day_of_week[this.getDay()];
			}
		};

		Date.prototype.getDayNameShort = function(asUTC) {
			if (asUTC === true) {
				return Date.locale.day_of_week_short[this.getUTCDay()];
			} else {
				return Date.locale.day_of_week_short[this.getDay()];
			}
		};
	}

	function viewMessage(event) {
		event.preventDefault();

		// Get the correct postponed message preview
		var $element = $(event.target);
		if (!$element.hasClass('simples-postponed-message')) {
			$element = $element.parents('.simples-postponed-message');
		}

		// Check state
		if (viewMessageInProgress === true || $element.hasClass('disabled') || $element.hasClass('active')) {
			return;
		}

		var messageId = $element.attr('data-messageId'),
			rootId = $element.attr('data-rootId');


		viewMessageInProgress = true;
		meerkat.modules.loadingAnimation.showInside($element);
		$element.addClass('disabled');

		if (meerkat.site.inInEnabled === true) {
			meerkat.modules.simplesMessage.performLauncherSearch(rootId).then(
				function resetAndUpdate() {
					viewMessageInProgress = false;
					meerkat.modules.loadingAnimation.hide($element);
					$element.removeClass('disabled');

					// Update currentMessage to flag it is a PM
					var currentMessage = meerkat.modules.simplesMessage.getCurrentMessage();
					currentMessage.message.isPM = true;
					meerkat.modules.simplesMessage.setCurrentMessage(currentMessage);
				}
			);
			return;
		}

		meerkat.modules.comms.get({
			url: baseUrl + 'simples/messages/get.json?messageId=' + encodeURI(messageId),
			cache: false,
			errorLevel: 'silent',
			useDefaultErrorHandling: false
		})
		.then(function onSuccess(json) {
			if (!json.hasOwnProperty('message') || !json.message.hasOwnProperty('messageId')) {
				alert('Failed to load message: invalid response');
			}
			else {
				meerkat.modules.simplesMessage.setCurrentMessage(json);
			}
		})
		.catch(function onError(obj, txt, errorThrown) {
			if (obj.hasOwnProperty('responseJSON') && obj.responseJSON.hasOwnProperty('errors') && obj.responseJSON.errors.length > 0) {
				alert('Failed to load message\n' + obj.responseJSON.errors[0].message);
			}
			else {
				alert('Unsuccessful because: ' + txt + ': ' + errorThrown);
			}
		})
		.always(function onComplete() {
			viewMessageInProgress = false;
			meerkat.modules.loadingAnimation.hide($element);
			$element.removeClass('disabled');
		});
	}

	function refresh() {
		if ($container === false || $container.length === 0) return;

		$container.html('Fetching postponed queue...');

		meerkat.modules.comms.get({
			url: baseUrl + 'simples/messages/postponed.json',
			cache: false,
			errorLevel: 'silent',
			useDefaultErrorHandling: false
		})
		.then(function onSuccess(json) {
			var htmlContent = '';

			if (typeof templatePQ !== 'function') {
				htmlContent = 'Unsuccessful because: template not configured.';
			}
			else {
				// Store the existing message queue
				setMessageQueue(json);

				// Render the template using the data
				htmlContent = templatePQ(json);
			}

			// Display the content
			$container.html( htmlContent );
		})
		.catch(function onError(obj, txt, errorThrown) {
			$container.html('Unsuccessful because: ' + txt + ': ' + errorThrown);
		});
	}

	function setMessageQueue(json) {
		currentMessageQueue = [];
		if(_.isObject(json) && json.hasOwnProperty('messages') && _.isArray(json.messages) && json.messages.length > 0) {
			for(var i = 0; i < json.messages.length; i++) {
				currentMessageQueue.push({
					contactName : json.messages[i].contactName,
					whenToAction : json.messages[i].whenToAction
				});
			}
		}
	}

	function getMessageQueue() {
		return currentMessageQueue;
	}

	meerkat.modules.register('simplesPostponedQueue', {
		init: init,
		initDateStuff : initDateStuff,
		getMessageQueue : getMessageQueue
	});

})(jQuery);
