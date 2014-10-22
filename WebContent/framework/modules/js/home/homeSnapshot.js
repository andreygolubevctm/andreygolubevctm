/**
 * Brief explanation of the module and what it achieves. <example: Example pattern code for a meerkat module.>
 * Link to any applicable confluence docs: <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined){

	var meerkat = window.meerkat;

	var events = {
			homeSnapshot: {
			}
		},
		$coverType = $('#home_coverType'),
		$quoteSnapshot = $(".quoteSnapshot");

	function initHomeSnapshot() {

		// Initial render
		renderSnapshot(getIcon());

		// On change
		$coverType.on('change', function changeHomeCoverDetails() {
			renderSnapshot(getIcon());
		});

		/**
		 * Legacy address search sucks. Can't properly listen to change events on the hidden inputs
		 * that I wanted to use to render the snapshot.
		 */
		$('#home_property_address_streetSearch, #home_property_address_streetNum, #home_property_address_postCode, #home_property_address_suburb, #home_property_address_nonStdStreet').on('blur', function() {
			setTimeout(function() {
				renderSnapshot();
			}, 50);
		});
	}

	/**
	 * Which icon to render depending on what the cover type is.
	 */
	function renderSnapshot(icon) {
		if ($coverType.val() !== '') {
			$quoteSnapshot.removeClass('hidden');
			if(typeof icon !== 'undefined') {
				$quoteSnapshot.find('.icon:first').attr('class','icon').addClass(icon);
			}
		}
		meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(0) .snapshot');
	}

	/**
	 * Utility function used here and in edit details
	 */
	function getIcon() {
		var icon = 'icon-home-contents';
		switch($coverType.val()) {
			case 'Home Cover Only':
				icon = 'icon-house';
				break;
			case 'Contents Cover Only':
				icon = 'icon-contents';
				break;
		}
		return icon;
	}

	meerkat.modules.register('homeSnapshot', {
		init: initHomeSnapshot,
		events: events,
		getIcon: getIcon
	});

})(jQuery);