/**
* Description: Minimal, temporary file to detect affected Safari browsers and add a class to the body to remove -webkit-column-count = 2
* External documentation: http://itsupport.intranet:8080/browse/HLT-1548
*/

;(function($, undefined){

	var initialised = false;

	function initHealthSafariColumnCountFix(){
		if(!initialised) {
			initialised = true;
			if(meerkat.modules.performanceProfiling.isSafariAffectedByColumnCountBug()) {
				$('.benefits-component .benefits-list .children').css('-webkit-column-count', '1');
			}
		}
	}

	meerkat.modules.register("healthSafariColumnCountFix", {
		initHealthSafariColumnCountFix: initHealthSafariColumnCountFix
	});

})(jQuery);