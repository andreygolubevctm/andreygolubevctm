/*

New way of disabling a field
- 30% opacity
- disable the actual field

Have placed this in health just in case it accidentally affects a field in a different vertical if I place this in the shared folder

*/
;(function($, undefined) {

	var meerkat = window.meerkat;

	function disable(field) {
		_toggleFields(field, true);
	}

	function enable(field) {
		_toggleFields(field, false);
	}

	function _toggleFields(field, isDisabled) {
		// .find(':input') is for those instances where there's multiple fields within a fieldrow eg dob, checkboxes etc...
		$(field).closest('.fieldrow').toggleClass('disabled', isDisabled).find(':input').not(':hidden').prop('disabled', isDisabled);
	}

	meerkat.modules.register("fieldAvailability", {
		disable: disable,
		enable: enable
	});

})(jQuery);
