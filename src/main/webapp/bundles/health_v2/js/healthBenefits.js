;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		$dropdown,  //Stores the jQuery object for this dropdown
		$component, //Stores the jQuery object for the component group
		isIE8;

	var events = {
			healthBenefits: {
				CHANGED: 'HEALTH_BENEFITS_CHANGED'
			}
		},
		moduleEvents = events.healthBenefits;


	// Populate and reset the checkboxes on the drop down to match the values from the journey benefits selections.
	function resetDisplayComponent(){
		$component.find(".benefits-list input[type='checkbox']").prop('checked', false);
		if (isIE8) $component.find(".benefits-list input[type='checkbox']").change();
	}

	function populateDisplayComponent(){

		resetDisplayComponent();

		// Get values from hidden fields and display them.//
		$( "#mainform input.benefit-item" ).each(function( index, element ) {
			var $element = $(element);
			if($element.val() == 'Y'){
				var key = $element.attr('name');
				$component.find(".benefits-list :input[name='"+key+"']").prop('checked', true);
				if (isIE8) $component.find(".benefits-list :input[name='"+key+"']").change();
			}
		});

		// Get values from journey benefits fields and display them.//
		$( "#benefitsForm").find(".benefits-list input[type='checkbox']" ).each(function( index, element ) {
			var $element = $(element);
			if($element.is(':checked')){
				var key = $element.attr('name');
				$component.find(".benefits-list :input[name='"+key+"']").prop('checked', true);
				if (isIE8) $component.find(".benefits-list :invx put[name='"+key+"']").change();
			}
		});

		// Redraw bootstrap switches.
		$component.find('input.checkbox-switch').bootstrapSwitch('setState');

		// Set disabled/enabled states on checkboxes
		$component.find('input.hasChildren').each(function( index, element ) {
			updateEnableSectionState(element);
		});

	}

	// Control the enabled/disabled state of checkboxes from the top level on/off switches
	function onSectionChange(event) {
		
		// At least one top level checkbox must be selected:
		if($component.find(':input.hasChildren:checked').length === 0){
			$component.find('.btn-save').prop('disabled', true);
			$component.find('a.btn-save').addClass('disabled');
		}else{
			$component.find('.btn-save').prop('disabled', false);
			$component.find('a.btn-save').removeClass('disabled');
		}

		updateEnableSectionState($(this));

	}

	function updateEnableSectionState(element) {
		var $element = $(element),
			disabled = !$element.is(':checked'),
			$first = $element.parents('.short-list-item').first(),
			$childrenInputs = $first.find(".children :input");

		$childrenInputs.prop('disabled', disabled);

		if (disabled === true) {
			$first.addClass('disabled');
			$childrenInputs.prop('checked', false);
		} else {
			$first.removeClass('disabled');
		}

		if (isIE8) $childrenInputs.change();
	}

	function saveBenefits(){

		meerkat.modules.healthBenefitsStep.resetBenefitsSelection();

		var selectedBenefits = [];

		$component.find(':input:checked').each(function( index, element ) {
			var benefit = $(element).attr('name').replace('health_benefits_benefitsExtras_', ''),
				$element;

			// For the yes/no toggle, update the hidden fields
			if (benefit === 'Hospital' || benefit === 'GeneralHealth') {
				$element = $("#mainform input[name='"+ $(element).attr('name')+"'].benefit-item");
				$element.val('Y');
			}
			// otherwise update the journey benefits checkboxes
			else {
				$element = $('#benefitsForm').find("input[name='"+ $(element).attr('name')+"']");
				$element.prop('checked', true);
			}

			selectedBenefits.push(benefit);
		});

		// TODO: when call centre starts using healthV2, check if below logic still needs to be moved to new benefitsStep module
		// when hospital is set to off in [Customise Cover] disable the hospital level drop down in [Filter Results]
		if(_.contains(selectedBenefits, 'Hospital')){
			$('#filter-tierHospital').removeClass('hidden');
		}else{
			$('#filter-tierHospital').addClass('hidden');
			$('#filters_tierHospital').val('');
			$('#health_filter_tierHospital').val('');
		}
		// when extra is set to off in [Customise Cover] disable the extra level drop down in [Filter Results]
		if(_.contains(selectedBenefits, 'GeneralHealth')){
			$('#filter-tierExtras').removeClass('hidden');
		}else{
			$('#filter-tierExtras').addClass('hidden');
			$('#filters_tierExtras').val('');
			$('#health_filter_tierExtras').val('');
		}

		return selectedBenefits;

	}

	// Save and close dropdown
	function saveSelection(){

		// Show the loading only on #benefits and #results because Simples can open it on earlier slides.
		var navigationId = '';
		if (meerkat.modules.journeyEngine.getCurrentStep()) navigationId = meerkat.modules.journeyEngine.getCurrentStep().navigationId;

		if (navigationId === 'results') {
			meerkat.modules.journeyEngine.loadingShow('getting your quotes', true);
		}

		close();
		
		// Defers are here for performance reasons on tablet/mobile.
		_.defer(function(){
			var selectedBenefits = saveBenefits();
			meerkat.messaging.publish(moduleEvents.CHANGED, selectedBenefits);
			meerkat.modules.healthBenefitsStep.updateCoverTypeByBenefitsSelected();
		});

	}

	// Enable parent switch when disabled child checkbox is clicked.
	function enableParent(event){
		$target = $(event.currentTarget);
		if($target.find('input').prop('disabled') === true){
			$target.parents('.hasShortlistableChildren').first().find(".title").first().find(':input').prop('checked', true);
			$component.find('input.checkbox-switch').bootstrapSwitch('setState'); // Redraw bootstrap switches.
		}
	}

	// Open the dropdown
	function open() {

		// Open the menu on mobile too.
		meerkat.modules.navMenu.open();

		if($dropdown.hasClass('open') === false){
			$dropdown.find('.activator').dropdown('toggle');
		}
	}

	// Add event listeners when dropdown is opened.
	function afterOpen() {
		$component.find(':input.hasChildren').on('change.benefits', onSectionChange);
		$component.find('.btn-save').on('click.benefits', saveSelection);
		$component.find('.btn-cancel').on('click.benefits', close);
		$component.find(".categoriesCell .checkbox").on('click.benefits', enableParent);
	}

	// Close the drop down with code (public method).
	function close() {
		if ($dropdown.hasClass('open')) {

			if (isLocked()) {
				unlockBenefits();
				$dropdown.find('.activator').dropdown('toggle');
				lockBenefits();
			}
			else {
				$dropdown.find('.activator').dropdown('toggle');
			}

			//Also close the hamburger menu on mobile which contains the close.
			meerkat.modules.navMenu.close();
		}
	}

	// Remove event listeners and reset class state when dropdown is closed.
	function afterClose(){
		$component.find('input.hasChildren').off('change.benefits');
		$component.find('.btn-save').off('click.benefits');
		$component.find('.btn-cancel').off('click.benefits');
		$component.find(".categoriesCell .checkbox").off('click.benefits', enableParent);
	}


	function init(){

		$(document).ready(function(){

			if (meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;

			// Store the jQuery objects
			$dropdown = $('#benefits-dropdown');
			$component = $('.benefits-component');

			isIE8 = meerkat.modules.performanceProfiling.isIE8();

			$dropdown.on('show.bs.dropdown', function () {
				afterOpen();
				populateDisplayComponent();
			});

			$dropdown.on('hide.bs.dropdown', function(event) {
				// TODO Rethink this to make it more generic and not hard-coded to prevent closure on step 2.
				// ?maybe connected to the toggle button being enabled/disabled?
				if(meerkat.modules.journeyEngine.getCurrentStepIndex() == 1) {
					// Prevent hidden.bs.dropdown from running
					event.preventDefault();

					// Re-apply the backdrop because we can't prevent Bootstrap from removing it
					meerkat.modules.dropdownInteractive.addBackdrop($dropdown);
				}
			});

			$dropdown.on('hidden.bs.dropdown', function () {
				afterClose();
			});

			meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function jeStepChange(step){
				// Close dropdowns when changing steps
				meerkat.modules.healthBenefits.close();
			});

			$("[data-benefits-control='Y']").click(function(event){
				event.preventDefault();
				event.stopPropagation();
				open();
			});

			// On application lockdown/unlock, disable/enable the dropdown
			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, lockBenefits);
			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, unlockBenefits);

		});
	}

	function isLocked() {
		return $dropdown.children('.activator').hasClass('disabled');
	}

	function lockBenefits() {
		$dropdown.children('.activator').addClass('inactive').addClass('disabled');
	}

	function unlockBenefits() {
		$dropdown.children('.activator').removeClass('inactive').removeClass('disabled');
	}

	meerkat.modules.register('healthBenefits', {
		init: init,
		events: events,
		open: open,
		close: close
	});

})(jQuery);
