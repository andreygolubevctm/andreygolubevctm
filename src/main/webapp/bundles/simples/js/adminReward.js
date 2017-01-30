/**
 * Reward implementation of crud.js
 */
;(function($, undefined){

    var meerkat = window.meerkat;
    var meerkatEvents = meerkat.modules.events;

    var CRUD;

    function init() {
        $(document).ready(function() {
            meerkat.modules.affix.topDockBasedOnOffset($('.navbar-affix'));
            if($("#simples-reward-details-container").length) {
                CRUD = new meerkat.modules.crud.newCRUD({
                    baseURL: "/ctm/spring/rest/reward/order",
                    primaryKey: "phoneNumber",
                    models: {
                        datum: function(data) {
                            return {
                                extraData: {
                                    type: function () {
                                        return "current";
                                    }
                                }
                            };
                        }
                    },
                    renderResults: renderRewardHTML
                });

                // CRUD.getDeleteRequestData = function($row) {
                //     return CRUD.dataSet.get($row.data("id")).data;
                // };

                CRUD.getSaveRequestData = function($modal) {
                    var $inputs = $modal.find("input, textarea, select"),
                        data = {
                            "orderHeader": {
                                "orderLine":
                                    {
                                        "campaignCode": "code1",
                                        "contactEmail": "stuff",
                                        "firstName": "Steve",
                                        "lastName": "Jiang",
                                        "signOnReceipt": true,
                                        "orderNotes": "test notes",
                                        "phoneNumber": "0412345678",
                                        "touchType": "string",
                                        "trackerOptIn" : true,
                                        "updatedByOperator": "sjiang",
                                        "orderAddresses": [
                                            {
                                                "addressType": "P",
                                                "businessName": "Compare The Market",
                                                "dpid": "36957671",
                                                "postcode": "4066",
                                                "state": "QLD",
                                                "streetName": "Jephson St.",
                                                "suburb": "Toowong",
                                                "unitNumber": "2",
                                                "unitType": "L"
                                            }
                                        ]
                                    },
                                "saleStatus": "Sale",
                                "reasonCode": "somthing"
                            }
                        };

                    // for(var i = 0; i < $inputs.length; i++) {
                    //     var $input = $($inputs[i]);
                    //     data[$input.attr("name")] = $input.val();
                    // }

                    return data;
                };

                CRUD.find = function (data) {
                    this.dataSet.empty();

                    data = data || {};

                    var that = this,
                        onSuccess = function(response) {
                            if(typeof response === "string")
                                response = JSON.parse(response);
                            var orderLineResponses = response.orderLineResponses;
                            if(orderLineResponses.length) {
                                for (var i = 0; i < orderLineResponses.length; i++) {
                                    var datum = orderLineResponses[i],
                                        obj = new meerkat.modules.crudModel.datumModel(that.primaryKey, that.models.datum, datum, that.views.row);
                                    that.dataSet.push(obj);
                                }
                            }
                            $('#simples-reward-details-container').removeClass('hidden');
                            that.sortRenderResults();
                        };
                    return this.promise("find", data, onSuccess, 'post', true);
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

    /**
     * Actions to do on sort refresh
     */
    function refresh() {
        CRUD.renderResults();
    }



    meerkat.modules.register('adminReward', {
        init: init,
        refresh: refresh
    });

})(jQuery);