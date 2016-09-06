/*

Handling of the rebate tiers based off situation

*/
;(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var init =  function(){
		if(!_.isUndefined(meerkat.site.competitionActive) && meerkat.site.competitionActive) {
			$(document).ready(function () {
				$('.journeyEngineSlide.contactSlide .slideAction .btn-next').hide();
			});
			meerkat.messaging.subscribe(meerkatEvents.journeyEngine.BEFORE_STEP_CHANGED, function (step) {
				if (step.navigationId === "contact") {
					var familyType = $('#health_situation_healthCvr').val();
					familyType = familyType === 'SM' || familyType === 'SF' ? "S" : familyType;
					$('#worryFreePromoContainer .custom-copy').hide();
					$('#worryFreePromoContainer .custom-copy.' + familyType).show();
					// Restore require attributes of ALL input fields on page
					$('#health_contactDetails_name').attr("required","true");
					$('#health_contactDetails_flexiContactNumberinput').attr("required","true");
					$('#health_contactDetails_email').attr("required","true");
					if($('#worryFreePromoContainer .no-thanks a')) {
						// Event to skip the competition
						$('#worryFreePromoContainer .no-thanks a').off().on('click',function(){
							// Strip require attributes from ALL input fields on page
							$('#health_contactDetails_name').removeAttr("required");
							$('#health_contactDetails_flexiContactNumberinput').removeAttr("required");
							$('#health_contactDetails_email').removeAttr("required");
							// Optout user from competition
							if($('#health_contactDetails_competition_optin').prop('checked')) {
								$('#health_contactDetails_competition_optin').prop('checked', null).change();
							}
							// Make journeyEngine goto next page
							$('#worryFreePromoContainer .competition-details .btn-next:first').trigger("click");
						});
					}
				}
			});
		}
	};

	meerkat.modules.register("healthCompetition1608WorryFree", {
		init: init
	});

})(jQuery);