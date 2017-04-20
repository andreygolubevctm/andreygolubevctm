;(function($, undefined){

	var meerkat = window.meerkat;
	var meerkatEvents = meerkat.modules.events;
	var log = window.meerkat.logging.info;

	var events = {
			affix: {
				AFFIXED: 'CORE_AFFIX_AFFIXED',
				UNAFFIXED: 'CORE_AFFIX_UNAFFIXED'
			}
		},
		moduleEvents = events.affix;

	//Typical implementation using top offset.
	function topDockBasedOnOffset($elems) {
		$elems.each(function(index, val) {
			$item = $(val);
			$item.affix({
				offset: {
					top: function () {
						var offsetTop = $item.offset().top;
						var attr = $item.attr('data-affix-after');
						if(attr && $(attr).length) {
							offsetTop = $(attr).offset().top;
							// Only set this value once the element is visible. Until that time, it will try and calculate it by re-running this function.
							if($item.is(':visible')) {
								// this.top appears to be cached by bootstrap/affix.js
								this.top = offsetTop;
							}
						} else {
							this.top = offsetTop;
						}
						// This value determines at which point a menu will start to affix itself.
						return offsetTop;
					}
				}
			});

			$item.on('affixed.bs.affix', function(event) {
				meerkat.messaging.publish(moduleEvents.AFFIXED, $item);
			});

			$item.on('affixed-top.bs.affix', function(event) {
				meerkat.messaging.publish(moduleEvents.UNAFFIXED, $item);
			});
		});
	}

	//Occasionally you might want to find the offset top from heights.
	/*function topDockBasedOnParentHeight($elems) {
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
	}*/


	function init() {
		//Example for multiple item affix
		//var $topDockers = $('.all, .of, .the, .things'); //intended to be lots of things.
		//topDockBasedOnOffset($topDockers);

		//Because of the odd race conditions that the journeyEngine's journeyProgress bar now suffers from, I'm waiting for its init event before using affix on the navbar below it.
		meerkat.messaging.subscribe(meerkatEvents.journeyProgressBar.INIT, function affixNavbar(step) {

			// If on XS, defer the affixing until/if the breakpoint increases
			if (meerkat.modules.deviceMediaState.get() === 'xs') {
				// Subscribe
				var messagingId = meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function affixXsBreakpointLeave() {
					// Unsubscribe (one-off event)
					meerkat.messaging.unsubscribe(messagingId);

					// Do the affix calcs
					topDockBasedOnOffset($('.navbar-affix'));

				});
			}
			else {
				topDockBasedOnOffset($('.navbar-affix'));
			}
		});
	}

	meerkat.modules.register("affix", {
		init: init,
        topDockBasedOnOffset: topDockBasedOnOffset,
		events: events
	});

})(jQuery);