//
// Health Tax Time Module
//
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var $healthSituation = '',
		$extrasCoverOptionContainer,
		doFastTrack = true,
		$contactDetailsFieldSet,
		$contactAboutUsTarget,
		$contactDetailsTarget,
		sectionsToSkip = [],
		$tieredHospitalCover,
		$hospitalCoverToggles,
		$govtRebateFieldset,
		taxTimeIsActive = false;

	function init() {

		$(document).ready(function ($) {
			taxTimeIsActive = (meerkat.site.isTaxTime === 'Y' && (meerkat.modules.splitTest.isActive(30) || meerkat.modules.splitTest.isActive(31) ||  meerkat.modules.splitTest.isActive(32)));
			if (!taxTimeIsActive) {
				doFastTrack = false;
				return;
			}

			_setFields();
			_applyEventListeners();
		});
	}

	function _setFields() {
		$healthSituation = $('input[name="health_situation_healthSitu"]');
		$extrasCoverOptionContainer = $('#extrasCoverOptionContainer');

		$contactDetailsFieldSet = $('#health-contact-fieldset');
		$contactAboutUsTarget = $('.health-contact-details-optin-group');
		$contactDetailsTarget = $('div.contactSlide').find('.fieldset-column-side').prev();

		$tieredHospitalCover = $('#health_situation_coverType').closest('fieldset');
		$hospitalCoverToggles = $('.hospitalCoverToggles');

		$govtRebateFieldset = $('#australian-government-rebate');
	}

	function _applyEventListeners() {
		$healthSituation.on('change.FT', function toggleFields() {
			_toggleFastTrackFields($healthSituation.val());
		});

		$extrasCoverOptionContainer.on('change.FT', function setSectionsToSkip(){
			if ($extrasCoverOptionContainer.find('input').filter(':checked').val()=== 'Y') {
				sectionsToSkip = ['contact'];
			} else {
				sectionsToSkip = ['benefits', 'contact'];
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, skipSteps);
	}

	function _toggleFastTrackFields(val) {
		if (val === 'CHC') {
			$contactDetailsFieldSet.slideDown();

			moveContactDetailsToStep1();
			$extrasCoverOptionContainer.slideDown();
		} else {
			sectionsToSkip = [];
			$extrasCoverOptionContainer.slideUp(function deSelectOption(){
				$(this).find('input').filter(':checked').prop('checked', false).end().closest('label.active').removeClass('active');
			});

			moveContactDetailsToStep3();
		}
	}

	// this is to prevent the question from being saved into the db
	function disableNewQuestion(isDisabled) {
		if (typeof $extrasCoverOptionContainer !== 'undefined') {
			$extrasCoverOptionContainer.find('input').prop('disabled', isDisabled);
		}
	}

	function disableFastTrack() {
		resetBenefitsStep();
		moveContactDetailsToStep3();
		updateFastTrack(false);

		// remove the fast track events
		$healthSituation.off('change.FT');
		$extrasCoverOptionContainer.off('change.FT');

		$extrasCoverOptionContainer.hide();

		// reset array
		sectionsToSkip = [];

		// unsubscribe once we've reached results
		meerkat.messaging.unsubscribe(meerkatEvents.journeyEngine.STEP_CHANGED);
	}

	function isFastTrack(){
		return doFastTrack;
	}

	function moveContactDetailsToStep1() {
		if (!taxTimeIsActive) return;
		// to ensure we don't double up
		if ($govtRebateFieldset.next('#health-contact-fieldset').length != 1) {
			$contactDetailsFieldSet.insertBefore($contactAboutUsTarget);
		}
	}

	function moveContactDetailsToStep3() {
		if (!taxTimeIsActive) return;
		// maintains the events via appendTo
		$contactDetailsFieldSet.appendTo($contactDetailsTarget).show();
	}

	function _onlyShowExtras() {
		// hide the tiered hospital cover options and add the data-attach attribute
		$tieredHospitalCover.hide();
		$tieredHospitalCover.find('input').attr('data-attach', 'true');

		// pre-select limited and hide the hospital section
		$hospitalCoverToggles.find('a[data-category="limited"]').click().closest('fieldset').hide();
	}

	function resetBenefitsStep() {
		$tieredHospitalCover.show();
		$hospitalCoverToggles.closest('fieldset').show();
	}

	function skipSteps() {
		// hide anything that is not within the extras section
		if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'benefits') {
			if (isFastTrack() && $healthSituation.filter(':checked').val() === 'CHC') {
				if ($extrasCoverOptionContainer.find('input').filter(':checked').val()=== 'Y') {
					// pre-select hospital only. .trigger('change'); to update active class. a .change()
					$tieredHospitalCover.find('input[value="C"]').prop('checked', true).trigger('change');
				} else {
					// pre-select hospital & extras .trigger('change'); to update active class
					$tieredHospitalCover.find('input[value="H"]').prop('checked', true).trigger('change');
				}

				_onlyShowExtras();
			} else {
				resetBenefitsStep();
			}
		}

		// if there's items to skip and this current navigationId is within the array, skip to the next page
		if (sectionsToSkip.length > 0 && _.indexOf(sectionsToSkip, meerkat.modules.journeyEngine.getCurrentStep().navigationId) > -1) {
			meerkat.modules.journeyEngine.gotoPath('next');
		}
	}

	function updateFastTrack(fastTrack) {
		doFastTrack = fastTrack;
	}

	meerkat.modules.register('healthTaxTime', {
		init : init,
		disableFastTrack : disableFastTrack,
		disableNewQuestion: disableNewQuestion,
		isFastTrack : isFastTrack,
		moveContactDetailsToStep3 : moveContactDetailsToStep3,
		resetBenefitsStep: resetBenefitsStep,
		updateFastTrack : updateFastTrack
	});

})(jQuery);