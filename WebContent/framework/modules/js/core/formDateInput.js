;(function($, undefined){

	var meerkat = window.meerkat;



	function init() {
		var iOS = meerkat.modules.performanceProfiling.isIos();
		var Android = meerkat.modules.performanceProfiling.isAndroid();
		var Chrome = meerkat.modules.performanceProfiling.isChrome();

		$(document).ready(function() {
			var nativePickerEnabled = false;

			// Decide whether to activate an HTML5 native date picker
			// (This is also known as Impress The Bosses On Their iPads feature)
			if (Modernizr.inputtypes.date && (iOS || (Android && Chrome))) {
				nativePickerEnabled = true;
			}

			// Set up each date input component
			$('[data-provide=dateinput]').each(function setupDateInput() {
				var $component = $(this);

				if (nativePickerEnabled) {
					$component.attr('data-dateinput-type', 'native');

					$component.find('.dateinput-tripleField').addClass('hidden');
					$component.find('.dateinput-nativePicker')
						.removeClass('hidden')
						.find('input')
							.on('change', serialise)
					;
				}
				else {
					$component.find('input.dateinput-day, input.dateinput-month, input.dateinput-year')
						.on('input', moveToNextInput)
						.on('change', serialise)
						//.on('focus', function() { this.select(); });
					;
				}

				// If the main form element changes, populate it back into the input fields
				var $serialise = $component.find('.serialise');
				populate($component, $serialise.val());

				$serialise.on('change', function() {
					populate($component, this.value);
				});
			});

		});
	}

	function populate($component, value) {
		var parts = value.split('/'),
			nativeValue = '';

		//alert('populate');

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

		$component.find('input.dateinput-day').val(parts[0]);
		$component.find('input.dateinput-month').val(parts[1]);
		$component.find('input.dateinput-year').val(parts[2]);

		$component.find('.dateinput-nativePicker input').val(nativeValue);
		//alert('populate2: ' + nativeValue);

		if(meerkat.modules.performanceProfiling.isIE8() || meerkat.modules.performanceProfiling.isIE9()){
			meerkat.modules.placeholder.invalidatePlaceholder($component.find('input.dateinput-day'));
			meerkat.modules.placeholder.invalidatePlaceholder($component.find('input.dateinput-month'));
			meerkat.modules.placeholder.invalidatePlaceholder($component.find('input.dateinput-year'));
		}

		$component.removeAttr('data-locked');
	}

	function moveToNextInput() {
		//console.log('moveToNextInput', this);

		var $this = $(this);
		if (!$this.attr('maxlength')) return;
		if ($this.hasClass('year')) return;

		if ($this.val().length == $this.attr('maxlength')) {
			var next = ($this.hasClass('dateinput-day')) ? 'input.dateinput-month' : 'input.dateinput-year';
			$this.closest('[data-provide="dateinput"]').find(next).focus().select();
		}
	}

	function serialise() {
		//alert('serialise value: ' + this.value);

		var $component = $(this).parents('[data-provide="dateinput"]'),
			$destination = $component.find('.serialise'),
			day = '',
			month = '',
			year = '';

		//console.log($component.find('.dateinput-nativePicker').val());
		if ($component.attr('data-locked') == 1) return;
		$component.attr('data-locked', 1);

		if ($component.attr('data-dateinput-type') == 'native') {

			var parts = (this.value.length > 0) ? this.value.split('-') : ['', '', ''];
			year = parts[0];
			month = parts[1];
			day = parts[2];
		}
		else {
			day = $component.find('input.dateinput-day').val();
			month = $component.find('input.dateinput-month').val();
			year = $component.find('input.dateinput-year').val();
		}

		if (day.length === 1) day = '0' + day;
		if (month.length === 1) month = '0' + month;


		// Run validation
		if (day.length > 0 && Number(day) > 0 && month.length > 0 && Number(month) > 0 && year.length > 0 && Number(year) > 0) {
			$destination.val(day + '/' + month + '/' + year);
			$destination.valid();
		}
		else {
			$destination.val('');
		}

		$destination.change();

		$component.removeAttr('data-locked');
	}



	meerkat.modules.register("formDateInput", {
		init: init
	});

})(jQuery);