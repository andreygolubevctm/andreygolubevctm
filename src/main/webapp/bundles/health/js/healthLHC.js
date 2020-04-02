;(function($, undefined){

    var meerkat = window.meerkat;

    function displayLHC() {
        meerkat.modules.healthCoverDetails.setHealthFunds();
        if(meerkat.site.isCallCentreUser === true){
            // Get rates and show LHC inline.
            meerkat.modules.health.loadRates(function(rates){

                $('.health_cover_details_rebate .fieldrow_legend').html(getOverallLoadingText(rates.loading));

                $('.simples_dialogue-checkbox-26 span[data-loading=true]').html(rates.loading);

                if(meerkat.modules.health.hasPartner()){
                    $('#health_healthCover_primaryCover .fieldrow_legend')
                        .html(getLoadingText(rates.primaryLoading ,  rates.loading));

                    $('#health_healthCover_partnerCover .fieldrow_legend')
                        .html(getLoadingText(rates.partnerLoading ,  rates.loading));
                } else {
                    $('#health_healthCover_primaryCover .fieldrow_legend').html(getOverallLoadingText(rates.loading));
                }
                meerkat.modules.healthTiers.setTiers();
            });
        }

    }

    function getLoadingText(individualLoading, loading){
        return 'Individual LHC ' + individualLoading + '%, overall  LHC ' + loading + '%';
    }

    function getOverallLoadingText(loading){
        return 'Overall LHC ' + loading + '%';
    }


    meerkat.modules.register("healthLHC", {
        displayLHC: displayLHC
    });

})(jQuery);
