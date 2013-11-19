var ResultsUtilities = new Object();
ResultsUtilities = {

	setContainerWidth: function( elements, container ){
		var width = $( elements ).first().outerWidth(true) * $( elements ).length;
		$( container ).css('width', width + "px");
	},

	makeElementSticky : function( stickySide, element, extraClass, startPosition ) {

		// check if already been fixed
		if( element.attr("data-fixed") != "true" ){

			var msie6 = $.browser == 'msie' && $.browser.version < 7;
			if (!msie6) {

				var $window = $(window);
				var elementHeight = element.height();
				var scrollTop = $window.scrollTop();
				var windowHeight = $window.height();

				// We could perhaps throttle instead of debounce, to get faster updating of the fixed positions.
				$window.smartscroll(function(e){
					// do stuff as soon as the user stops scrolling for longer than 100ms
					scrollTop = $window.scrollTop();
					windowHeight = $window.height();

					if( stickySide == "top" ){
						if (scrollTop >= startPosition) {
							element.addClass( extraClass );
						} else {
							element.removeClass( extraClass );
						}
					} else if ( stickySide == "bottom" ) {
						if( elementHeight + startPosition > scrollTop + windowHeight ){
							element.addClass( extraClass );
						} else {
							element.removeClass( extraClass );
						}
					}
				});

			}
			// set element as already been fixed
			element.attr( "data-fixed", "true" );
		}

	},

	position: function( position, elements, orientation){
		switch(position){
			case "absolute":
				ResultsUtilities.positionAbsolute( elements, orientation );
				break;
			case "relative":
			case "static":
				ResultsUtilities.positionStaticOrRelative( position, elements );
				break;
		}
	},

	positionAbsolute: function( elements, orientation ){

		if( !elements.parent().hasClass("absoluteContainer") ){
			elements.wrapAll('<div class="absoluteContainer" />');
		}
		var container = elements.parent();
		container.css('position', 'relative');

		var totalDimension;
		var lastElement = elements.last();

		if( orientation == "vertical" ){
			dimension = "width";
			totalDimension = lastElement.position().left + lastElement.outerWidth(true);

			var maxHeight = 0;
			elements.each(function(){
				var height = $(this).outerHeight(true);
				if(height > maxHeight){
					maxHeight = height;
				}
			});

			container.css( "height", maxHeight );
		} else {
			dimension = "height";
			totalDimension = lastElement.position().top + lastElement.outerHeight(true);
		}


		elements.each(function(index, element){
			var elementPosition = $(element).position();
			$(element).css('top', elementPosition.top);
			$(element).css('left', elementPosition.left);
		});

		elements.css("position","absolute");

		container.css( dimension, totalDimension );

	},

	positionStaticOrRelative: function( position, elements ){

		var container = elements.parent();
		if( container.hasClass("absoluteContainer") ){
			elements.unwrap();
		} else {
			container.css('position', position);
			container.height('auto');
		}

		elements.css('top', 'auto');
		elements.css('left', 'auto');
		elements.css('position', position);

	}

}

var deBouncer = function($,cf,of, interval){
	// deBouncer by hnldesign.nl
	// based on code by Paul Irish and the original debouncing function from John Hann
	// http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/
	var debounce = function (func, threshold, execAsap) {
		var timeout;
		return function debounced () {
			var obj = this, args = arguments;
			function delayed () {
				if (!execAsap)
					func.apply(obj, args);
				timeout = null;
			}
			if (timeout)
				clearTimeout(timeout);
			else if (execAsap)
				func.apply(obj, args);
			timeout = setTimeout(delayed, threshold || interval);
		};
	};
	jQuery.fn[cf] = function(fn){  return fn ? this.bind(of, debounce(fn)) : this.trigger(cf); };
};

//deBouncer(jQuery,'smartresize', 'resize', 100);
deBouncer(jQuery,'smartscroll', 'scroll', 50);
//deBouncer(jQuery,'smartmousemove', 'mousemove', 100);


(function( $ ) {

	/**
	 * jQuery.transitionDuration
	 * Retrieves the total amount of time, in milliseconds that
	 * an element will be transitioned
	 */
	$.fn.transitionDuration = function() {
		var properties = [
			'transition-duration',
			'-webkit-transition-duration',
			'-ms-transition-duration',
			'-moz-transition-duration',
			'-o-transition-duration'
		];

		var property;
		while (property = properties.shift()) {
			if($(this).css(property)){
				return Math.round(parseFloat($(this).css(property)) * 1000);
			}
		}
		return 0;
	};

})( jQuery );