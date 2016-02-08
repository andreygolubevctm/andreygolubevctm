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
		$partnerHealthCoverHealthCoverLoading;

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
		$healthCoverIncomeLabel = $aboutYouContainer.find('#health_healthCover_incomelabel');

		if (!healthChoices.hasSpouse()) {
			$partnerContainer.hide();
		}

		$primaryContinuousCoverContainer.hide();
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

		$primaryCurrentCover.find('input').on('click', function toggleYourContinuousCover() {
			if ($(this).filter(':checked').val() === 'Y') {
				$primaryContinuousCoverContainer.slideDown();
			} else {
				$primaryContinuousCoverContainer.find('label:nth-child(2)').trigger('click').end().slideUp();
			}
		});

		$partnerCurrentCover.find('input').on('click', function togglePartnersContinuousCover() {
			if ($(this).filter(':checked').val() === 'Y') {
				$partnerHealthCoverHealthCoverLoading.slideDown();
			} else {
				$partnerHealthCoverHealthCoverLoading.find('label:nth-child(2)').trigger('click').end().slideUp();
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
	}

	function resetPartnerDetails() {
		$partnerDOB.val('').change();
		$partnerCurrentCover.find(':checked').prop('checked', false);
		resetRadio($partnerCurrentCover);
		$partnerContinuousCoverContainer.find(':checked').prop('checked', false);
		resetRadio($partnerContinuousCoverContainer);
	}

	function resetRebateForm() {
		$healthCoverDependants.find('option:selected').prop("selected", false).end().find('option').first().prop("selected", true);
		$healthCoverIncome.find('option:selected').prop("selected", false).end().find('option').first().prop("selected", true);
		$healthCoverIncomeLabel.val('');
		$healthCoverRebate.find(':checked').prop('checked', false);
		resetRadio($healthCoverRebate);
		$healthCoverRebate.hide();
		$healthCoverlhcGroup.show();
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
