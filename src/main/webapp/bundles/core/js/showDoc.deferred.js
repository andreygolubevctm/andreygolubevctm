/**
 * Launches content in a popup based on data attributes
 */
(function ($, undefined) {

	var meerkat = window.meerkat;

	function showTermsDocument(event) {
		event.preventDefault();

		var $el = $(this),
			title = $el.attr('data-title');
			url = $el.attr('href');

		if (typeof $el.attr('data-url') !== 'undefined') {
			url = $el.attr('data-url');
		}
		if (title) {
			title = title.replace(/ /g,"_");
		}
		window.open(url, title, "width=800,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=no");
	}

	function initShowDoc(options) {
		$(document).ready(function ($) {
			$(document.body).on('click', '.showDoc', showTermsDocument);
		});
	}

	meerkat.modules.register('showDoc', {
		init:initShowDoc
	});

})(jQuery);