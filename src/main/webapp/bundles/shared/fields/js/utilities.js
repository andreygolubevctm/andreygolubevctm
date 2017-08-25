/*

New way of disabling a field
- 30% opacity
- disable the actual field

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		toggleType = {
			DISABLED : 'disabled',
			VISIBLE : 'hidden-toggle'
		},
		toggleClasses = {
			PLACEHOLDER_COLOR: 'text-placeholder-color'
		},
		$selectFormControl = $('select.form-control');

	function disable(fields) {
		toggleFields(fields, true, toggleType.DISABLED);
	}

	function enable(fields) {
		toggleFields(fields, false, toggleType.DISABLED);
	}

	function hide(fields) {
		toggleFields(fields, true, toggleType.VISIBLE);
	}

	function show(fields) {
		toggleFields(fields, false, toggleType.VISIBLE);
	}

	function toggleDisabled(fields, state) {
		toggleFields(fields, state, toggleType.DISABLED);
	}

	function toggleVisible(fields, state) {
		toggleFields(fields, state, toggleType.VISIBLE);
	}

	function toggleFields(fields, state, type) {
		var $fields = _.isString(fields) ? $(fields) : fields;
		var applyType = type || toggleType.DISABLED;
		// .find(':input') is for those instances where there's multiple fields within a fieldrow eg dob, checkboxes etc...
		$fields.closest('.fieldrow').toggleClass(applyType, state).find(':input').prop('disabled', state);
	}

	// find all disabled classes initially and disable the fields
	function initFields() {
		$('.fieldrow.disabled, .fieldrow.hidden-toggle').find(':input').prop('disabled', true);
	}

	function selectsOnChange() {
		$selectFormControl
			.on('change.togglePlaceholderColor', function togglePlaceholderColor() {
				_toggleSelectPlaceholderColor($(this));
			});
	}

	function toggleSelectsPlaceholderColor() {
		$selectFormControl
			.each(function() {
				_toggleSelectPlaceholderColor($(this));
			});
	}

	function _toggleSelectPlaceholderColor($select) {
		$select.toggleClass(toggleClasses.PLACEHOLDER_COLOR, _.isEmpty($select.val()));
	}

	meerkat.modules.register("fieldUtilities", {
		initFields: initFields,
		disable: disable,
		enable: enable,
		show: show,
		hide: hide,
		toggleFields: toggleFields,
		toggleDisabled: toggleDisabled,
		toggleVisible: toggleVisible,
		selectsOnChange: selectsOnChange,
		toggleSelectsPlaceholderColor: toggleSelectsPlaceholderColor,
		toggleType: toggleType
	});

})(jQuery);
