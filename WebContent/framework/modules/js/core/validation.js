;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {
		validation: {

		}
	},
	moduleEvents = events.validation;

	var $form= null;

	function init(){
		jQuery(document).ready(function($) {
			$form = $("#mainform");
		});
	}

	function isValid( $element, displayErrors ){
		if( displayErrors ){
			return $element.valid();
		}
		return $form.validate().check( $element ) === false ? false : true;
	}

	meerkat.modules.register("validation", {
		init: init,
		events: events,
		isValid: isValid
	});

})(jQuery);

jQuery.fn.extend({
	isValid: function( displayErrors ) {
		return meerkat.modules.validation.isValid( $(this), displayErrors );
	}
});