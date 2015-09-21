/*
 *
 * Handling of the Your cover selection
 *
*/
;(function($, undefined) {

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events,
	log = meerkat.logging.info;


	var $destinationfs,
		$datestravellersfs,
		$travel_policyType_S,
		$travel_policyType_A,
		$travel_dates_fromDate_row,
		$travel_dates_toDate_row,
		$detailsForm,
		$resultsContainer,
		$countrySelector,
		modalId = null;

	function init() {

			$(document.body).on('click', '.btn-view-brands', displayBrandsModal);

			// setup object references
			$destinationfs = $('#destinationsfs');
			$datestravellersfs = $('#datestravellersfs');
			$travel_policyType_S = $('#travel_policyType_S');
			$travel_policyType_A = $('#travel_policyType_A');
			$travel_dates_fromDate_row = $('#travel_dates_fromDate_row');
			$travel_dates_toDate_row = $('#travel_dates_toDate_row');
			$detailsForm = $('#detailsForm');
			$resultsContainer = $('.resultsContainer');
			$countrySelector = $('#travel_destinations');

			// hide the destinations section, travellers section, leave date and return date
			$destinationfs.hide();
			$datestravellersfs.hide();
			$travel_dates_toDate_row.hide();
			$travel_dates_fromDate_row.hide();

			// hide the blue bubble amt and single trip content
			$detailsForm.find('.well-chatty > .amt, .well-chatty > .single').hide();

			// subsribe to the COVER_TYPE_CHANGE event
			meerkat.messaging.subscribe(meerkatEvents.traveldetails.COVER_TYPE_CHANGE, toggleDetailsFields);

			applyEventListeners();
	}


	function applyEventListeners() {

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter() {
			if (meerkat.modules.dialogs.isDialogOpen(modalId))
			{
				meerkat.modules.dialogs.close(modalId);
			}
		});
	}

	function displayBrandsModal(event) {

		var template = _.template($('#brands-template').html());

		modalId = meerkat.modules.dialogs.show({
			title : $(this).attr('title'),
			hashId : 'travel-brands',
			className : 'travel-brands-modal',
			htmlContent: template(),
			closeOnHashChange: true,
			openOnHashChange: false
		});

		return false;
	}

	function toggleDetailsFields() {

		// set the policytype
		$resultsContainer.attr('policytype', $("input[name=travel_policyType]:checked").val());
		meerkat.modules.journeyEngine.sessionCamRecorder({"navigationId": "PolicyType-"+$("input[name=travel_policyType]:checked").val()});
		// single trip
		var isIe8 = meerkat.modules.performanceProfiling.isIE8(), showMethod = isIe8 ? 'show' : 'slideDown', hideMethod = isIe8 ? 'hide' : 'slideUp';
		if ($travel_policyType_S.prop('checked')) {
			// show the green bubble and single trip blue bubble copy
			$detailsForm.find('.well-info, .well-chatty > .single').show();
			// hide the amt and default blue bubble copy
			$detailsForm.find('.well-chatty > .amt, .well-chatty > .default').hide();

			$destinationfs.add($datestravellersfs).add($travel_dates_fromDate_row).add($travel_dates_toDate_row)[showMethod]();

			// update section header name for dates & travellers section
			$datestravellersfs.find('h2').text("Dates & Travellers");

			$countrySelector.focus();
		} else {
			// AMT
			// hide the green bubble and the blue bubble copy for default and single trips
			$detailsForm.find('.well-info, .well-chatty > .single, .well-chatty > .default').hide();
			// show the amt blue bubble copy
			$detailsForm.find('.well-chatty > .amt').show();

			// check if desination is visiable
			if ($destinationfs.is(':visible'))
			{
				$destinationfs.add($travel_dates_toDate_row).add($travel_dates_fromDate_row)[hideMethod]();
			} else {
				// on first load
				$datestravellersfs.slideDown();
			}

			// update section header name for dates & travellers section
			$datestravellersfs.find('h2').text("Travellers");
		}
	}

	meerkat.modules.register("travelYourCover", {
		initTravelCover: init,
		toggleDetailsFields: toggleDetailsFields
	});

})(jQuery);