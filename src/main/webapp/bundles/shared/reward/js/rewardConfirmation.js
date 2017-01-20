;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var CRUD = false;

    function initRewardConfirmation() {
        $(document).ready(function() {
            if (typeof meerkat.site === 'undefined') return;
            if (meerkat.site.pageAction !== "confirmation") return;
            initCRUD();
        });

    }

    function initCRUD(){
        CRUD = new meerkat.modules.crud.newCRUD({
            baseURL: "spring/rest/reward",
            primaryKey: "encryptedOrderLineId",
            models: {
                datum: function(data) {
                    return {
                        extraData: {}
                    };
                }
            }
        });

        CRUD.openModal();

    }

    meerkat.modules.register("rewardConfirmation", {
        init: initRewardConfirmation
    });

})(jQuery);