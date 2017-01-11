/*

New way of disabling a field
- 30% opacity
- disable the actual field

*/
;(function($, undefined) {

	var meerkat = window.meerkat;

	function disable(fields) {
		toggleFields(fields, true);
	}

	function enable(fields) {
		toggleFields(fields, false);
	}

	function toggleFields(fields, isDisabled) {
		var $fields = _.isString(fields) ? $(fields) : fields;
		// .find(':input') is for those instances where there's multiple fields within a fieldrow eg dob, checkboxes etc...
		$fields.closest('.fieldrow').toggleClass('disabled', isDisabled).find(':input').prop('disabled', isDisabled);
	}

	// find all disabled classes initially and disable the fields
	function initDisabledFields() {
		$('.fieldrow.disabled').find(':input').prop('disabled', true);
	}

	meerkat.modules.register("fieldUtilities", {
		initDisabledFields: initDisabledFields,
		disable: disable,
		enable: enable,
		toggleFields: toggleFields
	});

})(jQuery);
