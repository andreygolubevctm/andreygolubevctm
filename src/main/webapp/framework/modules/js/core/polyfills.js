;(function($, undefined){

	var meerkat = window.meerkat,
		noButtons = document.createElement('button').type === 'button';

//This file defines additional polyfills to those already included in the meerkat and meerkat.logging:

	// included in Meerkat.logging - Mozilla implementation of Array.indexOf, for IE < 9
	// See http://stackoverflow.com/questions/143847/best-way-to-find-an-item-in-a-javascript-array

	// included in Meerkat.logging - Mozilla implementation of ISODateString call
	// https://developer.mozilla.org/en/Core_JavaScript_1.5_Reference:Global_Objects:Date

	// included in Meerkat.logging - JSON support for older browsers. Public domain.
	// https://github.com/douglascrockford/JSON-js/blob/master/json2.js

	// included in Meerkat.logging - Universal stack trace method. Public domain.
	// https://raw.github.com/eriwen/javascript-stacktrace/master/stacktrace.js

	// included in Meerkat.logging - IE9/IEx Console patch.

	function initPolyfills(){
		// Internet Explorer 10 in Windows 8 and Windows Phone 8
		// Internet Explorer 10 doesn't differentiate device width from viewport width, and thus doesn't properly apply the media queries in Bootstrap's CSS.
		// For more information and usage guidelines, read Windows Phone 8 and Device-Width.
		if (navigator.userAgent.match(/IEMobile\/10\.0/)) {
			var msViewportStyle = document.createElement("style")
			msViewportStyle.appendChild(
				document.createTextNode(
					"@-ms-viewport{width:auto!important}"
				)
			)
			document.getElementsByTagName("head")[0].appendChild(msViewportStyle)
		}

		//This just fixes ie's stupid lack of button type=submit support (instead of input type submit)
		if(noButtons){
			$(document).on('click','form button[type="submit"]', function(event){
				event.preventDefault();
				$(this).closest('form').submit();
			}).on('keypress','form input', function(event){
				if(event.which === 13){
						$(this).closest('form').submit();
				}
			});
		}

		//Fastclick instantiated here on the body - see page.tag for fastclick from cdn or lib/js/fastclick-x.x.x.min.js
		//Add the needsclick class to an element to prevent the behaviour. Possibly required with bootstrap dropdowns. TODO: Check this possibility!
		$(function() {
			if (typeof FastClick === 'undefined') return;
			FastClick.attach(document.body);
		});
	}

	meerkat.modules.register("polyfills", {
		init: initPolyfills
	});

})(jQuery);