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
        $partnerFund,
        $primaryFundContainer,
        $partnerFundContainer,
        noCurrentFund = 'NONE';


    function init() {

        $(document).ready(function(){
            $primaryFund = $('#clientFund').find('select');
            $partnerFund = $('#partnerFund').find('select');

            $primaryFundContainer = $('#health_previousfund');
            $partnerFundContainer = $('#partnerpreviousfund');

            meerkat.messaging.subscribe(moduleEvents.POPULATE_PRIMARY, coverChangePrimary);
            meerkat.messaging.subscribe(moduleEvents.POPULATE_PARTNER, coverChangePartner);
        });
    }

    function coverChangePrimary(hasCover){
        coverChange( $primaryFund , hasCover, 'primary');

        //$primaryFundContainer
//            $partnerFundContainer,
    }
    function coverChangePartner(hasCover){
        coverChange($partnerFund , hasCover, 'partner');
    }

    function coverChange(element , hasCover, person){
        // did this so i don't rely on the id's
        var $fundFields = person === 'primary' ? $primaryFundContainer : $partnerFundContainer;

        $fundFields.show();
        if( hasCover == 'Y' && element.val() == noCurrentFund){
            element.val('');
        } else if(hasCover == 'N'){
            element.val(noCurrentFund);
            $fundFields.hide();
        }
        meerkat.modules.healthCoverDetails.displayHealthFunds();
    }

    function getPrimaryFund(){
        return $primaryFund.val();
    }

    function getPartnerFund(){
        return $partnerFund.val();
    }

    meerkat.modules.register('healthPreviousFund', {
        init: init,
        events: events,
        getPrimaryFund : getPrimaryFund,
        getPartnerFund : getPartnerFund
    });

})(jQuery);
