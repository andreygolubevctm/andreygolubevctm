/**
 * Implementation of crud.js for Help Box page
 *
 * Documentation here:
 * http://confluence:8090/display/CM/Creating+Simples+Admin+Interfaces
 */
;(function($, undefined){

    var meerkat = window.meerkat,
        log = meerkat.logging.info;

    var CRUD;

    function init() {
        $(document).ready(function() {
            if($("#help-box-container").length) {
                CRUD = new meerkat.modules.crud.newCRUD({
                    baseURL: "admin/helpbox",
                    primaryKey: "helpBoxId",
                    models: {
                        datum: function(helpBox) {
                            return {
                                extraData: {
                                    type: function () {
                                        var curDate = new Date(),
                                            futureDate = new Date(),
                                            startDate = new Date(helpBox.effectiveStart).setHours(0, 0, 0, 0),
                                            endDate = new Date(helpBox.effectiveEnd).setHours(23, 59, 59, 0);

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
                    renderResults: renderHelpBoxHTML
                });

                CRUD.get();
            }
        });
    }

    /**
     * Renders the complete offers list HTML
     */
    function renderHelpBoxHTML() {
        var types = ["current", "future", "past"];

        for(var i = 0; i < types.length; i++) {
            var type = types[i],
                helpBox = CRUD.dataSet.getByType(type),
                helpBoxHTML = "";

            for(var j = 0; j < helpBox.length; j++) {
                helpBoxHTML += helpBox[j].html;
            }

            $("#" + type + "-help-box-container")
                .html(helpBoxHTML)
                .closest(".row")
                .find("h1 small")
                .text("(" + helpBox.length + ")");
        }
    }

    /**
     * Actions to do on sort refresh
     */
    function refresh() {
        CRUD.renderResults();
    }

    meerkat.modules.register('adminHelpBox', {
        init: init,
        refresh: refresh
    });

})(jQuery);