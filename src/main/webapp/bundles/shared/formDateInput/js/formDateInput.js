;(function($, undefined){

	var meerkat = window.meerkat,
	log = meerkat.logging.info;

	var nativePickerEnabled = false;

	function init() {
		var iOS = meerkat.modules.performanceProfiling.isIos();
		var iOS5 = meerkat.modules.performanceProfiling.isIos5();

		$(document).ready(function() {
			// Decide whether to activate an HTML5 native date picker
			// (This is also known as Impress The Bosses On Their iPads feature)
			// Dropped native datepicker on Android due to default date and format issues
			if (Modernizr.inputtypes.date && iOS && !iOS5) {
				// set to false to enforce three box style picker
				nativePickerEnabled = false;
			}
			// Set up each date input component
			$('[data-provide=dateinput]').each(function initDateComponentFromDataAttribute() {
				initDateComponent($(this));
			});
		});
	}

	/**
	 * So it can be triggered externally for newly loaded in date elements.
	 * @param $component
	 */
	function initDateComponent($component) {

		if (nativePickerEnabled) {
			$component.attr('data-dateinput-type', 'native');

			$component.find('.dateinput-tripleField').addClass('hidden');
			$component.find('.dateinput-nativePicker')
				.removeClass('hidden')
				.find('input')
				.on('change', serialise);
		}
		else {
			$component.find(':input.dateinput-day, :input.dateinput-month, :input.dateinput-year')
				.on('input', moveToNextInput)
				.on('change', serialise);
		}

		// If the main form element changes, populate it back into the input fields
		var $serialise = $component.find('.serialise');
		populate($component, $serialise.val());

		$serialise.on('change', function() {
			populate($component, this.value);
		});
	}

	function populate($component, value) {
		if(!value) return;
		var parts = value.split('/'),
			nativeValue = '';

		if ($component.attr('data-locked') == 1) return;
		$component.attr('data-locked', 1);

		if (value.length === 0 || parts.length !== 3) {
			parts = ['', '', ''];
		}
		else {
			if (parts[0].length === 1) parts[0] = '0' + parts[0];
			if (parts[1].length === 1) parts[1] = '0' + parts[1];

			if (parts[2].length === 4 && parts[1].length === 2 && parts[0].length === 2) {
				nativeValue = parts[2] + '-' + parts[1] + '-' + parts[0];
			}
		}

		$component.find(':input.dateinput-day').val(parts[0]);
		$component.find(':input.dateinput-month').val(parts[1]);
		$component.find(':input.dateinput-year').val(parts[2]);

		$component.find('.dateinput-nativePicker input').val(nativeValue);

		if(meerkat.modules.performanceProfiling.isIE8() || meerkat.modules.performanceProfiling.isIE9()){
			meerkat.modules.placeholder.invalidatePlaceholder($component.find(':input.dateinput-day'));
			meerkat.modules.placeholder.invalidatePlaceholder($component.find(':input.dateinput-month'));
			meerkat.modules.placeholder.invalidatePlaceholder($component.find(':input.dateinput-year'));
		}

		$component.removeAttr('data-locked');

		var populatedEvent = $.Event('populated.meerkat.formDateInput');
		$component.trigger(populatedEvent);
	}

	function moveToNextInput() {

		var $this = $(this);
		if($this.is('select')) { return; }
		if (!$this.attr('maxlength')) {return;}
		if ($this.hasClass('year') || $this.hasClass('dateinput-year')) {return;}

		if ($this.val().length == $this.attr('maxlength')) {
			var next = ($this.hasClass('dateinput-day')) ? ':input.dateinput-month' : ':input.dateinput-year';
			$this.closest('[data-provide="dateinput"]').find(next).focus().select();
		}
	}

	function serialise() {

		var $component = $(this).parents('[data-provide="dateinput"]'),
			$destination = $component.find('.serialise'),
			day = '',
			month = '',
			year = '';

		if ($component.attr('data-locked') == 1) return;
		$component.attr('data-locked', 1);

		if ($component.attr('data-dateinput-type') == 'native') {

			var parts = (this.value.length > 0) ? this.value.split('-') : ['', '', ''];
			year = parts[0];
			month = parts[1];
			day = parts[2];
		}
		else {
			day = $component.find(':input.dateinput-day').val();
			month = $component.find(':input.dateinput-month').val();
			year = $component.find(':input.dateinput-year').val();
		}

		if($(this).data('is-year-input-for-hidden')) {
			year = $(this).val();
			if(year && year.length === 4) {
				var yearShort = year.substring(2, 4);
				$component.find(':input.dateinput-year-hidden-yy').val(yearShort);
			}
			$('[data-provide=dateinput]').find('input[id$="cardExpiryYear"]').trigger('change');
		}

		if (day.length === 1) day = '0' + day;
		if (month.length === 1) month = '0' + month;

		if ($component.attr('data-dateinput-type') != 'native' && $component.find('input.dateinput-day').length > 0) {
			$component.find(':input.dateinput-day').val(day);
			$component.find(':input.dateinput-month').val(month);
		}

		// Run 'simple' validation - only checks for non zero and is a valid number!!
		if (day.length > 0 && Number(day) > 0 && month.length > 0 && Number(month) > 0 && year.length > 0 && Number(year) > 0) {
			$destination.val(day + '/' + month + '/' + year);
			$destination.valid();

			var serialiseEvent = $.Event('serialised.meerkat.formDateInput');
			$destination.trigger(serialiseEvent, $destination.val());
		}
		else {
			$destination.val('');
		}

		$destination.change();

		$component.removeAttr('data-locked');
	}

	meerkat.modules.register("formDateInput", {
		init: init,
		initDateComponent: initDateComponent,
		populate: populate,
		serialise: serialise
	});

})(jQuery);