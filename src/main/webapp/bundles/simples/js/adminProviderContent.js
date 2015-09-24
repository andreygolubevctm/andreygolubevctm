/**
 * Provider Content CRUD implementation
 */
;(function ($, undefined) {

    var meerkat = window.meerkat;
    var CRUD;

    function init() {
        $(document).ready(function () {
            if ($("#admin-provider-content-container").length) {
                CRUD = new meerkat.modules.adminDataCRUD.newCRUD({
                    baseURL: "../../admin/providerContent",
                    primaryKey: "providerContentId",
                    models: {
                        datum: function (providerContent) {
                            return {
                                extraData: {
                                    providerName: function() {
                                        var providerInfo = providers.filter(function(a) {
                                            return a.value === providerContent.providerId;
                                        });
                                        return providerInfo.length ? providerInfo[0].text : "";
                                    },
                                    providerContentTypeCode: function() {
                                        var providerContentTypeInfo = providerContentTypes.filter(function(a) {
                                            return a.value === providerContent.providerContentTypeId;
                                        });
                                        return providerContentTypeInfo.length ? providerContentTypeInfo[0].code : "";
                                    }
                                }
                            };
                        }
                    }
                });

                var data = {};
                data.providerContentTypeCode = providerContentTypeCode;
                CRUD.get(data);
            }
        });
    }

    /**
     * Actions to do on sort refresh
     */
    function refresh() {
        CRUD.renderResults();
    }

    meerkat.modules.register('adminProviderContent', {
        init: init,
        refresh: refresh
    });

})(jQuery);