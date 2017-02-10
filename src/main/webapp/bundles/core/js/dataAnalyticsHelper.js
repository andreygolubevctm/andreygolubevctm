/**
 * dataAnalyticsHelper module provides a common interface to add
 * data analytics attributes to html elements via JavaScript.
 *
 * Will make it easier if the method of or label for these attributes
 * ever needs to change in the future.
 */
;(function($, undefined){

	var meerkat = window.meerkat,
		attributeLabel = "data-analytics";

	function initDataAnalyticsHelper() {/* NOTHING TO DO */}

	/**
	 * Public method to add attribute/value to elements
	 * @param $element
	 * @param value
     */
	function add($element,value) {
		if($element && !_.isEmpty($element) && $element instanceof jQuery) {
			$element.attr(attributeLabel,value);
		}
	}

	/**
	 * Public method to receive an attribute string
	 * @param value
	 * @param quoteType
	 */
	function get(value, quoteType) {
		var quote = quoteType || '"';
		return ' ' + attributeLabel + '=' + quote + value + quote + ' ';
	}

	meerkat.modules.register("dataAnalyticsHelper", {
		init: initDataAnalyticsHelper,
		add: add,
		get: get
	});

})(jQuery);