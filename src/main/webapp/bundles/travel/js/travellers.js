(function ($, undefined) {
	
	var $elements = {
		add: $('#plus'),
		remove: $('.icon-exit'),
		warning: $('.warning-label-hidden'),
		input: $('.age-item input'),
		container: $('.age-container'),
		numberOfTravellers: $('#num-travellers'),
		travelParty: $('.travel_party input')
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
	
	function getTemplate(canDelete) {
		var className = canDelete ? 'col-lg-4' : 'col-lg-3';
		return (
			'<div class="age-item col-md-5 ' + className + '"> <span>Age(years)</span><div class="clearfix">' +
			'<input data-msg-required="Please add age" data-msg-range="Please add age" data-rule-range="1,99" required type="text" maxlength="2" />' +
			(canDelete ? '<div class="exit-container"> <a href="javascript:;" class="icon-exit"></a> </div>' : '') + '</div></div>'
		);
	}
	
	function _renderCheckboxes() {
		var container = $('.age-container');
		var items = container.children().length;
		if (items > state.travellers) {
			_removeExcess();
		} else if (items < state.travellers) {
			container.append(getTemplate());
		}
		_renderAddBtn();
		_updateNumber(state.travellers);
	}
	
	function _renderAddBtn() {
		if (state.showAddBtn) {
			$('#plus').show();
		} else {
			$('#plus').hide();
		}
	}
	
	function _removeExcess() {
		var items = $('.age-container').children();
		var lastItem = items.last();
		lastItem.remove();
		if ($('.age-container').children().length !== state.travellers) {
			_removeExcess();
		}
	}
	
	function _travelPartyChange(e) {
		var travelParty = e.target.value;
		if (travelParty !== state.selection) {
			switch (travelParty) {
				case "S":
						setState({ travellers: 1, showAddBtn: false, selection: travelParty, addedFields: 0 });
					break;
				case "C":
						setState({ travellers: 2, showAddBtn: false, selection: travelParty, addedFields: 0 });
					break;
				case "F":setState({ travellers: 2, showAddBtn: false, selection: travelParty, addedFields: 0 });
					break;
				case "G":
						setState({ travellers: 2, showAddBtn: true, selection: travelParty });
					break;
			}
			_renderCheckboxes();
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
			$elements.container.append(getTemplate(true));
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
	
	function _mapValuesToInput() {
		var inputVals = '';
		$elements.container.find('input').each(function(index) {
			if(this.value !== '') {
				if (index === 0) {
					inputVals = this.value;
				} else {
					inputVals = inputVals + ',' + this.value;
				}
			}
		});
		$('#ages-hidden-input').val(inputVals);
	}

	function _eventListeners() {
		$elements.add.on('click', _add);
		$(document).on('click', '.icon-exit', _remove);
		$(document).on('change', '.age-item input', _removeValidationError);
		$(document).on('blur', '.age-item input', _mapValuesToInput);
		$elements.travelParty.on('change', _travelPartyChange);
	}
	
	function init() {
		_eventListeners();
	}

	meerkat.modules.register("travelers", {
		init: init
	});

})(jQuery);