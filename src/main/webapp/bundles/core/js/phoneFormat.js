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

	var lastInputtedKey;

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
		/* Lets format the field each time a key is entered, but don't valide on it until it blurs */
		element.onkeyup = function(evt) {
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
				if(!$('html').hasClass('lt-ie10')) {
					var index = this.selectionStart;
					var key = String.fromCharCode(evt.keyCode);

					// Just gonna get that caret position... Mmm, mmm, mmm...
					lastInputtedKey = {
						index: index,
						key: key,
						// Find out how many times this character has appeared leading up to this fateful moment
						numberOfRepeats: $(element).val().substring(0, index).split(key).length - 1
					};
				}

				formatPhoneNumber (element);

				if(!$('html').hasClass('lt-ie10')) {
					var elementVal = $(element).val();
					var caretPosition = 0;

					// If a phone numbery type character
					if(lastInputtedKey.key.match(/[\s()+0-9]/)) {
						var repeatCount = 0;
						var substring = '';
						// Get the substring up to the last occurrence of that key
						for (var i = 0; i < elementVal.length; i++) {
							var char = elementVal[i];

							if (char === lastInputtedKey.key) {
								repeatCount++;

								if (repeatCount === lastInputtedKey.numberOfRepeats) {
									substring = elementVal.substring(0, i + 1);
									break;
								}
							}
						}

						caretPosition = substring.length;
					} else {
						// Otherwise just set it to wherever they were
						caretPosition = lastInputtedKey.index - 1;
					}

					element.focus();
					element.setSelectionRange(caretPosition, caretPosition);
				}
			}
		};
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
			case stringStartsWith(number, "04"): // Mobile eg 0412 345 678
				number = number.replace(/(\d{7})/, '$1 ').replace(/(\d{4})/, '$1 ');
				break;
			case stringStartsWith(number, "+614"): // Mobile eg +61412 345 678
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
		return number.replace('+61', '0').replace(/^61/, '0').replace(/ /g,'').replace('(', '').replace(')', '');
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
		cleanNumber: cleanNumber
	});
})(jQuery);