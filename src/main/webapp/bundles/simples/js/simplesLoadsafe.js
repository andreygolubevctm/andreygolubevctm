/*

	Apply a 'needs-loadsafe' class to links to first redirect to a loading page before continuing on the destination.

	Additionally, the loading page is an authentication checker and will force user to the login form if not authenticated.

*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	var $iframe = $('#simplesiframe');
	var baseUrl = '';



	function init() {
		$(document).ready(function() {

			baseUrl = meerkat.modules.simples.getBaseUrl();

			//
			// Capture links
			//
			$(document.body).on('click', '.needs-loadsafe', function loadsafeClick(event) {
				event.preventDefault();

				var $this = $(this);
				var addBaseUrlToHref = false;

				// Close the dropdown menu if the link is inside one
				if ($this.parent().parent().hasClass('dropdown')) {
					$this.parent().parent().find('.dropdown-toggle').dropdown('toggle');
				}

				if ($this.hasClass('needs-baseurl')) addBaseUrlToHref = true;

				loadsafe($this.attr('href'), addBaseUrlToHref);
			});

		});
	}



	function loadsafe(href, addBaseUrlToHref) {
		if (!href || href.length === 0) return;

		addBaseUrlToHref = addBaseUrlToHref || false;

		// Append timestamp to the URL
		href += ((href.indexOf('?') >= 0) ? '&' : '?');
		href += 'ts=' + new Date().getTime();

		if (addBaseUrlToHref === true) {
			href = baseUrl + href;
		}

		var loadingUrl = baseUrl + 'simples/loading.jsp?url=' + encodeURIComponent(href);

		//alert(href);

		// Pass the destination to the loading page
		if ($iframe.length > 0) {
			$iframe.attr('src', loadingUrl);
		}
		else {
			window.location = loadingUrl;
		}

	}



	meerkat.modules.register('simplesLoadsafe', {
		init: init,
		loadsafe: loadsafe
	});

})(jQuery);
