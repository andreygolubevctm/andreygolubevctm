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
        var $el = $('#health_situation-selection').find('input[name="health_healthCover_rebate"]:checked');
        return !_.isEmpty($el) && $el.val() === 'Y';
    }

    //Previous funds, settings
    function displayHealthFunds() {
        var $_previousFund = $('#mainform').find('.health-previous_fund');

        var primaryFund = meerkat.modules.healthPreviousFund.getPrimaryFund();
        var partnerFund = meerkat.modules.healthPreviousFund.getPartnerFund();
        if (primaryFund !== 'NONE' && primaryFund !== '') {
            $_previousFund.find('#clientMemberID').slideDown();
            $_previousFund.find('.membership').addClass('onA');
        } else {
            $_previousFund.find('#clientMemberID').slideUp();
            $_previousFund.find('.membership').removeClass('onA');
        }

        if (healthChoices.hasSpouse() && partnerFund !== 'NONE' && partnerFund !== '') {
            $_previousFund.find('#partnerMemberID').slideDown();
            $_previousFund.find('.membership').addClass('onB');
        } else {
            $_previousFund.find('#partnerMemberID').slideUp();
            $_previousFund.find('.membership').removeClass('onB');
        }
    }

    function setHealthFunds(initMode) {
        setHealthFundsForPerson(initMode,
            $('#health_healthCover_primaryCover') ,
            $('#health-continuous-cover-primary'),
            $('#health_healthCover_primary_dob'),
            $('#primaryLHCRow'));
        setHealthFundsForPerson(initMode,
            $('#health_healthCover_partnerCover') ,
            $('#health-continuous-cover-partner'),
            $('#health_healthCover_partner_dob'),
            $('#partnerLHCRow'));
    }

    function setHealthFundsForPerson(initMode, $healthCover , $continuousCover, $dob, $lhcRow){

        var lessThan31Or31AndBeforeJuly1 = isLessThan31Or31AndBeforeJuly1($dob.val());
        var healthCoverValue = $healthCover.find(':checked').val();
        if( healthCoverValue == 'Y' ) {
            if( lessThan31Or31AndBeforeJuly1 ) {
                hide(initMode , $continuousCover);
            } else{
                show(initMode , $continuousCover);
            }

        } else {
            if( healthCoverValue == 'N'){
                resetRadio($continuousCover,'N');
            }
            hide(initMode , $continuousCover);
        }
        if(meerkat.site.isCallCentreUser === true) {
            var noContinuousCover = $continuousCover.find(':checked').val() == 'N';
            var noHealthCover = healthCoverValue == 'N';
            // only show LHC override if LHC is being applied to the person
            if (!lessThan31Or31AndBeforeJuly1 && (noContinuousCover || noHealthCover)) {
                show(initMode , $lhcRow);
            } else {
                hide(initMode , $lhcRow);
            }
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

    meerkat.modules.register("healthCoverDetails", {
        init: initHealthCoverDetails,
        isRebateApplied: isRebateApplied,
        displayHealthFunds: displayHealthFunds,
        setHealthFunds : setHealthFunds
    });

})(jQuery);
