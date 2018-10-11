;(function($){

	// TODO: write unit test once DEVOPS-31 goes live

	var meerkat = window.meerkat,
		$primaryCurrentCover,
		$primaryContinuousCoverContainer,
		$partnerContainer,
		$partnerCurrentCover,
		$partnerContinuousCoverContainer,
		$partnerDOB,
		$healthCoverDependants,
		$healthCoverRebate,
		$healthSituationHealthCvr,
		$heathClaimHealthCoverRebate,
		$dontClaimHealthRebate,
		$incomeBase,
		$healthCoverIncome,
        $healthCoverIncomeFieldLabel,
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
		$healthSituation;

	function init(){
		$(document).ready(function () {
			initFields();

			meerkat.modules.healthTiers.initHealthTiers();
            meerkat.modules.healthCoverDetails.setIncomeBase(true);
			meerkat.modules.healthTiers.setTiers(true);

			eventSubscriptions();
			toggleMlsMessage();
		});
	}

	function initFields() {
		$healthCoverDetailsDependants = $('.health_cover_details_dependants'),
		$healthCoverIncomeMessage = $('#health_healthCover_incomeMessage'),
		$primaryCurrentCover = $('#health_healthCover_health_cover'),
		$primaryContinuousCoverContainer = $('#health-continuous-cover-primary'),
		$partnerContainer = $('#partner-health-cover'),
		$partnerCurrentCover = $('#health_healthCover_partner_health_cover'),
		$partnerContinuousCoverContainer = $('#health-continuous-cover-partner'),
		$partnerHealthCoverHealthCoverLoading = $('input[name=health_healthCover_partner_healthCoverLoading]'),
		$partnerDOB = $('#health_healthCover_partner_dob'),
		$healthCoverDependants = $('#health_healthCover_dependants'),
		$healthCoverRebate = $('.health_cover_details_rebate'),
		$heathClaimHealthCoverRebate = $('#health_healthCover_health_cover_rebate'),
		$dontClaimHealthRebate = $('#health_healthCover_health_cover_rebate_dontApplyRebate'),
		$healthSituationHealthCvr = $('#health_situation_healthCvr'),
		$healthCoverIncome = $('#health_healthCover_income'),
		$healthCoverIncomeFieldLabel = $("label[for='health_healthCover_income']"),
		$healthCoverIncomeLabel = $('#health_healthCover_incomelabel'),
		$incomeBase = $('#health_healthCover_incomeBase'),
		$tierDropdowns = $('#health_situation_healthCvr, #health_healthCover_dependants'),
		$primaryDOB = $('#health_healthCover_primary_dob'),
		$rebateLegend = $('#health_healthCover_tier_row_legend'),
		$partnersDetails = $('#partnerFund, #partnerMemberID, #partnerContainer'),
		$lhcContainers = $('#health-contact-fieldset, #partner-health-cover, #australian-government-rebate'),
		$medicare = $('.health-medicare_details'),
		$healthSituation = $('input[name="health_situation_healthSitu"]');


		if (!meerkat.modules.healthChoices.hasSpouse()) {
			$partnerContainer.hide();
		}

		setupForm(true);
	}

	function eventSubscriptions() {

		$dontClaimHealthRebate.on('change', function dontClaimHealthRebateUpdated(){
			updateClaimHealthRebate();
		});

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
			updateDynamicIncomeFieldText();
		});

		$healthSituationHealthCvr.on('change', function toggleAboutYouFields() {
			setupForm();
		});

		$lhcContainers.find(':input').on('change', function updateRebateContinuousCover(event) {

			var $this = $(this);

			// Don't action on the DOB input fields; wait until it's serialised to the hidden field.
			if ($this.hasClass('dateinput-day') || $this.hasClass('dateinput-month') || $this.hasClass('dateinput-year') || ($this.attr('name').indexOf('primary_dob') >= 0 && $this.val() === "") || ($this.attr('name').indexOf('partner_dob') >= 0 && $this.val() === "")) return;

			// Don't action on situation cover and international student field, remove line below when we provide OVC cover
			if (_.indexOf(['health_situation_cover', 'health_situation_internationalstudent'], $this.attr('name')) > -1) return;

			togglePrimaryContinuousCover();
			togglePartnerContinuousCover();

			// update rebate
			if ($this.valid()) {
				setRebate();
			}
		});

		$healthSituation.add($healthCoverIncome).on('change', toggleMlsMessage);

        if(meerkat.site.isCallCentreUser === true){
            $incomeBase.find('input').on('change', function(){
                $healthCoverIncome.prop('selectedIndex',0);
                meerkat.modules.healthTiers.setTiers();

                updateDynamicIncomeFieldText();
            });
        }
	}

	function updateDynamicIncomeFieldText() {

		var rebateIncomeBracket = $healthCoverIncome.find('option#health_healthCover_income_0').text().replace(/\s(.*)/g,'');

		var rebateIncomeBracketQuestionStartText = 'This is based on your taxable income, so can i confirm do you earn above or below ';

		switch($healthSituationHealthCvr.val()) {
			case 'C':
				$healthCoverIncomeFieldLabel.text(rebateIncomeBracketQuestionStartText + rebateIncomeBracket + ' a year as a household?');
				break;
			case 'F':
			case 'EF':
			case 'SPF':
			case 'ESP':
				$healthCoverIncomeFieldLabel.text('And do you earn above or below ' + rebateIncomeBracket + ' a year as a household?');
				break;
			default:
				var rebateIncomeBracketQuestionEndText = ($incomeBase.is(':visible') && $incomeBase.find('#health_healthCover_incomeBasedOn_H:checked').length > 0) ? " a year as a household?" : " a year?";
				$healthCoverIncomeFieldLabel.text(rebateIncomeBracketQuestionStartText + rebateIncomeBracket + rebateIncomeBracketQuestionEndText);
				break;
		}
	}

	function updateClaimHealthRebate(){
        if(!$dontClaimHealthRebate.is(':checked')){
			$heathClaimHealthCoverRebate.find("input[value='Y']").prop('checked',true).trigger('change');
		} else {
			$heathClaimHealthCoverRebate.find("input[value='N']").prop('checked', true).trigger('change');
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

		updateClaimHealthRebate();

		switch($healthSituationHealthCvr.val())
		{
			case 'F':
            case 'EF':
				$partnerContainer.slideDown();
				$healthCoverIncomeMessage.show();

				if($heathClaimHealthCoverRebate.find('input:checked').val() !== 'N'){
					$healthCoverDetailsDependants.slideDown();
				}
				$partnerContainer.slideDown();
				$partnersDetails.show();
				break;
			case 'SPF':
            case 'ESP':
				$partnerContainer.slideUp();

				if($heathClaimHealthCoverRebate.find('input:checked').val() !== 'N'){
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

		if(meerkat.site.isCallCentreUser === true){
			updateDynamicIncomeFieldText();
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

	function getPartnerCurrentCover() {
		return $partnerCurrentCover.find(':checked').val();
	}

	function getPrimaryCurrentCover() {
		return $primaryCurrentCover.find(':checked').val();
	}

	function toggleMlsMessage () {
		$('#health_healthCover_tier_row_legend_mls').toggleClass('hidden', ['CHC', 'ATP'].indexOf($healthSituation.val()) < 0 || $healthCoverIncome.val() !== '0');
	}

	meerkat.modules.register('healthAboutYou', {
		init: init,
		getPartnerCurrentCover : getPartnerCurrentCover,
		getPrimaryCurrentCover : getPrimaryCurrentCover
	});

})(jQuery);