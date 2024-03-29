//  This file is part of the jQuery formatCurrency Plugin version 1.4.0
//
//    The jQuery formatCurrency Plugin is free software: you can redistribute it
//    and/or modify it under the terms of the GNU General Public License as published
//    by the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.

(function($) {

	$.formatCurrency = {};

	$.formatCurrency.regions = [];

	// default Region is en
	$.formatCurrency.regions[''] = {
		symbol: '$',
		positiveFormat: '%s%n',
		negativeFormat: '(%s%n)',
		decimalSymbol: '.',
		digitGroupSymbol: ',',
		groupDigits: true
	};

	$.fn.formatCurrency = function(destination, settings) {

		if (arguments.length == 1 && typeof destination !== "string") {
			settings = destination;
			destination = false;
		}

		// initialize defaults
		var defaults = {
			name: "formatCurrency",
			colorize: false,
			region: '',
			global: true,
			roundToDecimalPlace: 2, // roundToDecimalPlace: -1; for no rounding; 0 to round to the dollar; 1 for one digit cents; 2 for two digit cents; 3 for three digit cents; ...
			eventOnDecimalsEntered: false
		};
		// initialize default region
		defaults = $.extend(defaults, $.formatCurrency.regions['']);
		// override defaults with settings passed in
		settings = $.extend(defaults, settings);

		// check for region setting
		if (settings.region.length > 0) {
			settings = $.extend(settings, getRegionOrCulture(settings.region));
		}
		settings.regex = generateRegex(settings);

		return this.each(function() {
			$this = $(this);

			// get number
			var num = '0';
			num = $this[$this.is('input, select, textarea') ? 'val' : 'html']();

			//identify '(123)' as a negative number
			if (num.search('\\(') >= 0) {
				num = '-' + num;
			}

			if (num === '' || (num === '-' && settings.roundToDecimalPlace === -1)) {
				return;
			}

			// if the number is valid use it, otherwise clean it
			if (isNaN(num)) {
				// clean number
				num = num.replace(settings.regex, '');

				if (num === '' || (num === '-' && settings.roundToDecimalPlace === -1)) {
					return;
				}

				if (settings.decimalSymbol != '.') {
					num = num.replace(settings.decimalSymbol, '.');  // reset to US decimal for arithmetic
				}
				if (isNaN(num)) {
					num = '0';
				}
			}

			// evalutate number input
			var numParts = String(num).split('.');
			var isPositive = (num == Math.abs(num));
			var hasDecimals = (numParts.length > 1);
			var decimals = (hasDecimals ? numParts[1].toString() : '0');
			var originalDecimals = decimals;

			// format number
			num = Math.abs(numParts[0]);
			num = isNaN(num) ? 0 : num;
			if (settings.roundToDecimalPlace >= 0) {
				decimals = parseFloat('1.' + decimals); // prepend "0."; (IE does NOT round 0.50.toFixed(0) up, but (1+0.50).toFixed(0)-1
				decimals = decimals.toFixed(settings.roundToDecimalPlace); // round
				if (decimals.substring(0, 1) == '2') {
					num = Number(num) + 1;
				}
				decimals = decimals.substring(2); // remove "0."
			}
			num = String(num);

			if (settings.groupDigits) {
				for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++) {
					num = num.substring(0, num.length - (4 * i + 3)) + settings.digitGroupSymbol + num.substring(num.length - (4 * i + 3));
				}
			}

			if ((hasDecimals && settings.roundToDecimalPlace == -1) || settings.roundToDecimalPlace > 0) {
				num += settings.decimalSymbol + decimals;
			}

			// format symbol/negative
			var format = isPositive ? settings.positiveFormat : settings.negativeFormat;
			var money = format.replace(/%s/g, settings.symbol);
			money = money.replace(/%n/g, num);

			// setup destination
			var $destination = $([]);
			if (!destination) {
				$destination = $this;
			} else {
				$destination = $(destination);
			}
			// set destination
			$destination[$destination.is('input, select, textarea') ? 'val' : 'html'](money);

			if (
				hasDecimals &&
				settings.eventOnDecimalsEntered &&
				originalDecimals.length > settings.roundToDecimalPlace
			) {
				$destination.trigger('decimalsEntered', originalDecimals);
			}

			// colorize
			if (settings.colorize) {
				$destination.css('color', isPositive ? 'black' : 'red');
			}
		});
	};

	// Remove all non numbers from text
	$.fn.toNumber = function(settings) {
		var defaults = $.extend({
			name: "toNumber",
			region: '',
			global: true
		}, $.formatCurrency.regions['']);

		settings = jQuery.extend(defaults, settings);
		if (settings.region.length > 0) {
			settings = $.extend(settings, getRegionOrCulture(settings.region));
		}
		settings.regex = generateRegex(settings);

		return this.each(function() {
			var method = $(this).is('input, select, textarea') ? 'val' : 'html';
			$(this)[method]($(this)[method]().replace('(', '(-').replace(settings.regex, ''));
		});
	};

	// returns the value from the first element as a number
	$.fn.asNumber = function(settings) {
		var defaults = $.extend({
			name: "asNumber",
			region: '',
			parse: true,
			parseType: 'Float',
			global: true
		}, $.formatCurrency.regions['']);
		settings = jQuery.extend(defaults, settings);
		if (settings.region.length > 0) {
			settings = $.extend(settings, getRegionOrCulture(settings.region));
		}
		settings.regex = generateRegex(settings);
		settings.parseType = validateParseType(settings.parseType);

		var method = $(this).is('input, select, textarea') ? 'val' : 'html';
		var num = $(this)[method]();
		num = num ? num : "";
		num = num.replace('(', '(-');
		num = num.replace(settings.regex, '');
		if (!settings.parse) {
			return num;
		}

		if (num.length === 0) {
			num = '0';
		}

		if (settings.decimalSymbol != '.') {
			num = num.replace(settings.decimalSymbol, '.');  // reset to US decimal for arthmetic
		}

		return window['parse' + settings.parseType](num);
	};

	function getRegionOrCulture(region) {
		var regionInfo = $.formatCurrency.regions[region];
		if (regionInfo) {
			return regionInfo;
		}
		else {
			if (/(\w+)-(\w+)/g.test(region)) {
				var culture = region.replace(/(\w+)-(\w+)/g, "$1");
				return $.formatCurrency.regions[culture];
			}
		}
		// fallback to extend(null) (i.e. nothing)
		return null;
	}

	function validateParseType(parseType) {
		switch (parseType.toLowerCase()) {
			case 'int':
				return 'Int';
			case 'float':
				return 'Float';
			default:
				throw 'invalid parseType';
		}
	}

	function generateRegex(settings) {
		if (settings.symbol === '') {
			return new RegExp("[^\\d" + settings.decimalSymbol + "-]", "g");
		}
		else {
			var symbol = settings.symbol.replace('$', '\\$').replace('.', '\\.');
			return new RegExp(symbol + "|[^\\d" + settings.decimalSymbol + "-]", "g");
		}
	}

})(jQuery);

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
		entryName.on("keyup blur", function() {

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

			entryName.formatCurrency({symbol:'$',roundToDecimalPlace:-2}).change();
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

	}

	meerkat.modules.register('currencyField', {
		initCurrency: initCurrency,//main entrypoint to be called.
		formatCurrency: formatCurrency,
		initSingleCurrencyField: initCurrencyField
	});

})(jQuery);