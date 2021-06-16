;(function($, undefined) {

    var meerkat = window.meerkat,
        modalId = false,
        $healthCoverRebate;

    function initHealthCoverDetails() {
        $(document).ready(function () {
            $healthCoverRebate = $('.health_cover_details_rebate');
        });
    }

    function isRebateApplied() {
        var $el = $('#health_healthCover_health_cover_rebate').find('input[name="health_healthCover_rebate"]:checked');
        return !_.isEmpty($el) && $el.val() === 'Y';
    }

    function _prefillPreviousFund(applicant) {
        var selectedFieldCurrentVal = applicant == 'primary'? meerkat.modules.healthPreviousFund.getPrimaryPreviousFund() : meerkat.modules.healthPreviousFund.getPartnerPreviousFund() ;

        if(selectedFieldCurrentVal !== ''){
            $('input[name=health_previousfund_' + applicant + '_fundNameHidden]').attr('value',selectedFieldCurrentVal);
            if( applicant == 'primary'){
                $('input[name=health_previousfund_' + applicant + '_fundNameInput]').val($('#health_healthCover_primary_previousFundName :selected').text());
            }else{
                $('input[name=health_previousfund_' + applicant + '_fundNameInput]').val($('#health_healthCover_partner_previousFundName :selected').text());
            }
            $('input[name=health_previousfund_' + applicant + '_fundNameInput]').trigger('keyup');
            $('input[name=health_previousfund_' + applicant + '_fundNameInput]').parent().find('ul').trigger('click');
        }
    }


    //Previous funds, settings
    function displayHealthFunds() {
        var $_previousFund = $('#mainform').find('.health-previous_fund');

        var hasSpouse = meerkat.modules.healthChoices.hasSpouse();
        var primaryHasCover = hasPrimaryCover();
        var primaryHasHadCover = hasPrimaryPreviousCover();
        var partnerHasCover = hasPartnerCover();
        var partnerHasHadCover = hasPartnerPreviousCover();
        var primaryFund = meerkat.modules.healthPreviousFund.getPrimaryFund();
        var partnerFund = meerkat.modules.healthPreviousFund.getPartnerFund();
        var primaryExtrasFund = meerkat.modules.healthPreviousFund.getPrimaryExtrasFund();
        var partnerExtrasFund = meerkat.modules.healthPreviousFund.getPartnerExtrasFund();
        var primarySameFund = meerkat.modules.healthPreviousFund.getPrimaryHasSameFund();
        var partnerSameFund = meerkat.modules.healthPreviousFund.getPartnerHasSameFund();
        var primaryPreviousFund = meerkat.modules.healthPreviousFund.getPrimaryPreviousFund();
        var partnerPreviousFund = meerkat.modules.healthPreviousFund.getPartnerPreviousFund();

		if(primaryHasCover || primaryHasHadCover) {
			$_previousFund.find('#clientFund').slideDown();
			if ((primaryFund !== 'NONE' && primaryFund !== '') || (primaryPreviousFund !== 'NONE' && primaryPreviousFund !== '')) {
				$_previousFund.find('#clientMemberID').slideDown();
				$_previousFund.find('.membership').addClass('onA');
			} else {
				$_previousFund.find('#clientMemberID').slideUp();
				$_previousFund.find('.membership').removeClass('onA');
			}
			if (!primarySameFund) {
				$_previousFund.find('#clientExtrasFund').slideDown();
				if(primaryExtrasFund !== 'NONE' && primaryExtrasFund !== '') {
					$_previousFund.find('#clientExtrasMemberID').slideDown();
					$_previousFund.find('.membership').addClass('onA');
				} else {
					$_previousFund.find('#clientExtrasMemberID').slideUp();
					$_previousFund.find('.membership').removeClass('onA');
				}
			} else {
				$_previousFund.find('#clientExtrasFund').slideUp();
				$_previousFund.find('#clientExtrasMemberID').slideUp();
				$_previousFund.find('.membership').removeClass('onA');
			}
		} else {
			$_previousFund.find('#clientFund').slideUp();
			$_previousFund.find('#clientMemberID').slideUp();
			$_previousFund.find('#clientExtrasFund').slideUp();
			$_previousFund.find('#clientExtrasMemberID').slideUp();
			$_previousFund.find('.membership').removeClass('onA');
		}

		if(hasSpouse && (partnerHasCover || partnerHasHadCover)) {
			$_previousFund.find('#partnerFund').slideDown();
			if ((partnerFund !== 'NONE' && partnerFund !== '') || (partnerPreviousFund !== 'NONE' && partnerPreviousFund !== '')) {
				$_previousFund.find('#partnerMemberID').slideDown();
				$_previousFund.find('.membership').removeClass('onB');
			} else {
				$_previousFund.find('#partnerMemberID').slideUp();
				$_previousFund.find('.membership').addClass('onB');
			}
			if (!partnerSameFund) {
				$_previousFund.find('#partnerExtrasFund').slideDown();
				if(partnerExtrasFund !== 'NONE' && partnerExtrasFund !== '') {
					$_previousFund.find('#partnerExtrasMemberID').slideDown();
					$_previousFund.find('.membership').addClass('onB');
				} else {
					$_previousFund.find('#partnerExtrasMemberID').slideUp();
					$_previousFund.find('.membership').removeClass('onB');
				}
			} else {
				$_previousFund.find('#partnerExtrasFund').slideUp();
				$_previousFund.find('#partnerExtrasMemberID').slideUp();
				$_previousFund.find('.membership').removeClass('onB');
			}
		} else {
			$_previousFund.find('#partnerFund').slideUp();
			$_previousFund.find('#partnerMemberID').slideUp();
			$_previousFund.find('#partnerExtrasFund').slideUp();
			$_previousFund.find('#partnerExtrasMemberID').slideUp();
			$_previousFund.find('.membership').removeClass('onB');
		}
    }

    function setHealthFunds(initMode) {
        setHealthFundsForPerson(initMode,
            $('#health_healthCover_primaryCover') ,
            $('#health-current-cover-primary'),
            $('#health-continuous-cover-primary'),
            $('#health_healthCover_primary_dob'),
            $('#primaryLHCRow'));
        setHealthFundsForPerson(initMode,
            $('#health_healthCover_partnerCover') ,
            $('#health-current-cover-partner'),
            $('#health-continuous-cover-partner'),
            $('#health_healthCover_partner_dob'),
            $('#partnerLHCRow'));
    }

    function setHealthFundsForPerson(initMode, $healthCover , $currentCover, $continuousCover, $dob, $lhcRow){

        var isAgeLhcApplicable = meerkat.modules.age.isAgeLhcApplicable($dob.val());
        var healthCoverValue = $healthCover.find(':checked').val();
        var healthCurrentCoverValue = $currentCover.find(':input').filter(':checked').val();
        var hasHospitalCover = ['H', 'C'].indexOf(healthCurrentCoverValue) > -1;

        if( healthCoverValue === 'Y' && hasHospitalCover ) {

            if( isAgeLhcApplicable ) {
                show(initMode , $continuousCover);
            } else{
                hide(initMode , $continuousCover);
            }

        } else {
            if( healthCoverValue === 'N'){
                resetRadio($continuousCover,'N');
            }
            hide(initMode , $continuousCover);
        }
        if(meerkat.site.isCallCentreUser === true) {
            var noContinuousCover = $continuousCover.find(':checked').val() === 'N';
            var noHealthCover = healthCoverValue === 'N';

            // only show LHC override if LHC is being applied to the person
            if (isAgeLhcApplicable && (noContinuousCover || noHealthCover)) {
                show(initMode , $lhcRow);
            } else {
                hide(initMode , $lhcRow);
            }
        }
    }

    function setIncomeBase (initMode){
        var $incomeBase = $('#health_healthCover_incomeBase'),
            cover = meerkat.modules.healthChoices.returnCoverCode();
        if((cover === 'S' || cover === 'SM' || cover === 'SF') && isRebateApplied()){
            show(initMode , $incomeBase);
        } else {
            hide(initMode , $incomeBase);
        }
    }



    function show(initMode , $element) {
        if(initMode){
            $element.show();
        }else{
            $element.slideDown();
        }
    }

    function hide(initMode , $element) {
        if(initMode){
            $element.hide();
        }else{
            $element.slideUp();
        }
    }

    function hasPrimaryCover() {
        return $('#health_healthCover_health_cover').find('input').filter(':checked').val() === 'Y';
    }

    function hasPrimaryPreviousCover() {
        return $('#health-ever-held-cover-primary').find('#health_healthCover_health_ever_held_cover').first().find('input').filter(':checked').val() === 'Y';
    }

    function hasPartnerCover() {
        return $('#health_healthCover_partner_health_cover').find('input').filter(':checked').val() === 'Y';
    }

    function hasPartnerPreviousCover() {
        return $('#health-ever-held-cover-partner').find('#health_healthCover_health_ever_held_cover').first().find('input').filter(':checked').val() === 'Y';
    }

    meerkat.modules.register("healthCoverDetails", {
        init: initHealthCoverDetails,
        isRebateApplied: isRebateApplied,
        displayHealthFunds: displayHealthFunds,
        setHealthFunds: setHealthFunds,
        setIncomeBase: setIncomeBase,
        hasPrimaryCover: hasPrimaryCover,
        hasPartnerCover: hasPartnerCover,
        hasPrimaryPreviousCover: hasPrimaryPreviousCover,
        hasPartnerPreviousCover: hasPartnerPreviousCover
    });

})(jQuery);
