////////////////////////////////////////////////////////////////
//// DYNAMIC CONTENT LOADING MODULE							////
////--------------------------------------------------------////
//// This is a module to apply an event listener to all the ////
//// DOM elements that will load dynamic content on a click.////
//// Typical examples would be dialogs and popovers			////
////--------------------------------------------------------////
//// REQUIRES: jquery as $									////
////--------------------------------------------------------////
////////////////////////////////////////////////////////////////

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var events = {
			dynamicContentLoading: {
				PARSED_POPOVER: 'DYNAMIC_CONTENT_PARSED_POPOVER',
				PARSED_DIALOG: 'DYNAMIC_CONTENT_PARSED_DIALOG'
			}
		},
		moduleEvents = events.dynamicContentLoading;

	// Initialise
	function init() {
		applyDynamicContentListeners();
	}

	/* Apply the listeners on all dynamic content elements */
	function applyDynamicContentListeners(){

		$(document.body).on('click', 'a[data-content]' ,function(eventObject){

			eventObject.preventDefault();
			eventObject.stopPropagation();

			parseDynamicContent(eventObject);

		});

		$(document.body).on('mouseenter', '[data-trigger=mouseenter], [data-trigger="mouseenter click"]' ,function(eventObject){

			parseDynamicContent(eventObject);

		});

	}

	function parseDynamicContent(eventObject){

		var contentType = null;
		var contentValue = null;
		var $currentTarget = $(eventObject.currentTarget);
		var targetContent = $currentTarget.attr('data-content');
		var targetType = $currentTarget.attr('data-toggle');

		if( typeof targetType !== "undefined" && targetType !== '' ){

			var contentUrlTest = targetContent.split('.');

			// CSS ID or Class
			if( targetContent[0] === '#' || targetContent[0] === '.' ){
				contentType = 'selector';
				contentValue = $(targetContent).html();
			// Special helpid: for helo tooltips
			} else if( targetContent.substr(0,7) == 'helpid:') {
				contentType = 'url';
				contentValue = "ajax/xml/help.jsp?id=" + targetContent.substr(7,targetContent.length);
			// external URLs (start with http or www)
			} else if( targetContent.substring(0,4) === "http" || targetContent.substring(0,3) === "www" ) {
				contentType = 'externalUrl';
				contentValue = targetContent;
			// internal URLs (finish with .jsp or .html)
			} else if(contentUrlTest[contentUrlTest.length-1] == 'jsp' || contentUrlTest[contentUrlTest.length-1] == 'html' ){
				contentType = 'url';
				contentValue = targetContent;
			// simple basic content
			} else {
				contentType = 'content';
				contentValue = targetContent;
			}

			meerkat.messaging.publish(moduleEvents["PARSED_" + targetType.toUpperCase()], {
				element: $currentTarget,
				contentType: contentType,
				contentValue: contentValue
			});

		} else {
			// @todo warn dev that no data-content-type has been set on the dom element
		}

	}

	meerkat.modules.register('dynamicContentLoading', {
		init: init,
		events: events
	});

})(jQuery);
