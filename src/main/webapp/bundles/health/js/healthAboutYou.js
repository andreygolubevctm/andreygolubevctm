;(function($){

	// TODO: write unit test once DEVOPS-31 goes live

	var meerkat = window.meerkat,
		log = meerkat.logging.info,
		$primaryCurrentCover,
		$primaryHealthCurrentCover,
		$primaryContinuousCoverContainer,
        $primaryContinuousCoverDialog,
		$primaryEverHeldCover,
        $primaryFundHistory,
        $primaryFundHistoryUnsure,
        $primaryPreviousFund,
		$partnerContainer,
		$partnerCurrentCover,
		$partnerHealthCurrentCover,
		$partnerContinuousCoverContainer,
        $partnerContinuousCoverDialog,
		$partnerEverHeldCover,
        $partnerPreviousFund,
        $partnerFundHistory,
        $partnerFundHistoryUnsure,
		$partnerDOB,
		$healthCoverDependants,
		$healthCoverRebate,
		$healthSituationHealthCvr,
		$heathClaimHealthCoverRebate,
		$dontClaimHealthRebate,
		$incomeBase,
		$healthCoverIncome,
        $healthCoverIncomeDialog,
		$healthCoverIncomeFieldLabel,
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
		$abdElements,
		$tier3Dialogue,
		$hasRebateDialogue,
        $australianGovtRebateIntroDialog,
        $complianceCopyWaitingPeriods,
		$complianceCopyReServe,
        $complianceCopyPreviousCover,
        $complianceCopyExtrasOnly,
        $complianceCopyHospitalChoices,
        $complianceCopyExtrasChoices,
		$evenLHCMessage,
		$primary_lhc_input,
		$partner_lhc_input;


	function init(){
		$(document).ready(function () {
			initFields();

			meerkat.modules.healthTiers.initHealthTiers();
			meerkat.modules.healthCoverDetails.setIncomeBase(true);
			meerkat.modules.healthTiers.setTiers(true);

			eventSubscriptions();
			toggleMlsMessage();
		});

		$(window).on("load", setRabdQuestions);
	}

	function initFields() {
		$healthCoverDetailsDependants = $('.health_cover_details_dependants'),
		$healthCoverIncomeMessage = $('#health_healthCover_incomeMessage'),
		$tier3Dialogue = $('.simples-dialogue-144'),
		$hasRebateDialogue = $('.simples-dialogue-37'),
		$primaryCurrentCover = $('#health_healthCover_health_cover'),
		$primaryHealthCurrentCover = $('#health-current-cover-primary'),
		$primaryContinuousCoverContainer = $('#health-continuous-cover-primary'),
		$primaryContinuousCoverDialog = $('#simples-dialogue-201'),
		$primaryEverHeldCover = $('#health-ever-held-cover-primary'),
		$primaryPreviousFund = $('#clientPreviousFund'),
		$primaryFundHistory = $('#health-primary-fund-history'),
		$primaryFundHistoryUnsure = $('#primaryLhcDatesUnsureApplyFullLHC'),
		$partnerContainer = $('#partner-health-cover'),
		$partnerCurrentCover = $('#health_healthCover_partner_health_cover'),
		$partnerHealthCurrentCover = $('#health-current-cover-partner'),
		$partnerContinuousCoverContainer = $('#health-continuous-cover-partner'),
		$partnerContinuousCoverDialog = $('#simples-dialogue-206'),
		$partnerHealthCoverHealthCoverLoading = $('input[name=health_healthCover_partner_healthCoverLoading]'),
		$partnerEverHeldCover = $('#health-ever-held-cover-partner'),
		$partnerPreviousFund = $('#partnerPreviousFund'),
		$partnerFundHistory = $('#health-partner-fund-history'),
		$partnerFundHistoryUnsure = $('#partnerLhcDatesUnsureApplyFullLHC'),
		$partnerDOB = $('#health_healthCover_partner_dob'),
		$healthCoverDependants = $('#health_healthCover_dependants'),
		$healthCoverRebate = $('.health_cover_details_rebate'),
		$heathClaimHealthCoverRebate = $('#health_healthCover_health_cover_rebate'),
		$dontClaimHealthRebate = $('#health_healthCover_health_cover_rebate_dontApplyRebate'),
		$healthSituationHealthCvr = $('#health_situation_healthCvr'),
		$healthCoverIncome = $('#health_healthCover_income'),
        $healthCoverIncomeDialog = $('#health_healthCover_tier .simples-dialogue').hide(),
		$healthCoverIncomeFieldLabel = $healthCoverIncomeDialog.find("p:first"),
		$incomeBase = $('#health_healthCover_incomeBase'),
		$tierDropdowns = $('#health_situation_healthCvr, #health_healthCover_dependants'),
		$primaryDOB = $('#health_healthCover_primary_dob'),
		$rebateLegend = $('#health_healthCover_tier_row_legend'),
		$partnersDetails = $('#partnerFund, #partnerMemberID, #partnerContainer'),
		$lhcContainers = $('#health_situation_coverType, #health-contact-fieldset, #partner-health-cover, #australian-government-rebate, #health-current-cover-primary, #health-current-cover-partner'),
		$medicare = $('.health-medicare_details'),
		$healthSituation = $('input[name="health_situation_healthSitu"]');
		$abdElements = {
			primary: {
				ageBasedDiscountDialog: $('#simples-dialogue-202'),
				receivesAgeBasedDiscountRow: $('#primary_abd'),
				receivesAgeBasedDiscount: $('#primary_abd_health_cover'),
				policyStartDateDialog: $('#simples-dialogue-203'),
				ageBasedDiscountPolicyStartRow: $('#primary_abd_start_date'),
				healthApplicationDOB: $('#health_application_primary_dob'),
			},
			partner: {
                ageBasedDiscountDialog: $('#simples-dialogue-207'),
				receivesAgeBasedDiscountRow: $('#partner_abd'),
				receivesAgeBasedDiscount: $('#partner_abd_health_cover'),
                policyStartDateDialog: $('#simples-dialogue-208'),
				ageBasedDiscountPolicyStartRow: $('#partner_abd_start_date'),
				healthApplicationDOB: $('#health_application_partner_dob')
			}
		};
        $australianGovtRebateIntroDialog = $('#simples-dialogue-210');

        $complianceCopyWaitingPeriods = $('#simples-dialogue-62');
		$complianceCopyReServe = $('#simples-dialogue-226');
        $complianceCopyPreviousCover = $('#simples-dialogue-212');
        $complianceCopyExtrasOnly = $('#simples-dialogue-213');
        $complianceCopyHospitalChoices = $('#simples-dialogue-214');
        $complianceCopyExtrasChoices = $('#simples-dialogue-215');
		$evenLHCMessage = $('#contactForm .even-lhc-value-message');
		$primary_lhc_input = $('#health_healthCover_primary_lhc');
		$partner_lhc_input = $('#health_healthCover_partner_lhc');



		if (!meerkat.modules.healthChoices.hasSpouse()) {
			$partnerContainer.hide();
		}

        initComplianceCopyDialogs();
		setupForm(true);
	}

	function eventSubscriptions() {

		$dontClaimHealthRebate.on('change', function dontClaimHealthRebateUpdated(){
			updateClaimHealthRebate();
		});

		$tierDropdowns.on('change', function updateRebateTiers(){
			meerkat.modules.healthTiers.setTiers();
		});

		$abdElements.primary.healthApplicationDOB.on('change', function() {
			_toggleAgeBasedDiscountQuestion('primary');
		});

		$abdElements.partner.healthApplicationDOB.on('change', function() {
			_toggleAgeBasedDiscountQuestion('partner');
		});

		$abdElements.primary.receivesAgeBasedDiscount.find(':input').on('change', function(event) {
			if(event.target.value === 'Y') {
				$abdElements.primary.policyStartDateDialog.removeClass('hidden');
                $abdElements.primary.ageBasedDiscountPolicyStartRow.removeClass('hidden');
			}else{
                $abdElements.primary.policyStartDateDialog.addClass('hidden');
				$abdElements.primary.ageBasedDiscountPolicyStartRow.addClass('hidden');
			}
		});

		$abdElements.partner.receivesAgeBasedDiscount.find(':input').on('change', function(event) {
			if(event.target.value === 'Y') {
                $abdElements.partner.policyStartDateDialog.removeClass('hidden');
				$abdElements.partner.ageBasedDiscountPolicyStartRow.removeClass('hidden');
			}else{
                $abdElements.partner.policyStartDateDialog.addClass('hidden');
				$abdElements.partner.ageBasedDiscountPolicyStartRow.addClass('hidden');
			}
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

		$primaryFundHistoryUnsure.find(':input').on('change', function onPrimaryFundDatesUnsure(event) {
			var value = $primaryFundHistoryUnsure.find(':input').filter(':checked').val();
		});

		$primaryPreviousFund.find('select').on('change', function(event) {
			$('#clientFund').find('select').val(event.target.value);
		});

		$partnerPreviousFund.find('select').on('change', function(event) {
			$('#partnerFund').find('select').val(event.target.value);
		});


		$lhcContainers.find(':input').on('change', function updateRebateContinuousCover(event) {

			var $this = $(this);

			// Don't action on the DOB input fields; wait until it's serialised to the hidden field.
			if ($this.hasClass('dateinput-day') || $this.hasClass('dateinput-month') || $this.hasClass('dateinput-year') || ($this.attr('name').indexOf('primary_dob') >= 0 && $this.val() === "") || ($this.attr('name').indexOf('partner_dob') >= 0 && $this.val() === "")) return;

			// Don't action on situation cover and international student field, remove line below when we provide OVC cover
			if (_.indexOf(['health_situation_cover', 'health_situation_internationalstudent'], $this.attr('name')) > -1) return;

			togglePrimaryContinuousCover();
			togglePartnerContinuousCover();

			var lhcApplicablePrimary = meerkat.modules.age.isAgeLhcApplicable($primaryDOB.val());
			var lhcApplicablePartner = meerkat.modules.age.isAgeLhcApplicable($partnerDOB.val());

			var hasCoverPrimary = $primaryCurrentCover.find('input').filter(':checked').val();
			var hasContinuousCoverPrimary = $primaryContinuousCoverContainer.find('input').filter(':checked').val();
			var primaryCurrentCoverType = $('#health-current-cover-primary').find(':input').filter(':checked').val();

			var hasCoverPartner = $partnerCurrentCover.find('input').filter(':checked').val();
			var hasContinuousCoverPartner = $partnerContinuousCoverContainer.find('input').filter(':checked').val();
            var partnerCurrentCoverType = $('#health-current-cover-partner').find(':input').filter(':checked').val();

			var hasEverHeldCoverPrimary = $primaryEverHeldCover.find('input').filter(':checked').val();
			var hasEverHeldCoverPartner = $partnerEverHeldCover.find('input').filter(':checked').val();

            var primaryEverHeldCover = (hasCoverPrimary && hasCoverPrimary === 'N') || (hasContinuousCoverPrimary && hasContinuousCoverPrimary === 'N') || (hasCoverPrimary && hasCoverPrimary === 'Y' && lhcApplicablePrimary && primaryCurrentCoverType === 'E');
            var partnerEverHeldCover = (hasCoverPartner && hasCoverPartner === 'N') || (hasContinuousCoverPartner && hasContinuousCoverPartner === 'N') || (hasCoverPartner && hasCoverPartner === 'Y' && lhcApplicablePartner && partnerCurrentCoverType === 'E');

            var primaryHasFundHistory = lhcApplicablePrimary && ((hasCoverPrimary === 'Y' && hasContinuousCoverPrimary === 'N' && hasEverHeldCoverPrimary  === 'Y') || (hasCoverPrimary === 'N' && hasEverHeldCoverPrimary === 'Y') || (primaryEverHeldCover && hasCoverPrimary === 'Y' && primaryCurrentCoverType === 'E' && hasEverHeldCoverPrimary === 'Y'));
            var partnerHasFundHistory = lhcApplicablePartner && ((hasCoverPartner === 'Y' && hasContinuousCoverPartner === 'N' && hasEverHeldCoverPartner  === 'Y') || (hasCoverPartner === 'N' && hasEverHeldCoverPartner === 'Y') || (partnerEverHeldCover && hasCoverPartner === 'Y' && partnerCurrentCoverType === 'E' && hasEverHeldCoverPartner === 'Y'));

			togglePrimaryCurrentCoverType(hasCoverPrimary && hasCoverPrimary === 'Y');
			togglePartnerCurrentCoverType(hasCoverPartner && hasCoverPartner === 'Y');

			togglePrimaryEverHeldCoverType(primaryEverHeldCover);
			togglePartnerEverHeldCoverType(partnerEverHeldCover);

			var unsureValuePrimary = $primaryFundHistoryUnsure.find(':input').filter(':checked').val();
			var unsureValuePartner = $partnerFundHistoryUnsure.find(':input').filter(':checked').val();

			$primaryFundHistory.toggleClass('hidden', !primaryHasFundHistory || unsureValuePrimary === 'Y');
			$partnerFundHistory.toggleClass('hidden', !partnerHasFundHistory || unsureValuePartner === 'Y');

			$('#clientFund').find('label').text(primaryHasFundHistory ? 'Your Previous Hospital Fund' : 'Your Current Hospital Fund');
			$('#partnerFund').find('label').text(partnerHasFundHistory ? "Your Partner's Previous Hospital Fund" : "Your Partner's Current Hospital Fund");

			$primaryFundHistoryUnsure.toggleClass('hidden', !primaryHasFundHistory);
			$partnerFundHistoryUnsure.toggleClass('hidden', !partnerHasFundHistory);

			$primaryPreviousFund.toggleClass('hidden', !primaryHasFundHistory);
			$partnerPreviousFund.toggleClass('hidden', !partnerHasFundHistory);

			_toggleAgeBasedDiscountQuestion('primary');

			if (meerkat.modules.healthChoices.hasSpouse()) {
				_toggleAgeBasedDiscountQuestion('partner');
			}

			// update rebate
			if ($this.valid()) {
				setRebate();
			}

            setupComplianceCopy();

			$primary_lhc_input.on('change', function (event) {
				$primary_lhc_input.prev().toggleClass('hidden', ifNotNumericOrEven(event.target.value));
			});

			$partner_lhc_input.on('change', function (event) {
				$partner_lhc_input.prev().toggleClass('hidden', ifNotNumericOrEven(event.target.value));
			});

			function ifNotNumericOrEven(val) {
				return !$.isNumeric(val) || val % 2 === 0;
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

	function getContinuousCoverPrimary() {
		return $primaryContinuousCoverContainer.find('input').filter(':checked').val() === 'Y';
	}

	function getContinuousCoverPartner() {
		return $partnerContinuousCoverContainer.find('input').filter(':checked').val() === 'Y';
	}

	function neverHadCoverPrimary() {
		return $primaryEverHeldCover.find('input').filter(':checked').val() === 'N';
	}

	function neverHadCoverPartner() {
		return $partnerEverHeldCover.find('input').filter(':checked').val() === 'N';
	}

	function convertDate(date) {
		var dobSplit = date.split('/');
		if(dobSplit.length === 3) {
			return new Date(dobSplit[1] + '/' + dobSplit[0] + '/' + dobSplit[2]);
		}

		return date;
	}

	function _toggleAgeBasedDiscountQuestion(applicant) {
        if($abdElements && applicant && _.has($abdElements, applicant)) {
            var dob = convertDate($abdElements[applicant].healthApplicationDOB.val());

            if(!dob) return;

            var applicationDate = $('#health_searchDate').val();
            var applicationDateString = '';

            if(applicationDate) {
                var dateSplit = applicationDate.split('/');
                if(dateSplit.length == 3) {
                    var year = dateSplit[2];
                    var month = dateSplit[1];
                    var day = dateSplit[0];
                    applicationDateString = year + '-' + month + '-' + day;
                }
            }

            var curDate = applicationDateString ? new Date(applicationDateString) : meerkat.site.serverDate;
            var privateHospitalValue = $primaryCurrentCover.find('input').filter(':checked').val();
            var hasExtrasCover = getPrimaryHealthCurrentCover() === 'E' || !getPrimaryHealthCurrentCover();

            if(applicant === 'partner') {
                privateHospitalValue = $partnerCurrentCover.find('input').filter(':checked').val();
                hasExtrasCover = getPartnerHealthCurrentCover() === 'E'  || !getPartnerHealthCurrentCover();
            }

            var age = new Date(curDate.getTime() - dob.getTime()).getFullYear() - 1970;

            if(meerkat.modules.healthBenefitsStep.getCoverType() === 'e') {
                $abdElements[applicant].ageBasedDiscountDialog.addClass('hidden');
                $abdElements[applicant].receivesAgeBasedDiscountRow.addClass('hidden');
                $abdElements[applicant].ageBasedDiscountPolicyStartRow.addClass('hidden');
                return;
            }

            if (!hasExtrasCover && age >= 18 && age < 45 && privateHospitalValue === 'Y' && meerkat.modules.age.isBornAfterFirstOfApril1989($abdElements[applicant].healthApplicationDOB.val())) {
                $abdElements[applicant].ageBasedDiscountDialog.removeClass('hidden');
                $abdElements[applicant].receivesAgeBasedDiscountRow.removeClass('hidden');
                var hasABD = $abdElements[applicant].receivesAgeBasedDiscount.find(':checked').val();
                if(hasABD === 'Y') {
                    $abdElements[applicant].ageBasedDiscountPolicyStartRow.removeClass('hidden');
                }
            } else {
                $abdElements[applicant].ageBasedDiscountDialog.addClass('hidden');
                $abdElements[applicant].receivesAgeBasedDiscountRow.addClass('hidden');
                $abdElements[applicant].ageBasedDiscountPolicyStartRow.addClass('hidden');
                $abdElements[applicant].receivesAgeBasedDiscountRow.find(':input').filter(':checked').prop('checked', false).parent().removeClass('active');
            }
        } else {
	        return;
        }
	}

	function updateDynamicIncomeFieldText() {

		var rebateIncomeBracket = $healthCoverIncome.find('option#health_healthCover_income_0').text().replace(/\s(.*)/g,'');

		var rebateIncomeBracketQuestionStartText = 'Do you earn above or below ';

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

        $healthCoverIncomeDialog.show();
	}

	function updateClaimHealthRebate(){
		if(!$dontClaimHealthRebate.is(':checked')){
			$heathClaimHealthCoverRebate.find("input[value='Y']").prop('checked',true).trigger('change');
		} else {
			$heathClaimHealthCoverRebate.find("input[value='N']").prop('checked', true).trigger('change');
		}
	}

	function togglePrimaryCurrentCoverType(show) {
		if(show) {
			$primaryHealthCurrentCover.slideDown();
		} else {
			$primaryHealthCurrentCover.find(':input').filter(':checked').prop('checked', false).parent().removeClass('active');
			$primaryHealthCurrentCover.slideUp();
		}
	}

	function togglePartnerCurrentCoverType(show) {
		if(show) {
			$partnerHealthCurrentCover.slideDown();
		} else {
			$partnerHealthCurrentCover.find(':input').filter(':checked').prop('checked', false).parent().removeClass('active');
			$partnerHealthCurrentCover.slideUp();
		}
	}

	function togglePrimaryEverHeldCoverType(show) {
		if(show) {
			$primaryEverHeldCover.slideDown();
		} else {
			$primaryEverHeldCover.find(':input').filter(':checked').prop('checked', false).parent().removeClass('active');
			$primaryEverHeldCover.slideUp();
		}
	}

	function togglePartnerEverHeldCoverType(show) {
		if(show) {
			$partnerEverHeldCover.slideDown();
		} else {
			$partnerEverHeldCover.find(':input').filter(':checked').prop('checked', false).parent().removeClass('active');
			$partnerEverHeldCover.slideUp();
		}
	}

	function getPrimaryHealthCurrentCover() {
		return $primaryHealthCurrentCover.find(':input').filter(':checked').val();
	}

	function getPartnerHealthCurrentCover() {
		return $partnerHealthCurrentCover.find(':input').filter(':checked').val();
	}

	function togglePrimaryContinuousCover(isInitMode) {
		var healthCurrentCoverValue = $primaryHealthCurrentCover.find(':input').filter(':checked').val();
		var hasHospitalCover = ['H', 'C'].indexOf(healthCurrentCoverValue) > -1;

		if ($primaryCurrentCover.find('input').filter(':checked').val() === 'Y' && hasHospitalCover && meerkat.modules.age.isAgeLhcApplicable($primaryDOB.val())) {
            $primaryContinuousCoverDialog.removeClass('hidden');
			$primaryContinuousCoverContainer.slideDown();
		} else if (isInitMode === true || hasHospitalCover) {
            $primaryContinuousCoverDialog.addClass('hidden');
            $primaryContinuousCoverContainer.hide();
        } else {
            $primaryContinuousCoverDialog.addClass('hidden');
			$primaryContinuousCoverContainer.find('input[name=health_healthCover_primary_healthCoverLoading]:checked').prop('checked', false).parent().removeClass('active').end().end().slideUp();
		}
	}

	function togglePartnerContinuousCover(isInitMode) {
		var healthCurrentCoverValue = $partnerHealthCurrentCover.find(':input').filter(':checked').val();
		var hasHospitalCover = ['H', 'C'].indexOf(healthCurrentCoverValue) > -1;

		if ($partnerCurrentCover.find('input').filter(':checked').val() === 'Y' && hasHospitalCover && meerkat.modules.age.isAgeLhcApplicable($partnerDOB.val())) {
            $partnerContinuousCoverDialog.removeClass('hidden');
			$partnerContinuousCoverContainer.slideDown();
		} else if (isInitMode === true || hasHospitalCover) {
            $partnerContinuousCoverDialog.addClass('hidden');
            $partnerContinuousCoverContainer.hide();
        } else {
            $partnerContinuousCoverDialog.addClass('hidden');
			$partnerContinuousCoverContainer.find('input[name=health_healthCover_partner_healthCoverLoading]:checked').prop('checked', false).parent().removeClass('active').end().end().slideUp();
		}
	}

	function setupForm(isInitMode) {

		updateClaimHealthRebate();

		var familyType = $healthSituationHealthCvr.val();

		switch(familyType)
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
				$incomeBase.hide();
				break;
			case 'SPF':
			case 'ESP':
				$partnerContainer.slideUp();

				if($heathClaimHealthCoverRebate.find('input:checked').val() !== 'N'){
					$healthCoverDetailsDependants.slideDown();
				}
				$partnersDetails.hide();
                $incomeBase.hide();
				break;
			case 'C':
				$healthCoverDetailsDependants.slideUp();
				$partnerContainer.slideDown();
				$partnersDetails.show();
				$incomeBase.hide();
				break;
			default:
				isInitMode === true ? $partnerContainer.hide() : $partnerContainer.slideUp();
				isInitMode === true ? $healthCoverDetailsDependants.hide() : $healthCoverDetailsDependants.slideUp();
				resetPartnerDetails();
				$healthCoverIncomeMessage.hide();
				$partnersDetails.hide();
				$incomeBase.show();
				break;
		}

		if(meerkat.site.isCallCentreUser === true){
			updateDynamicIncomeFieldText();
            setupAustralianGovtRebateIntroCopy(familyType);
            setupComplianceCopy();
		}

		togglePrimaryContinuousCover();
		togglePartnerContinuousCover();
	}

	function setupAustralianGovtRebateIntroCopy(familyType) {
        var isSingle = _.indexOf(['S', 'SM', 'SF'], familyType) !== -1;
        var isCouple = _.indexOf(['C'], familyType) !== -1;
        $australianGovtRebateIntroDialog.find('.single-couple-copy').toggleClass('hidden', !isSingle);
        $australianGovtRebateIntroDialog.find('.family-copy').toggleClass('hidden', isSingle || isCouple);
    }

    function setupComplianceCopy() {
	    var coverType = meerkat.modules.health.getCoverType();
        var hasCoverPrimary = $primaryCurrentCover.find('input').filter(':checked').val() === 'Y';
        var hasCoverPartner = $partnerCurrentCover.find('input').filter(':checked').val() === 'Y';
		var primaryCurrentCover = $primaryHealthCurrentCover.find('input').filter(':checked').val();
		var partnerCurrentCover = $partnerHealthCurrentCover.find('input').filter(':checked').val();
        var isCombinedOrHospital = _.indexOf(['C','H'], coverType) >= 0;
        var isCombinedOrExtras = _.indexOf(['C','E'], coverType) >= 0;
        var primaryHasCombinedOrHospital = _.indexOf(['C','H'], primaryCurrentCover) >= 0;
        var partnerHasCombinedOrHospital = _.indexOf(['C','H'], partnerCurrentCover) >= 0;
		var primaryHasCombinedOrExtras = _.indexOf(['C','E'], primaryCurrentCover) >= 0;
		var partnerHasCombinedOrExtras = _.indexOf(['C','E'], partnerCurrentCover) >= 0;
		var primaryHasHospitalCover = _.indexOf(['C','H'], primaryCurrentCover) !== -1;
		var partnerHasHospitalCover = _.indexOf(['C','H'], partnerCurrentCover) !== -1;
		var primaryHasExtrasCover = _.indexOf(['C','E'], $primaryHealthCurrentCover.find('input').filter(':checked').val()) !== -1;
		var partnerHasExtrasCover = _.indexOf(['C','E'], $partnerHealthCurrentCover.find('input').filter(':checked').val()) !== -1;
		var nonSingleFamilyType = _.indexOf(['S','SF', 'SM', 'SPF', 'ESPF'], $healthSituationHealthCvr.val()) === -1;

        updateComplianceDialogCopy();

        $complianceCopyWaitingPeriods.toggleClass('hidden', !isCombinedOrHospital);
		$complianceCopyReServe.toggleClass('hidden', !((hasCoverPrimary && ((isCombinedOrHospital && primaryHasCombinedOrHospital) || (isCombinedOrExtras && primaryHasCombinedOrExtras)) || (nonSingleFamilyType && hasCoverPartner && ((isCombinedOrHospital && partnerHasCombinedOrHospital) || (isCombinedOrExtras && partnerHasCombinedOrExtras))))));
        $complianceCopyPreviousCover.toggleClass('hidden', !((primaryHasHospitalCover || (nonSingleFamilyType && partnerHasHospitalCover)) && isCombinedOrHospital));
        $complianceCopyExtrasOnly.toggleClass('hidden', !((primaryHasExtrasCover || (nonSingleFamilyType && partnerHasExtrasCover)) && isCombinedOrExtras));

        $complianceCopyHospitalChoices.toggleClass('hidden', !isCombinedOrHospital);
        $complianceCopyExtrasChoices.toggleClass('hidden', !isCombinedOrExtras);
    }

    function initComplianceCopyDialogs() {
        var copy = $complianceCopyHospitalChoices.html();
        $complianceCopyHospitalChoices.prop('data-backup', copy);
        copy = $complianceCopyExtrasChoices.html();
        $complianceCopyExtrasChoices.prop('data-backup', copy);
    }

    function restoreComplianceCopyDialogs() {
        restoreHospitalComplianceCopyDialogs();
        restoreExtrasComplianceCopyDialogs();
    }

    function restoreHospitalComplianceCopyDialogs() {
        $complianceCopyHospitalChoices.html($complianceCopyHospitalChoices.prop('data-backup'));
    }

    function restoreExtrasComplianceCopyDialogs() {
        $complianceCopyExtrasChoices.html($complianceCopyExtrasChoices.prop('data-backup'));
    }

    function updateComplianceDialogCopy() {
        restoreComplianceCopyDialogs();
        meerkat.modules.simplesDynamicDialogue.parse(214);
        meerkat.modules.simplesDynamicDialogue.parse(215);
    }

	function setRebate(){
		meerkat.modules.health.loadRatesBeforeResultsPage(true, function (rates) {
			setRebateRates(rates);
		});
	}

	function setRebateRates(rates) {
		if (!isNaN(rates.rebate) && parseFloat(rates.rebate) > 0) {
			$rebateLegend.html('You are eligible for a ' + rates.rebate + '% rebate.');
			$healthCoverRebate.slideDown();
		} else {
			$rebateLegend.html('');
		}
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
		if ($healthCoverIncome.val() === '3') {
			$hasRebateDialogue.hide();
			$tier3Dialogue.toggleClass('hidden', false);
		} else if(meerkat.modules.healthCoverDetails.isRebateApplied()) {
			$hasRebateDialogue.show();
			$tier3Dialogue.toggleClass('hidden', true);
		}
	}

	function getSituation() {
		return $('#health_situation_healthCvr').val();
	}

	function setRabdQuestions() {
		_toggleAgeBasedDiscountQuestion('primary');

		if (meerkat.modules.healthChoices.hasSpouse()) {
			_toggleAgeBasedDiscountQuestion('partner');
		}
	}

	meerkat.modules.register('healthAboutYou', {
		init: init,
		getPartnerCurrentCover : getPartnerCurrentCover,
		getPrimaryCurrentCover : getPrimaryCurrentCover,
		getContinuousCoverPrimary: getContinuousCoverPrimary,
		getContinuousCoverPartner: getContinuousCoverPartner,
		neverHadCoverPrimary :neverHadCoverPrimary,
		neverHadCoverPartner: neverHadCoverPartner,
		getPrimaryHealthCurrentCover: getPrimaryHealthCurrentCover,
		getPartnerHealthCurrentCover: getPartnerHealthCurrentCover,
		getSituation : getSituation,
		setRabdQuestions: setRabdQuestions,
		setRebateRates: setRebateRates,
        setupComplianceCopy: setupComplianceCopy,
        restoreHospitalComplianceCopyDialogs: restoreHospitalComplianceCopyDialogs,
        restoreExtrasComplianceCopyDialogs: restoreExtrasComplianceCopyDialogs,
        updateComplianceDialogCopy: updateComplianceDialogCopy
	});

})(jQuery);
