(function ($, undefined) {
	
	var $elements = {
		add: $('#plus'),
		remove: $('.icon-exit'),
		warning: $('.warning-label-hidden'),
		input: $('.age-item input'),
		container: $('.age-container'),
		numberOfTravellers: $('#num-travellers')
	};
	
	var state = {
		travellers: 1,
		selection: 'S',
		showAddBtn: false,
		addedFields: 0
	};

	var meerkat = window.meerkat,
		max = $elements.numberOfTravellers.data('max');
	
	function _disableBtn() {
		$elements.warning.show();
		$elements.add.addClass('disabled');
	}
	
	function setState(newState, callback) {
		state = _.extend(state, newState);
		if (typeof callback === 'function') callback();
	}
	
	function getTemplate(index, canDelete) {
		return (
			'<div class="age-item"> <span>Age(years)</span><div class="clearfix">' +
			'<input name="travellers-age-'+ index +'"data-msg-required="Please add age" data-msg-range="Please add age" data-rule-range="1,99" required type="text" maxlength="2" />' +
			(canDelete ? '<div class="exit-container"> <a href="javascript:;" class="icon-exit"></a> </div>' : '') + '</div></div>'
		);
	}
	
	function renderCheckboxes() {
		var container = $('.age-container');
		var children = container.children();
		if (children.length > state.travellers) {
			_removeExcess(children.length - state.travellers);
		} else if (children.length < state.travellers) {
			container.append(getTemplate(2));
		}
		if (state.showAddBtn) {
			$('#plus').show();
		} else {
			$('#plus').hide();
		}
		_updateNumber();
	}
	
	function _removeExcess(removeNum) {
		var items = $('.age-container').children();
		for (var i = state.travellers - 1; removeNum > i; i++) {
			items[i].remove();
		}
	}
	
	function _travelPartyChange(e) {
		var travelParty = e.target.value;
		if (travelParty !== state.selection) {
			switch (travelParty) {
				case "S":
						setState({ travellers: 1, showAddBtn: false, selection: travelParty });
					break;
				case "C":
						setState({ travellers: 2, showAddBtn: false, selection: travelParty });
					break;
				case "F":setState({ travellers: 2, showAddBtn: false, selection: travelParty });
					break;
				case "G":
						setState({ travellers: 2, showAddBtn: true, selection: travelParty });
					break;
			}
			renderCheckboxes();
		}
	}

	
	function _enableBtn() {
		$elements.warning.hide();
		$elements.add.removeClass('disabled');
	}
		
	function _updateNumber() {
		$elements.numberOfTravellers.text(state.travellers + state.addedFields);
	}
	
	function _add() {

		var number = state.travellers + state.addedFields;
		if (number < max) {
			$elements.container.append(getTemplate(number + 1, true));
			setState({ addedFields: state.addedFields + 1 }, _updateNumber);
			if (number === max - 1) {
				_disableBtn();
			}
		}
	}
	
	function _remove(e) {
		$(e.target).closest('.age-item').remove();
		setState({ addedFields: state.addedFields - 1 });
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
		$('.travel_party input').on('change', _travelPartyChange);
	}
	
	function init() {
		_eventListeners();
	}

	meerkat.modules.register("travelers", {
		init: init
	});

})(jQuery);