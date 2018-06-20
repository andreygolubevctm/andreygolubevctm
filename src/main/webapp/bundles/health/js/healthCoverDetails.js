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

        if (meerkat.modules.healthChoices.hasSpouse() && partnerFund !== 'NONE' && partnerFund !== '') {
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

        var isAgeLhcApplicable = meerkat.modules.age.isAgeLhcApplicable($dob.val());
        var healthCoverValue = $healthCover.find(':checked').val();
        if( healthCoverValue == 'Y' ) {

            if( isAgeLhcApplicable ) {
                show(initMode , $continuousCover);
            } else{
                hide(initMode , $continuousCover);
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
        return meerkat.site.hasPrimaryCover === 'Y';
    }

    function hasPartnerCover() {
        return meerkat.site.hasPartnerCover === 'Y';
    }

    meerkat.modules.register("healthCoverDetails", {
        init: initHealthCoverDetails,
        isRebateApplied: isRebateApplied,
        displayHealthFunds: displayHealthFunds,
        setHealthFunds: setHealthFunds,
        setIncomeBase: setIncomeBase,
        hasPrimaryCover: hasPrimaryCover,
        hasPartnerCover: hasPartnerCover
    });

})(jQuery);
