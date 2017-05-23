;(function($){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		$healthAboutYouLegend;
	

	function init(){
		$(document).ready(function () {
            var $healthAboutYou = $('#healthAboutYou');
            $healthAboutYouLegend = $healthAboutYou.find('h3');
            _toggleAboutYouFields();
		});
	}

	function _eventSubscriptions() {
		meerkat.messaging.subscribe(
            meerkatEvents.healthSituation.SITUATION_CHANGED,
            _toggleAboutYouFields
		);
	}

	function _toggleAboutYouFields() {
		if (!meerkat.modules.healthChoices.hasPartner()){
			$healthAboutYouLegend.text('Tell us about yourself, so we can find the right cover for you');
		} else {
			$healthAboutYouLegend.text('We have a few additional questions about you and your partner');
		}
	}


	meerkat.modules.register('healthAboutYou', {
		init: init
	});

})(jQuery);