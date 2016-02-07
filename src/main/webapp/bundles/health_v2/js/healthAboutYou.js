;(function($){

	var meerkat = window.meerkat,
		$aboutYouContainer,
		$primaryCurrentCover,
		$primaryContinuousCover,
		$partnerContainer,
		$partnerCurrentCover,
		$partnerContinuousCover,
		$partnerDOB,
		$healthCoverDependants,
		$healthCoverRebate,
		$rebateDialogue,
		$healthSituationHealthCvr,
		$healthCoverIncome,
		$healthCoverIncomeLabel;

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
		$healthHealthCoverIncomeMessage = $('#health_healthCover_incomeMessage'),
		$primaryCurrentCover = $aboutYouContainer.find('#health_healthCover_primaryCover'),
		$primaryContinuousCover = $aboutYouContainer.find('#health-continuous-cover-primary'),
		$partnerContainer = $aboutYouContainer.find('#partner-health-cover'),
		$partnerCurrentCover = $aboutYouContainer.find('#health_healthCover_partnerCover'),
		$partnerContinuousCover = $aboutYouContainer.find('#health-continuous-cover-partner'),
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
				$primaryContinuousCover.slideDown();
			} else {
				$primaryContinuousCover.slideUp();
			}
		});

		$partnerCurrentCover.find('input').on('click', function togglePartnersContinuousCover() {
			if ($(this).filter(':checked').val() === 'Y') {
				$partnerContinuousCover.slideDown();
			} else {
				$partnerContinuousCover.slideUp();
			}
		});

		$healthCoverDependants.on('change', function setRebateTiers(){
			meerkat.modules.healthTiers.setTiers();
		});

		$healthSituationHealthCvr.on('change', function toggleAboutYouFields() {
			switch($(this).val())
			{
				case 'SPF':
				case 'F':
						$partnerContainer.slideDown();
						$healthHealthCoverIncomeMessage.slideDown();
						$healthCoverDetailsDependants.slideDown();
						$partnerContainer.slideDown();
					break;
				default:
						$partnerContainer.slideUp();
						$healthCoverDetailsDependants.slideUp();
						resetPartnerDetails();
						$healthHealthCoverIncomeMessage.hide();
					break;
			}
		});
	}

	function resetPartnerDetails() {
		$partnerDOB.val('').change();
		$partnerCurrentCover.find(':checked').prop('checked', false);
		resetRadio($partnerCurrentCover);
		$partnerContinuousCover.find(':checked').prop('checked', false);
		resetRadio($partnerContinuousCover);
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
