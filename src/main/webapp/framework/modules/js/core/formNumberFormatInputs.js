;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {},
	moduleEvents = events;

	function init(){

		jQuery(document).ready(function($) {
			if($.hasOwnProperty("number") && _.isFunction($.number)) {
				$('input.liveFormatNumber').each(function(){
					var $that = $(this);
					var decimals = 0;
					if($that.hasClass('formattedInteger') || $that.hasClass('unFormattedInteger')) {
						decimals = 0;
					} else if($that.hasClass('formattedDecimal') || $that.hasClass('unFormattedDecimal')) {
						$($that.attr('class').split(' ')).each(function() {
							if (this.indexOf('decimalPlaces_') === 0) {
								decimals = Number(this.split('_')[1]);
							}
						});
					}
					if($that.hasClass('unFormattedDecimal') || $that.hasClass('unFormattedInteger')) {
						$that.number(true, decimals, ".", "");
					} else {
						$that.number(true, decimals);
					}
				});
			}
		});
	}

	meerkat.modules.register("formNumberFormatInputs", {
		init: init,
		events: events
	});

})(jQuery);