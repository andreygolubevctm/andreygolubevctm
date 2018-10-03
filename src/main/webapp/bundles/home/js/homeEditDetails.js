;(function($, undefined) {

	var meerkat = window.meerkat, meerkatEvents = meerkat.modules.events, log = meerkat.logging.info;

	var events = {
			homeEditDetails : {}
	}, moduleEvents = events.homeEditDetails;

	/* Variables */
	var $editDetailsDropDown = $('#edit-details-dropdown'),
		$editDetailsTemplate,
		modalId = null;

	/* main entrypoint for the module to run first */
	function initEditDetails() {
		$editDetailsTemplate = $('#edit-details-template');

		applyEventListeners();
		eventSubscriptions();
	}

	function getData() {
		return {
			coverType: $('#home_coverType').val(),
			icon: meerkat.modules.homeSnapshot.getIcon(),
			landlordInsuranceClaims: $('.isLandlord #home_disclosures_claims_Y')[0].checked,
			ownsHome: $('.notLandlord #home_occupancy_ownProperty_Y').is(':checked'),
			ownsHomeLandlord: $('.isLandlord #home_occupancy_ownProperty_Y').is(':checked'),
			isPrincipalResidence: $('#home_occupancy_principalResidence_Y').is(':checked'),
			businessActivity: $('#home_businessActivity_conducted_Y').is(':checked'),
			isBodyCorp: $('#home_property_bodyCorp_Y').is(':checked'),
			hasInternalSiren: $('#home_property_securityFeatures_internalSiren').is(':checked'),
			hasExternalSiren: $('#home_property_securityFeatures_externalSiren').is(':checked'),
			hasExternalStrobe: $('#home_property_securityFeatures_strobeLight').is(':checked'),
			hasBackToBase: $('#home_property_securityFeatures_backToBase').is(':checked'),
			isSpecifyingPersonalEffects: $('#home_coverAmounts_itemsAway_Y').is(':checked'),
			specifiedPersonalEffects: $('#home_coverAmounts_specifyPersonalEffects_Y').is(':checked'),
			bicycles: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_bicycleentry"),
			musical: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_musicalentry"),
			clothing: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_clothingentry"),
			jewellery: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_jewelleryentry"),
			sporting: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_sportingentry"),
			photography: hasPersonalEffects("#home_coverAmounts_specifiedPersonalEffects_photoentry"),
			hasRetiredOver55: $('#home_policyHolder_retired_Y').is(':checked'),
			previousClaims: $('#home_disclosures_claims_Y').is(':checked')
		};
	}

	function applyEventListeners() {

		$editDetailsDropDown.on('show.bs.dropdown', function() {
			show();
		}).on('click', '.dropdown-container', function(e) {
			e.stopPropagation();
		});

	}

	function hasPersonalEffects(selector) {
		$el = $(selector);
		if($el.val() === "$0" || $el.val() === "") {
			return false;
		}
		return true;
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

		meerkat.messaging.subscribe(meerkatEvents.mobileNavButtons.EDIT_DETAILS_TOGGLED, function onEditDetailsToggled() {
			show();
		});
	}

	function show() {
		var templateCallback = _.template($editDetailsTemplate.html()),
			data = getData();

		if (meerkat.modules.deviceMediaState.get() == 'xs') {
			modalId = showModal(templateCallback(data));
		} else {
			showDropDown(templateCallback(data));
		}
	}

	function hide() {
		if ($editDetailsDropDown.hasClass('open')) {
			$editDetailsDropDown.find('.activator').dropdown('toggle').end().find('.edit-details-wrapper').empty();
		} else {
			$editDetailsDropDown.find('.edit-details-wrapper').empty();
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


	meerkat.modules.register('homeEditDetails', {
		initEditDetails : initEditDetails,
		events : events,
		show: show,
		hide: hide,
		getFormData: getData
	});

})(jQuery);
