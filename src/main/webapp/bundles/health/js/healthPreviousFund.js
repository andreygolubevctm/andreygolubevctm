;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        events = {
             healthPreviousFund: {
                 POPULATE_PARTNER: 'POPULATE_PREVIOUS_FUND_PARTNER',
                 POPULATE_PRIMARY: 'POPULATE_PREVIOUS_FUND_PRIMARY'
            }
        },
        moduleEvents = events.healthPreviousFund,
        $primaryFund,
        $primaryFundLabel,
        $partnerFund,
        $partnerFundLabel,
        $primaryFundContainer,
        $partnerFundContainer,
        noCurrentFund = 'NONE',
        $primaryDifferentFund,
        $partnerDifferentFund,
        $primaryExtrasFund,
        $primaryExtrasMemberID,
        $partnerExtrasFund,
        $partnerExtrasMemberID;


    function init() {

        $(document).ready(function(){
            $primaryFund = $('#clientFund').find('select');
            $primaryFundLabel = $('#clientFund').find('label');

            $partnerFund = $('#partnerFund').find('select');
            $partnerFundLabel = $('#partnerFund').find('label');

            $primaryDifferentFund = $('#health_previous_fund_different_funds_primary');
            $partnerDifferentFund = $('#health_previous_fund_different_funds_partner');

            $primaryExtrasFund = $('#clientExtrasFund');
            $partnerExtrasFund = $('#partnerExtrasFund');

            $primaryExtrasMemberID = $('#clientExtrasMemberID');
            $partnerExtrasMemberID = $('#partnerExtrasMemberID');

            $primaryFundContainer = $('#health_previousfund');
            $partnerFundContainer = $('#partnerpreviousfund');

            meerkat.messaging.subscribe(moduleEvents.POPULATE_PRIMARY, coverChangePrimary);
            meerkat.messaging.subscribe(moduleEvents.POPULATE_PARTNER, coverChangePartner);

            setupEventListeners();
        });
    }

    function setupEventListeners() {
        $primaryDifferentFund.find('input').on('change', function(event) {
            var value = $primaryDifferentFund.find(':input').filter(':checked').val();
            $primaryExtrasFund.toggleClass('hidden', value === 'Y');
            meerkat.modules.healthCoverDetails.displayHealthFunds();
        });

        $partnerDifferentFund.find('input').on('change', function(event) {
            var value = $partnerDifferentFund.find(':input').filter(':checked').val();
            $partnerExtrasFund.toggleClass('hidden', value === 'Y');
            meerkat.modules.healthCoverDetails.displayHealthFunds();
        });
    }

    function coverChangePrimary(hasCover){
        coverChange( $primaryFund , hasCover, 'primary');

        var coverTerm =  meerkat.modules.healthAboutYou.getPrimaryCurrentCover() === 'N' ? 'Previous' : 'Current';

        if(meerkat.modules.healthAboutYou.getPrimaryHealthCurrentCover() === 'E') {
            $primaryFundLabel.text('Your Current Extras Fund');
        }else{
            $primaryFundLabel.text('Your ' + coverTerm + ' Hospital Fund');
        }
    }

    function coverChangePartner(hasCover){
        coverChange($partnerFund , hasCover, 'partner');

        var coverTerm =  meerkat.modules.healthAboutYou.getPartnerCurrentCover() === 'N' ? 'Previous' : 'Current';

        if (meerkat.modules.health.hasPartner()) {
            if( meerkat.modules.healthAboutYou.getPartnerHealthCurrentCover() === 'E') {
                $partnerFundLabel.text("Partner's Current Extras Fund");
            }else{
                $partnerFundLabel.text("Partner's " + coverTerm + " Hospital Fund");
            }
        }
    }

    function coverChange(element , hasCover, person){
        var noneOption = element.find('option[value="' + noCurrentFund + '"]');
        // did this so i don't rely on the id's
        var $fundFields = person === 'primary' ? $primaryFundContainer : $partnerFundContainer;

        $fundFields.show();
        if( element.val() == noCurrentFund) {
            element.val('');
        }

        noneOption.remove();
        meerkat.modules.healthCoverDetails.displayHealthFunds();
    }

    function getPrimaryFund(){
        return typeof $primaryFund !== 'undefined' ? $primaryFund.val() : '';
    }

    function getPartnerFund(){
        return typeof $partnerFund !== 'undefined' ? $partnerFund.val() : '';
    }

    function getPrimaryExtrasFund(){
        var select = $primaryExtrasFund.find('select');
        return typeof $(select) !== 'undefined' ? $(select).val() : '';
    }

    function getPartnerExtrasFund(){
        var select = $partnerExtrasFund.find('select');
        return typeof $(select) !== 'undefined' ? $(select).val() : '';
    }

    function getPrimaryHasDifferentFund(){
        return $primaryDifferentFund.find(':input').filter(':checked').val() === 'Y';
    }

    function getPartnerHasDifferentFund(){
        return $partnerDifferentFund.find(':input').filter(':checked').val() === 'Y';
    }

    meerkat.modules.register('healthPreviousFund', {
        init: init,
        events: events,
        getPrimaryFund : getPrimaryFund,
        getPartnerFund : getPartnerFund,
        getPrimaryExtrasFund: getPrimaryExtrasFund,
        getPartnerExtrasFund: getPartnerExtrasFund,
        getPrimaryHasDifferentFund: getPrimaryHasDifferentFund,
        getPartnerHasDifferentFund: getPartnerHasDifferentFund
    });

})(jQuery);
