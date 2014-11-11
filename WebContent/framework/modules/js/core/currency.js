/**
 * Currency Tag Module.
 * Format the entry field to have a dollar symbol and comma when blurred
 * Sets the entry to a number when focused.
 *
 * Module does not self-init: You need to call initCurrency at the appropriate time e.g. journey step
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	function applyEventListeners($this) {
		var entryName = getEntryName ($this);

		entryName.on("blur", function() {

			// Strip out any non numbers
			entryName.val( $.trim( entryName.val().replace(/[^\d.-]/g, '') ) );

			if(entryName.val() === ""){
				entryName.val("0");
			}

			if(entryName.val() !== '') {
				$this.val( entryName.asNumber() );
			} else {
				$this.val('');
			}

			entryName.formatCurrency({symbol:'$',roundToDecimalPlace:-2});
		});
		entryName.on("focus", function() {
			entryName.toNumber().setCursorPosition(entryName.val().length, entryName.val().length);
			if(entryName.val() == "0"){
				entryName.val("");
			}
		});
	}

	function getEntryName ($this) {
		var entryName = "#"+$this.attr("id")+"entry";
		return $(entryName);
	}

	function initCurrencyField () {
		var $this = $(this);
		var entryName = getEntryName($this);

		applyEventListeners($this);

		if (entryName.val() !== "" && entryName.val() !== "$0" ){
			entryName.trigger("blur");
		}
	}

	function initCurrencyFields(){
		var inputsThatNeedCurrency = $('#journeyEngineSlidesContainer').find('.currency');

		inputsThatNeedCurrency.each(initCurrencyField);
	}

	function formatCurrency(number, options) {
		if (typeof $.fn.formatCurrency === 'function') {
			options = options || {};
			return $("<input value=''/>").val(number).formatCurrency(options).val();
		}
		return '$' + number;
	}

	function initCurrency() {

		// This is needed for IE7/IE8 to position the cursor correctly
		$.fn.setCursorPosition = function(pos) {

			var $el = $(this).get(0);
			if ($el.setSelectionRange) {
				$el.setSelectionRange(pos, pos);
			} else if ($el.createTextRange) {
				var range = $el.createTextRange();
				if(typeof range.collapse === 'function') {
					range.collapse(true).moveEnd('character', pos).moveStart('character', pos).select();
				}
			}
		};

		initCurrencyFields();

		log("[Currency] Initialised"); //purely informational

	}

	meerkat.modules.register('currencyField', {
		initCurrency: initCurrency,//main entrypoint to be called.
		formatCurrency: formatCurrency,
		initSingleCurrencyField: initCurrencyField
	});

})(jQuery);