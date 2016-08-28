;(function($){

	var meerkat = window.meerkat,
		$primaryCurrentCover,
		$partnerCurrentCover;

	function init(){
		$(document).ready(function () {
			initFields();
		});
	}

	function initFields() {
		var $aboutYouContainer = $('.health-cover_details');
		$primaryCurrentCover =  $aboutYouContainer.find('#health_healthCover_health_cover'),
		$partnerCurrentCover =  $aboutYouContainer.find('#health_healthCover_partner_health_cover');
	}

	function getPartnerCurrentCover() {
		return $partnerCurrentCover.find(':checked').val();
	}

	function getPrimaryCurrentCover() {
		return $primaryCurrentCover.find(':checked').val();
	}

	meerkat.modules.register('healthAboutYou', {
		init: init,
		getPartnerCurrentCover : getPartnerCurrentCover,
		getPrimaryCurrentCover : getPrimaryCurrentCover
	});

})(jQuery);
