;(function($){

	// TODO: write unit test once DEVOPS-31 goes live

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		currentSituation = null,
		$aboutYouContainer,
		$primaryCurrentCover,
		$primaryContinuousCoverContainer,
		$partnerContainer,
		$partnerCurrentCover,
		$partnerContinuousCoverContainer,
		$partnerDOB,
		$healthCoverDependants,
		$healthCoverRebate,
		$rebateDialogue,
		$healthSituationHealthCvr,
		$healthCoverIncome,
		$healthCoverIncomeLabel,
		$partnerHealthCoverHealthCoverLoading,
		$tierDropdowns,
		$primaryDOB,
		$rebateLegend,
		$healthCoverDetailsDependants,
		$healthCoverIncomeMessage,
		$partnersDetails,
		$lhcContainers,
		$medicare,
		$healthSituation,
		$lookingTo;

	var moduleEvents = {
			healthSituation: {
				CHANGED: 'HEALTH_SITUATION_CHANGED'
			}
	};

	function init(){
		$(document).ready(function () {
			initFields();

			meerkat.modules.healthTiers.initHealthTiers();
			meerkat.modules.healthTiers.setTiers(true);

			eventSubscriptions();
			toggleMlsMessage();

			if(meerkat.site.isNewQuote === false) {
				checkSituation();
			}
		});
	}

	function initFields() {
		$aboutYouContainer = $('#startForm'),
			$healthCoverDetailsDependants = $('.health_cover_details_dependants'),
			$healthCoverIncomeMessage = $('#health_healthCover_incomeMessage'),
			$primaryCurrentCover = $aboutYouContainer.find('#health_healthCover_health_cover'),
			$primaryContinuousCoverContainer = $aboutYouContainer.find('#health-continuous-cover-primary'),
			$partnerContainer = $aboutYouContainer.find('#partner-health-cover'),
			$partnerCurrentCover = $aboutYouContainer.find('#health_healthCover_partner_health_cover'),
			$partnerContinuousCoverContainer = $aboutYouContainer.find('#health-continuous-cover-partner'),
			$partnerHealthCoverHealthCoverLoading = $aboutYouContainer.find('input[name=health_healthCover_partner_healthCoverLoading]'),
			$partnerDOB = $aboutYouContainer.find('#health_healthCover_partner_dob'),
			$healthCoverDependants = $aboutYouContainer.find('#health_healthCover_dependants'),
			$healthCoverRebate = $aboutYouContainer.find('.health_cover_details_rebate'),
			$rebateDialogue = $aboutYouContainer.find('.simples-dialogue-37'),
			$healthSituationHealthCvr = $aboutYouContainer.find('#health_situation_healthCvr'),
			$healthCoverIncome = $aboutYouContainer.find('#health_healthCover_income'),
			$healthCoverIncomeLabel = $aboutYouContainer.find('#health_healthCover_incomelabel'),
			$tierDropdowns = $aboutYouContainer.find('#health_situation_healthCvr, #health_healthCover_dependants'),
			$primaryDOB = $aboutYouContainer.find('#health_healthCover_primary_dob'),
			$rebateLegend = $aboutYouContainer.find('#health_healthCover_tier_row_legend'),
			$partnersDetails = $('#partnerFund, #partnerMemberID, #partnerContainer'),
			$lhcContainers = $('#primary-health-cover, #partner-health-cover, #australian-government-rebate'),
			$medicare = $('.health-medicare_details'),
			$healthSituation = $aboutYouContainer.find('input[name="health_situation_healthSitu"]');

			if(meerkat.site.isCallCentreUser) {
				$lookingTo = $('#health_situation_healthSitu');
			} else {
				$lookingTo = $('[name=health_situation_healthSitu][type=radio]');
			}

		if (!meerkat.modules.healthChoices.hasSpouse()) {
			$partnerContainer.hide();
		}

		setupForm(true);
	}

	function eventSubscriptions() {
		$tierDropdowns.on('change', function updateRebateTiers(){
			meerkat.modules.healthTiers.setTiers();
		});

		$healthCoverDependants.on('change', function setRebateTiers(){
			meerkat.modules.healthTiers.setTiers();

			if ($(this)[0].selectedIndex > 1) {
				$healthCoverIncomeMessage.show();
			} else {
				$healthCoverIncomeMessage.hide();
			}
		});

		$healthSituationHealthCvr.on('change', function toggleAboutYouFields() {
			setupForm();
			checkSituation();
		});

		$lhcContainers.find(':input').on('change', function updateRebateContinuousCover(event) {

			var $this = $(this);

			// Don't action on the DOB input fields; wait until it's serialised to the hidden field.
			if ($this.hasClass('dateinput-day') || $this.hasClass('dateinput-month') || $this.hasClass('dateinput-year') || ($this.attr('name').indexOf('primary_dob') >= 0 && $this.val() === "") || ($this.attr('name').indexOf('partner_dob') >= 0 && $this.val() === "")) return;

			togglePrimaryContinuousCover();
			togglePartnerContinuousCover();

			// update rebate
			if ($this.valid()) {
				setRebate();
			}
		});

		$healthSituation.add($healthCoverIncome).on('change', toggleMlsMessage);

		if(meerkat.site.isCallCentreUser === false) {
			$lookingTo.on('change',checkSituation);
		}
	}

	/**
	 * Triggered whenever the family type or looking to values are changed. If the
	 * situation is different and event is fired.
	 */
	function checkSituation() {
		var familyType = $healthSituationHealthCvr.val();
		var lookingTo = '';
		if(meerkat.site.isCallCentreUser) {
			lookingTo = $lookingTo.val();
		} else {
			if($lookingTo.is(':checked')) {
				lookingTo = $lookingTo.filter(':checked').val();
			}
		}
		if(!_.isEmpty(familyType) && !_.isEmpty(lookingTo)) {
			var situation = {
				familyType : familyType,
				lookingTo : lookingTo
			};
			if(!_.isMatch(currentSituation,situation)) {
				currentSituation = _.extend({},situation);
				meerkat.messaging.publish(moduleEvents.healthSituation.CHANGED, currentSituation);
			}
		}
	}

	function togglePrimaryContinuousCover(isInitMode) {
		if ($primaryCurrentCover.find('input').filter(':checked').val() === 'Y' && meerkat.modules.age.isAgeLhcApplicable($primaryDOB.val())) {
			$primaryContinuousCoverContainer.slideDown();
		} else {
			isInitMode === true ? $primaryContinuousCoverContainer.hide() : $primaryContinuousCoverContainer.find('input[name=health_healthCover_primary_healthCoverLoading]:checked').prop('checked', false).parent().removeClass('active').end().end().slideUp();
		}
	}

	function togglePartnerContinuousCover(isInitMode) {
		if ($partnerCurrentCover.find('input').filter(':checked').val() === 'Y' && meerkat.modules.age.isAgeLhcApplicable($partnerDOB.val())) {
			$partnerContinuousCoverContainer.slideDown();
		} else {
			isInitMode === true ? $partnerContinuousCoverContainer.hide() : $partnerContinuousCoverContainer.find('input[name=health_healthCover_partner_healthCoverLoading]:checked').prop('checked', false).parent().removeClass('active').end().end().slideUp();
		}
	}

	function setupForm(isInitMode) {
		switch($healthSituationHealthCvr.val())
		{
			case 'F':
				$partnerContainer.slideDown();
				$healthCoverIncomeMessage.show();

				if($('#health_healthCover_health_cover_rebate').find('input:checked').val() !== 'N'){
					$healthCoverDetailsDependants.slideDown();
				}
				$partnerContainer.slideDown();
				$partnersDetails.show();
				break;
            case 'SPF':
				$partnerContainer.slideUp();

				if($('#health_healthCover_health_cover_rebate').find('input:checked').val() !== 'N'){
					$healthCoverDetailsDependants.slideDown();
				}
				$partnersDetails.hide();
				break;
			case 'C':
				$healthCoverDetailsDependants.slideUp();
				$partnerContainer.slideDown();
				$partnersDetails.show();
				break;
			default:
				isInitMode === true ? $partnerContainer.hide() : $partnerContainer.slideUp();
				isInitMode === true ? $healthCoverDetailsDependants.hide() : $healthCoverDetailsDependants.slideUp();
				resetPartnerDetails();
				$healthCoverIncomeMessage.hide();
				$partnersDetails.hide();
				break;
		}

		togglePrimaryContinuousCover();
		togglePartnerContinuousCover();
	}

	function setRebate(){
		meerkat.modules.health.loadRatesBeforeResultsPage(true, function (rates) {
			if (!isNaN(rates.rebate) && parseFloat(rates.rebate) > 0) {
				$rebateLegend.html('You are eligible for a ' + rates.rebate + '% rebate.');
				$healthCoverRebate.slideDown();
			} else {
				$rebateLegend.html('');
			}
		});
	}

	function resetPartnerDetails() {
		$partnerDOB.val('').change();
		$partnerCurrentCover.find(':checked').prop('checked', false);
		resetRadio($partnerCurrentCover);
		$partnerContinuousCoverContainer.find(':checked').prop('checked', false);
		resetRadio($partnerContinuousCoverContainer);
	}

	function toggleRebateDialogue() {

		var isCallCentre = meerkat.site.isCallCentreUser;
		var isWebChat = false;
		if (isCallCentre) {
			var callType = $(':input[name="health_simples_contactTypeRadio"] option').is(':selected') ? $(':input[name="health_simples_contactTypeRadio"]').val() : null;
			isWebChat = !_.isEmpty(callType) && callType === 'webchat';
		}

		// apply rebate
		if ($healthCoverRebate.find('input:checked"]').val() === 'Y') {
			if (!isWebChat) {
                $rebateDialogue.removeClass('hidden');
            } else {
				$rebateDialogue.addClass('hidden');
			}
		}
		// no rebate
		else {
			$rebateDialogue.addClass('hidden');
		}
	}

	function getPartnerCurrentCover() {
		return $partnerCurrentCover.find(':checked').val();
	}

	function getPrimaryCurrentCover() {
		return $primaryCurrentCover.find(':checked').val();
	}

	function toggleMlsMessage () {
		$('#health_healthCover_tier_row_legend_mls').toggleClass('hidden', ['CHC', 'ATP'].indexOf($healthSituation.filter(':checked').val()) < 0 || $healthCoverIncome.val() !== '0');
	}

	function getSituation() {
		return $('#health_situation_healthCvr').val();
	}

	meerkat.modules.register('healthAboutYou', {
		init: init,
		events: moduleEvents,
		getPartnerCurrentCover : getPartnerCurrentCover,
		getPrimaryCurrentCover : getPrimaryCurrentCover,
		getSituation : getSituation
	});

})(jQuery);