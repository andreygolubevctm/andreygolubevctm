;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = window.meerkat.logging.info;

	var events = {
		resultsHeaderBar: {
			
		}
	},
	moduleEvents = events.resultsHeaderBar;

	var $resultsHeaderBg,
		$affixOnScroll,
		$resultsContainer,
		navBarHeight,
		topStartOffset = 0,
		previousStartOffset = 0,
		contentAnimating=false,
		enterXsSubscription,
		leaveXsSubscription;

	function init(){
		$resultsHeaderBg = $('.resultsHeadersBg');
		$affixOnScroll = $('.affixOnScroll');
		$resultsContainer = $('.resultsContainer');
		navBarHeight = $("#navbar-main").height();
	}

	// has to wait for the results page to be displayed before updating
	function setHeaderBarStartOffset(forceUpdate){

		// if not set yet, then set it
		if(topStartOffset === 0 || forceUpdate){
			var dynamicTopHeaderContentHeight = 0;
			$(".dynamicTopHeaderContent > *").each(function(){
				// don't calculate height of hidden elements for Simples users if the user is a Simples user
				if( $(this).hasClass("simplesHidden") && meerkat.site.isCallCentreUser){
					return;
				}
				dynamicTopHeaderContentHeight += $(this).height();
			});

			// height of the header without navbar (which gets affixed at the same time)
			topStartOffset = dynamicTopHeaderContentHeight + $(".header-top .container").height() + $resultsHeaderBg.position().top;
		}

	}

	// Helpers to determine current state...
	function isWindowInAffixPosition(){
		if($(window).scrollTop() >= topStartOffset) return true;
		return false;
	}

	function isWindowInCompactPosition(){
		// the +5 is to force the headers to affix first before we switch to compact mode for performance reasons
		if($(window).scrollTop() >= topStartOffset + 5) return true;
		return false;
	}

	function isContentAffixed(){
		return $resultsContainer.hasClass('affixed');
	}

	function isContentCompact(){
		return $resultsContainer.hasClass('affixed-compact');
	}

	function isContentAffixedForPagination(){
		return $resultsContainer.hasClass('affixed-absoluted');
	}


	// Handle events...
	function onScroll(){

		setHeaderBarStartOffset(); // will set it first time only

		if(isWindowInAffixPosition() === true){

			if(isContentAffixed() === false){
				$affixOnScroll.addClass("affixed");
				$resultsContainer.addClass("affixed-settings");
			}

			if(isWindowInCompactPosition() === true && isContentCompact() === false){
				$affixOnScroll.addClass("affixed-compact");
				$resultsContainer.find(".result .productSummary").addClass("compressed");
			}else if(isWindowInCompactPosition() === false && isContentCompact() === true){
				removeCompactClasses();
			}

		}else if(isWindowInAffixPosition() === false && isContentAffixed() === true){
			removeAffixClasses();
		}

	}

	function removeCompactClasses(){
		$affixOnScroll.removeClass("affixed-compact");
		$resultsContainer.find(".result .productSummary").removeClass("compressed");
	}

	function removeAffixClasses(){
		removeCompactClasses();
		$affixOnScroll.removeClass("affixed");
		$resultsContainer.removeClass("affixed-settings");
	}

	function onAnimationStart(){
		if(isContentAffixed() && contentAnimating === false){
			contentAnimating = true;
			var top = $(window).scrollTop()+navBarHeight-$resultsContainer.offset().top;			
			$resultsContainer.find(".result").css("top", top+'px');
			$resultsContainer.removeClass("affixed");
			$resultsContainer.addClass("affixed-absoluted");
		}
	}

	function onAnimationEnd(){
		if(isContentAffixedForPagination() && contentAnimating === true){
			contentAnimating = false;
			$resultsContainer.removeClass("affixed-absoluted");
			$resultsContainer.addClass("affixed");
			$resultsContainer.find(".result").css("top", '');
		}
	}

	// when changing breakpoint, in compact mode, on page>1, the header layouts needs to refresh
	function refreshHeadersLayout(){
		if(isContentCompact()){
			$(Results.settings.elements.productHeaders).refreshLayout(); // jquery plugin in utilities module
		}
	}

	function enableAffixMode(){

		if( meerkat.modules.deviceMediaState.get() !== "xs"){
			_.defer(function(){
				onScroll(); // force call it once in case we just entered the breakpoint and did not scroll
			});
			$(window).on('scroll.resultsHeaderBar', _.throttle(onScroll, 25));

			// subscribe to enter XS to disable fixed headers in that breakpoint
			enterXsSubscription = meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function(){
				disableAffixMode();
			});
		}
	}

	function disableAffixMode(){

		// unsubscribe to enter XS
		meerkat.messaging.unsubscribe(enterXsSubscription);

		// remove affix position
		removeAffixClasses();

		// unsubscribe from scroll event
		$(window).off('scroll.resultsHeaderBar');

		// subscribe to leave XS
		subscribeToLeaveXs();

	}

	function subscribeToLeaveXs(){
		leaveXsSubscription = meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function(){
			meerkat.messaging.unsubscribe(leaveXsSubscription);
			registerEventListeners();
		});
	}

	// Add remove event listeners (on entering / leaving results page)...
	function registerEventListeners(){
		
		if( meerkat.modules.deviceMediaState.get() === "xs"){
			subscribeToLeaveXs();
		} else {
			enableAffixMode();
		}

		// when repositioning the results (i.e. breakpoint change), this event is triggered. Fixed headers don't reposition so we force them to
		$(Results.settings.elements.resultsContainer).off("pagination.instantScroll").on("pagination.instantScroll", refreshHeadersLayout);
		$(Results.settings.elements.resultsContainer).off("pagination.scrolling.start").on("pagination.scrolling.start", onAnimationStart);
		$(Results.settings.elements.resultsContainer).off("pagination.scrolling.end").on("pagination.scrolling.end",onAnimationEnd);

		$(Results.settings.elements.resultsContainer).off("results.view.animation.start").on("results.view.animation.start", onAnimationStart);
		$(Results.settings.elements.resultsContainer).off("results.view.animation.end").on("results.view.animation.end",onAnimationEnd);

		// opening any of the Simples dialogue needs to refresh the header bar top offset value
		$resultsHeaderBg.prevAll(".simples-dialogue.toggle").off("click.updateHeaderBarOffset").on("click.updateHeaderBarOffset",function(){
			_.delay(function(){
				setHeaderBarStartOffset(true);
			}, 300);
		});
	}

	function removeEventListeners(){
		
		if(typeof enterXsSubscription !== "undefined"){
			meerkat.messaging.unsubscribe(enterXsSubscription);
		}
		
		if(typeof leaveXsSubscription !== "undefined"){
			meerkat.messaging.unsubscribe(leaveXsSubscription);
		}
		
		$(window).off('scroll.resultsHeaderBar');

		$(Results.settings.elements.resultsContainer).off("pagination.instantScroll");
		$(Results.settings.elements.resultsContainer).off("pagination.scrolling.start");
		$(Results.settings.elements.resultsContainer).off("pagination.scrolling.end");

		$(Results.settings.elements.resultsContainer).off("results.view.animation.start");
		$(Results.settings.elements.resultsContainer).off("results.view.animation.end");
	}

	meerkat.modules.register("resultsHeaderBar", {
		init: init,
		registerEventListeners:registerEventListeners,
		removeEventListeners:removeEventListeners,
		enableAffixMode: enableAffixMode,
		disableAffixMode: disableAffixMode
	});

})(jQuery);