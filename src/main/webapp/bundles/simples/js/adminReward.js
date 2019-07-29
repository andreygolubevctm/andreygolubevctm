/**
 * Reward implementation of crud.js
 */
;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var CRUD,
        currentCampaign,
        adHocRewardData;

    function init() {
        $(document).ready(function() {
            meerkat.modules.affix.topDockBasedOnOffset($('.navbar-affix'));
            if($("#simples-reward-details-container").length) {
                CRUD = new meerkat.modules.crud.newCRUD({
                    baseURL: '/' + meerkat.site.urls.context + "spring/rest/reward/order",
                    primaryKey: "orderForm.orderHeader.orderLine.encryptedOrderLineId",
                    models: {
                        datum: function(data) {
                            return {
                                extraData: {
                                    type: function () {
                                        return "current";
                                    }
                                }
                            };
                        },
                        db: _createAdHocRewardData
                    },
                    renderResults: renderRewardHTML
                });

                CRUD.getSaveRequestData = function($modal, encryptedOrderLineId) {
                    var $form = $modal.find('.redemptionForm');

                    // Abort if form is invalid
                    if ( $form.valid() !== true ) return false;

                    var rewardData = encryptedOrderLineId ? this.dataSet.get(encryptedOrderLineId).data : adHocRewardData,
                        orderForm = false;

                    // try to valid the model...
                    if (rewardData && rewardData.orderForm &&
                        rewardData.orderForm.orderHeader && rewardData.orderForm.orderHeader.orderLine) {
                        orderForm = rewardData.orderForm;
                        var orderLine = orderForm.orderHeader.orderLine,
                            orderAddress = orderLine.orderAddresses[0] || {},
                            currentCampaign = rewardData.eligibleCampaigns[0] || {};

                        // orderHeader
                        orderForm.orderHeader.reasonCode = $form.find('select[name="order_reasonCode"]').val() || null;

                        // orderLine
                        orderLine.campaignCode = currentCampaign.campaignCode;
                        orderLine.orderStatus = $form.find('select[name="order_orderStatus"]').val() || orderLine.orderStatus || 'Scheduled';
                        orderLine.rewardTypeId = $form.find('input[name="order_rewardType"]:checked').val() || null;
                        orderLine.firstName = $form.find('input[name="order_firstName"]').val();
                        orderLine.lastName = $form.find('input[name="order_lastName"]').val();
                        orderLine.contactEmail = $form.find('input[name="order_contactEmail"]').val();
                        orderLine.phoneNumber = $form.find('input[name="order_phoneNumber"]').val();
                        orderLine.signOnReceipt = $form.find('input[name="order_signOnReceipt"]:checked').val() === 'Y';
                        orderLine.trackerOptIn = true; // defaulting to true as Product team told to remove the field
                        orderLine.orderNotes = $form.find('textarea[name="order_notes"]').val();

                        //addresses
                        orderAddress.addressType = orderAddress.addressType || 'P';
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

                        // Safe guard in case the order/get gets incomplete data
                        orderForm.orderHeader.orderLine = orderLine;
                        orderForm.orderHeader.orderLine.orderAddresses[0] = orderAddress;
                    }

                    return orderForm;
                };

                CRUD.find = function (data) {
                    this.dataSet.empty();

                    data = data || {};

                    var that = this,
                        onSuccess = function(response) {
                            if(typeof response === "string") {
                                response = JSON.parse(response);
                            }

                            var orderHeaderResponses = response.orderHeaderResponses;
                            if(orderHeaderResponses && orderHeaderResponses.length) {
                                for (var i = 0; i < orderHeaderResponses.length; i++) {
                                    if(orderHeaderResponses[i].orderLines && orderHeaderResponses[i].orderLines.length > 0) {
                                        var datum = _transformRewardOrder(orderHeaderResponses[i]),
                                            obj = new meerkat.modules.crudModel.datumModel(that.primaryKey, that.models.datum, datum, that.views.row, true);
                                        that.dataSet.push(obj);
                                    }
                                }
                            }
                            $('#simples-reward-details-container').removeClass('hidden');
                            that.sortRenderResults();
                        };
                    return this.promise("find", data, onSuccess, 'post', true);
                };

                CRUD.save = function (data, $targetRow) {
                    var that = this,
                        onSuccess = function (response) {
                            if (response.status && response.status === true) {
                                if ($targetRow) {
                                    // for edit, try search to render the list again
                                    // (not ideal but the api doesn't return the updated model)
                                    $('#simples-reward-search-navbar').find('button').trigger('click');
                                } else {
                                    // for adhoc add the model to dataSet (missing rewardType, dateToIssue atm, unless we trigger another search)
                                    var datum = {orderForm: data};
                                    var obj = new meerkat.modules.crudModel.datumModel(that.primaryKey, that.models.datum, datum, that.views.row);
                                    that.dataSet.push(obj);
                                    $('#simples-reward-details-container').removeClass('hidden');
                                    that.sortRenderResults();
                                }

                                meerkat.modules.dialogs.close(that.modalId);
                            } else if (response.message) {
                                $('#' + that.modalId).find(".error-message").html('Error: ' + response.message);
                            }
                        };

                    if (data) {
                        $targetRow ? this.promise("update", data, onSuccess, 'post', true) : this.promise("create", data, onSuccess, 'post', true);
                    }
                };

                CRUD.cancel = function ($targetRow) {
                    var data = this.dataSet.get($targetRow.data("id")).data;
                    if (data && data.orderForm &&
                        data.orderForm.orderHeader && data.orderForm.orderHeader.orderLine) {
                        data.orderForm.orderHeader.orderLine.orderStatus = 'Cancelled';
                    }

                    CRUD.save(data.orderForm, $targetRow);
                };

                meerkat.messaging.subscribe(meerkatEvents.crud.CRUD_MODAL_OPENED, function initRedemptionForm(modalId) {
                    meerkat.modules.redemptionForm.initRedemptionForm(modalId, '/ctm/');
                });

                applyEventListeners();
            }
        });
    }

    function applyEventListeners() {
        $('#simples-reward-search-navbar').on('submit', function () {
            event.preventDefault();
            var data = {
                searchParam: $(this).find(':input[name=keywords]').val() || ''
            };
            CRUD.find(data);
        });
    }
    /**
     * Renders the complete offers list HTML
     */
    function renderRewardHTML() {
        var types = ["current", "past"];

        for(var i = 0; i < types.length; i++) {
            var type = types[i],
                orders = CRUD.dataSet.getByType(type),
                orderHTML = "";

            for(var j = 0; j < orders.length; j++) {
                orderHTML += orders[j].html;
            }

            $("#" + type + "-reward-container")
                .html(orderHTML)
                .closest(".row")
                .find("h1 small")
                .text("(" + orders.length + ")");
        }
    }

    function _fetchCampaigns() {
       meerkat.modules.comms.get({
            url: '/' + meerkat.site.urls.context + 'spring/rest/reward/campaigns/get.json',
            cache: false,
            async: false,
            errorLevel: 'silent',
            dataType: 'json'
        })
        .then(function onSuccess(json) {
            if (json && json.hasOwnProperty('campaigns')) {
                currentCampaign = json.campaigns.filter(function(campaign) {
                    return campaign.active === true;
                })[0];
            } else {
                debug('No active campaigns.');
            }

        })
        .catch(function onError(obj, txt, errorThrown) {
            exception(txt + ': ' + errorThrown);
        });
    }
    
    function _createAdHocRewardData() {
        adHocRewardData = {
            eligibleCampaigns: [],
            orderForm: {
                orderHeader: {
                    orderLine: {
                        rewardType: {},
                        orderAddresses: []
                    }
                }
            }
        };
        _fetchCampaigns();
        adHocRewardData.eligibleCampaigns[0] = currentCampaign;

        return adHocRewardData;
    }


    function _transformRewardOrder(orderHeader) {
        var obj = {
            orderForm: {
                orderHeader: {}
            }
        };
        for(var key in orderHeader) {
            if(key === 'eligibleCampaigns') {
                obj[key] = orderHeader[key];
            } else if(key === 'orderLines') {
                obj.orderForm.orderHeader['orderLine'] = orderHeader[key][0];
            } else {
                obj.orderForm.orderHeader[key] = orderHeader[key];
            }
        }

        return obj;
    }

    meerkat.modules.register('adminReward', {
        init: init
    });

})(jQuery);