////////////////////////////////////////////////////////////
//// phoneFormat										////
////----------------------------------------------------////
//// formats the phone fields appropriately				////
////////////////////////////////////////////////////////////

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;
	var log = meerkat.logging.info,
		phoneAllowedCharacters = /[^0-9\(\)+]/g;

	moduleEvents = {};

	/**
	 * Checks the string starts with something
	 * @param number
	 * @returns boolean
	 */
	function stringStartsWith (string, prefix) {
		return string.lastIndexOf(prefix, 0) === 0;
	}

	/**
	 * Start formatting (as typing) and format on blur
	 * @param number
	 * @returns boolean
	 */
	function startFormatNumber (element){
		/* Lets format the field each time a key is entered, but don't validate on it until it blurs */
		$(element).on('blur keyup', function(evt) {
			evt.preventDefault();
			evt.stopPropagation();

			var lastInputtedKey;

			/*
			 8 is the keyCode for the backspace key,
			 16 is shift,
			 35 is end,
			 36 is home,
			 37 is the keyCode for the left arrow,
			 39 is the keyCode for the right arrow,
			 46 is the keyCode for the Del,
			 17 is the ctrl key (don't format when nothing is entered, specifically after ctrl+a is pressed),
			 evt.ctrlKey + 65 = Ctrl+a = Select all
			 Which we don't want to format on */
			var disallowedKeys = [8, 16, 17, 35, 36, 37, 39, 46];
			if (disallowedKeys.indexOf(evt.keyCode) === -1 && !(evt.ctrlKey && evt.keyCode == 65)) {
				var elementVal = $(element).val();
				var useCaretPosition = false;

				if(!$('html').hasClass('lt-ie10')) {
					var index = this.selectionStart;

					useCaretPosition = (index !== elementVal.length);
					if(useCaretPosition) {
						var keyCode = null;
						if (window.event) {
							keyCode = window.event.keyCode;
						} else if (evt) {
							keyCode = evt.which;
						}

						var key = String.fromCharCode((96 <= keyCode && keyCode <= 105) ? keyCode - 48 : keyCode);

						// Just gonna get that caret position... Mmm, mmm, mmm...
						lastInputtedKey = {
							index: index,
							key: key,
							// Find out how many times this character has appeared leading up to this fateful moment
							numberOfRepeats: elementVal.substring(0, index).split(key).length - 1
						};
					}
				}

				elementVal = formatPhoneNumber (element);

				if(!$('html').hasClass('lt-ie10') && useCaretPosition) {
					var caretPosition = elementVal.length;

					// If a phone numbery type character
					if(lastInputtedKey.key.match(/[\s()+0-9]/)) {
						var repeatCount = 0;

						// Get the substring up to the last occurrence of that key
						for (var i = 0; i < elementVal.length; i++) {
							var char = elementVal.charAt(i);

							if (char === lastInputtedKey.key) {
								repeatCount++;

								if (repeatCount === lastInputtedKey.numberOfRepeats) {
									caretPosition = i + 1;
									break;
								}
							}
						}
					} else {
						// Otherwise just set it to wherever they were
						if(lastInputtedKey.index < elementVal.length) {
							lastInputtedKey.index;
						}
					}

					// if element is currently focused
					if ($(element).is(':focus')) {
						element.setSelectionRange(caretPosition, caretPosition);
					}
				}
			}
		});
	}
	/**
	 * Format the phone number so it is in the format 04xx xxx xxx or (0x) xxxx xxxx
	 * @param number
	 * @returns number
	 */
	function formatPhoneNumber (element){

		var number = $(element).val();
		/*Clean up non allowed characters and the allowed spaces and brackets first */
		number = number.replace(phoneAllowedCharacters,'').replace(/([\s\(\)])/g,'');

		switch(true){
			case stringStartsWith(number, "04") || stringStartsWith(number, "05"): // Mobile eg 0412 345 678
				number = number.replace(/(\d{7})/, '$1 ').replace(/(\d{4})/, '$1 ');
				break;
			case stringStartsWith(number, "+614") || stringStartsWith(number, "+615"): // Mobile eg +61412 345 678
				number = number.replace(/(\d{8})/, '$1 ').replace(/(\d{5})/, '$1 ');
				break;
			case stringStartsWith(number, "+61"): // Landline eg (+617) 1234 5678
				number = number.replace(/(\d{7})/, '$1 ').replace(/(\d{3})/, '$1 ').replace(/(\d{0})/, '($1').replace(/(\d{3})/, '$1)');
				break;
			case stringStartsWith(number, "0"): // Landline eg (07) 1234 5678
				number = number.replace(/(\d{6})/, '$1 ').replace(/(\d{2})/, '$1 ').replace(/(\d{0})/, '($1').replace(/(\d{2})/, '$1)');
				break;
		}
		$(element).val(number);

		//We want the hidden field to not be formatted
		var numberClean =  cleanNumber (number);
		var hiddenField = $(element).attr('id').replace('input', '');
		$('#'+hiddenField).val(numberClean);

		return number;
	}

	function cleanNumber (number){
		return number.replace(/\D/g, "").replace(/^\+61/, '0').replace(/^61/, '0').substr(-10);
	}

	function getPhoneType(number) {
		var type = null;
		if(isMobile(number)) {
			type = "mobile";
		} else if (isLandline(number)) {
			type = "landline";
		}
		return type;
	}

	function isMobile(number) {
		return cleanNumber(number).match("^(04|05)");
	}

	function isLandline(number) {
		return cleanNumber(number).match("^0") && !isMobile(number);
	}

	function applyEventListeners() {
		// if not done this way, clicking on the btn-apply will create a popup error on the first click
		$('.flexiphone, .landline, .mobile').each(function() {
			startFormatNumber (this);
		});
	}

	function init()	{

		$(document).ready(function(){
			applyEventListeners();
		});
	}

	meerkat.modules.register('phoneFormat', {
		init: init,
		formatPhoneNumber : formatPhoneNumber,
		events: moduleEvents,
		cleanNumber: cleanNumber,
		isMobile: isMobile,
		isLandline: isLandline,
		getPhoneType: getPhoneType
	});
})(jQuery);