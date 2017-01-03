/**
 * travelOptins module simply ensures the hidden privacyoptin field value
 * is maintained when the marketing field is toggled.
 */
;(function($){

	var meerkat = window.meerkat;

	var $optinMarketing,
		$optinPrivacy;

	function init(){
		$(document).ready(function(){
			$optinMarketing = $('#travel_marketing');
			$optinPrivacy = $('#travel_privacyoptin');
			addEventListeners();
			onUpdateOptin();
		});
	}

	function addEventListeners() {
		$optinMarketing.on('change', onUpdateOptin);
	}

	function onUpdateOptin() {
		$optinPrivacy.val($optinMarketing.is(':checked') ? 'Y' : '');
	}

	meerkat.modules.register('travelOptins', {
		init: init
	});

})(jQuery);
