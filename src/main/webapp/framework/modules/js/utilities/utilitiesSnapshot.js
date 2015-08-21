;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info;

    var events = {
            utilitiesSnapshot: {
            }
        };

    var $snapshotSituation,
        $productSnapshot;

    function initUtilitiesSnapshot() {
        $snapshotSituation = $('.snapshotSituation');
        $productSnapshot = $(".product-snapshot");
    }

    function onEnterEnquire() {
        renderEnquireSnapshot();
        fillEnquireTemplate();
    }
    function onEnterResults() {
        renderResultsSnapshot();
    }

    function renderResultsSnapshot() {
        var template = _.template($("#results-summary-template").html()),
            data = {};

        data.postcode = "Postcode " + $("#utilities_householdDetails_location").val().match(/\d+/)[0];

        var whatToCompare = $(".what-to-compare :checked").val(),
            isSpendEstimate = $(".how-to-estimate").val() === "S";

        if(whatToCompare === "E" || whatToCompare === "EG") {
            if(isSpendEstimate) {
                data.electricitySpend = "$" + $("#utilities_estimateDetails_spend_electricity_amount").val() + " / " + $("#utilities_estimateDetails_spend_electricity_period").children("option").filter(":selected").text();
            } else {
                var elecPeakVal = $("#utilities_estimateDetails_usage_electricity_peak_amount").val(),
                    elecPeakPeriod = $("#utilities_estimateDetails_usage_electricity_peak_period").children("option").filter(":selected").text(),
                    elecOffpeakVal = $("#utilities_estimateDetails_usage_electricity_offpeak_amount").val(),
                    elecOffpeakPeriod = $("#utilities_estimateDetails_usage_electricity_offpeak_period").children("option").filter(":selected").text();

                data.electricityPeak = elecPeakVal + "kWh/" + elecPeakPeriod;
                data.electricityOffPeak = (elecOffpeakVal !== "" ? elecOffpeakVal : 0) + "kWh/" + elecOffpeakPeriod;
            }
        }

        if(whatToCompare === "G" || whatToCompare === "EG") {
            if(isSpendEstimate) {
                data.gasSpend = "$" + $("#utilities_estimateDetails_spend_gas_amount").val() + " / " + $("#utilities_estimateDetails_spend_gas_period").children("option").filter(":selected").text();
            } else {
                var gasPeakVal = $("#utilities_estimateDetails_usage_gas_peak_amount").val(),
                    gasPeakPeriod = $("#utilities_estimateDetails_usage_gas_peak_period").children("option").filter(":selected").text(),
                    gasOffpeakVal = $("#utilities_estimateDetails_usage_gas_offpeak_amount").val(),
                    gasOffpeakPeriod = $("#utilities_estimateDetails_usage_gas_offpeak_period").children("option").filter(":selected").text();

                data.gasPeak = gasPeakVal + "MJ/" + gasPeakPeriod;
                data.gasOffPeak = (gasOffpeakVal !== "" ? gasOffpeakVal : 0) + "MJ/" + gasOffpeakPeriod;
            }
        }

        data.isSpendEstimate = isSpendEstimate;
        data.segmentClass = isSpendEstimate ? "spend" : "usage";

        var html = template(data);
        $("#results-summary-container").html(html);
        return html;
    }


    function renderEnquireSnapshot() {

        $snapshotSituation.html(renderResultsSnapshot());
        meerkat.modules.contentPopulation.render('.journeyEngineSlide:eq(2) .snapshot');
    }

    function fillEnquireTemplate() {
        var currentProduct = Results.getSelectedProduct();
        if(currentProduct !== false) {
            var productTemplate = $("#enquire-snapshot-template").html();
            var htmlTemplate = _.template(productTemplate);
            var htmlString = htmlTemplate(currentProduct);
            $productSnapshot.html(htmlString);
        } else {
            $productSnapshot.empty();
        }

    }
    meerkat.modules.register('utilitiesSnapshot', {
        initUtilitiesSnapshot: initUtilitiesSnapshot,
        events: events,
        onEnterEnquire: onEnterEnquire,
        onEnterResults: onEnterResults
    });

})(jQuery);