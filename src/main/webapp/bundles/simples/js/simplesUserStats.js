/*
*/

;(function($, undefined){

	var meerkat = window.meerkat;

	var template = false,
		$containers = false,
		intervalSeconds = 60, /* 1 minutes */
		timer = false,
		baseUrl = '';



	function init() {
		$(document).ready(function() {

			$containers = $("[data-provide='simples-user-stats']");
			if ($containers.length === 0) return;

			//
			// Set up templates
			//
			var $e = $('#simples-template-user-stats');
			if ($e.length > 0) {
				template = _.template($e.html());
			}

			baseUrl = meerkat.modules.simples.getBaseUrl();

			// Fetch straight away
			refresh();

			// polling turned off fow now (refresh of the page required), uncomment next line to re-enabled it
			//setInterval(intervalSeconds);
		});
	}

	function setInterval(seconds) {
		intervalSeconds = seconds;

		if (timer !== false) {
			clearInterval(timer);
		}

		if (intervalSeconds !== false && intervalSeconds > 0) {
			var intervalMs = intervalSeconds * 1000;
			timer = window.setInterval(refresh, intervalMs);
		}

		return intervalSeconds;
	}

	function refresh() {
		$containers.each(function() {
			var $this = $(this);
			if ($this.find('table').length === 0) {
				$this.hide();
			}
		});

		var deferred = meerkat.modules.comms.get({
			url: baseUrl + 'simples/users/stats_today.json',
			cache: false,
			errorLevel: 'silent',
			useDefaultErrorHandling: false
		})
		.then(function onSuccess(json) {
			var htmlContent = '';

			if (typeof template !== 'function') {
				htmlContent = 'Unsuccessful because: template not configured.';
			}
			else {
				// Render the template using the data
				htmlContent = template(json);
			}

			// Display the content
			$containers.each(function() {
				var $this = $(this);
				var slideDown = false;
				if ($this.find('table').length === 0) {
					slideDown = true;
				}

				$this.html( htmlContent );

				if (slideDown) {
					$this.slideDown(200);
				}
			});
		})
		.catch(function onError(obj, txt, errorThrown) {
			$containers.each(function() {
				$(this).html('Unsuccessful because: ' + txt + ': ' + errorThrown);
			});
		});

		return deferred;
	}



	meerkat.modules.register('simplesUserStats', {
		init: init,
		setInterval: setInterval,
		refresh: refresh
	});

})(jQuery);
