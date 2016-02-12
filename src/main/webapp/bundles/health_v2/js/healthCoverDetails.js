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
        return $('#health_situation-selection').find('input[name="health_healthCover_rebate"]').val() === 'Y';
    }

    //Previous funds, settings
    function displayHealthFunds() {
        var $_previousFund = $('#mainform').find('.health-previous_fund'),
            $_primaryFund = $('#clientFund').find('select'),
            $_partnerFund = $('#partnerFund').find('select');

        if ($_primaryFund.val() !== 'NONE' && $_primaryFund.val() !== '') {
            $_previousFund.find('#clientMemberID').slideDown();
            $_previousFund.find('.membership').addClass('onA');
        } else {
            $_previousFund.find('#clientMemberID').slideUp();
            $_previousFund.find('.membership').removeClass('onA');
        }

        if (healthChoices.hasSpouse() && $_partnerFund.val() !== 'NONE' && $_partnerFund.val() !== '') {
            $_previousFund.find('#partnerMemberID').slideDown();
            $_previousFund.find('.membership').addClass('onB');
        } else {
            $_previousFund.find('#partnerMemberID').slideUp();
            $_previousFund.find('.membership').removeClass('onB');
        }
    }


    meerkat.modules.register("healthCoverDetails", {
        init: initHealthCoverDetails,
        isRebateApplied: isRebateApplied,
        displayHealthFunds: displayHealthFunds
    });

})(jQuery);
