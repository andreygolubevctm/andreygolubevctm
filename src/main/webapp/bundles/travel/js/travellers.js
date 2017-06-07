(function ($, undefined) {
	
	var $elements = {
		add: $('#plus'),
		remove: $('.icon-exit'),
		warning: $('.warning-label-hidden'),
		input: $('.age-item input'),
		container: $('.age-container'),
		numberOfTravellers: $('#num-travellers')
	};

	var meerkat = window.meerkat,
		max = $elements.numberOfTravellers.data('max');
	
	function _disableBtn() {
		$elements.warning.show();
		$elements.add.addClass('disabled');
	}
	
	function getTemplate(index) {
		return (
			'<div class="age-item"> <span>Age(years)</span><div class="clearfix">' +
			'<input name="travellers-age-'+ index +'"data-msg-required="Please add age" data-msg-range="Please add age" data-rule-range="1,99" required type="text" maxlength="2" />' +
			'<div class="exit-container"> <a href="javascript:;" class="icon-exit"></a> </div> </div></div>'
		);
	}
	
	function _enableBtn() {
		$elements.warning.hide();
		$elements.add.removeClass('disabled');
	}
		
	function _updateNumber() {
		var number = $('.age-container .age-item').length;
		$elements.numberOfTravellers.text(number);
	}
	
	function _add() {
		var number = $('.age-container .age-item').length;
		if (number < max) {
			$elements.container.append(getTemplate(number + 1));
			_updateNumber();
			if (number === max - 1) {
				_disableBtn();
			}
		}
	}
	
	function _remove(e) {
		$(e.target).closest('.age-item').remove();
		_updateNumber();
		_enableBtn();
	}
	
	function _removeValidationError(e) {
		if (e.target.value.length > 0 && $(e.target).prev().hasClass('error-field')) {
			$(e.target).prev().remove();
		}
	}

	function _eventListeners() {
		$elements.add.on('click', _add);
		$(document).on('click', '.icon-exit', _remove);
		$(document).on('change', '.age-item input', _removeValidationError);
	}
	
	function init() {
		_eventListeners();
	}

	meerkat.modules.register("travelers", {
		init: init
	});

})(jQuery);