;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var CRUD = false,
        $confirmationHtml;

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

        CRUD.getSaveRequestData = function($modal) {
            return meerkat.modules.form.getData( $modal.find('#redemptionForm') );
        };

        CRUD.save = function (data) {
            var that = this,
                onSuccess = function (response) {
                    renderSuccessMessage();
                    meerkat.modules.dialogs.close(that.modalId);
            };

            this.update(data, onSuccess);
        };

        meerkat.messaging.subscribe(meerkatEvents.crud.CRUD_MODAL_OPENED, function initRedemptionForm(modalId) {
            meerkat.modules.redemptionForm.initRedemptionForm(modalId);
        });

        // defer rendering because confirmation page is a template
        _.defer(function() {
            renderRewardOrder();
        });

    }
    
    function renderRewardOrder() {
        // Bad response, don't render
        if (!rewardOrder || rewardOrder.status !== true) return;

        setConfirmationHtml();

        switch (rewardOrder.generalStatus) {
            case 'OK_TO_REDEEM':
                renderSuccessMessage();
                break;
            case 'ALREADY_REDEEMED':
                CRUD.openModal();
        }

    }

    function setConfirmationHtml(){
        if (rewardOrder.orderHeader && rewardOrder.orderHeader.eligibleCampaigns && rewardOrder.orderHeader.eligibleCampaigns[0]) {
            $confirmationHtml = $(rewardOrder.orderHeader.eligibleCampaigns[0].contentHtml);
        }
    }

    function renderSuccessMessage() {
        if ($confirmationHtml) {
            $('.reward-confirmation-message-container').html(
                $confirmationHtml.find('.reward-confirmation-message').prop('outerHTML')
            );
        }
    }

    meerkat.modules.register("rewardConfirmation", {
        init: initRewardConfirmation
    });

})(jQuery);