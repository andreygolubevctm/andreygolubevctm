;(function($){

	var meerkat = window.meerkat,
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
		$rebateLegend;

	function init(){
		$(document).ready(function () {
			initFields();

			meerkat.modules.healthTiers.initHealthTiers();
			meerkat.modules.healthTiers.setTiers(true);

			eventSubscriptions();
		});
	}

	function initFields() {
		$aboutYouContainer = $('#startForm'),
		$healthCoverDetailsDependants = $('.health_cover_details_dependants'),
		$healthCoverIncomeMessage = $('#health_healthCover_incomeMessage'),
		$primaryCurrentCover = $aboutYouContainer.find('#health_situation_health_cover'),
		$primaryContinuousCoverContainer = $aboutYouContainer.find('#health-continuous-cover-primary'),
		$partnerContainer = $aboutYouContainer.find('#partner-health-cover'),
		$partnerCurrentCover = $aboutYouContainer.find('#health_situation_partner_health_cover'),
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
		$rebateLegend = $aboutYouContainer.find('#health_healthCover_tier_row_legend');

		if (!healthChoices.hasSpouse()) {
			$partnerContainer.hide();
		}

		$healthCoverDetailsDependants.hide();
		$primaryContinuousCoverContainer.hide();
		$partnerContinuousCoverContainer.hide();
		$partnerHealthCoverHealthCoverLoading.hide();
	}

	function eventSubscriptions() {
		if(meerkat.site.isCallCentreUser === true){
			// Handle pre-filled
			toggleRebateDialogue();
			// Handle toggle rebate options
			$healthCoverRebate.find('input').on('change', function() {
				toggleRebateDialogue();
			});
		}

		$tierDropdowns.on('change', function(){
			meerkat.modules.healthTiers.setTiers();
		});

		$primaryCurrentCover.find('input').on('click', function toggleYourContinuousCover() {
			if ($(this).filter(':checked').val() === 'Y' && isLessThan31Or31AndBeforeJuly1($primaryDOB.val())) {
				$primaryContinuousCoverContainer.slideDown();
			} else {
				$primaryContinuousCoverContainer.find('label:nth-child(2)').trigger('click').end().slideUp();
			}
		});

		$partnerCurrentCover.find('input').on('click', function togglePartnersContinuousCover() {

			if ($(this).filter(':checked').val() === 'Y' && isLessThan31Or31AndBeforeJuly1($partnerDOB.val())) {
				$partnerContinuousCoverContainer.slideDown();
			} else {
				$partnerContinuousCoverContainer.find('label:nth-child(2)').trigger('click').end().slideUp();
			}
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
			switch($(this).val())
			{
				case 'F':
						$partnerContainer.slideDown();
						$healthCoverIncomeMessage.show();
						$healthCoverDetailsDependants.slideDown();
						$partnerContainer.slideDown();
					break;
				case 'SPF':
						$partnerContainer.slideUp();
						$healthCoverDetailsDependants.slideDown();
					break;
				case 'C':
						$healthCoverDetailsDependants.slideUp();
						$partnerContainer.slideDown();
					break;
				default:
						$partnerContainer.slideUp();
						$healthCoverDetailsDependants.slideUp();
						resetPartnerDetails();
						$healthCoverIncomeMessage.hide();
					break;
			}
		});

		$aboutYouContainer.find(':input').on('change', function(event) {
			// update rebate
			if ($(this).valid()) {
				setRebate();
			}
		});
	}

	function setRebate(){
		meerkat.modules.health.loadRatesBeforeResultsPage(function (rates) {
			if (!isNaN(rates.rebate) && parseFloat(rates.rebate) > 0) {
				$rebateLegend.html('You are eligible for a ' + rates.rebate + '% rebate.');
				$healthCoverRebate.slideDown();
			} else {
				$rebateLegend.html('');
				$healthCoverRebate.find('input[value="N"]').prop('checked', true);
				$healthCoverRebate.slideUp();
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
		// apply rebate
		if ($healthCoverRebate.find('input:checked"]').val() === 'Y') {
			$rebateDialogue.removeClass('hidden');
		}
		// no rebate
		else {
			$rebateDialogue.addClass('hidden');
		}
	}

	meerkat.modules.register('healthAboutYou', {
		init: init
	});

})(jQuery);
