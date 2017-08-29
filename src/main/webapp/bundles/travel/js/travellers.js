(function ($, undefined) {
	
	var $elements = {
		add: $('#plus'),
		remove: $('.icon-exit'),
		warning: $('.warning-label-hidden'),
		input: $('.age-item input'),
		container: $('.age-container'),
		numberOfTravellers: $('#num-travellers'),
		travelParty: $('.travel_party input'),
		travelPartText: $('.traveler-age-label'),
		hiddenInput: $('#travel_travellers_travellersAge'),
	};
	
	var travelText = {
		S: 'The age of the travelling adult?',
		C: 'The age of the travelling adults?',
		F: 'The age of the travelling adults?',
		G: 'The age of all adults travelling and the age of all children travelling in the group?'
	};
	
	var state = {
		travellers: 1,
		selection: 'S',
		showAddBtn: false,
		addedFields: 0,
		minAge: 16,
		maxAge: 99,
		hiddenValues: []
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
	
	function getTemplate(index, canDelete, value) {
		var val = value || '';
		var className = canDelete ? 'col-lg-4' : 'col-lg-3';
		return (
			'<div class="age-item col-md-5 ' + className + '"> <span>Age(years)</span><div class="clearfix">' +
			'<input value="' + val + '" name="travellers-age-'+ index +'" data-msg-required="Please add age" data-msg-range="age must be between ' + state.minAge + '-' + state.maxAge + '" data-rule-range="' + state.minAge + ',' + state.maxAge + '" required type="text" maxlength="2" />' +
			(canDelete ? '<div class="exit-container"> <a href="javascript:;" class="icon-exit"></a> </div>' : '') + '</div></div>'
		);
	}
	
	function _renderCheckboxes() {
		var container = $('.age-container');
		var items = container.children().length;
		if (items > state.travellers) {
			_removeExcess();
		} else if (state.travellers > items) {
			for(var i = items; state.travellers > i; i++) {
				container.append(getTemplate(i + 1));
			}
		}
		_changeValidation();
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
	
	function _changeTravelText(travelParty) {
		$elements.travelPartText.text(travelText[travelParty]);
	}
	
	function _travelPartyChange(e, bypass) {
		var travelParty = bypass || e.target.value;
		if (travelParty !== state.selection) {
			switch (travelParty) {
				case "S":
						setState({ travellers: 1, showAddBtn: false, selection: travelParty, addedFields: 0, minAge: 16 });
					break;
				case "C":
						setState({ travellers: 2, showAddBtn: false, selection: travelParty, addedFields: 0, minAge: 16 });
					break;
				case "F":
						setState({ travellers: 2, showAddBtn: false, selection: travelParty, addedFields: 0, minAge: 16 });
					break;
				case "G":
						setState({ travellers: 3, showAddBtn: true, selection: travelParty, minAge: 0 });
					break;
			}
			_enableBtn();
			_changeTravelText(travelParty);
			_renderCheckboxes();
		}
	}

	function _changeValidation() {
		var inputs = $('.age-container input');
		var ageLabel = state.minAge + '-' + state.maxAge;
		inputs.data('ruleRange', state.minAge + ',' + state.maxAge);
		inputs.data('msgRange', 'Age must be between ' + ageLabel);
	}
	
	function _enableBtn() {
		$elements.warning.hide();
		$elements.add.removeClass('disabled');
	}
		
	function _updateNumber() {
		$elements.numberOfTravellers.text(state.travellers + state.addedFields);
	}
	
	function _add(e, value) {
		var number = state.travellers + state.addedFields;
		if (number < max) {
			$elements.container.append(getTemplate(number + 1, true, value));
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
	
	function mapValuesToInput() {
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
		setState({ hiddenValues: inputVals });
		$elements.hiddenInput.val(inputVals);
	}
	
	function prefillFields() {
		var value = $elements.hiddenInput.val();
		var selected = $('.travel_party input:checked').val();
		if (value != null && value.length > 0 || selected) {
			var arrayValues = value.split(/\s*,\s*/);
			setState({ hiddenValues: arrayValues });
			_travelPartyChange(this, selected);
			insertValues();
		}
	}
	
	function insertValues() {
		values = state.hiddenValues;
		for (var i = 0; values.length > i; i++) {
			var indexFix = i + 1;
			if ($('input[name=travellers-age-'+ indexFix +']').length > 0) {
				$('input[name=travellers-age-'+ indexFix +']').val(values[i]);
			} else {
				_add(null, values[i]);
			}
		}
	}

	function _eventListeners() {
		$elements.add.on('click', _add);
		$(document).on('click', '.icon-exit', _remove);
		$(document).on('change', '.age-item input', _removeValidationError);
		$elements.travelParty.on('change', _travelPartyChange);
	}
	
	function init() {
		_eventListeners();
		prefillFields();
	}

	meerkat.modules.register("travellers", {
		init: init,
		mapValues: mapValuesToInput
	});

})(jQuery);