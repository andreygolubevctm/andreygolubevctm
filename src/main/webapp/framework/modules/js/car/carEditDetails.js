/**
 * Brief explanation of the module and what it achieves. <example: Example
 * pattern code for a meerkat module.> Link to any applicable confluence docs:
 * <example: http://confluence:8090/display/EBUS/Meerkat+Modules>
 */

;(function($, undefined) {

	var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;

	var events = {
		carEditDetails : {}
	}, moduleEvents = events.carEditDetails;

	/* Variables */
	var $editDetailsDropDown = $('#edit-details-dropdown'),
	modalId = null;

	/* main entrypoint for the module to run first */
	function initEditDetails() {
		applyEventListeners();
		eventSubscriptions();
	}

	function applyEventListeners() {

		$editDetailsDropDown.on('show.bs.dropdown', function() {
			var $e = $('#edit-details-template');
			if ($e.length > 0) {
				templateCallback = _.template($e.html());
			}
			var data = {
				youngDriver : $('input[name=quote_drivers_young_exists]:checked').val(),
			};

			show(templateCallback(data));
		}).on('click', '.closeDetailsDropdown', function(e) {
			hide();
			e.stopPropagation();
		}).on('click', '.dropdown-container', function(e) {
			e.stopPropagation();
		});
	}
	function eventSubscriptions() {
		// On application lockdown/unlock, disable/enable the dropdown
		meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockEditDetails(obj) {
			hide();
			$editDetailsDropDown.children('.activator').addClass('inactive').addClass('disabled');
		});

		meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockEditDetails(obj) {
			$editDetailsDropDown.children('.activator').removeClass('inactive').removeClass('disabled');
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function editDetailsEnterXsState() {
			hide();
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function editDetailsLeaveXsState() {
			hide();
		});
	}

	function show(htmlContent) {
		if (meerkat.modules.deviceMediaState.get() == 'xs') {
			modalId = showModal(htmlContent);
		} else {
			showDropDown(htmlContent);
		}
	}

	function hide() {
		if ($editDetailsDropDown.hasClass('open')) {
			$editDetailsDropDown.find('.activator').dropdown('toggle').end().find('.edit-details-wrapper').empty();
		}
		if(modalId !== null) {
			$('#'+modalId).modal('hide');
		}
	}

	/**
	 * Shows the modal in a wrapper, scoped to the modal (otherwise collapse
	 * won't work).
	 */
	function showModal(htmlContent) {
		var modalId = meerkat.modules.dialogs.show({
					htmlContent : '<div class="edit-details-wrapper"></div>',
					hashId : 'edit-details',
					className: 'edit-details-modal',
					closeOnHashChange : true,
					onOpen : function(modalId) {
						var $editDetails = $('.edit-details-wrapper', $('#' + modalId));
						$editDetails.html(htmlContent);
						meerkat.modules.contentPopulation.render('#' + modalId + ' .edit-details-wrapper');
						$('.accordion-collapse').on('show.bs.collapse', function(){
							$(this).prev('.accordion-heading').addClass("active-panel");
						}).on('hide.bs.collapse',function(){
							$(this).prev('.accordion-heading').removeClass("active-panel");
						});
						$editDetails.show();

					}
				});
		return modalId;
	}

	function showDropDown(htmlContent) {
		var $editDetails = $('#edit-details-dropdown .edit-details-wrapper');
		$editDetails.html(htmlContent);
		meerkat.modules.contentPopulation
				.render('#edit-details-dropdown .edit-details-wrapper');
		$editDetails.find('.accordion-collapse').addClass('in').end().show();
	}
	/**
	 * Utility callback to format the No Claim Discount to a specific format.
	 */
	function formatNcd(sourceEl) {
		var val = sourceEl.val(), rating;
		switch (val) {
		case "5":
			rating = 1;
			break;
		case "4":
			rating = 2;
			break;
		case "3":
			rating = 3;
			break;
		case "2":
			rating = 4;
			break;
		case "1":
			rating = 5;
			break;
		case "0":
			rating = 6;
			break;
		}
		// No NCD if 6
		if(rating == 6) {
			return "Rating 6 No NCD";
		}
		return typeof rating == 'undefined' ? "" : "Rating " + rating + " ("+val+" Years) NCD";
	}

	/**
	 * Utility callback to format the Driver Option to a specific format.
	 */
	function driverOptin(sourceEl) {

		var val = sourceEl.val(), output = '', years;
		switch (val) {
		case 'H':
			years = 21;
			break;
		case '7':
			years = 25;
			break;
		case 'A':
			years = 30;
			break;
		case 'D':
			years = 40;
			break;
		}

		if (val == '3') {
			output = 'No Restrictions';
		} else if (typeof years != 'undefined') {
			output = 'Restricted to ' + years + ' or older';
		}
		return output;
	}

	function formatDamage(sourceEl) {
		var val = sourceEl.find(':checked').val(), output = ' Accident/Hail Damage';

		if(val === 'Y')
			return output;
		if(val === 'N')
			return 'No' + output;

		return '';
	}

	function formatRedbookCode(sourceEl) {
		var val = "";

		if(meerkat.modules.carVehicleSelection.isSplitTest()) {
			val = sourceEl.find('input:checked').parent().text();
		} else {
			val = sourceEl.text();
		}

		return val;
	}

	meerkat.modules.register('carEditDetails', {
		initEditDetails : initEditDetails, // main entrypoint to be called.
		events : events, // exposes the events object
		driverOptin : driverOptin,
		formatNcd : formatNcd,
		formatDamage : formatDamage,
		formatRedbookCode : formatRedbookCode,
		hide: hide
	});

})(jQuery);