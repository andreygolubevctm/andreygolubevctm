/**
 * Redemption implementation of crud.js
 */
;(function($, undefined){

    var meerkat = window.meerkat;
    var meerkatEvents = meerkat.modules.events;
    var CRUD;

    function init() {
        $(document).ready(function() {
            if($("#simples-redemption-details-container").length) {
                CRUD = new meerkat.modules.crud.newCRUD({
                    baseURL: "../../admin/redemption",
                    primaryKey: "encryptedOrderId",
                    models: {
                        datum: function(data) {
                            return {
                                extraData: {}
                            };
                        }
                    },
                    renderResults: renderRedemptionsHTML
                });

                // CRUD.getDeleteRequestData = function($row) {
                //     return CRUD.dataSet.get($row.data("id")).data;
                // };

                // CRUD.get();

                meerkat.messaging.subscribe(meerkatEvents.crud.CRUD_MODAL_OPENED, function initRedemptionForm(modalId) {
                    meerkat.modules.redemptionForm.initRedemptionForm(modalId, '/ctm/');
                });
            }
        });
    }

    /**
     * Renders the complete offers list HTML
     */
    function renderRedemptionsHTML() {
        var types = ["current", "past"];

        for(var i = 0; i < types.length; i++) {
            var type = types[i],
                redemptions = CRUD.dataSet.getByType(type),
                redemptionHTML = "";

            for(var j = 0; j < redemptions.length; j++) {
                redemptionHTML += redemptions[j].html;
            }

            $("#" + type + "-redemption-container")
                .html(redemptionHTML)
                .closest(".row")
                .find("h1 small")
                .text("(" + redemptions.length + ")");
        }
    }

    /**
     * Actions to do on sort refresh
     */
    function refresh() {
        CRUD.renderResults();
    }

    meerkat.modules.register('adminRedemption', {
        init: init,
        refresh: refresh
    });

})(jQuery);