/**
 * Implementation of crud.js for Rate Rise Banner page
 *
 * Documentation here:
 * http://confluence:8090/display/CM/Creating+Simples+Admin+Interfaces
 */
;(function($, undefined){

        log = meerkat.logging.info;

    var CRUD;

    function init() {
        $(document).ready(function() {
            if($("#rate-rise-banner-container").length) {
                CRUD = new meerkat.modules.crud.newCRUD({
                    baseURL: "admin/raterise",
                    primaryKey: "textId",
                    models: {
                        datum: function(rateRiseBanner) {
                            return {
                                extraData: {
                                    type: function () {
                                        var curDate = new Date(),
                                            futureDate = new Date(),
                                            startDate = new Date(rateRiseBanner.effectiveStart).setHours(0, 0, 0, 0),
                                            endDate = new Date(rateRiseBanner.effectiveEnd).setHours(23, 59, 59, 0);

                                        futureDate.setDate(futureDate.getDate() + 1);

                                        if (startDate >= futureDate.setHours(0, 0, 0, 0)) {
                                            return "future";
                                        } else if (startDate <= curDate.setHours(0, 0, 0, 0) && endDate >= curDate.setHours(23, 59, 59, 0)) {
                                            return "current";
                                        } else {
                                            return "past";
                                        }
                                    }
                                }
                            };
                        }
                    },
                    renderResults: renderRateRiseBannerHTML
                });

                CRUD.get();
            }
        });
    }

    /**
     * Renders the complete offers list HTML
     */
    function renderRateRiseBannerHTML() {
        var types = ["current", "future", "past"];

        for(var i = 0; i < types.length; i++) {
            var type = types[i],
                rateRiseBanners = CRUD.dataSet.getByType(type),
                rateRiseBannerHTML = "";

            for(var j = 0; j < rateRiseBanners.length; j++) {
                rateRiseBannerHTML += rateRiseBanners[j].html;
            }

            $("#" + type + "-rate-rise-banner-container")
                .html(rateRiseBannerHTML)
                .closest(".row")
                .find("h1 small")
                .text("(" + rateRiseBanners.length + ")");
        }
    }

    /**
     * Actions to do on sort refresh
     */
    function refresh() {
        CRUD.renderResults();
    }

    meerkat.modules.register('adminRateRiseBanner', {
        init: init,
        refresh: refresh
    });

})(jQuery);