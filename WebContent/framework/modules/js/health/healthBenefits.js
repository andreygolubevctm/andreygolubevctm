;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		$dropdown,  //Stores the jQuery object for this dropdown
		$component, //Stores the jQuery object for the component group
		mode,
		isIE8;

	var events = {
			healthBenefits: {
				CHANGED: 'HEALTH_BENEFITS_CHANGED'
			}
		},
		moduleEvents = events.healthBenefits;

	var MODE_POPOVER = 'popover-mode'; // Triggered as pop over
	var MODE_JOURNEY = 'journey-mode'; // Triggered by journey engine step. Different buttons are shown and different events are triggered.


	function getProductCategory() {
		var hospital = $('#health_benefits_benefitsExtras_Hospital').is(':checked');
		var extras = $('#health_benefits_benefitsExtras_GeneralHealth').is(':checked');

		if (hospital > 0 && extras) {
			return 'Combined';
		} else if (hospital) {
			return 'Hospital';
		} else if (extras) {
			return 'GeneralHealth';
		} else {
			return 'None';
		}
	}

	function getBenefitsForSituation(situation){

		if(situation === ""){
			populateHiddenFields([]);
			return;
		}

		meerkat.modules.comms.post({
			url:"ajax/csv/get_benefits.jsp",
			data: {
				situation: situation
			},
			errorLevel: "silent",
			cache:true,
			onSuccess:function onBenefitSuccess(data){
				defaultBenefits = data.split(',');
				populateHiddenFields(defaultBenefits);
			}
		});

	}

	// The information submitted to the server is contained in hidden fields. The values are read from here before making the popover visible.
	function resetHiddenFields(){
		$("#mainform input[type='hidden'].benefit-item").val('');
	}

	function populateHiddenFields(checkedBenefits){

		resetHiddenFields();

		for(var i=0;i<checkedBenefits.length;i++){
			var path = checkedBenefits[i];
			var element = $("#mainform input[name='health_benefits_benefitsExtras_"+path+"'].benefit-item").val('Y');
		}

	}

	// Populate and reset the checkboxes on the drop down to match the values from the hidden fields.
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

	// Get the selected benefits from the forms hidden fields (the source of truth! - not the checkboxes)
	function getSelectedBenefits(){
		
		var benefits = [];
		
		$( "#mainform input.benefit-item" ).each(function( index, element ) {
			var $element = $(element);
			if($element.val() == 'Y'){
				var key = $element.attr('data-skey');
				benefits.push(key);
			}
		});

		return benefits;

	}

	function saveBenefits(){

		resetHiddenFields();

		var selectedBenefits = [];

		$component.find(':input:checked').each(function( index, element ) {
			var $element = $("#mainform input[name='"+ $(element).attr('name')+"'].benefit-item");
			$element.val('Y');
			selectedBenefits.push($element.attr('data-skey'));
		});

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

		if (navigationId === 'benefits' || navigationId === 'results') {
			meerkat.modules.journeyEngine.loadingShow('...getting your quotes...', true);
		}
		
		close();
		
		// Defers are here for performance reasons on tablet/mobile.
		_.defer(function(){

			var selectedBenefits = saveBenefits();

			if (mode === MODE_JOURNEY) {
				meerkat.modules.journeyEngine.gotoPath("next"); //entering the results step will step up the selected benefits.
			}else{
				meerkat.messaging.publish(moduleEvents.CHANGED, selectedBenefits);
			}

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

	// Open the dropdown with code (public method). Specify a 'mode' of 'journey-mode' to apply different UI options.
	function open(modeParam) {
		mode = modeParam;

		// Open the menu on mobile too.
		meerkat.modules.navbar.open();

		if($dropdown.hasClass('open') === false){
			$component.addClass(mode);
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
			meerkat.modules.navbar.close();
		}
	}

	// Remove event listeners and reset class state when dropdown is closed.
	function afterClose(){
		$component.find('input.hasChildren').off('change.benefits');
		$component.find('.btn-save').off('click.benefits');
		$component.find('.btn-cancel').off('click.benefits');
		$component.find(".categoriesCell .checkbox").off('click.benefits', enableParent);

		$component.removeClass('journey-mode');
		$component.removeClass('popover-mode');

		mode = null;
	}


	function init(){

		$(document).ready(function(){

			if (meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;

			// Store the jQuery objects
			$dropdown = $('#benefits-dropdown');
			$component = $('.benefits-component');

			isIE8 = meerkat.modules.performanceProfiling.isIE8();

			$dropdown.on('show.bs.dropdown', function () {
				if(mode === null) mode = MODE_POPOVER;
				afterOpen();
				populateDisplayComponent();
			});

			$dropdown.on('hide.bs.dropdown', function(event) {
				// TODO Rethink this to make it more generic and not hard-coded to prevent closure on step 2.
				// ?maybe connected to the toggle button being enabled/disabled?
				if(meerkat.modules.journeyEngine.getCurrentStepIndex() == 2) {
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
				if (step.navigationId === 'benefits') {
					return;
				}
				// Close dropdowns when changing steps
				meerkat.modules.healthBenefits.close();
			});

			$("[data-benefits-control='Y']").click(function(event){
				event.preventDefault();
				event.stopPropagation();
				open(MODE_POPOVER);
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
		close: close,
		getProductCategory: getProductCategory,
		getSelectedBenefits:getSelectedBenefits,
		getBenefitsForSituation:getBenefitsForSituation
	});

})(jQuery);
