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
            movingIn = $(".moving-in").find("input[type='radio']:checked").val(),
            recentElectricityBill = $(".recent-electricity-bill").find("input[type='radio']:checked").val(),
            recentGasBill = $(".recent-gas-bill").find("input[type='radio']:checked").val();

        if(whatToCompare === "E" || whatToCompare === "EG") {
            if(recentElectricityBill === 'Y') {
                var elecPeakVal = $("#utilities_estimateDetails_usage_electricity_peak_amount").val(),
                    elecPeakPeriod = $("#utilities_estimateDetails_usage_electricity_peak_period").children("option").filter(":selected").text(),
                    elecOffpeakVal = $("#utilities_estimateDetails_usage_electricity_offpeak_amount").val(),
                    elecOffpeakPeriod = $("#utilities_estimateDetails_usage_electricity_offpeak_period").children("option").filter(":selected").text();

                data.electricityPeak = elecPeakVal + "kWh/" + elecPeakPeriod;
                data.electricityOffPeak = (elecOffpeakVal !== "" ? elecOffpeakVal : 0) + "kWh/" + elecOffpeakPeriod;
            } else {
                electricityUsage = $('utilities_estimateDetails_electricity_usage').val();
                if (electricityUsage === 'L') {
                    data.electricitySpend = "Low";
                } else if (electricityUsage === 'M') {
                    data.electricitySpend = "Medium";
                } else {
                    data.electricitySpend = "High";
                }
            }
        }

        if(whatToCompare === "G" || whatToCompare === "EG") {
            if(recentGasBill === 'Y') {
                var gasPeakVal = $("#utilities_estimateDetails_usage_gas_peak_amount").val(),
                    gasPeakPeriod = $("#utilities_estimateDetails_usage_gas_peak_period").children("option").filter(":selected").text(),
                    gasOffpeakVal = $("#utilities_estimateDetails_usage_gas_offpeak_amount").val(),
                    gasOffpeakPeriod = $("#utilities_estimateDetails_usage_gas_offpeak_period").children("option").filter(":selected").text();

                data.gasPeak = gasPeakVal + "MJ/" + gasPeakPeriod;
                data.gasOffPeak = (gasOffpeakVal !== "" ? gasOffpeakVal : 0) + "MJ/" + gasOffpeakPeriod;
            } else {
                gasUsage = $('utilities_estimateDetails_electricity_usage').val();
                if (gasUsage === 'L') {
                    data.gasSpend = "Low";
                } else if (gasUsage === 'M') {
                    data.gasSpend = "Medium";
                } else {
                    data.gasSpend = "High";
                }
            }
        }

        data.recentElectricityBill = recentElectricityBill;
        data.recentGasBill = recentGasBill;
        data.segmentClassElec = recentElectricityBill ? "spend" : "usage";
        data.segmentClassGas = recentGasBill ? "spend" : "usage";

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