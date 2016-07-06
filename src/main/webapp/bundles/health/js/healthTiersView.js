/*

 Handling of the rebate tiers based off situation

 */
;(function($, undefined) {

    var meerkat = window.meerkat,
        initialised = false,
        $income,
        $healthCoverIncomeLabel;

    initHealthTiers =  function(){
        if(!initialised) {
            initialised = true;
            $income = $('#health_healthCover_income');
            $healthCoverIncomeLabel = $('#health_healthCover_incomelabel');
        }
    };

    getIncome = function() {
        return  $income;
    };

    getIncomeLabel = function() {
        return $healthCoverIncomeLabel;
    };

    meerkat.modules.register("healthTiersView", {
        initHealthTiers: initHealthTiers,
        getIncome : getIncome,
        getIncomeLabel : getIncomeLabel
    });

})(jQuery);