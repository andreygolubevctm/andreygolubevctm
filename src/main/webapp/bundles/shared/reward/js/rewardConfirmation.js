;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var CRUD = false,
        rewardData,
        $contentHtml,
        currentCampaign,
        selectedRewardTypeId;

    function initRewardConfirmation() {
        $(document).ready(function() {
            if (typeof meerkat.site === 'undefined') return;
            if (meerkat.site.pageAction !== "confirmation") return;
            // Bad response, abort
            if (!rewardOrder || rewardOrder.status !== true || !rewardOrder.orderHeader) return;

            rewardData = _transformRewardOrder();
            if (rewardData.eligibleCampaigns && rewardData.eligibleCampaigns[0]) {
                currentCampaign = rewardData.eligibleCampaigns[0];
                $contentHtml = $(currentCampaign.contentHtml);
            }
            initCRUD();
        });

    }

    function initCRUD(){
        CRUD = new meerkat.modules.crud.newCRUD({
            baseURL: "spring/rest/reward/order",
            primaryKey: "encryptedOrderLineId",
            models: {
                db: rewardData
            }
        });

        CRUD.getSaveRequestData = function($modal) {
            var orderForm = rewardData.orderForm,
                orderLine = orderForm.orderHeader.orderLine,
                orderAddress = orderLine.orderAddresses[0],
                $form = $('#redemptionForm');

            selectedRewardTypeId = $form.find('input[name="order_rewardType"]').val();

            orderLine.campaignCode = currentCampaign.campaignCode;
            orderLine.rewardTypeId = selectedRewardTypeId;
            orderLine.firstName = $form.find('input[name="order_firstName"]').val();
            orderLine.lastName = $form.find('input[name="order_lastName"]').val();
            orderLine.contactEmail = $form.find('input[name="order_contactEmail"]').val();
            orderLine.phoneNumber = $form.find('input[name="order_phoneNumber"]').val();
            orderLine.signOnReceipt = $form.find('input[name="order_signOnReceipt"]').val() === 'Y';
            orderLine.trackerOptIn = true;
            orderLine.orderStatus = 'Scheduled';

            //addresses
            orderAddress.dpid = $form.find('input[name="order_address_dpId"]').val();
            orderAddress.businessName = $form.find('input[name="order_address_businessName"]').val();
            orderAddress.state = $form.find('input[name="order_address_state"]').val();
            orderAddress.postcode = $form.find('input[name="order_address_postCode"]').val();
            orderAddress.suburb = $form.find('input[name="order_address_suburbName"]').val();
            orderAddress.streetName = $form.find('input[name="order_address_streetName"]').val();
            orderAddress.streetNumber = $form.find('input[name="order_address_streetNum"]').val()
                || $form.find('input[name="order_address_houseNoSel"]').val();
            orderAddress.unitNumber = $form.find('input[name="order_address_unitSel"]').val()
                || $form.find('input[name="order_address_unitShop"]').val();
            orderAddress.unitType = $form.find('input[name="order_address_unitType"]').val();
            orderAddress.fullAddress = $form.find('input[name="order_address_fullAddress"]').val();

            return orderForm;
        };

        CRUD.save = function (data) {
            var that = this,
                onSuccess = function (response) {
                    if (response.status && response.status === true) {
                        renderSuccessMessage();
                        meerkat.modules.dialogs.close(that.modalId);
                        meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                            method:'trackQuoteReward',
                            object: {
                                action: 'Reward Redeemed',
                                redeemedCampaignCode: currentCampaign.campaignCode,
                                redeemedRewardTypeId: selectedRewardTypeId
                            }
                        });
                    } else if (response.message) {
                        $('#redemptionForm').find(".error-message").html('response.message');
                    }
                };

            if ( $('#redemptionForm').valid() ) {
                this.promise("update", data, onSuccess, 'post', true);
            }
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
        switch (rewardOrder.generalStatus) {
            case 'ALREADY_REDEEMED':
                renderSuccessMessage();
                break;
            case 'OK_TO_REDEEM':
                CRUD.openModal();
        }

    }


    function getContentHtml() {
        return $contentHtml;
    }

    function renderSuccessMessage() {
        if ($contentHtml) {
            $('.reward-confirmation-message-container').html(
                $contentHtml.find('.reward-confirmation-message').prop('outerHTML')
            );
        }
    }

    function _transformRewardOrder() {
        var obj = {
            orderForm: {
                orderHeader: {}
            }
        };
        for(var key in rewardOrder.orderHeader) {
            if(key === 'eligibleCampaigns') {
                obj[key] = rewardOrder.orderHeader[key];
            } else if(key === 'orderLines') {
                obj.orderForm.orderHeader['orderLine'] = rewardOrder.orderHeader[key].filter(_filterByEncryptedOrderLineId)[0];
            } else {
                obj.orderForm.orderHeader[key] = rewardOrder.orderHeader[key];
            }
        }

        return obj;
    }

    function _filterByEncryptedOrderLineId(orderLine){
        return orderLine.encryptedOrderLineId === encryptedOrderLineId;
    }

    meerkat.modules.register("rewardConfirmation", {
        init: initRewardConfirmation,
        getContentHtml: getContentHtml
    });

})(jQuery);