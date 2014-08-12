/*
	This module supports the Sorting for travel results page.
*/

//hasScrollBar($htmlBody) &&

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		$htmlBody,
		$morePrompt,
		promptInit = false;


	function initPrompt() {
		$(document).ready(function(){
			$htmlBody = $('body,html'),
			$footer = $("#footer"),
			$morePrompt = $('.morePromptContainer'),
			contentBottom = $footer.offset().top - $(window).height();

			if (!promptInit && (meerkat.modules.deviceMediaState.get() != 'xs')) {
				
				applyEventListeners();
			} else if (promptInit) {
				//come back slowly if you're 're-showing'
				_.delay(handleFades,600);
			}
			eventSubscriptions();
		});
	}

	function eventSubscriptions() {
		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function leaveXSMode() {
			if (!promptInit)
			{
				applyEventListeners();	
			}
		});
	}


	function handleFades() {
		var height = "innerHeight" in window ? window.innerHeight : document.documentElement.offsetHeight;
		if ((height + $(window).scrollTop()) >= $('.resultsContainer').outerHeight()) {
			$morePrompt.fadeOut();
		} else {
			$morePrompt.fadeIn();
		}
	}

	function applyEventListeners()	{

		$morePrompt.fadeIn();
		promptInit = true;

		$( window ).scroll(function() {
			clearTimeout( $.data( this, "scrollCheck" ) );
			$.data( this, "scrollCheck", setTimeout(handleFades, 150) );
		});

		$(document.body).on('click', '.morePromptLink', function(e){
			
			//e.preventDefault();
			var scrollTo = ('top').toLowerCase(),
				animationOptions = {},
				contentBottom = $footer.offset().top - $(window).height();
			
			if(scrollTo == 'bottom'){
				contentBottom += $footer.outerHeight(true);
			}

			animationOptions.scrollTop = contentBottom;

			$htmlBody.stop(true, true).animate(animationOptions, 800);					
		});
	}

	function hasScrollBar($obj) {
		return $obj.get(0).scrollHeight > $(window).height();
	}
	

	function init() {
		meerkat.messaging.subscribe(meerkatEvents.RESULTS_DATA_READY, function morePromptCallBack(obj) {
			
			meerkat.modules.travelMorePrompt.initPrompt();
		});
	}

	meerkat.modules.register('travelMorePrompt', {
		init: init,
		initPrompt: initPrompt
	});

})(jQuery);