/**
 * Fund Warning Message CRUD implementation
 */
;(function ($, undefined) {

    var meerkat = window.meerkat;
    var CRUD;

    function init() {
        $(document).ready(function () {
            if ($("#admin-fund-warning-message-container").length) {
                CRUD = new meerkat.modules.adminDataCRUD.newCRUD({
                    baseURL: "../../admin/fundwarning",
                    primaryKey: "messageId",
                    models: {
                        datum: function (message) {
                            return {
                                extraData: {
                                    providerName: function() {
                                        var providerInfo = providers.filter(function(a) {
                                            return a.value === message.providerId;
                                        });
                                        return providerInfo.length ? providerInfo[0].text : "";
                                    }
                                }
                            }
                        }
                    }
                });

                CRUD.get();
            }
        });
    }

    /**
     * Actions to do on sort refresh
     */
    function refresh() {
        CRUD.renderResults();
    }

    meerkat.modules.register('adminFundWarningMessage', {
        init: init,
        refresh: refresh
    });

})(jQuery);