;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = window.meerkat.logging.info;

	//Set by initialiseVars()
	var $topLevel;
	var $bannerElems,
		$panelElems,
		$basketElems,
		$animated,
		$fixedPageNav,
		inits = {};

	function init(){
		$(document).ready(function(){ //Hmmmm weird to need this.
			
			$topLevel = $('#resultsPage');
			

			
			

			// -----------------------------------------------------------------
			// High level functions
			// -----------------------------------------------------------------
			

			//On breakpoint change, update the initialising variables.
			meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE,
				function breakPointChange(data) {
					initialiseVars();
					autoReposition(isActive());
					$animated.addClass('scrolling up');
					updateY(window, inits);
					$animated.removeClass('scrolling up down');
					//log('breakPointChange called');
			});

			//Don't float this headerbar anymore - turn off the movement class.
			if (!(meerkat.site.isCallCentreUser)) {
			//ignore it if in simples since we wont move.

				meerkat.messaging.subscribe(meerkatEvents.healthMoreInfo.BRIDGINGPAGE_STATE, function bridgingPageStateEvent(stateData) {
					
					if (stateData.isOpen) {
						autoReposition(false);
						$animated.addClass('scrolling up');
						meerkat.modules.utilities.scrollPageTo("header",250,0,function toggleIt(){
							//log("scrollPageTo is completed");
								updateY(window, inits); //update the js style top value
								$animated.removeClass('scrolling up down'); //safe to stop overriding that now that it's set with updateY.
						});
					} else {
						autoReposition(isActive());
					}
					//log('bridgingPageStateEvent called');
				});

			}

			$(document).on('resultsLoaded',function(){
				initialiseVars();
			});

			

		});
	}

	function isActive(){
		if(	meerkat.modules.performanceProfiling.isIE8() ||
			meerkat.site.isCallCentreUser ||
			meerkat.modules.deviceMediaState.get() === "xs"){
				return false;
		}
		return true;
	}

	function initialiseVars(){
		
		$bannerElems	= $topLevel.find('.resultsHeadersBg');
		$panelElems		= $topLevel.find('.resultsOverflow .result');
		$basketElems	= $topLevel.find('.featuresHeaders .result');
		$animated		= $topLevel.find('.animateTop');
		$fixedPageNav	= $('.navbar-affix');
		$header			= $('header');

		//Create an inits object for easy passing
		inits = {
			navbar:		{ height: $fixedPageNav.height()	},
			header:		{ height: $header.height()			},
			resultsNav:	{ height: 0 }
		};
		//Determine if there's an extra offset for the results nav on XS
		if(meerkat.modules.deviceMediaState.get() === 'xs'){

			$fixedResultsNav = $('.xs-results-pagination');
			inits.resultsNav = { height: $fixedResultsNav.height() };
			inits.navbar  = { height: 0 };
		} else {
			inits.resultsNav = { height: 0 };
		}
		//log('initialiseVars completed');

	}

	//The main feature, is that this bar auto-repositions to 'dock' to the top of the screen.
	function autoReposition(bool){
		//log('autoReposition called');
		if (bool) {
			$topLevel.addClass('resultsHeaderbar');
		} else {
			$topLevel.removeClass('resultsHeaderbar');
		}
	}



	function updateY(e, initsPassed) {
		//log('updateY called');

		//Negative the initial height of the headerbar and simples dialogs which acts as the offset before 'affix', aka - the new 0 value boundary. Add on the height of the affixed navbar. In the case of XS - when it's visible, add that height too.
		var y = 0;
		if(isActive()){
			y = $(window).scrollTop();
		}
		
		var computed = Math.max(0, y
						- initsPassed.header.height
						+ initsPassed.navbar.height
						+ initsPassed.resultsNav.height);

		$panelElems.css({top: computed});
		$basketElems.css({top: computed});
		$bannerElems.css({top: computed});
		$animated.removeClass('scrolling up down');					
		
	}

	var lastY = 0;
	function hideShowAnimated(e, $targets) {
		//log('hideShowAnimated called');
		var y = $(window).scrollTop();
		if (y > lastY) { //DOWN
			$targets.addClass('scrolling down');
		} else if (y < lastY) { //UP
			$targets.addClass('scrolling up');
		}

		lastY = y;
	}

	function onScrollStart(e){
		
		//True to call before this bounce timeout instead of after
		
		if (!($topLevel.hasClass('resultsHeaderbar'))) {
			return
		} else {
			$animated.addClass("activeScroll");
			hideShowAnimated(e, $animated);
		}

		
	}

	function onScrollEnd(e){
	
		//Only act on the event if the bar features are enabled
		if (!($topLevel.hasClass('resultsHeaderbar'))) {
			return
		} else {
			$animated.removeClass("activeScroll");
			updateY(e, inits);
		}
		
	}

	function registerEventListeners(){
		initialiseVars();
		
		//This is a flag to determine if we should do any repositioning of the headerbar. Don't reposition when finding simples elements in results.
		autoReposition(isActive());

		$(window).on('scroll.resultsHeaderbar touchmove.resultsHeaderbar', _.debounce(onScrollStart, 50, true));
		$(window).on('scroll.resultsHeaderbar touchmove.resultsHeaderbar touchend.resultsHeaderbar', _.debounce(onScrollEnd, 50));

	}

	function removeEventListeners(){
		$(window).off('scroll.resultsHeaderbar touchmove.resultsHeaderbar'); 
		$(window).off('scroll.resultsHeaderbar touchmove.resultsHeaderbar touchend.resultsHeaderbar');
	}

	meerkat.modules.register("resultsHeaderbar", {
		init: init,
		registerEventListeners:registerEventListeners,
		removeEventListeners:removeEventListeners
	});

})(jQuery);