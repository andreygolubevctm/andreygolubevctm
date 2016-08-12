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
		$healthSituationHealthCvr = $('#health_situation_healthCvr'),
		$healthCoverIncome = $('#health_healthCover_income'),
		$healthCoverIncomeLabel = $('#health_healthCover_incomelabel'),
		$tierDropdowns = $('#health_situation_healthCvr, #health_healthCover_dependants'),
		$primaryDOB = $('#health_healthCover_primary_dob'),
		$rebateLegend = $('#health_healthCover_tier_row_legend'),
		$partnersDetails = $('#partnerFund, #partnerMemberID, #partnerContainer'),
		$lhcContainers = $('#health-contact-fieldset, #partner-health-cover, #australian-government-rebate'),
		$medicare = $('.health-medicare_details'),
		$healthSituation = $('input[name="health_situation_healthSitu"]');


		if (!healthChoices.hasSpouse()) {
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

        if(meerkat.site.isCallCentreUser === true){
            $('#health_healthCover_incomeBase').find('input').on('change', function(){
                $healthCoverIncome.prop('selectedIndex',0);
                meerkat.modules.healthTiers.setTiers();
            });
        }
	}

	function togglePrimaryContinuousCover(isInitMode) {
		if ($primaryCurrentCover.find('input').filter(':checked').val() === 'Y' && !isLessThan31Or31AndBeforeJuly1($primaryDOB.val())) {
			$primaryContinuousCoverContainer.slideDown();
		} else {
			isInitMode === true ? $primaryContinuousCoverContainer.hide() : $primaryContinuousCoverContainer.find('input[name=health_healthCover_primary_healthCoverLoading]:checked').prop('checked', false).parent().removeClass('active').end().end().slideUp();
		}
	}

	function togglePartnerContinuousCover(isInitMode) {
		if ($partnerCurrentCover.find('input').filter(':checked').val() === 'Y' && !isLessThan31Or31AndBeforeJuly1($partnerDOB.val())) {
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