/*
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var $refreshButton = false,
		templateUsers = false,
		$container = false,
		baseUrl = '';



	function init() {
		$(document).ready(function() {

			var $elements = $("[data-provide='simples-consultant-status']");

			if ($elements.length === 0) return;

			baseUrl = meerkat.modules.simples.getBaseUrl();

			$elements.each(function() {
				var $this = $(this);

				$refreshButton = $('.simples-status-refresh');
				$container = $('.simples-status');

				refresh();
			});

			//
			// Set up templates
			//
			var $e = $('#simples-template-consultantstatus');
			if ($e.length > 0) {
				templateUsers = _.template($e.html());
			}

		});
	}

	function refresh() {
		// Show animation next to refresh button
		meerkat.modules.loadingAnimation.showAfter($refreshButton);

		meerkat.modules.comms.get({
			url: baseUrl + 'simples/users/list_online.json',
			cache: false,
			errorLevel: 'silent',
			useDefaultErrorHandling: false,
			onSuccess: function onSuccess(json) {
				var htmlContent = '';

				if (typeof templateUsers !== 'function') {
					htmlContent = 'Unsuccessful because: template not configured.';
				}
				else {
					// Render the template using the data
					htmlContent = templateUsers(json);
				}

				// Display the content
				$container.html( htmlContent );
			},
			onError: function onError(obj, txt, errorThrown) {
				$container.html('Unsuccessful because: ' + txt + ': ' + errorThrown);
			},
			onComplete: function onComplete() {
				// Hide loading animation
				meerkat.modules.loadingAnimation.hide($refreshButton);
			}
		});
	}



	meerkat.modules.register('simplesUserStatus', {
		init: init
	});

})(jQuery);
