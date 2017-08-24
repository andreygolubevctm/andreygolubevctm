var ResultsUtilities = {

	setContainerWidth: function( elements, container ){
		var $firstElement = $( elements ).first(),
			firstElementWidth = _.isFunction(Results.settings.setContainerWidthCB) ?
				Results.settings.setContainerWidthCB( $firstElement ) : $firstElement.outerWidth(true),
			width = firstElementWidth * $( elements ).length;

		$( container ).css('width', width + "px");
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

	positionAbsolute: function( $elements, orientation ){

//console.group('positionAbsolute');

		if( !$elements.parent().hasClass("absoluteContainer") ){
			$elements.wrapAll('<div class="absoluteContainer" />');
		}
		var $container = $elements.parent();
		$container.css('position', 'relative');

		var totalDimension;
		var $firstElement = $elements.first();

		if (orientation === "vertical") {
			totalDimension = $firstElement.outerWidth(true) * $elements.length;

			var maxHeight = 0;
			$elements.each(function(){
				var height = $(this).outerHeight(true);
				if(height > maxHeight){
					maxHeight = height;
				}
			});

			$container.css("height", maxHeight);
			$container.css("width", totalDimension);
		} else {
			totalDimension = $firstElement.outerHeight(true) * $elements.length;
			$container.css("height", totalDimension);
		}

		$elements.each(function(index, element){
			var $element = $(element);
			var elementPosition = $element.position();

			if (orientation === "horizontal") {
				$element.css('top', elementPosition.top); // caused rendering issues to health vertical - offset columns from top of page and not parent.
			}

			$element.css('left', elementPosition.left);

////console.log('left', index, elementPosition.left);
		});

		$elements.css("position", "absolute");

//console.log('maxHeight', maxHeight);
//console.log('totalDimension', totalDimension);
////console.log('container', $container.clone().empty()[0].outerHTML);
//console.groupEnd('positionAbsolute');
	},

	positionStaticOrRelative: function( position, $elements ){

//console.log('positionStaticOrRelative', position, $elements.parent());

		var $container = $elements.parent();

		if ($container.hasClass("absoluteContainer")) {
			$elements.unwrap();
		}
		else {
			// Double check there is no leftover wrapper
			if ($container.children('.absoluteContainer').length > 0) {
				$container.children('.absoluteContainer').remove();
			}

			$container.css({
				'position': position,
				'height': 'auto'
			});
		}

		$elements.css({
			'top': 'auto',
			'left': 'auto',
			'position': position
		});
	},

	/*
	 * Get the scroll value of a sliding div.
	 * Typically used to get the current scroll value of a carousel div (the div would slide inside of an overflow:hidden container)
	 * @axis ('x', 'y', 'z') => which axis scroll value to return
	 * @element => a jquery selected element to get the scroll value out of
	 */
	getScroll: function( axis, element ){

		if( axis != 'x' & axis != 'y' && axis != 'z'){
			return;
		}

		switch(axis){
			case "x":
				return parseInt( element.css("margin-left") );
			case "y":
				return parseInt( element.css("margin-top") );
			case "z":
				return 0;
		}
	}

};

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
			var $el = $(this);
			if($el.css(property)){
				return Math.round(parseFloat($el.css(property)) * 1000);
			}
		}
		return 0;
	};

})( jQuery );