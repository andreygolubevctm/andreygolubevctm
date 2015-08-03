;(function($, undefined){

	var meerkat = window.meerkat;

	function initRadioGroup() {

		$(document).on('change', '[data-toggle^=radio] input', function (e) {

			var $btn, $target = $(e.target);

			// TODO check why this code doesn't make the active class clear:
			// $('#radiogroup input').prop('checked', false).change()

			$btn = $target.parent().parent().find('.btn');
			$btn.removeClass('active');

			if ($target.is(':checked')) {
				$btn = $target.parent();
				$btn.addClass('active');
			}

		});

		$(document).on('focusin', '[data-toggle^=radio] input', function (e) {
			var $btn = $(e.target).parent().parent().find('.btn');
			$btn.removeClass('focus');
			$btn = $(e.target).parent();
			$btn.addClass('focus');
		});

		$(document).on('focusout', '[data-toggle^=radio] input', function (e) {
			var $btn = $(e.target).parent().parent().find('.btn');
			$btn.removeClass('focus');
		});

	}

	// Change the label text in a radio group
	//     Argument positionNumber is zero-based
	function changeLabelText($radioGroup, positionNumber, newText) {
		if (typeof $radioGroup === 'undefined' || $radioGroup.length === 0) return;

		var $label = $radioGroup.find('label:eq(' + positionNumber + ')');

		/* This ruins any events on the element
		$label.html( $('<div/>').append( $label.children() ).html() + newText );
		*/

		// Filter the label to find the text node
		$label.contents().filter( function() {
			return this.nodeType === 3;
		}).each(function() {
			var pattern = /[a-z0-9]+/i;

			if (this.textContent) {
				if (pattern.test(this.textContent) === false) return;
				this.textContent = newText;
			}
			// IE
			else if (this.innerText) {
				if (pattern.test(this.innerText) === false) return;
				this.innerText = newText;
			}
		});

		return $label;
	}

	meerkat.modules.register("radioGroup", {
		init: initRadioGroup,
		changeLabelText: changeLabelText
	});

})(jQuery);