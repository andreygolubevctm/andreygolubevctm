;(function($, undefined){

	var meerkat = window.meerkat;

	function init(){
		$(document).ready(function($) {
			$('.help-icon').prop("tabindex", -1);
		});
	}

	meerkat.modules.register("helpIcons", {
		init: init,
		events: events
	});
})(jQuery);