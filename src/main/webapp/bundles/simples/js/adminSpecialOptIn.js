/**
 * Implementation of crud.js for Special opt in page
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
            if($("#special-opt-in-container").length) {
                CRUD = new meerkat.modules.crud.newCRUD({
                    baseURL: "admin/specialOptIn",
                    primaryKey: "specialOptInId",
                    models: {
                        datum: function(specialOptIn) {
                            return {
                                extraData: {
                                    type: function () {
                                        var curDate = new Date(),
                                            startDate = new Date(specialOptIn.effectiveStart).setHours(0, 0, 0, 0),
                                            endDate = new Date(specialOptIn.effectiveEnd).setHours(23, 59, 59, 0);

                                        if (startDate > curDate.setHours(0, 0, 0, 0)) {
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
                    renderResults: renderSpecialOptInHTML
                });

                CRUD.get();

                CRUD.update = function (data, onSuccess) {
                    var effectiveStart = new Date(data.effectiveStart),
                        effectiveEnd = new Date(data.effectiveEnd);

                    data.effectiveStart = effectiveStart.getTime();
                    data.effectiveEnd = effectiveEnd.getTime();

                    return this.promise("update", data, onSuccess);
                };
            }
        });
    }

    /**
     * Renders the complete offers list HTML
     */
    function renderSpecialOptInHTML() {
        var types = ["current", "future", "past"];

        for(var i = 0; i < types.length; i++) {
            var type = types[i],
                specialOptIn = CRUD.dataSet.getByType(type),
                specialOptInHTML = "";

            for(var j = 0; j < specialOptIn.length; j++) {
                specialOptInHTML += specialOptIn[j].html;
            }

            $("#" + type + "-special-opt-in-container")
                .html(specialOptInHTML)
                .closest(".row")
                .find("h1 small")
                .text("(" + specialOptIn.length + ")");
        }
    }

    /**
     * Actions to do on sort refresh
     */
    function refresh() {
        CRUD.renderResults();
    }

    meerkat.modules.register('adminSpecialOptIn', {
        init: init,
        refresh: refresh
    });

})(jQuery);