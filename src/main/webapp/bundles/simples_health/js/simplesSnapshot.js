;(function($, undefined){

	var meerkat = window.meerkat;

	var events = {
			simplesSnapshot: {
			}
		},
		$simplesSnapshot;
	var	elements = {
				journeyName:			'#health_contactDetails_name',
				journeySituation:		'#health_situation_healthCvr',
				journeyState:			'#health_situation_state',
				applicationState:		'#health_application_address_state',
				journeyPostCode:		'#health_situation_postcode',
				applicationPostCode:	'#health_application_address_postCode',
				journeySuburb:			'#health_situation_suburb',
				applicationSuburb:		'#health_application_address_suburb',
				applicationFirstName:	'#health_application_primary_firstname',
				applicationSurame:		'#health_application_primary_surname'
		};

	function applyEventListeners() {
		$(document).ready(function() {
            $simplesSnapshot = $(".simplesSnapshot");
			//Initial render for existing quotes
			renderSnapshot();

			$(	elements.journeyName +', '+
				elements.journeySituation +', '+
				elements.journeyState +', '+
				elements.applicationState +', '+
				elements.journeyPostCode +', '+
				elements.applicationPostCode +', '+
				elements.applicationFirstName +', '+
				elements.applicationSurame
				).on('change', function() {
				setTimeout(function() {
					renderSnapshot();
				}, 50);
			});
		});
	}

	function initSimplesSnapshot() {
		applyEventListeners();
	}

	/**
	 * Which icon to render depending on what the cover type is.
	 */
	function renderSnapshot() {
		if ($(elements.journeySituation +' option:selected').val() !== "" || $(elements.journeyState).val() !== "" || $(elements.journeyPostCode).val() !== "") { // These are compulsory so dont need to check for the others
			$simplesSnapshot.removeClass('hidden');
		}
		// Name
		if ($(elements.applicationFirstName).val() === '' && $(elements.applicationSurame).val() === ''){
			$('.snapshotApplicationFirstName, .snapshotApplicationSurname').hide();
			$('.snapshotJourneyName').show();
		}
		else {
			$('.snapshotApplicationFirstName, .snapshotApplicationSurname').show();
			$('.snapshotJourneyName').hide();
		}
		// State
		if ($(elements.applicationState).val() === ''){
			$('.snapshotApplicationState').hide();
			$('.snapshotJourneyState').show();
		}
		else {
			$('.snapshotApplicationState').show();
			$('.snapshotJourneyState').hide();
		}
		// Postcode
		if ($(elements.applicationPostcode).val() === ''){
			$('.snapshotApplicationPostcode').hide();
			$('.snapshotJourneyPostcode').show();
		}
		else {
			$('.snapshotApplicationPostcode').show();
			$('.snapshotJourneyPostcode').hide();
		}
		// Suburb
		if ($(elements.applicationSuburb).val() === ''){
			$('.snapshotApplicationSuburb').hide();
			$('.snapshotJourneySuburb').show();
		}
		else {
			$('.snapshotApplicationSuburb').show();
			$('.snapshotJourneySuburb').hide();
		}
		meerkat.modules.contentPopulation.render('.simplesSnapshot');
	}

	meerkat.modules.register('simplesSnapshot', {
		initSimplesSnapshot: initSimplesSnapshot,
		events: events
	});

})(jQuery);