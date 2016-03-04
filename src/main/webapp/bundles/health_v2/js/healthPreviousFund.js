;(function($){

    // TODO: write unit test once DEVOPS-31 goes live

    var meerkat = window.meerkat,
        events = {
             healthPreviousFund: {
                 POPULATE_PARTNER: 'POPULATE_PREVIOUS_FUND_PARTNER',
                 POPULATE_PRIMARY: 'POPULATE_PREVIOUS_FUND_PRIMARY',
            }
        },
        moduleEvents = events.healthPreviousFund,
        $primaryFund,
        $partnerFund;


    function init() {

        $(document).ready(function(){
            $primaryFund = $('#clientFund').find('select');
            $partnerFund = $('#partnerFund').find('select');
            meerkat.messaging.subscribe(moduleEvents.POPULATE_PRIMARY, coverChangePrimary);
            meerkat.messaging.subscribe(moduleEvents.POPULATE_PARTNER, coverChangeEventPartner);
        });
    }

    function coverChangePrimary(hasCover){
        coverChange( $primaryFund , hasCover);
    }
    function coverChangeEventPartner(hasCover){
        coverChange($partnerFund , hasCover);
    }

    function coverChange(element , hasCover){
        if( hasCover == 'Y' && element.val() == 'NONE'){
            element.val('');
        } else if(hasCover == 'N'){
            element.val('NONE');
        }
    }
    meerkat.modules.register('healthPreviousFund', {
        init: init,
        events: events
    });

})(jQuery);
