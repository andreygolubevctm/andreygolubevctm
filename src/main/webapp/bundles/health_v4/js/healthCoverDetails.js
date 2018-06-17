;(function($, undefined) {

    var meerkat = window.meerkat,
        modalId = false;

    function initHealthCoverDetails() {
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

        if (meerkat.modules.healthChoices.hasPartner() && partnerFund !== 'NONE' && partnerFund !== '') {
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

        var lhcApplicable = meerkat.modules.age.isAgeLhcApplicable($dob.val());
        var healthCoverValue = $healthCover.find(':checked').val();
        if( healthCoverValue == 'Y' ) {
            if( !lhcApplicable ) {
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
            if (lhcApplicable&& (noContinuousCover || noHealthCover)) {
                show(initMode , $lhcRow);
            } else {
                hide(initMode , $lhcRow);
            }
        }
    }

    function setIncomeBase (initMode){
        var $incomeBase = $('#health_healthCover_incomeBase'),
            cover = meerkat.modules.healthChoices.returnCoverCode();
        if((cover === 'S' || cover === 'SM' || cover === 'SF') && meerkat.modules.healthRebate.isRebateApplied()){
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

    meerkat.modules.register("healthCoverDetails", {
        init: initHealthCoverDetails,
        displayHealthFunds: displayHealthFunds,
        setHealthFunds: setHealthFunds,
        setIncomeBase: setIncomeBase
    });

})(jQuery);
