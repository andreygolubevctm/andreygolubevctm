/*
 *
 * Handling of the contact details
 *
*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		$firstname,
		$surname,
		$email,
		$postcodeDetails,
		$productDetailsField,
		$marketing,
		currentJourney;



	function applyEventListeners(){

		if (!meerkat.modules.splitTest.isActive(7)) {
			$marketing.on('change', function () {

				if ($(this).is(':checked')) {
					$email.attr('required', 'required').valid();
					showHidePostcodeField();
				} else {
					$email.removeAttr('required').valid();
				}
			});
		}
		$email.on('blur', function() {
				showHidePostcodeField();
			});
	}

	function showHidePostcodeField()
	{
		if (meerkat.modules.splitTest.isActive([5,6]))
		{
			if ($marketing.is(':checked') && $email.valid()) {
				if ($email.val().trim().length > 0) {
					$postcodeDetails.slideDown();
				} else {
					$postcodeDetails.slideUp();
				}
			}
		}
	}

	function setLocation(location) {
		if( isValidLocation(location) ) {
			var value = $.trim(String(location));
			var pieces = value.split(' ');
			var state = pieces.pop();
			var postcode = pieces.pop();
			var suburb = pieces.join(' ');

			$('#travel_state').val(state);
			$('#travel_postcode').val(postcode).trigger("change");
			$('#travel_suburb').val(suburb);
		} 
	}

	function isValidLocation( location ) {

		var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

		value = $.trim(String(location));

		if( value !== '' ) {
			if( value.match(search_match) ) {
				return true;
			}
		}
		return false;
	}

	function init(){
		
		//Elements need to be in the page
		$(document).ready(function() {
			$email = $('#travel_email'); 
			$marketing = $('#travel_marketing');
			$postcodeDetails = $('.postcodeDetails');
			$productDetailsField = $postcodeDetails.find('#travel_location');
			if (!meerkat.modules.splitTest.isActive(7)) {
				$email.removeAttr('required');
			}
			applyEventListeners();
		});
	}

	meerkat.modules.register("travelContactDetails", {
		init: init,
		setLocation: setLocation
	});

})(jQuery);