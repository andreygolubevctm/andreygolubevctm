/*
	Library in:
		framework/jquery/lib/bootstrap-datepicker

	Style in:
		framework/modules/less/datepicker3.less

	Datepicker useful links for devs:
		http://bootstrap-datepicker.readthedocs.org/
		http://eternicode.github.io/bootstrap-datepicker/
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;

	function init() {
		// datepickers settings
		$(document).ready(function(){
			// Check library dependancy exists
			if (!$.fn.datepicker) {
				log('core/datepicker', 'Datepicker library is not available.');
				return;
			}

			// defaults
			$.fn.datepicker.defaults.format = 'dd/mm/yyyy';
			$.fn.datepicker.defaults.autoclose = true;
			$.fn.datepicker.defaults.forceParse = false; // this is false for a usability issue, use validation instead.
			$.fn.datepicker.defaults.weekStart = 1;
			$.fn.datepicker.defaults.todayHightlight = true;
			$.fn.datepicker.defaults.clearBtn = true;

			// when clicking a group input icon, trigger the focus on the input field
			$("[data-provide=datepicker]").each(function(){
				var datepicker = $(this);
				datepicker.siblings(".input-group-addon").on("click", function(){
					datepicker.datepicker("show");
				});
			});
		});

		// Refresh the validation after a date pick.
		// This is for instances where the input was marked as invalid, then a new date was picked - we need to trigger a blur to then trigger the re-validate.
		$(document).on(
			//'changeDate', //Stopped using changeDate because it fires when the picker initialises and the input already has a value (preload etc)
			'hide',
			'[data-provide="datepicker"]',
			function(e) {
				//log('datepicker.change', e);
				if (!e.target) return;
				if ($(e.target).is(':focus')) return; //Don't blur if field has focus e.g. user is typing in the date
				$(e.target).blur();
			}
		);
	}



	meerkat.modules.register('datepicker', {
		init: init
	});

})(jQuery);
