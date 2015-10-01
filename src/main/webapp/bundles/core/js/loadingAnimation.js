/**
* This module has been designed to display the loading animation where needed
* Link to Confluence: http://confluence:8090/display/EBUS/LoadingAnimation
*/
;(function($){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;



	function hide($elements) {
		$elements.each(function(){
			var $element = $(this);
			var attr = $element.attr('data-loadinganimation');

			if (attr === 'after') {
				$element.next('.spinner').hide();
			} else {
				$element.find('.spinner').hide();
			}
		});
		return $elements.find('.spinner');
	}

	function showAfter($elements) {
		$elements.each(function(){
			var $element = $(this);
			var $spinner = $element.next('.spinner');
			if ($spinner.length > 0) {
				$spinner.show();
			}
			else {
				$element.attr('data-loadinganimation', 'after');
				$element.after(getTemplate());
			}
		});
		return $elements.find('.spinner');
	}

	// Add the loading element to the inside of the elements
	// param $elements: jQuery collection of elements to add loading to
	// param showAtEnd: Does an append instead of the default prepend
	//
	function showInside($elements, showAtEnd) {
		$elements.each(function(){
			var $element = $(this);
			var $spinner = $element.find('.spinner');
			if ($spinner.length > 0) {
				$spinner.show();
			}
			else {
				$element.attr('data-loadinganimation', 'inside');
				if (showAtEnd === true) {
					$element.append(getTemplate());
				}
				else {
					$element.prepend(getTemplate());
				}
			}
		});
		return $elements.find('.spinner');
	}

	/**
	* Gets the DOM elements for the loading animation
	* @return String of DOM elements
	*/
	function getTemplate() {
		return '<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>';
	}



	meerkat.modules.register('loadingAnimation', {
		hide: hide,
		showAfter: showAfter,
		showInside: showInside,
		getTemplate: getTemplate
	});

})(jQuery);
