/*
	This is a wrapper for the bootstrap datepicker library
	which allows the semantic definition of multiple modes and instances.

	Library in:
		framework/jquery/lib/bootstrap-datepicker

	Style in:
		framework/modules/less/datepicker3.less

	Datepicker useful links for devs:
		http://bootstrap-datepicker.readthedocs.org/
		http://eternicode.github.io/bootstrap-datepicker/

	FOR DYNAMICALLY INSERTED OR TEMPLATE BASED DATEPICKERS, USE THE EXPOSED FUNCTIONS TO ENSURE ADDITIONAL FUNCTIONALITY IS HANDLED:
		initSeparated
		initComponent
		setDefaults
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		debug = meerkat.logging.debug,
		exception = meerkat.logging.exception,
		$datePickerElms,
		datePickerSelector;


	//Bind the input addon to be a clickable element to launch the calendar display
	//In theory this should have been handled by the default bootstrap datepicker code
	function bindSeparatedAddonClick($passedElement) {
		//log("bindSeparatedAddonClick",$passedElement,$passedElement.siblings(".withDatePicker").find(".input-group-addon"));
		// when clicking a group input icon, trigger the focus on the input field
		$passedElement.closest(".dateinput_container")
		.find(".withDatePicker .input-group-addon-button")
		.on("click", function showDatePickerOnAddonClick(){
			$passedElement.datepicker("show");
		});
	}

	// Refresh the validation after a date pick.
	function bindComponentBlurBehaviour(thisDatePickerSelector){
		// This is for instances where the input was marked as invalid, then a new date was picked - we need to trigger a blur to then trigger the re-validate.
		$(document).on(
			//'changeDate', //Stopped using changeDate because it fires when the picker initialises and the input already has a value (preload etc)
			'hide',
			thisDatePickerSelector,
			function(e) {

				var $target = $(e.target);
				//log('datepicker.change', e);
				
				// Make sure there's a target on hide.
				if (!e.target) { return; }
				// If it's the input, then we can blur it and get out.
				if ($target.is('input')) { $target.blur(); return; }
				// If it was bound to a parent, go find the element
				// Don't blur if field has focus e.g. user is typing in the date
				if ($target.find("input").is(':focus')) { return; } 
				// Otherwise just go for it
				$target.find("input").blur();
				if(meerkat.modules.performanceProfiling.isIE8() || meerkat.modules.performanceProfiling.isIE9()){
					meerkat.modules.placeholder.invalidatePlaceholder($('input.dateinput-date'));
				}
			}
		);
	}

	function setDefaultSettings() {
		// defaults
		if (typeof $.fn.datepicker.defaults === 'object') {
			$.fn.datepicker.defaults.format = 'dd/mm/yyyy';
			$.fn.datepicker.defaults.autoclose = true;
			$.fn.datepicker.defaults.forceParse = false; // this is false for a usability issue, use validation instead.
			$.fn.datepicker.defaults.weekStart = 1;
			$.fn.datepicker.defaults.todayHighlight = true;
			$.fn.datepicker.defaults.clearBtn = false;
			$.fn.datepicker.defaults.keyboardNavigation = false;

		} else {
			//This will log (as with the other exception) if you have a datepicker on the page but no library in place. It should only log the first error instead of the second.
			exception('core/datepicker:(lib-defaults-not-setable)');
		}
	}

	function initComponentDatepicker() {
		bindComponentBlurBehaviour(datePickerSelector);
	}

	function initSeparatedDatepicker($this) {
		//Set the calendar to the new value of the hidden input when it changes.
		bindSeparatedAddonClick($this);

		$this.on('serialised.meerkat.formDateInput', function updateCalendarOnInputChanges() {
			$this.datepicker('update').blur();
		});
		//This is to handle updating via picker and the separate fields are in error state
		$this.on('hide', function updateInputsOnCalenderChanges() {
			$this.closest(".dateinput_container")
			.find(".withDatePicker input").blur();
			$this.blur();
		});
	}

	function initDatepickerModule() {
		// datepickers settings

		//Find the approp dom elements.
		datePickerSelector = "[data-provide=datepicker]";
		$datePickerElms = $(datePickerSelector);

		log('[datepicker]','Initialised'); //purely informational
		
		if ($datePickerElms.length > 0) {
			// Check if library dependancy exists BUT only if you're trying to use a datepicker on the vertical.
			if (typeof $.fn.datepicker !== 'function') {
				exception('core/datepicker:(lib-not-loaded-err)'); //this is quiet and sends to the DB.
				return;
			}
			
			//Set the usual functions for all datepicker instances if the default object exists.
			setDefaultSettings();

		} else {
			debug('[datepicker]','No datepickers found');
		}

		$datePickerElms.each(function(){
			var $this = $(this);
			var mode = $this.data('date-mode');
			//Just a guard in case people are expecting the default component behaviours
			if (typeof mode === 'undefined'){
				mode = 'component'; //set a minimum mode
			}
			//The tag component defaults the output of "mode" at all times.

			//debug('[datepicker]','Mode:', mode,'Element:',$this);
			
			switch (mode) {
				//By default we actually use our crazy separated input mode, but we can kick it back to the original bootstrap datepicker functionality for component, inline or range by checking options.
				//Right now we haven't implemented much configurability.
				//As part of boostrap datepicker, the only thing you need for these options is different HTML, and its handled in the tag. This code is an opportunity to override things based on the flag set in HTML.
				case 'component':
					//This just consists of the .datepicker being applied to a parent div.input-group with only 1 input.form-control and the input-group-addon inside.
					initComponentDatepicker();
					break;
				case 'inline':
					//This just consists of the .datepicker being applied to a div with no inputs inside.

					break;
				case 'range':
					//This just consists of the .datepicker being applied to a parent div.input-group with 2 input.form-control and the input-group-addon inside between them.
					//Our html implementation may require us to tell datepicker which elements are in the range manually - use options.
					//var selector = options.selector;

					break;
				case 'separated':
					//As mentioned, the separated form controls are the ones we use for presentation of what is in essence the component style use case of bootstrap datepicker with some proxy code to fill separate fields.
					initSeparatedDatepicker($this);
					break;
			}
		});

	}

	function init() {
		$(document).ready(function(){
			meerkat.messaging.subscribe(meerkatEvents.journeyEngine.READY, function lateDomready() {
				initDatepickerModule();
			});
		});
	}


	meerkat.modules.register('datepicker', {
		init: init,
		initSeparated: initSeparatedDatepicker,
		initComponent: initComponentDatepicker,
		setDefaults: setDefaultSettings
	});

})(jQuery);