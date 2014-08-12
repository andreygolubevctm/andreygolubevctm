/**
* Description: Minimal, temporary file to detect affected firefox browsers and add a class to the body to remove them.
* External documentation: http://itsupport.intranet:8080/browse/AGG-2055
*/

;(function($, undefined){

	function init(){

		jQuery(document).ready(function($) {
			if(meerkat.modules.performanceProfiling.isFFAffectedByDropdownMenuBug()) {
				$('html').addClass('ff-no-custom-menu');
			}
		});

	}

	meerkat.modules.register("firefoxMenuFix", {
		init: init
	});

})(jQuery);