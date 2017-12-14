;(function ($, undefined) {
    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var baseURL = '/ctm/',
        CRUD,
        rewardData,
        $form,
        $contentHtml,
        currentCampaign,
        rewardGeneralStatus,
        selectedRewardTypeId,
        $redemptionMessageContainer = $('.redemption-message-container'),
        $redemptionTitle = $('.redemption-title'),
        $redemptionLead = $('.redemption-lead');

    function initRedemptionComponent() {
        $(document).ready(function() {
            if (typeof meerkat.site === 'undefined') return;

            // Bad response, abort
            if (!rewardOrder || rewardOrder.status !== true || !rewardOrder.orderHeader) {
                $redemptionTitle.text('Error: Invalid Redemption Link');
                $redemptionLead.removeClass('hide');
                $redemptionMessageContainer.removeClass('hide');
                return;
            }

            rewardGeneralStatus = rewardOrder.generalStatus;

            if (rewardGeneralStatus !== 'OK_TO_REDEEM') {
                return displayErrorPage();
            }

            rewardData = _transformRewardOrder();
            if (rewardData.eligibleCampaigns && rewardData.eligibleCampaigns[0]) {
                currentCampaign = rewardData.eligibleCampaigns[0];
                $contentHtml = $(currentCampaign.contentHtml);
            }
            initCRUD();
        });
    }

    function displayErrorPage(){
        switch (rewardGeneralStatus) {
            case "ALREADY_REDEEMED":
                $redemptionTitle.text("Hmmm... It appears that you have already redeemed your toy.");
                $redemptionLead.removeClass('hide');
                break;
            case "NO_STOCK":
                $redemptionTitle.text("We're sorry we are sold out of toys");
                break;
            case "NOT_ELIGIBLE":
                $redemptionTitle.text("We're sorry");
                $redemptionLead.html("The 28 day redemption window has expired.").removeClass('hide');
                break;
        }
        $redemptionMessageContainer.removeClass('hide');
    }

    function initCRUD(){
        CRUD = new meerkat.modules.crud.newCRUD({
            baseURL: '/' + meerkat.site.urls.context + "spring/rest/reward/order",
            primaryKey: encryptedOrderLineId,
            modalId: 1,
            models: {
                db: rewardData
            }
        });

        // defer rendering because redemption form is a CRUD template
        _.defer(function() {
            renderRewardOrder();
            setupForm();
        });
    }

    function setupForm() {
        meerkat.modules.elasticAddress.setupElasticAddressPlugin(baseURL);
        meerkat.modules.autocomplete.setBaseURL(baseURL);
        meerkat.modules.autocomplete.setTypeahead();
        meerkat.modules.address_lookup.setBaseURL(baseURL);
        $form = $('#mainform').find('.redemptionForm');
        applyEventListeners();
    }

    function applyEventListeners() {
        // Remove Toy Tiles errors on click.
        $('.toy-radio-tiles').on('click', function() {
            $('#order_rewardType-error').remove();
        });

        // Process redemption form on click
        $('#redemption-submit-button').on('click', function() {
            // Remove validation errors
            $("label.error").hide();
            $(".error").removeClass("error");
            $('#order_rewardType-error').remove();

            // Validate Form
            var data = validateForm();

            // Move Toy Radio Titles error to after question
            $('.toy-radio-tiles').after($('#order_rewardType-error'));

            if(data){
                submitForm(data);
            }
        });
    }

    function validateForm() {
        // Abort if form is invalid
        if ( $form.valid() !== true ) return;

        var orderForm = rewardData.orderForm,
            orderLine = orderForm.orderHeader.orderLine || {},
            orderAddress = orderLine.orderAddresses[0] || {};

        selectedRewardTypeId = $form.find('input[name="order_rewardType"]:checked').val();

        orderLine.campaignCode = currentCampaign.campaignCode;
        orderLine.rewardTypeId = selectedRewardTypeId || null;
        orderLine.firstName = $form.find('input[name="order_firstName"]').val();
        orderLine.lastName = $form.find('input[name="order_lastName"]').val();
        orderLine.contactEmail = $form.find('input[name="order_contactEmail"]').val();
        orderLine.phoneNumber = $form.find('input[name="order_phoneNumber"]').val();
        orderLine.signOnReceipt = $form.find('input[name="order_signOnReceipt"]:checked').val() === 'Y';
        orderLine.trackerOptIn = true; // defaulting to true as Product team told to remove the field
        orderLine.orderStatus = $form.find('input[name="order_orderStatus"]:checked').val() || 'Scheduled';

        orderAddress.dpid = $form.find('input[name="order_address_dpId"]').val();
        orderAddress.businessName = $form.find('input[name="order_address_businessName"]').val();
        orderAddress.state = $form.find('input[name="order_address_state"]').val();
        orderAddress.postcode = $form.find('input[name="order_address_postCode"]').val();
        orderAddress.suburb = $form.find('input[name="order_address_suburbName"]').val()
            || $form.find('input[name="order_address_suburbNamePrefill"]').val();
        orderAddress.streetName = $form.find('input[name="order_address_streetName"]').val()
            || $form.find('input[name="order_address_nonStdStreet"]').val();
        orderAddress.streetNumber = $form.find('input[name="order_address_streetNum"]').val()
            || $form.find('input[name="order_address_houseNoSel"]').val();
        orderAddress.unitNumber = $form.find('input[name="order_address_unitSel"]').val()
            || $form.find('input[name="order_address_unitShop"]').val();
        orderAddress.unitType = $form.find('input[name="order_address_unitType"]').val()
            || $form.find(':input[name="order_address_nonStdUnitType"]').val();
        orderAddress.fullAddress = $form.find('input[name="order_address_fullAddress"]').val();
        orderAddress.addressType = 'P';

        // Safe guard in case the order/get gets incomplete data
        orderForm.orderHeader.orderLine = orderLine;
        orderForm.orderHeader.orderLine.orderAddresses[0] = orderAddress;

        return orderForm;
    }

    function renderRewardOrder() {
        if (rewardGeneralStatus === 'OK_TO_REDEEM') {
            CRUD.appendToMainForm();
        }
    }

    function submitForm(data) {
        meerkat.modules.comms.post({
            url: "spring/rest/reward/order/update.json",
            data: data,
            cache: false,
            errorLevel: "warning",
            contentType: "application/json; charset=utf-8",
            doStringify: true,
            onSuccess: function(data, textStatus, jqXHR) {
                if (data.status && data.status === true) {
                    renderSuccessMessage();
                    meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
                        method:'trackQuoteReward',
                        object: {
                            action: 'Reward Redeemed',
                            redeemedCampaignCode: currentCampaign.campaignCode,
                            redeemedRewardTypeId: selectedRewardTypeId || $form.find('input[name="order_orderStatus"]:checked').val()
                        }
                    });
                } else if (data.message || data.status === false) {
                    renderErrorAJAXMessage();
                }
            }
        });
    }

    function getContentHtml() {
        return $contentHtml;
    }

    function renderErrorAJAXMessage() {
        $form.find(".error-message").html("Something went wrong, please try again. If the error persists, please contact us at <a href='mailto:toys@comparethemarket.com.au' target='_top'>toys@comparethemarket.com.au</a>");
    }

    function renderSuccessMessage() {
        $redemptionTitle.text('Congratulations! Your toy has been redeemed.');
        $form.addClass('hide');
        $redemptionMessageContainer.removeClass('hide');
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

    meerkat.modules.register('redemptionComponent', {
        init: initRedemptionComponent(),
        getContentHtml: getContentHtml
    });

})(jQuery);