;(function($, undefined){

	var meerkat = window.meerkat;
	var meerkatEvents = meerkat.modules.events;
	var log = window.meerkat.logging.info;

	//Typical implementation using top offset.
	function topDockBasedOnOffset($elems) {
		$elems.each(function(index, val) {
			//log(val);
			$item = $(val);
			$item.affix({
				offset: {
					top: function () {
						var offsetTop = $item.offset().top;
						return (this.top = offsetTop);
					}
				}
			});
		});
	}

	//Occasionally you might want to find the offset top from heights.
	function topDockBasedOnParentHeight($elems) {
		$elems.each(function(index, val) {
			//log(val);
			$item = $(val);
			$item.affix({
				offset: {
					top: function () {
						var offsetTop = ($item.parent().height())-($item.height());
						return (this.top = offsetTop);
					}
				}
			});
		});
	}


	function init() {
		//Example for multiple item affix
		//var $topDockers = $('.all, .of, .the, .things'); //intended to be lots of things.
		//topDockBasedOnOffset($topDockers);

		//Because of the odd race conditions that the journeyEngine's journeyProgress bar now suffers from, i'm waiting for it's init event before using affix on the navbar below it.
		meerkat.messaging.subscribe(meerkatEvents.journeyProgressBar.INIT, function affixNavbar(step) {
			// Disable affix in ie8 due to performance reasons
			if(meerkat.modules.performanceProfiling.isIE8() === false){
				topDockBasedOnOffset($('.navbar-affix'));
			}
		});
	}

	meerkat.modules.register("affix", {
		init: init
	});

})(jQuery);