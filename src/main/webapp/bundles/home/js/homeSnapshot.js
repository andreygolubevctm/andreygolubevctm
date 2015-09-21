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
		$quoteSnapshot = $(".quoteSnapshot"),
		$nonStdToggle = $("#home_property_address_nonStd");

	function initHomeSnapshot() {

		// Initial render
		renderSnapshot(getIcon());

		// On change
		$coverType.on('change', function changeHomeCoverDetails() {
			renderSnapshot(getIcon());
		});

		$nonStdToggle.on('change', function toggleNonStd() {
			_.defer(function(){
				renderSnapshot(getIcon());
			});
		});

		/**
		 * Legacy address search sucks. Can't properly listen to change events on the hidden inputs
		 * that I wanted to use to render the snapshot.
		 */
		$('#home_property_address_autofilllessSearch, #home_property_address_streetSearch, #home_property_address_streetNum, #home_property_address_nonStdPostCode, #home_property_address_suburb, #home_property_address_nonStdStreet, #home_property_address_unitShop, #home_property_address_nonStdUnitType').on('change blur', function() {
			_.defer(function(){
				renderSnapshot(getIcon());
			});
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

	function getAddress($element) {
		var address = "";
		if($element) {
			address = $element.val();
			if (address.indexOf(",") > 0) {
				// Had much nicer regex for this but didn't work in IE8 :(
				var pieces = address.split(/,/g);
				address = $.trim(pieces[0]) + "<br/>";
				var remainder = pieces.slice(1);
				for(var i=0; i<remainder.length; i++) {
					address += i > 0 ? " " : "";
					address += $.trim(remainder[i]);
				}
			}
		}
		return address;
	}

	meerkat.modules.register('homeSnapshot', {
		init: initHomeSnapshot,
		events: events,
		getIcon: getIcon,
		getAddress: getAddress
	});

})(jQuery);