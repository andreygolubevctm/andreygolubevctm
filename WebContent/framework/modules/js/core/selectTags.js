/**
 * Select tags selection module
 * 
 * Takes a list of values and adds them to a select element.
 * On selecting a value, the value of the chosen element is added
 * to a tag list and hidden input.
 *
 * If you need something similar but without countries, create a verticalSelectTags file and pass in a language object.
 */

;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;
	
	var $selectObj = $('.select-tags'),
		selectedTagsListClass = '.selected-tags';
	
	var fadeSpeed = 'slow',
		optionSelectedIcon = '[selected] ';

	function init() {
		$selectObj.each(function initializeSelectTagsObj() {
			var $this = $(this),
				variableName = $this.data('varname');
				list = window[variableName];

			if(typeof list !== 'undefined' && typeof list.countries !== 'undefined' && _.isArray(list.countries) && list.countries.length) {
				// Country selection
				
				$this.append(
						$('<option>')
							.attr('readonly', 'readonly')
							.text('Please choose your Destination(s)...')
					);
				
				if(list.topTen !== 'undefined' && list.topTen.length) {
					_addCountryOptionsToOptGroup($this, list.topTen, 'Popular Countries');
				}
				
				_addCountryOptionsToOptGroup($this, list.countries, 'All Countries');
			} else if(typeof list !== 'undefined' && typeof list.options !== 'undefined' && _.isArray(list.options) && list.options.length) {
				// Generic Selection
				
				_addOptionsToList($this, list.options);
			}
			
			$this.on('change', function onSelectTagCallback() {
				_onOptionSelect(this);
			});
		});
	}

	// This is currently used specific for the purposes of the country select tag on Travel.
	// If you want to implement optgroups in a similar way, please create a more generic 
	// method to do so.
	function _addCountryOptionsToOptGroup($element, options, optGroup) {
		$element.append(
			$('<optgroup>').attr('label', optGroup)
		);

		var optionsHTML = "";

		for(var i = 0; i < options.length; i++) {
			var country = options[i];
			optionsHTML += '<option value="' + country.isoCode + '">' + country.countryName + '</option>';
		}

		$element
			.find('optgroup[label="' + optGroup + '"]')
			.append(optionsHTML);
	}
	
	function _addOptionsToList($element, options) {
		var optionsHTML = "";
		
		for(var i = 0; i < options.length; i++) {
			var option = options[i];
			optionsHTML += '<option value="' + option.value + '">' + option.text + '</option>';
		}
		
		$element.append(optionsHTML);
	}
	
	function _onOptionSelect(selectElement) {
		var $select = $(selectElement),
			$selected = $select.find('option:selected'),
			value = $select.val(),
			$list = $select.parents('.row').next(selectedTagsListClass + '-row').find(selectedTagsListClass),
			selectedText = $selected.text(),
			selectedTextHTML = selectedText;
		
		if(selectedTextHTML.length > 25) {
			selectedTextHTML = selectedTextHTML.substr(0, 20) + '...';
		}
		
		selectedTextHTML = '<span>' + selectedTextHTML + '</span>';

		var isAlreadySelected = $list.find('li span').filter(function(){
			return optionSelectedIcon + $(this).text() === selectedText; 
		}).length;
		
		if($selected.not('[readonly]').length && !isAlreadySelected) {
			$select[0].selectedIndex = 0;
			
			// Find options by value because we may have multiple opt-groups which cause the same value
			// to be used multiple times
			$select.find('option[value="' + value + '"]').text(optionSelectedIcon + selectedText).attr('disabled', 'disabled');
			
			setTimeout(function delayTagAppearance(){ 
				$list.append(
					$('<li>')
						.html(selectedTextHTML)
						.data('value', value)
						.data('fulltext', selectedText)
						.addClass('selected-tag')
						.hide()
						.append(
							$('<button>')
								.html('&times;')
								.attr('type', 'button')
								.addClass('btn')
								.on('click', function onClickRemoveTagCallback() {
									_onRemoveListItem(this);
								})
								.hover(function onSelectTagHoverIn() {
									$(this).parents('li').addClass('hover');
								}, function onSelectTagHoverOut() {
									$(this).parents('li').removeClass('hover');
								})
						) 
						.fadeIn(fadeSpeed, function() {
							_updateHiddenInputs();
						})
				);
			}, 75);
		}
	}
	
	function _onRemoveListItem(listItem) {
		var $this = $(listItem),
			$select = $this.closest('.row').prev('.select-tags-row').find('select'),
			$listItem = $this.closest('li'),
			value = $listItem.data('value'),
			text = $listItem.data('fulltext');

		$select
			.find('option[value="' + value + '"]')
			.text(text)
			.removeAttr('disabled');
	
		$listItem.fadeOut(fadeSpeed, function removeTagFadeOutCallback () {
			$(this).remove();
			_updateHiddenInputs();
		});
	}
	
	function _updateHiddenInputs() {
		$selectObj.each(function updateHiddenInputsCallback() {
			var $this = $(this),
				$parent = $this.closest('.row'),
				$list = $parent.next(selectedTagsListClass + '-row').find(selectedTagsListClass),
				$hiddenField = $parent.find('.validate'),
				selectedTags = [];

			$list.find('li').each(function () {
				selectedTags.push($(this).data('value'));
			});
			
			$hiddenField.val(selectedTags.join(','));
		});
	}

	meerkat.modules.register('selectTags', {
		init: init
	});

})(jQuery);