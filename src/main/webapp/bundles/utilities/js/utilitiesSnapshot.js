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
                    elecOffpeakVal = $("#utilities_estimateDetails_usage_electricity_offpeak_amount").val(),
                    elecShoulderVal = $("#utilities_estimateDetails_usage_electricity_shoulder_amount").val();

                data.electricityPeak = elecPeakVal + "kWh";
                data.electricityOffPeak = (elecOffpeakVal !== "" ? elecOffpeakVal : 0) + "kWh";
                data.electricityShoulder = (elecShoulderVal !== "" ? elecShoulderVal : 0) + "kWh";
            } else {
                data.electricitySpend = $('utilities_estimateDetails_electricity_usage').val();
            }
        }

        if(whatToCompare === "G" || whatToCompare === "EG") {
            if(recentGasBill === 'Y') {
                var gasPeakVal = $("#utilities_estimateDetails_usage_gas_peak_amount").val(),
                    gasOffpeakVal = $("#utilities_estimateDetails_usage_gas_offpeak_amount").val();

                data.gasPeak = gasPeakVal + "MJ";
                data.gasOffPeak = (gasOffpeakVal !== "" ? gasOffpeakVal : 0) + "MJ";
            } else {
                data.gasSpend = gasUsage = $('utilities_estimateDetails_electricity_usage').val();
            }
        }

        data.recentElectricityBill = recentElectricityBill;
        data.recentGasBill = recentGasBill;

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